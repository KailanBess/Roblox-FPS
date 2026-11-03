# Gunplay-first balance pass

Movement supports fights rather than driving them. Walking now starts at 14
studs/sec and remains within 12.5–15.5 across weapon mobility ratings. Aiming and
leaning still slow it. Keep this baseline for the first combat playtest and focus
subsequent work on shooting and weapon feel rather than adding traversal systems.

## Small class strengths

Every named weapon keeps its distinct roster damage, accuracy, range, magazine,
reload, penetration and mobility combination. Each receives exactly one class
handling trait, displayed in the armory:

| Class | Strength added | Existing tradeoff to preserve |
| --- | --- | --- |
| Assault rifle | 6% faster bloom recovery | Generalist, not best at either range extreme |
| SMG | 6% shorter equip time | Short range and lower armor penetration |
| Shotgun | 5% shorter reload duration | Pellet consistency and distance |
| Sniper | 6% lower scoped base spread | Slow firing, handling and miss punishment |
| Pistol | 8% shorter equip time | Smaller magazines and sustained output |
| LMG | 6% lower spread while stationary on ground | Weight, reload time and mobile accuracy |
| Marksman | 6% less scoped camera kick | Controlled follow-up shots rather than automatic fire |
| Knife | 8% shorter equip time | Must close into melee range |

Traits do not stack damage, rate of fire, penetration or movement bonuses. They
are not a second upgrade system or a paid advantage. The scoped kick adjustment
is a client visual/handling effect; authoritative spread/reload/equip behavior
is applied on the server. The underlying class identities still come from the
catalog stats rather than large perk multipliers.

Switching preserves each weapon's current loaded rounds. A newly selected weapon
with no loaded magazine still needs a reload; switching or reselecting never
refills ammunition. Respawn resets the equipped gun to a full magazine and clears
other per-life magazine states. Reserve ammo remains unlimited in the sandbox.

## Explicit rate adjustments

Three outliers were adjusted; original uploaded design documents remain untouched:

| Weapon | Previous rate | New rate | Change |
| --- | ---: | ---: | ---: |
| Scout | 65 RPM | 60 RPM | -7.7% |
| Karambit | 55 swings/min | 52 swings/min | -5.5% |
| Tactical Axe | 25 swings/min | 26 swings/min | +4% |

Damage, range, armor penetration and magazine sizes were not changed. After these
changes, all 41 weapons fall within ±15% of their own class mean raw DPS. This
bounds one source of power difference; it does not establish equal effective TTK,
accuracy, reload downtime, headshot reliability, cross-class balance or ranked
readiness. In particular, 200 HP / 150 armor introduces whole-shot thresholds,
so a small raw-stat difference can still change the number of hits required.

[BALANCE_AUDIT.md](BALANCE_AUDIT.md) lists all 41 weapons with raw DPS, class-mean
variance, theoretical armored body/head TTK and reload time. Regenerate from
`game/` with `luau tests/balance-report.luau > docs/BALANCE_AUDIT.md`.

## What to do next

1. **Two-player Studio combat playtest.** Verify aiming, leaning, cover, headshot
   exposure, ammo retention, reload interruption, draw timing and each class trait.
   Compare close/mid/long-range hit rates and body/head TTK against 0/75/150 armor.
   Use actual duels to tune exceptions rather than forcing every class to behave
   alike. Physics, camera and multiplayer execution remain unverified in the cloud.
2. **Weapon feedback.** Add proper firing/reload sounds, equip/fire/reload/inspect
   animations, arms, muzzle effects and responsive confirmed-hit feedback. The
   current procedural models and camera kick are not finished weapon handling.
3. **One complete mode.** Build team deathmatch with a timer, score limit,
   teams, scoreboard, safe spawns and end-of-match flow. The current place is a
   practice sandbox, not a complete multiplayer match system.
4. **Persistent loadouts and progression.** Add safe server-side profile saving,
   unlocks, loadouts and mastery after the combat loop works. Build economy,
   ranked, pets and workshop publishing afterward, rather than compounding untested
   combat bonuses with more progression modifiers.

Validation here includes 486 movement checks, 158 class-trait/magazine-state
checks, 41 class-DPS bounds, existing combat/model checks, Luau compilation and a
successful Rojo place build. Studio playtests remain required for real feel and
competitive balance.
