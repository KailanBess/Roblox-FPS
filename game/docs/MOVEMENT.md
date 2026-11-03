# Controlled movement and leaning

This pass replaces the old 0.08 × mobility rating conversion, which produced
15.2–20 stud/sec walking, with a calmer 12.5-stud/sec baseline. Weapon mobility
ratings remain data inputs: final unmodified walking is clamped to 11–14 studs/sec.
There is no sprint or movement FOV boost. Jump height is 3.2 studs with auto-jump
disabled. No camera bob, dash, slide or additional movement forces are introduced.

Keyboard/analog movement input eases in with a response of 16/sec and brakes at
25/sec, settling below 1% in 0.2 seconds. Exponential smoothing uses elapsed time,
so response does not depend on frame rate. Roblox's existing PlayerModule supplies
input; this controller applies its smoothed move vector immediately after it.
Normal movement animations and the default camera remain in use.

## Lean controls

Hold **Q** for left or **E** for right. Release to return to neutral; holding both
is neutral. A full lean offsets the eye up to 0.8 studs with 9 degrees of camera
roll. Lean eases in and out. Aim movement is 80% of walking pace; a full lean is
82%; scoped leaning combines the two, giving 8.2 studs/sec with the default rifle.
These values live in `src/shared/Movement.luau` for later playtest tuning.

Leaning remains available while aiming. Menus, text input, focus loss, death and
respawn clear held lean input. Airborne/seated/swimming and stale server input
return the lean request to neutral. The server input timeout is 0.6 seconds.
Leaning currently has desktop Q/E input; dedicated touch/gamepad lean bindings
and accessibility toggle-to-lean controls remain future work.

## Cover, shooting and visibility

Both client and server use `LeanGeometry.resolve` to spherecast a 0.25-stud camera
clearance from the centered head toward the requested side. Cover limits the
actual lean distance, including padding; an initial overlap cancels leaning and
server firing rather than accepting a ray from inside cover. Bounds-overlap checks
are conservative and may cancel leaning near irregular geometry.

The server owns lean easing, allowable offsets, movement speed and shot origins.
The client sends only left/neutral/right and an aim flag; it cannot supply a shot
origin or arbitrary lean distance. Shot cadence, ammo, team checks and existing
combat validation still apply. Aiming precision now also requires server aim state.
Camera lean is applied after the Roblox camera update and removed before the next
one, preventing compounded roll. Scoped recoil is queued until that restoration
so recoil does not corrupt the lean transform.

A server-controlled, invisible `LeanHead` query Part exposes a headshot target at
the permitted peek origin while leaning. The centered avatar head remains hittable,
so the feature never removes the old head target. Other clients apply a smoothed
upper-body pose from the server's `Lean` character attribute (R15 Waist or R6
RootJoint). This pose is approximate across avatar proportions; Studio playtests
must check visible head/proxy alignment on supported rigs. The implementation is
not a full animation rig, lag-compensated hit reconstruction or movement anti-cheat.

## Validation performed here

486 standalone Luau checks cover pace caps, combined aim/lean speed, valid and
invalid movement requests, neutral states, partial wall-clearance math, stable
smoothing at 30/60/120/240 FPS, and braking response. Existing combat and model
checks pass, all scripts compile, and Rojo builds the updated place.
Roblox physics, camera execution, PlayerModule integration and network behavior
cannot be executed in this Linux cloud environment and are not claimed verified.

## Required Studio playtest

1. Play in the built place: walk, stop, reverse and strafe; check diagonal speed,
   camera stability and normal animations. Compare heavy and light weapon pace.
2. Hold/release Q/E, press both, alternate sides, and lean while scoped. Check for
   camera drift over repeated cycles, including firing a scoped weapon while leaning.
3. Move next to a wall and into a corner: camera translation and firing must stop
   at cover. Test thin obstacles and an obstructed starting head position.
4. Jump, die, respawn, open a menu, focus a text field and tab away while leaning:
   the stance must return to neutral, and movement must resume correctly afterward.
5. Test with two clients: the other avatar should lean and its exposed head should
   take headshot damage. Check both R6 and R15 rigs. Check latency during stance
   changes and check the unchanged normal head hitbox for overly generous hits.
6. Confirm mobile/analog walking still works; dedicated mobile/gamepad lean input
   is pending. Inspect Output and profile per-frame overlap/spherecast cost.
