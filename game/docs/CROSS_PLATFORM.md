# Cross-platform implementation and release checklist

## Implemented input foundation

| Input | Fire | Aim | Reload | Lean | Armory / back |
| --- | --- | --- | --- | --- | --- |
| Keyboard/mouse | LMB | hold RMB | R | hold Q/E | M / Play-Close button |
| Gamepad | RT | hold LT | X | hold LB/RB or D-pad left/right | Y / B |
| Touch | hold Fire button | toggle Aim button | Reload button | toggle Lean L/R buttons | Armory button |
| VR prototype | mapped controller trigger | mapped aim trigger | mapped X | mapped shoulder buttons | mapped Y / B |

Roblox PlayerModule still supplies walking, camera look and jumping, including
native thumbsticks and gamepad movement. All combat actions go through one
ContextActionService router. Touch buttons are 60 pixels; combat controls hide in
menus. HUD hints follow the current input. Device-mode changes, disconnects,
focus loss and text entry clear held/toggled actions. Mouse-button and mouse-motion
changes belong to the same mode, so aiming the mouse does not cancel held fire.

GuiButtons are selectable for Roblox gamepad navigation. Opening a menu with a
controller selects Play/Close; D-pad/stick navigation and A activation can select
weapons, colors, editor cells and actions. Preview rotation/zoom have selectable
buttons as well as mouse drag/wheel and touch drag.

The workshop supports touch drag painting, gamepad A cell painting, zoom,
pan/paint mode and a design/3D switch. Small touch layouts use two palette rows
and a full-width editing/preview area. ScreenGui respects device-safe insets.
Creator tools and combat templates have no payment gate.

## VR is a prototype, not certified support

The initial VR mode aims along Camera:GetRenderCFrame(), uses mapped controller
buttons and avoids artificial camera roll, scripted kick and forced FOV changes.
It is head-aimed; tracked-hand weapon aiming, physical grabbing/reloading,
world-space menu placement, scope magnification and accessibility/comfort settings
are not completed. The shared server still selects shot origins and limits cover
peeking. A headset must verify tracked avatar-head versus render-camera alignment
before VR is enabled for public competitive play. Do not label this build fully
playable on every Roblox device merely because it compiles.

## Required testing and Roblox publication

The cloud has no Roblox Studio, console or headset runtime. Automated tests cover
input-state transitions and policy contracts; they do not exercise ContextActionService,
GUI selection, safe-area rendering, VR cameras or console platform requirements.
Rojo builds successfully. These are implementation checks, not device certification.

1. Open the place in Roblox Studio. Test keyboard/mouse and the controller emulator.
   Verify fire/aim/reload, semi-auto versus automatic fire, leaning, menu navigation,
   cell painting, scrolling to offscreen cells and switching input during a hold.
2. Use Device Emulator for portrait and landscape phones, tablet and narrow windows.
   Check safe areas, text, controls versus native jump/thumbstick, and every workshop
   action. Validate on real iOS/Android hardware as well; emulation does not prove
   multi-touch behavior or performance. Confirm releasing the look finger does not
   release Fire, and pan gestures never paint.
3. Test a controller on PC, then actual supported Xbox/PlayStation hardware. Check
   A/B/Y conventions, GUI selection, camera look and Roblox menu behavior without
   intercepting the platform's reserved menu button.
4. Test actual supported VR hardware in both menus and combat. Complete the missing
   VR systems above before claiming full VR support.
5. Configure supported devices in the experience's Roblox settings, satisfy current
   Roblox platform eligibility requirements and publish there after the tests pass.
   GitHub publication does not enable devices or publish a Roblox experience.
6. Profile frame time/memory/network usage on the lowest target phone and console.
   Current detailed firearm models peak at 782 Parts. The untextured option is a
   starting point for quality settings; a full distance/quality LOD system is pending.

No aim assist or auto-fire advantage is silently added. Before ranked cross-play,
compare input-specific hit rates and tune transparent, free input accessibility
options and matchmaking. Never sell accuracy assistance or input advantages.
