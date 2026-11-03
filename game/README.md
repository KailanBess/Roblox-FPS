# Roblox FPS — first playable foundation

Game code is Roblox Luau. Original uploaded design documents remain unchanged.

## Open in Roblox Studio

The original design documents remain at the repository root; all game implementation lives in `game/`.

From the `game/` directory, build with Rojo 7.4.4:

```sh
rojo build default.project.json -o build/RobloxFPS.rbxlx
```

Open the generated place in Roblox Studio and press **Play**. Alternatively, run
`rojo serve default.project.json` and connect the Rojo Studio plugin to a new place.
The project adds scripts; the server creates a practice range only when no
SpawnLocation already exists. In an existing place, provide your own map/spawn.

The cloud instance has tools at `/workspace/tools/rojo/rojo` and
`/workspace/tools/luau/luau`. A built place can be generated at `game/build/RobloxFPS.rbxlx` from the repository root.
Roblox Studio itself must run on supported Windows or macOS hardware.

## Controls

- Armory: select one of 41 weapons, **Equip Selected**, then reload.
- **M**: open/close armory and workshop. **LMB**: fire; hold for automatic classes.
- **R**: reload. **RMB**: scope for sniper and marksman weapons only.
- Custom Weapons: choose a color, click/drag on the 32×16 grid, preview, undo,
  erase, clear, and apply. Applying requires 8–384 voxels. Designs last for the
  current server session and replace only your local first-person model.

## Included

- Documented 41-weapon roster and store prices (shown for reference; no purchases).
- True 3D voxel models for all 35 firearms, using real-world-inspired gun families,
  metal/polymer/wood finishes, magazines, open muzzles and scopes. Related variants
  share base shapes. Drag armory previews to rotate; scroll to zoom.
- [Downloadable Roblox/OBJ model pack](assets/VoxelWeapons-35-models.zip) and
  [model usage guide](docs/VOXEL_MODELS.md), [photographic references](docs/PHOTO_REFERENCES.md),
  and [magazine-fit close-ups](assets/VoxelWeapons-magazine-fit.png).
  First image guides the separate custom workshop.
- Server raycasts, server-selected origins, fire cadence, ammo, timed reloads,
  timestamp/type/finite checks, request rate limiting, team checks, armor,
  penetration, falloff, shotgun pellets, and hit/elimination feedback.
- 200 HP, 150 armor, no default passive healing; practice targets respawn.
- Client crosshair, first-person models, tracer effects, scoped zoom/recoil.
- Bounded server validation for cosmetic voxel designs; no client assets or code.

## Validation

```sh
/workspace/tools/luau/luau tests/run.luau
/workspace/tools/rojo/rojo build default.project.json -o build/RobloxFPS.rbxlx
```

186 baseline checks cover roster data, combat calculations and hostile workshop payloads.
Additional geometry checks validate all 35 voxel firearms, including merged volume,
nonoverlap, depth, muzzle placement and component budgets.
All Luau files also compile with Luau 0.659. These checks do **not** execute Roblox
services or prove multiplayer behavior. Run the Studio checklist in
[docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) before gameplay release.
