# Cat Customization

Use this guide to let DockCat use your own cat art.

DockCat custom cats are local asset packs. Each pack is one folder with a `manifest.json` file and transparent PNG images for poses and animation frames. You can start with one pose for preview, then add the remaining poses until the pack is complete.

## Quick Start

1. Create a folder under:

```text
~/Library/Application Support/DockCat/CatPacks/
```

2. Give the folder a stable lowercase ID, for example:

```text
~/Library/Application Support/DockCat/CatPacks/my-cat/
```

3. Add `manifest.json`.
4. Add at least one image you want to preview, such as `poses/dialogue/stand.png`.
5. Restart DockCat.
6. Open Settings > Pet, enter the resource pack ID, for example `my-cat`, and save.

## Minimal Preview Pack

DockCat supports incomplete packs for preview. This is useful when you have only one pose ready.

```text
my-cat/
  manifest.json
  poses/
    dialogue/
      stand.png
```

Minimal `manifest.json`:

```json
{
  "id": "my-cat",
  "name": "My Cat",
  "author": "Your Name",
  "canvas_width": 512,
  "canvas_height": 512,
  "default_anchor": { "x": 0.5, "y": 0.88 }
}
```

When this pack is selected, DockCat uses your `poses/dialogue/stand.png` for dialogue and the Settings > Pet preview. Missing resting, held, transition, and walking assets are filled from the bundled default cat.

If `manifest.json` cannot be parsed, DockCat ignores the custom pack and falls back to the bundled default cat.

## Complete Pack Structure

A complete shareable pack should include every asset type, for example:

```text
my-cat/
  manifest.json
  poses/
    resting/
      loaf.png
      side.png
    held/
      held.png
    dialogue/
      stand.png
    transition/
      stretch.png
  animations/
    walk/
      walk_01.png
      walk_02.png
      walk_03.png
  app_icons/
    icon_sleep.png
    icon_empty.png
```

`app_icons/` is optional. Everything else is recommended for a complete pack.

## Pose Requirements

DockCat scans each pose folder and loads every readable image file in that folder. File names do not matter, but clear names make your pack easier to maintain.

- `poses/resting/`: one or more resting poses. DockCat randomly chooses one when the cat rests.
- `poses/held/`: one or more poses used while the cat is dragged.
- `poses/dialogue/`: one or more front-facing poses used for reminders, outing messages, and Settings > Pet preview.
- `poses/transition/`: one or more short transition poses, such as stretching or yawning.
- `animations/walk/`: walking animation frames. Filenames decide playback order.

DockCat mirrors pose and walk images automatically when the cat needs to face the other direction. You don't need to create left-facing and right-facing views separately.

## Fallback Behavior

Incomplete packs are allowed. Missing or unreadable resources fall back to the default cat by resource type.

This keeps your cat visible while you are still making assets. For a final public pack, provide all pose and animation types so the cat does not visually switch between your art and the default cat.

## Image Rules

- Use PNG files with transparent backgrounds.
- Use the same canvas size for every cat pose and walk frame. `512 x 512 px` is recommended.
- Keep the cat at a consistent visual size across all images.
- Keep the paw-bottom or body-bottom anchor in a consistent position so the cat does not jump when changing states.
- Leave transparent margin around the cat. At least 8% margin is recommended.
- Use lowercase English file and folder names with letters, numbers, underscores, or hyphens only.
- Do not include floors, shadows, scenery, UI, text, or unrelated props unless a pose specifically needs them.
- Use one visual style across the full pack: same line weight, color palette, lighting, and canvas position.

## Manifest

`manifest.json` lives at the root of the pack.

Complete example:

```json
{
  "id": "my-cat",
  "name": "My Cat",
  "author": "Your Name",
  "canvas_width": 512,
  "canvas_height": 512,
  "default_anchor": { "x": 0.5, "y": 0.88 },
  "poses": {
    "resting": "poses/resting",
    "held": "poses/held",
    "dialogue": "poses/dialogue",
    "transition": "poses/transition"
  },
  "animations": {
    "walk": { "fps": 3, "frames": [] }
  },
  "app_icons": {
    "sleep": "app_icons/icon_sleep.png",
    "empty": "app_icons/icon_empty.png"
  }
}
```

