# Cat Customization

Use this guide to let DockCat use your own cat art.

DockCat custom cats are local asset packs. Each pack is one folder with a `manifest.json` file and transparent PNG images for poses and animation frames. You can start with one pose for preview, then add the remaining poses until the pack is complete.

## Quick Start

1. Open DockCat Settings > Pet.
2. Click `打开资源包位置`. DockCat opens:

```text
~/Library/Application Support/DockCat/CatPacks/
```

3. Open the pre-created `my-cat/` template folder.
4. Add at least one image you want to use to the corresponding pose folder, such as `poses/dialogue/stand.png`.
5. Return to Settings > Pet, select or enter `my-cat`, click `加载所选`, then save.

The resource pack ID is the folder name under `CatPacks/`.

DockCat supports incomplete packs for preview. Missing assets are filled from the default cat.

## Complete Pack Structure

A complete shareable pack should include at least one image for every asset type, for example:

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

DockCat scans each pose folder and loads every loadable image file in that folder. You can use whatever filename for the images, but clear names make your pack more readable.

When the cat switch to a pose, DockCat randomly presents one image from the corresponding folder. You can add any number of images you would like your cat to have for each pose.

- `poses/resting/`: one or more resting poses. 
- `poses/held/`: one or more poses used while the cat is being dragged.
- `poses/dialogue/`: one or more front-facing poses used for reminders, outing messages, and Settings > Pet preview.
- `poses/transition/`: one or more short transition poses, such as stretching or yawning.
- `animations/walk/`: walking animation frames. Filenames decide playback order.

DockCat mirrors pose and walk images automatically when the cat needs to face the other direction. You don't need to create left-facing and right-facing views separately.

## Image Rules

We recommend the following for the best experience:

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

- `id`: compatibility and description field. DockCat selects packs by folder name, so this does not need to match the resource pack ID entered in Settings > Pet. However, if you would like to share your pack with the community, we recommend changing it to a unique id.
- `name`: Name of the cat.
- `author`: creator name.
- `canvas_width` and `canvas_height`: stable canvas size for walking animation rendering. Change these values when your walk frames use a different intended canvas size. Static pose images do not use these manifest values for display size; they are shown from their actual PNG dimensions.
- `default_anchor`: reserved for pack metadata. Keep `{ "x": 0.5, "y": 0.88 }` unless the app adds anchor editing later.
- `poses`: optional for preview packs. Omitted keys default to `poses/resting`, `poses/held`, `poses/dialogue`, and `poses/transition`.
- `animations.walk.fps`: walking animation playback speed. `3` is a good starting point.
- `animations.walk.frames`: currently ignored by DockCat; frames are scanned from `animations/walk/` and sorted by filename.
- `app_icons`: optional. Omit it if the pack does not provide custom app icons.

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

1. Open Settings > Pet.
2. Click `打开资源包位置` if you need Finder access.
3. Select or enter the folder ID, such as `my-cat`.
4. Click `加载所选` to rescan and validate the pack.
5. Save.

When changing only Settings values, saving is enough. When changing image files inside a pack, click `加载所选` so the asset scanner sees the new files. If you change `manifest.json`, restart DockCat so the app reloads the manifest values. Icon file updates also require restarting DockCat.

## Troubleshooting

If the pack does not appear:

- Check that the folder is directly under `~/Library/Application Support/DockCat/CatPacks/`.
- Check that `manifest.json` is valid JSON.
- Check that the folder name matches the ID entered in Settings > Pet.
- Check that image files are readable PNGs.
- Click `加载所选` after changing files.

If only some states show your cat:

- The missing states are using default fallback assets.
- Check images in the matching folder: `resting`, `held`, `dialogue`, `transition`, or `animations/walk`.

If the cat jumps when changing poses:

- Make every PNG use the similar canvas size.
- Align the cat body and paw-bottom consistently across all pose files.
- Keep transparent margins consistent.

If the walk animation plays in the wrong order:

- Rename frames so filename sorting matches playback order, for example `walk_01.png`, `walk_02.png`, `walk_03.png`.

If the walking cat is much smaller or larger than other states:

- Open `manifest.json` and adjust `canvas_width` and `canvas_height` to match the intended walking animation canvas.
- For example, if your walk frames are designed around a `1500 x 1500 px` canvas, set both values to `1500`.
- Restart DockCat after changing `manifest.json`.

