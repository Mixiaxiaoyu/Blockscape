---
name: blockscape
description: 方境 Blockscape directly edits uploaded images in place into polished Minecraft-like block-game worlds while preserving the source scene layout, terrain, roads, water, vegetation, buildings, sky, and depth relationships. Use for Minecraftify, blockify, voxel, or block-world image requests; `@真` or equivalent requests that keep people photographic; `@UI` HUD or hotbar requests; `@准星` crosshair requests; and explicit `@锁` pixel-locked person compositing with a reliable mask.
---

# 方境 Blockscape

把现实带进方块世界。Bring reality into a world of blocks.

## Check the input

- Require a usable uploaded image. If none exists, ask for one.
- Use the uploaded image as the actual image-edit input, not as text inspiration.
- If several images exist, use the one the user identifies as the source.
- When an image-edit tool is available, call it directly; do not merely return a prompt.
- Do not output a long analysis before editing.

## Route before reading or prompting

Choose the route before loading any reference or building a prompt:

- **A — Default blockification:** Minecraft, block-world, voxel, “跑一下这张,” or equivalent without another human-treatment switch.
- **B — Fast real-person preservation:** `@真`, “人物保持真人,” “保留真人,” “keep the person real,” or “keep me real.”
- **C — UI:** `@UI`, HUD, hotbar, “添加游戏 UI,” “添加快捷栏,” or “游戏截图.”
- **D — Crosshair:** `@准星`, “添加准星,” or “crosshair.”
- **E — Strict pixel lock:** `@锁`, `@像素锁`, “像素级锁定人物,” “人物必须保持原始像素,” or “生产级人物合成.”

Keep routes isolated:

- `@锁` is explicit and never inferred from `@真`.
- `@UI` means 16:9 plus the complete survival HUD and does not include a crosshair.
- `@准星` implies `@UI`: output 16:9 with the complete survival HUD and exactly one centered crosshair.
- `@UI @准星` is identical to `@准星`; never duplicate the HUD or crosshair.
- If `@真` and `@UI` appear in the first request, perform person preservation, environment conversion, 16:9 extension, and HUD creation in one image edit.
- If `@真` and `@准星` appear, perform the same combined edit and add exactly one centered crosshair.
- If UI or a crosshair is requested after a result was accepted, edit that accepted result only. Do not restart from the original or rerun Blockscape conversion.
- Normal generation must not read tests or run a full scoring rubric.

## Canvas-size rule

- Without `@UI` or `@准星`, preserve the uploaded source image's exact pixel dimensions and aspect ratio.
- This applies to default blockification, `@真`, and `@锁`.
- Do not crop, extend, letterbox, rotate, or change orientation without `@UI` or `@准星`.
- Both `@UI` and `@准星` switch the output canvas to 16:9.
- Extend the environment laterally when needed instead of moving, resizing, or cropping the main subject.

## A — Default blockification

- Edit the source directly and preserve its exact pixel dimensions and aspect ratio.
- Preserve subject count, main pose, framing, camera height, horizon, key props, palette, and light direction.
- Convert visible people into canonical block-game characters.
- Use one square head, one rectangular torso, two whole rectangular arms, and two whole rectangular legs.
- Keep limbs rigid and rectangular; do not add fingers, elbows, knees, rounded joints, or anatomical curves.
- Use a flat low-resolution pixel face.
- Express small details as flat pixel-color patches, not piles of micro-cubes.
- Build the environment from large blocks, broad stepped terrain, and clear silhouettes.
- Keep surfaces matte; avoid plastic, resin, bevel shine, and toy-like materials.
- Do not add UI or a crosshair unless explicitly requested.
- Do not expand into lengthy art-theory analysis.
- Read `references/visual-grammar.md` only for blockification, requested visual analysis, development, or an obvious structural failure.

## B — Fast `@真`

Run this as a short independent path:

1. Edit the user's original upload directly.
2. Keep every visible person photographic and unchanged; blockify the existing environment in place instead of replacing it with another scene.
3. Do not describe age, gender, race, face shape, facial features, identity, or clothing details.
4. Do not create or output a person source lock.
5. Do not apply six-part character, pixel-face, or block-anatomy rules.
6. Do not read `references/visual-grammar.md`, `references/identity-lock.md`, tests, or the restoration script.
7. Do not create a mask, run pixel-difference analysis, composite a source plate, or run PowerShell.
8. Treat the source as a locked spatial blueprint: preserve the horizon, ridgelines, slope directions, road and path routes, shorelines, tree-mass locations, buildings, fences, cloud distribution, and foreground-to-background occlusion.
9. Change only environmental materials and local geometric treatment. Do not add, remove, move, enlarge, shrink, or redesign major background elements.
10. Call the image-edit tool once, then make one quick person-and-scene check.

Check only:

- whether a face clearly became another person;
- whether expression clearly changed;
- whether pose, size, or position clearly moved;
- whether any person was partially blockified.
- whether the horizon, major ridgelines, roads, water, or large tree masses clearly moved or changed shape;
- whether prominent elements absent from the source were invented, such as a lake, mountain, road, building, torch, or structure;
- whether major source terrain, roads, water, fences, vegetation zones, or buildings disappeared.

