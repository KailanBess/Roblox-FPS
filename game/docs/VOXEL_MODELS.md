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

- Integer voxel shapes use 0.05-stud cells, including stepped circular barrels,
  open muzzle bores, guard openings, curved magazines and scopes where applicable.
- Metal, polymer, wood and glass parts use separate palette colors and actual
  Roblox lighting. No baked fake image is used as the geometry.
- Contiguous same-component/color voxels merge across all three axes into rectangular blocks.
  The visible voxel silhouette is preserved, with at most 471 render Parts per
  firearm in this revision. All 35 models fit the tested 600-part ceiling.
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

## Detail revision

The finer-grid revision replaces rectangular stock/grip outlines with filled
polygons: tapered buttstocks, angled pistol grips, thumbhole and skeleton stocks,
sloped forearms, and swept magazines. Family-specific modeling includes M4 carry
handle/front-sight tower, AK dust cover/gas tube/rivets, MP5 tubular upper and
tri-lug mount, P90 top magazine, shotgun vent rib and pump, bolt-action handles,
Glock slide serrations/chamber, and Beretta open-top slide/exposed barrel.

Additional details include receiver chamfers, flared magwells, controls, ejection
ports, buffer tubes, stock openings, grip texture, scope rings/turrets, rail teeth,
belt rounds, bipods, and smaller pistol sights. The palette uses restrained metal,
polymer, wood and rubber finishes; voxel edges remain visible. Store combat stats
are unaffected. Geometry is original stylized interpretation, not a claim of
manufacturer-accurate dimensions or individually sculpted variants for every ID.

## Proportion and component-fit revision

The complete assembly is 11% larger through the cell-size change, with coherent
length increases of 25% for long guns, 18% for SMGs and 12% for pistols before that
size change. X coordinates are resampled on the cubic voxel grid, including grip,
muzzle and sight coordinates; components are not scaled independently.

Floating geometry found in the previous revision was corrected at the authored
mounts: stock cheek rests, guard hangers, grip tangs, charging handles, bipod hinges,
scope reducers and feet, bullpup handle supports, and Vector magazine well.
Automated flood-fill checks now require every voxel in every firearm to connect
to its body through shared faces. This checks assembly geometry, not animation
clearance or physical operation of a real firearm.

Iron sights are built after the body and rail, using their actual mounting surface
heights. Rear aperture and front post share one centered sight plane; tests require
an open rear aperture, an actual post at the aim point, and a clear intervening
sight line. Scoped variants omit competing iron-sight pairs. Luau models expose
`Anchor.RearSight` and `Anchor.FrontSight` Attachments when irons are present.

The armory camera now fits all eight bounding-box corners for the current orbit
angle and viewport size instead of using a fixed distance. Selection resets zoom;
wheel zoom remains available. Gallery spacing accommodates the longer models.
`assets/VoxelWeapons-fit-check.png` shows side, top and sight-axis geometry views.
The revised preview is rendered without cropping stocks or muzzles. These images
are offline renders; in-game framing and device performance still need Studio tests.
