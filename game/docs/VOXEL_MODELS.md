# 3D voxel firearm models

The armory and first-person view now use original, volumetric voxel geometry for
all 35 firearms. These are stylized visual approximations based on recognizable
real-world silhouettes, not dimensionally accurate replicas. Related roster
variants share family geometry; this is not 35 independently authored meshes.
The six melee weapons retain the earlier simple models.

## Ready-to-import files

Download `game/assets/VoxelWeapons-35-models.zip` and extract it.

- **Roblox Studio:** insert a `.rbxmx` with **Insert from File**. Each file is a
  complete anchored Model with a PrimaryPart, ready to position and rotate.
- **Other 3D tools:** import an `.obj` with its matching `.mtl` alongside it to
  retain the colors. Models use Y-up coordinates and +X as the barrel direction.
- The ZIP files contain static geometry only. The game scripts supply shooting;
  importing an asset alone does not create a functional Tool or ammunition system.

`game/assets/VoxelWeapons-preview.png` shows six examples rendered from the actual
geometry. It is an offline render, not a Roblox Studio screenshot. Exported files
have been checked for parseable XML and valid mesh indexing; Roblox import still
requires Studio verification.

## Use the Luau builders

After building/opening the place or syncing the project, run in Studio's Command
Bar in **edit mode**:

```lua
local fps = game.ReplicatedStorage.FPS
local catalog = require(fps.WeaponCatalog)
local models = require(fps.WeaponModel)
local gun = models.build(catalog.ById.M4A1)
gun:PivotTo(CFrame.new(0, 5, 0))
gun.Parent = workspace
```

Generate a gallery in edit mode and then save selected models to files:

```lua
local gallery = require(game.ReplicatedStorage.FPS.WeaponGallery)
gallery.build(workspace, CFrame.new(0, 5, 0), {
    "M4A1", "AK-103", "MP5", "M870", "AWM", "Glock 17",
})
```

Omit the third argument to generate all 35 firearm models. The gallery is an
optional authoring tool; it is not spawned in the live practice range.

For a moving world prop or hand attachment, build a model and mount it to a
BasePart on the server:

```lua
-- basePart is the existing hand or moving prop; offset is the desired grip pose.
models.mount(gun, basePart, CFrame.new())
```

Generated Luau models include `Anchor.Muzzle` and `Anchor.RightHandGrip`
Attachments, plus `WeaponId`, `VoxelFamily`, and `VoxelCount` metadata. Component
names distinguish Magazine, Slide, Scope, Trigger, and other pieces for later
animation work. `mount` makes all parts massless and welds them to the supplied
part. Call it once per model. Models intentionally have no collision, touch or
raycast participation, so visual geometry does not obstruct server combat rays.
The player avatar does not yet receive a replicated third-person held gun.

## Geometry and presentation

- Integer voxel shapes use 0.085-stud cells, including stepped circular barrels,
  open muzzle bores, guard openings, curved magazines and scopes where applicable.
- Metal, polymer, wood and glass parts use separate palette colors and actual
  Roblox lighting. No baked fake image is used as the geometry.
- Contiguous same-component/color voxels merge along X into rectangular runs.
  The visible voxel silhouette is preserved, with at most 485 render Parts per
  firearm in this revision. All 35 models fit the tested 1,200-part ceiling.
- Armory and custom design previews support mouse drag rotation and wheel zoom.
- Cosmetic workshop profiles remain separate: they use the player's painted 2D
  grid extruded into 3D, rather than the real-world-inspired system shapes.

## Validation limits

Automated checks rebuild all 35 guns, check voxel depth, material references,
nonoverlap, exact merged volume, required components, scope presence, muzzle
clearance and regeneration. Existing combat tests still pass and the updated
place builds with Rojo. Roblox Studio, in-game visuals, welded hand poses,
multiplayer replication, mobile orbit controls and performance on target devices
have not been tested here. Rotate a few models in Studio, check material/shadow
appearance and profile first-person rendering before release.