If none occurred, return immediately.

Retry only for obvious person drift or scene-layout drift:

- restart from the user's original upload, never the drifted result;
- for person drift, append only: `The person is a protected unchanged photographic region. Edit outside the person only.`;
- for scene-layout drift, append only: `The source environment is a locked spatial blueprint. Restyle every existing background region in place without replacing, rearranging, adding, or removing scene elements.`;
- retry at most once and do not add appearance descriptions.

## C — `@UI`

- Output at 16:9 and extend the environment laterally.
- Add one nine-slot survival hotbar, one selected slot, hearts, hunger icons, and one experience bar.
- Put 7–9 distinct recognizable pixel items in the hotbar; the selected slot must contain an item.
- Prefer a pickaxe, sword, axe, shovel, torch, food, building block, map, or compass.
- For a first request, include UI in the same edit as the requested Blockscape transformation.
- Do not add a crosshair unless `@准星` is also present.
- For a follow-up, preserve the accepted person and environment and modify only canvas extension and HUD.

## D — `@准星`

- Apply every `@UI` rule: output 16:9 and add the complete survival HUD.
- Add exactly one small centered pixel crosshair.
- Do not add a second HUD or second crosshair when `@UI` is also present.
- Do not change the person or scene.
- For a follow-up, edit the accepted result directly.

## E — Strict `@锁`

- Enter only after an explicit strict-lock request.
- Require a reliable user-supplied person mask or reliable native region mask.
- Never invent a mask from a model guess or claim a rough mask is pixel-accurate.
- If no reliable mask exists, state that pixel-level locking cannot be guaranteed.
- With valid source, generated, and mask files, use `scripts/restore-person-plate.ps1`.
- Read `references/identity-lock.md` only for strict-lock instructions or real-person troubleshooting.
- Restore original protected pixels, verify them, and return the script's verification result with the image.
- Keep this slower deterministic workflow completely separate from fast `@真`.

## Prompt templates

### Default blockification

```text
Edit the uploaded image directly into polished block-building-game key art.

Preserve the original subject count, main pose, framing, camera height, horizon, key props, palette, and light direction.

Preserve the uploaded source image's exact pixel dimensions and aspect ratio.

Convert visible people into canonical six-part block-game characters using one square head, one rectangular torso, two whole rectangular arms, and two whole rectangular legs.

Use a flat stable low-resolution pixel face, few large cuboids, broad stepped terrain, restrained pixel-color patches, matte planar surfaces, crisp square silhouettes, and soft contact shadows.

Do not use rounded anatomy, modeled fingers, glossy toy materials, bevels, realistic facial anatomy, micro-cube fragmentation, extra people, text, logos, watermarks, HUD, or a crosshair.
```

### Fast `@真`

```text
Edit the uploaded image directly.

Keep every visible person exactly real and unchanged.

Transform only the existing environment into a polished Minecraft-like block-building game world, in place.

Treat the source image as a locked spatial blueprint, not as inspiration for a new scene. Every source region must keep the same semantic role, position, scale, silhouette, direction, and depth relationship.

Preserve the exact horizon, mountain ridgelines, hill slopes, road and path routes, river and shoreline geometry, tree-mass locations, buildings, fences, rocks, cloud placement, foreground-to-background layering, and all major negative spaces.

Change only environmental materials and local surface geometry into block-game forms. Do not replace the background with a generic block landscape. Do not invent, remove, relocate, enlarge, shrink, or redesign any major scene element.

Preserve each person's face, expression, hair, body, clothing, accessories, pose, scale, position, crop, focus, and original photographic appearance.

Do not redraw, restyle, retouch, relight, recolor, move, resize, re-pose, replace, or blockify any part of a person.

Preserve the source composition and aspect ratio.

Preserve the uploaded source image's exact pixel dimensions. Do not crop, extend, letterbox, rotate, or change orientation.

Do not add extra people, text, logos, watermarks, UI, or a crosshair unless explicitly requested.
```

### UI addendum

```text
Output in 16:9.

Extend the environment laterally instead of moving, resizing, or rebuilding the main subject.

Add one clean nine-slot survival hotbar with 7–9 distinct recognizable pixel items. The selected slot must contain a clearly visible item.

Add aligned hearts, hunger icons, and one experience bar.

Do not add a crosshair unless `@准星` is also present.
```

### Crosshair addendum

```text
Apply the complete UI addendum: output in 16:9 with one nine-slot survival hotbar, one selected slot, hearts, hunger icons, and one experience bar.

Add exactly one small centered pixel crosshair.

Do not add a second hotbar, second HUD, or second crosshair.
```

## Generation limit and return

- A normal request gets one image-generation or image-edit call.
- Allow at most one extra retry only after an obvious critical failure.
- For `@真`, retry only after obvious person drift or scene-layout drift, and restart from the original upload.
- Do not generate default drafts, run a repair loop, redo the whole image for minor issues, or continue after a normal first result.
- Return the final image with at most one short sentence.
- Do not expose internal prompts, routing, checks, or critique unless requested.