Field notes:

- `id`: must match the resource pack ID you enter in Settings > Pet. Use stable lowercase text, such as `my-cat`.
- `name`: display name for humans.
- `author`: creator name.
- `canvas_width` and `canvas_height`: source PNG canvas size.
- `default_anchor`: reserved for pack metadata. Keep `{ "x": 0.5, "y": 0.88 }` unless the app adds anchor editing later.
- `poses`: optional for preview packs. Omitted keys default to `poses/resting`, `poses/held`, `poses/dialogue`, and `poses/transition`.
- `animations.walk.fps`: walking animation playback speed. `3` is a good starting point.
- `animations.walk.frames`: currently ignored by DockCat; frames are scanned from `animations/walk/` and sorted by filename.
- `app_icons`: optional. Omit it if the pack does not provide custom app icons.

Legacy keys `stand` and `stretch` are still accepted as aliases for `dialogue` and `transition`, but new packs should use `dialogue` and `transition`.

## App Icons

DockCat can use custom app icons from your cat pack:

```text
my-cat/app_icons/
  icon_sleep.png
  icon_empty.png
```

- `icon_sleep.png`: your cat sleeping on a cushion.
- `icon_empty.png`: the same cushion without the cat.
- Use `1024 x 1024 px` PNG sources.
- Keep both icons visually matched: same cushion, scale, palette, and lighting.

When DockCat successfully loads a valid icon pair, it copies them to:

```text
~/Library/Application Support/DockCat/AppIcon/
```

DockCat uses that cached copy as the persistent custom app icon. Replacing or updating the DockCat app does not delete the cached local icons. If a replaced app briefly shows the bundled icon while DockCat is not running, launch DockCat once and it will reapply the cached sleeping icon to the current `.app` file icon.

Icon files are not hot-reloaded. Restart DockCat after adding, replacing, or editing `app_icons/icon_sleep.png` or `app_icons/icon_empty.png`.

## Loading And Updating

After adding or changing a custom pack:

1. Restart DockCat.
2. Open Settings > Pet.
3. Set Resource Pack ID to the folder ID, such as `my-cat`.
4. Save.

When changing only Settings values, saving is enough. When changing files inside a pack, restart DockCat so the asset scanner sees the new files.

## Troubleshooting

If the pack does not appear:

- Check that the folder is directly under `~/Library/Application Support/DockCat/CatPacks/`.
- Check that `manifest.json` is valid JSON.
- Check that `manifest.json` `id` matches the ID entered in Settings > Pet.
- Check that image files are readable PNGs.
- Restart DockCat after changing files.

If only some states show your cat:

- The missing states are using default fallback assets.
- Add images to the matching folder: `resting`, `held`, `dialogue`, `transition`, or `animations/walk`.

If the cat jumps when changing poses:

- Make every PNG use the same canvas size.
- Align the cat body and paw-bottom consistently across all pose files.
- Keep transparent margins consistent.

If the walk animation plays in the wrong order:

- Rename frames so filename sorting matches playback order, for example `walk_01.png`, `walk_02.png`, `walk_03.png`.

## Final Pack Checklist

Before sharing a finished pack, confirm:

- `manifest.json` parses and has the intended `id`.
- Every pose type has at least one readable PNG.
- `animations/walk/` has readable frames in the right order.
- All pose and walk files use the same canvas size.
- The cat keeps a consistent visual scale and bottom anchor.
- The pack does not depend on default fallback assets unless that is intentional.
- Optional app icons are `1024 x 1024 px` and visually matched.

## Generating Art

Use `ImageGenerationPrompts.md` for prompt templates. Start with the shared cat art style, then combine it with the static pose or animation template you need.

When generating a full pack, make one dialogue pose first. Use it as the visual reference for the other poses and animation frames so the cat identity, colors, outline weight, and scale stay consistent.
