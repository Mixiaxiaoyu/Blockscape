> Troubleshooting and strict-lock reference.
> Normal `@真` requests use the fast prompt embedded in SKILL.md and do not need to load this file.

# Real-person troubleshooting and strict pixel lock

Use this reference only when:

- fast `@真` has an obvious person-preservation failure that needs diagnosis;
- the user explicitly requests `@锁`, exact source pixels, production compositing, or forensic verification.

Do not load it during a normal `@真` request.

## Fast-path troubleshooting

The normal `@真` path is one direct edit of the original upload, followed by one visual check. It does not use masks, pixel comparison, or source-plate restoration.

Treat these as obvious drift:

- a face becomes a different person;
- the expression clearly changes;
- pose, scale, placement, or crop clearly moves;
- skin, hair, clothing, or another person region becomes blockified.
- the horizon, major ridgelines, roads, water, or large tree masses clearly move or change shape;
- a prominent lake, mountain, road, building, torch, or structure absent from the source is invented;
- major source terrain, water, roads, fences, vegetation zones, or buildings disappear.

When drift occurs:

1. discard the drifted result as an edit source;
2. return to the user's original upload;
3. reuse the short `@真` prompt from `SKILL.md`;
4. for person drift, append only: `The person is a protected unchanged photographic region. Edit outside the person only.`;
5. for scene-layout drift, append only: `The source environment is a locked spatial blueprint. Restyle every existing background region in place without replacing, rearranging, adding, or removing scene elements.`;
6. retry once.

Do not repair identity by describing facial features, clothing, body shape, or coordinates. Do not chain further retries.

## Follow-up edits

After the user accepts a result, use that accepted result for UI, crosshair, or aspect-ratio changes.

Preserve the accepted person and environment. Modify only the requested canvas extension or interface. Do not restart from the original photo or regenerate the block environment.

## Strict `@锁` prerequisites

Enter strict mode only after an explicit request such as:

- `@锁` or `@像素锁`;
- “人物必须保持原始像素”;
- “像素级锁定人物”;
- “生产级人物合成”.

Require:

- the original source image;
- the generated environment image;
- a reliable person mask supplied by the user or a trustworthy native region-mask tool;
- known placement offsets when the canvas size or origin changed.

Never infer a strict mask from a model guess. If the available mask includes background, cuts into the person, or has uncertain edges, state that pixel-level locking cannot be guaranteed.

## Strict workflow

1. Validate source, generated image, mask dimensions, canvas size, and offsets.
2. Generate or edit the environment without claiming the person is already pixel-exact.
3. Run `scripts/restore-person-plate.ps1` with the validated files.
4. Restore every protected source pixel at the requested offset.
5. Verify the saved output against the protected source pixels.
6. Return the final image and the script's JSON verification result.

The script accepts:

- `SourcePath`
- `GeneratedPath`
- `MaskPath`
- `OutputPath`
- `OffsetX`
- `OffsetY`
- `Threshold`

The JSON result retains:

- `output`
- `protected_pixels`
- `restored_pixels`
- `mismatched_pixels`
- `offset_x`
- `offset_y`
- `verified`

## Failure handling

- No reliable mask: do not run the script; explain the limitation.
- Protected pixels outside the generated canvas: correct canvas size or offsets before retrying.
- Nonzero mismatches: fail verification and do not label the output pixel-locked.
- Visible halo from a poor mask: reject the mask rather than hiding the problem with generative retouching.

Strict mode may be slower. That cost must never leak into normal `@真`.
