# Acceptance tests

Use this rubric to validate the skill and generated outputs.

Use this file only for skill development, regression testing, or explicit user-requested scoring and acceptance. Do not load it during normal image generation.

## Pass threshold

Score the final image out of 100:

- Source fidelity: 20
- Canonical geometry: 25
- Face stability: 20
- Material quality: 15
- Block scale and texture discipline: 10
- Lighting and composition: 10

A result passes at **85 or higher** with no critical failure.

## Critical failures

Any of these fails the result regardless of score:

- `@真` is enabled and any protected person's face, expression, gaze, hair, glasses, hands, body contour, clothing detail, accessories, pose, scale, rotation, position, crop, or photographic texture changes;
- `@真` is enabled and major ridgelines, slopes, roads, water, tree masses, buildings, fences, clouds, or foreground-to-background relationships are rearranged;
- `@真` invents a prominent lake, mountain, road, building, torch, structure, or other scene element absent from the source;
- `@真` removes major source terrain, water, roads, fences, vegetation zones, or buildings;
- a normal `@真` request triggers automatic mask generation, pixel-difference analysis, or source-plate compositing without the user requesting strict pixel locking;
- a converted person has realistic, duplicated, crossed, or badly misaligned facial features;
- an open realistic mouth, individual teeth, modeled lips, or protruding realistic nose appears;
- the player body uses rounded anatomy, bent sculpted limbs, fingers, or toy joints;
- prominent surfaces read as glossy plastic, resin, wax, ceramic, or beveled collectibles;
- the image is dominated by tiny cubes, voxel dust, or fragmented mosaic geometry;
- subject count, main pose, or key props materially change;
- unrequested text, logo, watermark, HUD, or crosshair appears.
- UI is requested but the hotbar is entirely empty, the selected slot is empty, or fewer than seven slots contain recognizable items.

## Scoring anchors

### Source fidelity — 20

- 18–20: same count, pose, placement, framing, props, gaze, and light logic.
- 14–17: recognizable with minor shifts.
- 0–13: material pose, crop, identity-cue, or background changes.

### Canonical geometry — 25

- 22–25: people use the six-part player rig; objects use few large boxes; silhouettes are crisp.
- 17–21: mostly correct with a few unnecessary parts.
- 0–16: rounded anatomy, sculpted joints, miniature-toy construction, or dense cube tracing.

### Face stability — 20

- 18–20: aligned pixel eyes, coherent gaze, one short mouth mark, stable hairline.
- 14–17: readable but mildly asymmetric.
- 0–13: realistic face anatomy, malformed expression, teeth, duplicate features, or eye drift.

For images without people, award the face score based on whether animal/mob faces use the same stable flat-symbol principle.

### Material quality — 15

- 13–15: matte planes, restrained pixel color, broad per-face lighting, clean contact occlusion.
- 10–12: slightly smooth or shiny but still game-like.
- 0–9: plastic, wax, resin, ceramic, strong bevel shine, or photoreal material response.

### Block scale and texture discipline — 10

- 9–10: large geometry carries the form; fine detail lives in pixel patches.
- 7–8: a few areas are overbuilt.
- 0–6: micro-cubes are used as texture, fur, feathers, foliage, water spray, or photo pixels.

### Lighting and composition — 10

- 9–10: source direction and temperature are preserved; subject/background hierarchy is clear.
- 7–8: coherent but generic.
- 0–6: inconsistent face lighting, excessive depth blur, random rim lights, or lost focal hierarchy.

## Test matrix

### 1. Single-person portrait

Prompt: `把这张照片变成 Minecraft 风格。`

Expect:

- source ratio and crop retained;
- canonical six-part player model;
- outfit and hair remain recognizable through large color regions;
- flat stable face;
- key-art mode, no UI;
- no plastic shine or micro-cubes.

### 2. Close-up smiling selfie

Prompt: `Minecraft 化这张自拍，人也方块化。`

Expect:

- smile simplified to one closed pixel mouth mark;
- no teeth, lips, nostrils, cheeks, eyelashes, or sculpted nose;
- eyes remain aligned even if exact expression likeness is reduced;
- selfie camera relationship and arm direction remain recognizable.

### 3. Group photo

Prompt: `把所有人都变成 Minecraft 角色。`

Expect:

- exact person count;
- each face uses the same stable face grammar without duplicated features;
- identities remain distinguishable by hair, skin tone, outfit palette, accessories, and placement;
- body scale stays consistent across the group.

### 4. Fur or feather stress test

Prompt: `把这只长毛动物/飞鸟变成 Minecraft 风格。`

Expect:

