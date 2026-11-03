# Fair competition + optional weapon creation

The game's main identity is a competitive FPS where the choice to create a weapon
is the player's. Complete system weapons are ready to use; nobody must build,
spend Robux or grind a stronger gun to participate. The current build offers all
41 combat templates free. The uploaded price lists remain historical design
references; the armory no longer presents them as combat purchase requirements.

## Non-pay-to-win contract

- Combat templates, editor tools and combat-affecting class traits are free and
  available under the same rules to every player. No premium weapon slots,
  faster reloads, stronger armor, stronger pets or purchased enhancement power.
- Sell optional appearance/identity: premade skins, profile items, cosmetic
  animations and workshop room themes. Keep basic shape/color editing, saving,
  testing and sharing available without payment. Do not make payment the shortcut
  to a gameplay advantage through currency, crates or progression.
- Levels/mastery celebrate use and skill. Competitive combat power is not purchased
  or raised by a premium progression boost. If sidegrade progression is introduced,
  all competitive templates remain equally accessible and ranked normalizes power.
- Custom art changes appearance; server catalog stats and class rules determine
  damage, accuracy, rate, range and ammo. Voxel placement cannot move the server's
  muzzle/eye origin or change hitboxes. Keep consistent opponent readability and
  offer equivalent viewmodel visibility options to system and custom users.

`FairPlayPolicy.luau` records this contract. Server startup requires free-template,
free-workshop and no-paid-stat flags. Its strict cosmetic-grant validator is an
interface for future commerce, not a completed purchase/receipt pipeline. There
are currently no Robux transactions, DataStore economy or paid rewards to audit.
Future purchase code must route grants through the policy and keep an auditable
receipt path. Current tests reject hidden stat payloads and non-cosmetic grant
categories; the workshop rejects stat keys disguised as voxel-list entries.

## Creator freedom without a stronger paid gun

Offer two equally viable paths: choose a finished system gun, or pick a free class
template and build its appearance. Current creation is a 32×16 side profile
extruded into 3D, with bounded cells and session-only application. Persistent
private drafts, full 3D voxel editing, animations, sharing/discovery and moderation
are not implemented yet. Do not advertise them as finished.

Prioritize free draft saving, template choice, undo/redo, symmetry, copy/mirror,
mobile-friendly editing and a one-click test range. Then add a controlled pipeline:
private draft -> test -> technical/content review -> optional public sharing.
Give creators attribution, galleries, likes and cosmetic achievements. Using
someone else's design must not confer higher combat stats.

If players later allocate custom weapon stats, use the same free capped budget,
explicit tradeoffs, server validation and competitive normalization. Appearance
creation must remain available without that more complex stat-building workflow.

## Next vertical slice

1. Run cross-device two-player combat/workshop tests; fix input and visibility bugs.
2. Save and load private creator drafts and loadouts safely on the server. This is
   the next feature that directly proves the game's identity, not another movement
   mechanic or a premium shop.
3. Finish firing/reload/equip feedback and one complete team-deathmatch loop.
4. Add opt-in sharing with moderation and attribution, then evaluate ranked play.
5. Add cosmetic monetization only after the free combat/creator loop is enjoyable.

Avoid an oversized launch checklist of clubs, pets, seasons and currencies before
this loop works. Track fairness alongside retention: win rate by weapon/input,
TTK by armor and range, creator-tool completion on phone/controller, new-player
survival, and whether any paid cosmetic changes visibility or performance.
