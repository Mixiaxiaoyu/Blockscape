> Authoring and troubleshooting reference only.
> Do not load this file during normal `@真` execution.
> The runtime-critical visual rules are already embedded in SKILL.md.

# Visual grammar of the target style

This reference distills the shared visual language visible across the supplied official block-game character lineups, adventure key art, ensemble art, landscape scenes, and sunset action scenes.

## 1. The central insight

The target is not “a photograph made of voxels.”

It is a **designed low-part-count character and world system**:

- forms are chosen for readability before texture;
- people are canonical rigs, not voxel sculptures of human anatomy;
- a limb is usually one rectangular prism, not a chain of cubes;
- a face is a flat symbol map, not a block-built portrait;
- environments use large placed blocks and broad clusters;
- small detail is encoded as color patches on surfaces.

This distinction prevents the three common failures: plastic-toy materials, broken faces, and excessive cube fragmentation.

## 2. Character geometry

### Primary rig

Use six dominant cuboids:

1. square head;
2. rectangular torso;
3. left arm;
4. right arm;
5. left leg;
6. right leg.

Use the familiar player-skin proportion system:

- head: 8×8×8;
- torso: 8×12×4;
- each arm: 4×12×4;
- each leg: 4×12×4.

The exact pixel dimensions are less important than their relationship. The head is intentionally large, the torso is flat front-to-back, and the limbs are narrow rigid prisms.

### Pose

- Rotate parts at the shoulder, hip, and neck pivots.
- Keep arms and legs straight as whole pieces.
- Use silhouette overlap and perspective to communicate action.
- Do not add elbows, knees, wrists, fingers, muscles, neck cylinders, or curved shoulders.

Official-looking action comes from the angle and spacing of rigid pieces, not anatomical deformation.

### Identity

Carry identity through:

- hair cap silhouette and color;
- skin-tone region;
- shirt/jacket/dress color blocks;
- trouser and shoe colors;
- hats, glasses, straps, tools, or other large accessories;
- body pose and place in the composition.

Do not chase exact facial likeness. A stable player-skin face is more authentic than a distorted block portrait.

## 3. Face grammar

Treat the front face of the head as an 8×8 pixel canvas.

- Eyes occupy one shared horizontal band.
- Each eye is a small rectangle or pair of square color cells.
- Pupils remain centered and mutually coherent.
- Brows, when present, are short flat marks.
- The mouth is one short horizontal mark.
- A beard, blush, or nose is a flat color region.
- Hair is primarily a skin texture with only a few optional rectangular silhouette pieces.

Expression range is intentionally narrow: neutral, friendly, determined, mildly surprised, or simple smile.

Avoid:

- open realistic mouths;
- individual teeth;
- lip volume;
- nostrils;
- protruding noses;
- eyelids, eyelashes, or realistic eye whites;
- cheek modeling;
- asymmetry copied from a photographic expression;
- tiny shaded face cubes.

## 4. Part-count hierarchy

Use geometry only when it changes silhouette, depth, or function.

Suggested budgets are guides, not hard numerical limits:

- player: 6 primary parts plus 0–4 simple accessory/hair pieces;
- small animal: roughly 5–12 primary boxes;
- tree: 1–3 trunk masses plus a few broad leaf clusters;
- common prop: 1–8 boxes or stepped pieces;
- terrain: large block terraces and continuous masses rather than isolated cube particles.

If a detail is visible only as a color change, it belongs in the texture.

## 5. Texture scale

The reference art uses low-resolution albedo logic even when rendered cleanly.

- Use perceptually large texels.
- Keep palettes compact.
- Use hard-edged color regions and nearest-neighbor-like transitions.
- Let clothing and skin use broad, quiet patches.
- Let grass, dirt, stone, wood, and leaves use sparse recognizable motifs.
- Avoid procedural high-frequency noise.

The outer silhouette may be cleanly antialiased. Antialiasing does not imply rounded geometry.

## 6. Material response

Opaque materials read as matte painted game surfaces, not physical toys.

- Most planes have one dominant value with subtle texture variation.
- Adjacent planes differ in brightness according to the key light.
- Contact occlusion appears beneath feet, at limb overlaps, under hair caps, and between terrain blocks.
- Highlights are broad and restrained.
- No white plastic streak should run along every edge.
- No bevel should be used to make cubes catch light.

Water and glass can carry transparency, tint, and bands, but should remain graphically simple.

## 7. Lighting

The supplied references share a readable, staged light hierarchy:

- one clear key direction;
- enough fill to preserve saturated local color;
- darker side and underside planes;
- contact shadow or ambient occlusion at intersections;
- optional warm backlight or rim in promotional scenes;
- no conflicting micro-highlights.

For source-photo conversion, preserve the source direction and temperature, then translate them into planar values.

Do not put a smooth spherical gradient across a cube face. The face should remain visibly planar.

## 8. Composition and camera

### Character lineups

- eye-level or slightly low camera;
- generous negative space;
- clear feet and silhouettes;
- simple background gradient;
- consistent character scale.

### Adventure key art

- dynamic three-quarter view;
- one or two large foreground heroes;
- smaller supporting mobs or props;
- diagonal action;
- background organized into broad depth layers;
- atmosphere and color support the subject rather than hiding it.

### World scenes

- terrain reads as large terraces;
- trees and structures form broad framing masses;
- distant detail is aggressively simplified;
- foreground color and contrast are stronger than background color and contrast.

## 9. Prompt vocabulary

Prefer:

- official-looking block-game key art;
- canonical player rig;
- six primary cuboids;
- single-piece rigid limbs;
- flat 8×8-style player-skin face;
- few large boxes;
- broad stepped terrain;
- matte planar color;
- restrained low-resolution pixel patches;
- crisp square silhouette;
- per-face value changes;
- soft contact occlusion.

Use once, in a concise exclusion:

- no glossy toy material;
- no bevels or rounded anatomy;
- no realistic facial anatomy;
- no micro-cube fragmentation.

Avoid repeatedly invoking the unwanted concept. Long negative lists can reinforce the very visual pattern they are trying to remove.

## 10. Diagnosis map

### Result looks like plastic

Likely causes:

- “3D render,” “toy,” “figurine,” or physically based material language;
- bevels added to catch highlights;
- uniform smooth materials with bright edge streaks.

Correction:

- keep geometry;
- remove bevels and specular streaks;
- use matte planes, broad per-face values, sparse pixel albedo, and contact occlusion only.

### Face is broken

Likely causes:

- instruction to preserve exact expression or likeness;
- realistic face words mixed with block-character words;
- open smile or teeth;
- too much face geometry.

Correction:

- replace only the face with a flat 8×8-style map;
- align the eyes;
- use one closed mouth mark;
- preserve identity elsewhere.

### Blocks are too fragmented

Likely causes:

- “voxelize every detail”;
- describing fur, hair, feathers, foliage, or water as geometry;
- no explicit part budget.

Correction:

- merge fragments into a few primary boxes;
- move detail into pixel patches;
- simplify the background more than the foreground.

### Result is generic pixel art

Likely causes:

- asking for pixelation without structural reconstruction;
- no source lock or depth plan.

Correction:

- restore 3D cuboid silhouettes, perspective, overlap, and planar lighting;
- preserve the source camera and spatial layers.