- body, head, legs, wings, ears, or tail use a small number of large forms;
- fur and feathers become flat pixel patches;
- no glossy strand-like pieces or cube dust.

### 5. Water and foliage stress test

Prompt: `把这张湖边森林照片变成 Minecraft 风格。`

Expect:

- trees use trunk columns and broad leaf clusters;
- water uses large tiled planes and simple pixel bands;
- splashes and reflections are simplified;
- distant vegetation is less detailed than foreground vegetation.

### 6. Preserve real person

Prompt: `@真，把环境变成 Minecraft 风格。`

Expect:

- all people remain the exact photographic source plate rather than a newly generated lookalike;
- one direct edit of the original upload is attempted first;
- the existing environment is blockified in place rather than replaced with a similar new scene;
- the horizon, mountain ridgelines, slopes, roads, water and shorelines, tree masses, fences, clouds, negative spaces, and depth relationships stay aligned to the source;
- no major scene element is invented, removed, relocated, enlarged, shrunk, or redesigned;
- no automatic mask-generation or compositing workflow runs when the first result looks correct;
- face geometry, expression, gaze, hairline, glasses, hands, fingers, body contour, clothing folds, accessories, pose, scale, rotation, placement, crop, focus, grain, and lighting match the uploaded source;
- no partial blockification of skin, hair, hands, or clothing;
- environment is rebuilt with large block masses;
- the environment adapts to the person's original lighting;
- contact shadows and color interaction are added outside the protected person silhouette only;
- no pasted-edge halo.

### 6A. Preserve real person with 16:9 UI

Prompt: `@真 @UI`

Expect:

- the source person remains unchanged and is not regenerated to fit 16:9;
- the full person, worn accessories, and held props remain inside the frame;
- the person's bounding-box center, scale, pose, and crop remain anchored;
- the canvas is extended with environment rather than by moving or resizing the person;
- the HUD does not overlap the protected person region;
- all preserve-real-person checks from Test 6 pass.

### 7. Gameplay HUD

Prompt: `@UI，把这张图做成游戏截图。`

Expect:

- 16:9 output;
- one nine-slot hotbar, one selected slot, hearts, hunger, and XP bar;
- 7–9 hotbar slots contain distinct recognizable pixel-item icons;
- the selected slot contains a clearly visible tool or item;
- item icons are centered inside their slots and do not float outside the hotbar;
- the item set is coherent, such as a pickaxe, sword, axe, shovel, torch, food, building block, map, or compass;
- no second hotbar, duplicate item row, malformed colored blobs, or nine empty slots;
- no crosshair unless separately requested;
- HUD does not cover a face or key prop.

### 8. Independent crosshair

Prompt: `@准星，不要其他 UI。`

Expect:

- source ratio retained;
- exactly one centered crosshair;
- no hotbar, hearts, hunger, XP bar, hand, menu, or text.

### 9. Empty-hotbar repair

Input: a generated `@UI` result whose hearts, hunger and hotbar frame are correct but whose nine slots are empty.

Repair prompt:

`Keep the entire image and HUD layout unchanged. Populate the existing hotbar with 7–9 distinct recognizable pixel items and put a clear tool in the selected slot. Do not add a second hotbar.`

Expect:

- only the slot contents change;
- the selected outline, hearts, hunger icons, XP bar, composition and subjects remain unchanged;
- at least seven slots contain readable item silhouettes;
- no item appears outside a slot.

## Repair verification

When a draft fails, verify that the repair:

- changes only the named failed property;
- preserves composition, pose, identity cues, palette, and successful areas;
- does not introduce a new critical failure;
- improves the total score.

For `@真` identity failures:

- restart once from the original upload with a shorter region-based prompt;
- do not use the altered draft as the identity source;
- do not repair the face, hands, body, clothing, or accessories by generative approximation.

For an explicitly requested strict pixel-lock workflow:

- require a reliable supplied or tool-native person mask;
- allow deterministic source-plate compositing and pixel verification;
- reject masks that include visible background or cut into the person.

## Runtime behavior tests

### Runtime routing test

Prompt: `跑一下这张 @真`

Expect:

- no visual-grammar file read;
- no acceptance-test file read;
- no mask generation;
- no restoration script;
- no pixel-difference analysis;
- one direct image edit;
- maximum one retry only after obvious identity drift or scene-layout drift;
- any retry restarts from the original upload and appends only the relevant one-sentence lock.

### Follow-up UI test

Initial prompt: `跑一下这张 @真`

Follow-up prompt: `加上 UI，改成 16:9`

Expect:

- edit the accepted result;
- do not restart from the original photo;
- do not regenerate the block environment;
- preserve the accepted person and environment;
- modify only canvas extension and HUD.
