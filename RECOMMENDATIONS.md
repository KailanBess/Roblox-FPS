# Saved game recommendations

Repository: [KailanBess/Roblox-FPS](https://github.com/KailanBess/Roblox-FPS)

Saved: November 3, 2026

Status: **recommendation draft, not a claim that these features are finished**

## Resume without copying this document

With this repository selected in a future chat, say:

> Read the recommendations from GitHub.

To begin a particular feature, say:

> Read the recommendations from GitHub and implement REC-02.

The entry point is this file on `main`. `AGENTS.md` directs repository assistants
here when you refer to the saved recommendations. Read the linked detail files
and inspect the current code before starting: implementation status may have
changed since this draft was saved. Reading the draft alone does not mean
implementing every proposal at once.

## Core identity and requirements

**Fair competition + optional player-created weapons.**

- Players may use complete system weapons or create their own weapon appearance.
  Creation is optional; a player who never opens the editor must still compete.
- All combat templates and core creator tools stay free. Purchases must not grant
  combat power, stronger armor/pets, better accuracy, faster reloads, exclusive
  competitive weapons or paid shortcuts to gameplay advantages.
- Monetization, if added, is cosmetic/identity only. Keep basic shape/color editing,
  draft saving, testing and sharing free. Do not design the free editor to be
  deliberately frustrating to sell relief.
- Custom geometry follows the same server-controlled combat rules. Cosmetic rarity,
  money spent, creator popularity and account age do not increase combat stats.
- Gunplay is the focus. Movement should be smooth and moderate, with tactical lean;
  avoid making traversal mastery the primary identity. Current tuning is a
  14-stud/sec baseline, 12.5–15.5 weapon range, and bounded aim/lean slowdown.
- Weapon classes retain distinct roles and tradeoffs. Current handling bonuses are
  5–8%; do not compound them into an obvious best weapon. Spreadsheet balance is
  a starting check, not proof of competitive fairness.
- Target desktop, phone/tablet, supported consoles and VR. Do not advertise universal
  readiness until actual device testing and Roblox device/publication settings
  are complete. The current VR implementation is a prototype.

## Existing foundation — verify against current code

The repository already contains Luau combat, a practice range, 41 free weapon
entries, 35 voxel firearm models, procedural surface finishes, custom profile
painting, leaning, class traits and per-weapon magazine retention. Keyboard/mouse,
touch and gamepad input foundations are implemented; VR uses prototype head aim.

Creation currently paints a **2D profile extruded into 3D** and applies it for the
current session. Persistent drafts, full 3D authoring, public sharing/moderation,
a complete match lifecycle, ranked play and commerce are not finished. Automated
Luau checks and Rojo builds have passed; Roblox Studio/hardware execution has not
been verified by this cloud task.

## Prioritized recommendations

| ID | Recommendation | Completion evidence | Current status |
| --- | --- | --- | --- |
| REC-01 | Cross-device two-player testing and performance | Desktop, touch, controller/console and headset checks recorded; input, UI, camera, cover/lean and performance issues resolved; Roblox supported-device settings verified | Pending actual Studio/hardware tests; controls foundation exists |
| REC-02 | Free server-side custom-gun draft and loadout saving/loading | A player can save, leave, rejoin, load and edit a private design; safe profile ownership, validation, save failures and data migration handled; no payment gate | **Recommended next coding feature** |
| REC-03 | Better optional creator workflow | Template selection, redo, symmetry/mirror/copy and one-click test-range flow work on supported inputs; full 3D authoring can follow without replacing the beginner workflow | Proposed; basic painting/undo/preview exists |
| REC-04 | Finished weapon feel | Fire/reload/equip/inspect animations, arms, sounds, muzzle feedback and confirmed-hit effects tested across inputs; assets have valid usage rights | Proposed; current models/camera kick/tracers are a foundation |
| REC-05 | One complete team-deathmatch mode | Teams, timer, score limit, safe spawns, scoreboard, end-of-match and restart flow work with multiple players | Proposed; current place is a practice sandbox |
| REC-06 | Optional public sharing with moderation and attribution | Private draft -> test -> validation/content review -> share; reporting, creator credit and removal work; no stat advantage from popularity or purchases | Proposed; depends on reliable draft storage |
| REC-07 | Measured combat and ranked fairness | Hit rates/TTK measured by weapon, armor, distance and input; server validation and normalization handle exceptions; no purchased power | Proposed; raw-DPS checks and class traits exist |
| REC-08 | Cosmetic-only monetization | Auditable receipt/grant handling, only permitted cosmetic categories, no power/currency backdoor, equivalent combat access retained | Deferred until the free combat/creator loop is enjoyable |
| REC-09 | Current-source competitor review | Official pages, updates and storefronts actually read; dated sources distinguish observations from opinions and reputation | Pending live web access; design comparisons below are provisional |

Do not start every item automatically. Follow the user's selected task and its
necessary prerequisites. Preserve the original uploaded documents; keep game
implementation and detailed development notes under `game/`.

## Comparisons to guide design, not copying

These are broad gameplay references, **not a verified review of their current
updates, prices, supported devices or monetization**. No competitor is being
labeled pay-to-win.

| Reference | Learn from | Your game's distinct direction |
| --- | --- | --- |
| RIVALS | Focused duels, readable rounds and clear combat objectives | Fair combat with optional player-authored weapon identity |
| Arsenal | Fast onboarding and understandable weapon variety | Finished defaults that work immediately; no required editor homework |
| Phantom Forces | Weapon roles, loadout depth and range tradeoffs | Explain tradeoffs while avoiding progression/purchase power gaps |
| Bad Business | Expressive weapon/loadout personalization | Authored voxel shapes as a central feature; movement supports gunplay |
| FRONTLINES | Strong first-person audio, animation and presentation | Polish the voxel identity while respecting low-end device performance |

A request to Roblox's official site was blocked by the environment network proxy.
Access additions for `www.roblox.com`, `games.roblox.com` and `create.roblox.com`
were saved to the environment configuration draft, but that does not apply them.
Recheck current access before assuming the blocker still exists. The user-facing
environment settings save/publish workflow is separate from a GitHub push.

## Detailed context

- [Fair-play and creator identity](game/docs/GAME_IDENTITY.md)
- [Cross-platform implementation and device checklist](game/docs/CROSS_PLATFORM.md)
- [Shooter comparisons and official reference links](game/docs/SHOOTER_COMPARISON.md)
- [Weapon balance rules and next priorities](game/docs/WEAPON_BALANCE.md)
- [Generated weapon balance audit](game/docs/BALANCE_AUDIT.md)
- [Movement and leaning](game/docs/MOVEMENT.md)
- [Development status and Studio checklist](game/docs/DEVELOPMENT.md)
- [Build and controls](game/README.md)

When implementing an item, update its status with evidence and link the relevant
code/tests. Keep pending, implemented, build-checked and hardware-verified outcomes
separate so a future session does not mistake a saved recommendation for a shipped
feature.
