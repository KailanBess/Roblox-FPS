# Implementation decisions and remaining work

## Source precedence for this foundation

The uploads describe multiple incompatible revisions. This build uses named
weapons from `Roblox guns.txt` and prices from `Current system store prices..txt`.
Shared constants follow `core gameplay systems.1.txt`: 200 HP, 150 armor, 30%
maximum reduction, 1.5× normal and 2× sniper headshots. Penetration subtracts armor
points, as that document's example specifies. Uploaded base templates with much
lower fire rates are not silently substituted for the named roster. Three small,
explicit rate adjustments and the class traits are documented in WEAPON_BALANCE.md.

Range values are treated as meters and converted at 3.571 studs per meter.
Movement 190–250 is treated as a rating. The current controlled-movement pass maps
it to a 14-stud/sec baseline clamped to 12.5–15.5; aim/lean slow it further. See
MOVEMENT.md. This supersedes the initial 0.08 conversion. Reload rating is mapped
to 120/rating seconds. These conversions are provisional and centralized in
CombatMath for tuning. Falloff reaches 50% damage at twice the listed range.
Shotgun listed damage is total damage across eight pellets. Ranked TTK/DPS limits
are design goals; the roster is not certified or normalized for ranked play.

The current editor is a cosmetic 2D profile extruded to 3D. It does not allocate
25 gameplay points, publish, moderate, persist, share, or replace other players'
world weapon models. No design can modify server combat values. System models
use original procedural geometry rather than image-derived or copied assets.

## Script placement

`default.project.json` maps:

- `src/shared`: ReplicatedStorage/FPS (ModuleScripts).
- `src/server`: ServerScriptService/FPS (server Scripts).
- `src/client`: StarterPlayer/StarterPlayerScripts/FPS (LocalScript).
- `src/character/Health.server.luau`: StarterCharacterScripts/Health (empty Script
  that replaces the platform's default passive health regeneration script).

The server creates its Network RemoteEvents before clients connect. All roster
entries are unlocked for this sandbox. Newly selected weapons start unloaded,
while switching retains already loaded rounds without refilling them. Reload supplies unlimited
reserve ammo for this practice build. Spawn begins with a full magazine.

## Required Roblox Studio checks — not yet run in the cloud

1. Open the generated place, Play: confirm range, five targets, 200 health,
   menu, catalog previews and no Output errors.
2. Equip M4A1, close menu, reload, fire: ammo drops, damage markers appear,
   targets die and respawn, held automatic fire works, empty guns stop.
3. Interrupt reload by switching weapon or dying: an old reload must not refill
   the new weapon. Re-equipping must not create ammo.
4. Test M870 pellet damage, M9 click firing, knife range, AWM scope/zoom, no
   recoil or ADS on unscoped classes. Check cover blocks shots.
5. Paint at least eight cells, drag, erase, undo and apply. Check the preview
   and first-person model; restoring a system model must remove the design.
6. Studio Test with two players: verify damage, death/respawn, health cap,
   friendly fire rejection for assigned teams and spawn ForceField protection.
7. Use the Studio device emulator to assess layout. Touch drag, mobile/gamepad
   combat controls, accessibility, audio, and finished animations are pending.

## Next milestones

1. Studio-tested combat and handling: camera/muzzle obstruction, lag
   compensation, reload/inspect animations, audio, movement validation,
   third-person weapon replication, scoped movement, and input buffering.
2. Versioned profiles with safe session locking, ownership, loadouts, XP,
   mastery, upgrades and a documented resolution of the conflicting power rules.
3. Workshop class templates, 25-point allocation/tradeoffs, animation authoring,
   persistence, sandbox gating, text/content moderation, review and publishing.
4. Match lifecycle, maps, objectives, matchmaking, ranked normalization and MMR.
5. Armor/affixes/reforges, enhancements, crates, economy, pets, clubs, rewards,
   seasons and live-service operations. Do not present inactive menu features
   as working services or accept premium purchases before those services exist.
