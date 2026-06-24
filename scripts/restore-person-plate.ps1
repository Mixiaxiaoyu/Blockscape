param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$GeneratedPath,

    [Parameter(Mandatory = $true)]
    [string]$MaskPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [int]$OffsetX = 0,
    [int]$OffsetY = 0,
    [ValidateRange(1, 255)]
    [int]$Threshold = 1
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function Get-FullPath([string]$Path) {
    return [System.IO.Path]::GetFullPath($Path)
}

function Convert-ToArgb32([System.Drawing.Bitmap]$Bitmap) {
    $copy = New-Object System.Drawing.Bitmap(
        $Bitmap.Width,
        $Bitmap.Height,
        [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    )
    $graphics = [System.Drawing.Graphics]::FromImage($copy)
    try {
        $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
        $graphics.DrawImageUnscaled($Bitmap, 0, 0)
    }
    finally {
        $graphics.Dispose()
    }
    return $copy
}

function Copy-FromBitmapData(
    [System.Drawing.Imaging.BitmapData]$BitmapData,
    [int]$Height,
    [int]$RowBytes
) {
    $bytes = New-Object byte[] ($RowBytes * $Height)
    for ($y = 0; $y -lt $Height; $y++) {
        $rowPointer = [System.IntPtr]::Add($BitmapData.Scan0, $y * $BitmapData.Stride)
        [System.Runtime.InteropServices.Marshal]::Copy(
            $rowPointer,
            $bytes,
            $y * $RowBytes,
            $RowBytes
        )
    }
    return $bytes
}

function Copy-ToBitmapData(
    [byte[]]$Bytes,
    [System.Drawing.Imaging.BitmapData]$BitmapData,
    [int]$Height,
    [int]$RowBytes
) {
    for ($y = 0; $y -lt $Height; $y++) {
        $rowPointer = [System.IntPtr]::Add($BitmapData.Scan0, $y * $BitmapData.Stride)
        [System.Runtime.InteropServices.Marshal]::Copy(
            $Bytes,
            $y * $RowBytes,
            $rowPointer,
            $RowBytes
        )
    }
}

$sourceFull = Get-FullPath $SourcePath
$generatedFull = Get-FullPath $GeneratedPath
$maskFull = Get-FullPath $MaskPath
$outputFull = Get-FullPath $OutputPath

foreach ($inputPath in @($sourceFull, $generatedFull, $maskFull)) {
    if (-not [System.IO.File]::Exists($inputPath)) {
        throw "Input file does not exist: $inputPath"
    }
}

if ($outputFull -eq $sourceFull -or $outputFull -eq $generatedFull -or $outputFull -eq $maskFull) {
    throw "OutputPath must be different from every input path."
}

$outputDirectory = [System.IO.Path]::GetDirectoryName($outputFull)
if ($outputDirectory -and -not [System.IO.Directory]::Exists($outputDirectory)) {
    [System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
}

$sourceInput = $null
$generatedInput = $null
$maskInput = $null
$source = $null
$generated = $null
$mask = $null
$result = $null
$verifiedInput = $null
$verified = $null

try {
    $sourceInput = [System.Drawing.Bitmap]::FromFile($sourceFull)
    $generatedInput = [System.Drawing.Bitmap]::FromFile($generatedFull)
    $maskInput = [System.Drawing.Bitmap]::FromFile($maskFull)

    $source = Convert-ToArgb32 $sourceInput
    $generated = Convert-ToArgb32 $generatedInput
    $mask = Convert-ToArgb32 $maskInput

    if ($mask.Width -ne $source.Width -or $mask.Height -ne $source.Height) {
        throw "Mask dimensions must match the source image dimensions."
    }

    $result = Convert-ToArgb32 $generated

    $sourceRect = New-Object System.Drawing.Rectangle(0, 0, $source.Width, $source.Height)
    $resultRect = New-Object System.Drawing.Rectangle(0, 0, $result.Width, $result.Height)
    $readOnly = [System.Drawing.Imaging.ImageLockMode]::ReadOnly
    $readWrite = [System.Drawing.Imaging.ImageLockMode]::ReadWrite
    $pixelFormat = [System.Drawing.Imaging.PixelFormat]::Format32bppArgb

    $sourceData = $null
    $maskData = $null
    $resultData = $null

    try {
        $sourceData = $source.LockBits($sourceRect, $readOnly, $pixelFormat)
        $maskData = $mask.LockBits($sourceRect, $readOnly, $pixelFormat)
        $resultData = $result.LockBits($resultRect, $readWrite, $pixelFormat)

        $sourceRowBytes = $source.Width * 4
        $resultRowBytes = $result.Width * 4
        $sourceBytes = Copy-FromBitmapData $sourceData $source.Height $sourceRowBytes
        $maskBytes = Copy-FromBitmapData $maskData $mask.Height $sourceRowBytes
        $resultBytes = Copy-FromBitmapData $resultData $result.Height $resultRowBytes

        [long]$protectedPixels = 0
        [long]$restoredPixels = 0
        [long]$outsidePixels = 0

        for ($y = 0; $y -lt $source.Height; $y++) {
            $sourceRowOffset = $y * $sourceRowBytes
            $targetY = $y + $OffsetY

            for ($x = 0; $x -lt $source.Width; $x++) {
                $sourceIndex = $sourceRowOffset + ($x * 4)
                $maskValue = [Math]::Max(
                    $maskBytes[$sourceIndex + 2],
                    [Math]::Max($maskBytes[$sourceIndex + 1], $maskBytes[$sourceIndex])
                )

                if ($maskValue -lt $Threshold) {
                    continue
                }

                $protectedPixels++
                $targetX = $x + $OffsetX

                if (
                    $targetX -lt 0 -or $targetX -ge $result.Width -or
                    $targetY -lt 0 -or $targetY -ge $result.Height
                ) {
                    $outsidePixels++
                    continue
                }

                $targetIndex = ($targetY * $resultRowBytes) + ($targetX * 4)
                $resultBytes[$targetIndex] = $sourceBytes[$sourceIndex]
                $resultBytes[$targetIndex + 1] = $sourceBytes[$sourceIndex + 1]
                $resultBytes[$targetIndex + 2] = $sourceBytes[$sourceIndex + 2]
                $resultBytes[$targetIndex + 3] = $sourceBytes[$sourceIndex + 3]
                $restoredPixels++
            }
        }

        if ($protectedPixels -eq 0) {
            throw "The mask contains no protected pixels at the selected threshold."
        }

        if ($outsidePixels -gt 0) {
            throw "$outsidePixels protected pixels fall outside the generated canvas. Check OffsetX, OffsetY, and canvas size."
        }

        Copy-ToBitmapData $resultBytes $resultData $result.Height $resultRowBytes
    }
    finally {
        if ($resultData) { $result.UnlockBits($resultData) }
        if ($maskData) { $mask.UnlockBits($maskData) }
        if ($sourceData) { $source.UnlockBits($sourceData) }
    }

    $result.Save($outputFull, [System.Drawing.Imaging.ImageFormat]::Png)

    $verifiedInput = [System.Drawing.Bitmap]::FromFile($outputFull)
    $verified = Convert-ToArgb32 $verifiedInput
    $verifiedRect = New-Object System.Drawing.Rectangle(0, 0, $verified.Width, $verified.Height)
    $verifiedData = $null

    try {
        $verifiedData = $verified.LockBits($verifiedRect, $readOnly, $pixelFormat)
        $verifiedRowBytes = $verified.Width * 4
        $verifiedBytes = Copy-FromBitmapData $verifiedData $verified.Height $verifiedRowBytes
        [long]$mismatchedPixels = 0

        for ($y = 0; $y -lt $source.Height; $y++) {
            $sourceRowOffset = $y * $sourceRowBytes
            $targetY = $y + $OffsetY

            for ($x = 0; $x -lt $source.Width; $x++) {
                $sourceIndex = $sourceRowOffset + ($x * 4)
                $maskValue = [Math]::Max(
                    $maskBytes[$sourceIndex + 2],
                    [Math]::Max($maskBytes[$sourceIndex + 1], $maskBytes[$sourceIndex])
                )

                if ($maskValue -lt $Threshold) {
                    continue
                }

                $targetIndex = ($targetY * $verifiedRowBytes) + (($x + $OffsetX) * 4)
                if (
                    $sourceBytes[$sourceIndex] -ne $verifiedBytes[$targetIndex] -or
                    $sourceBytes[$sourceIndex + 1] -ne $verifiedBytes[$targetIndex + 1] -or
                    $sourceBytes[$sourceIndex + 2] -ne $verifiedBytes[$targetIndex + 2] -or
                    $sourceBytes[$sourceIndex + 3] -ne $verifiedBytes[$targetIndex + 3]
                ) {
                    $mismatchedPixels++
                }
            }
        }
    }
    finally {
        if ($verifiedData) { $verified.UnlockBits($verifiedData) }
    }

    if ($mismatchedPixels -ne 0) {
        throw "Identity plate verification failed: $mismatchedPixels protected pixels differ from the source."
    }

    [pscustomobject]@{
        output = $outputFull
        protected_pixels = $protectedPixels
        restored_pixels = $restoredPixels
        mismatched_pixels = $mismatchedPixels
        offset_x = $OffsetX
        offset_y = $OffsetY
        verified = $true
    } | ConvertTo-Json
}
finally {
    if ($verified) { $verified.Dispose() }
    if ($verifiedInput) { $verifiedInput.Dispose() }
    if ($result) { $result.Dispose() }
    if ($mask) { $mask.Dispose() }
    if ($generated) { $generated.Dispose() }
    if ($source) { $source.Dispose() }
    if ($maskInput) { $maskInput.Dispose() }
    if ($generatedInput) { $generatedInput.Dispose() }
    if ($sourceInput) { $sourceInput.Dispose() }
}
