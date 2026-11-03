# Weapon baseline audit

Generated from the current catalog and combat formulas. Handling traits add no damage or RPM.
TTK is theoretical against 200 HP / 150 armor at zero falloff, excluding misses, spread, reloads, reaction and equip time.
Shotgun figures assume every pellet hits; 0.000 head TTK means one successful headshot. This is not a ranked balance certification.

| Class | Trait | Effect |
| --- | --- | --- |
| Assault Rifle | Controlled bursts | +6% bloom recovery |
| SMG | Ready handling | 6% shorter equip time |
| Shotgun | Quick chambering | 5% shorter magazine reload |
| Sniper | Stable optics | 6% less scoped base spread |
| Pistol | Quick draw | 8% shorter equip time |
| LMG | Braced fire | 6% less spread while grounded and stationary |
| Marksman | Follow-up control | 6% less scoped camera kick |
| Knife | Ready blade | 8% shorter equip time |

| Weapon | Class | Raw DPS | vs class mean | Body TTK (s) | Head TTK (s) | Reload (s) | DPS review |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| M4A1 | Assault Rifle | 340.0 | -3.1% | 0.700 | 0.400 | 2.67 | Within 15% |
| AK-103 | Assault Rifle | 342.0 | -2.5% | 0.667 | 0.444 | 2.86 | Within 15% |
| HK416 | Assault Rifle | 357.5 | +1.9% | 0.646 | 0.369 | 2.50 | Within 15% |
| SCAR-L | Assault Rifle | 342.0 | -2.5% | 0.632 | 0.421 | 2.79 | Within 15% |
| FAMAS | Assault Rifle | 372.0 | +6.1% | 0.583 | 0.417 | 2.61 | Within 15% |
| MP5 | SMG | 312.5 | -0.8% | 0.800 | 0.480 | 2.67 | Within 15% |
| MP7 | SMG | 314.3 | -0.2% | 0.805 | 0.512 | 2.55 | Within 15% |
| UMP45 | SMG | 303.3 | -3.7% | 0.738 | 0.462 | 2.73 | Within 15% |
| Vector | SMG | 332.5 | +5.6% | 0.758 | 0.505 | 2.50 | Within 15% |
| P90 | SMG | 311.7 | -1.0% | 0.776 | 0.494 | 2.86 | Within 15% |
| M870 | Shotgun | 163.3 | -8.0% | 0.857 | 0.857 | 3.56 | Within 15% |
| M1014 | Shotgun | 187.5 | +5.6% | 0.667 | 0.667 | 3.80 | Within 15% |
| SPAS-12 | Shotgun | 180.0 | +1.4% | 0.750 | 0.750 | 3.68 | Within 15% |
| KSG | Shotgun | 157.1 | -11.5% | 0.923 | 0.923 | 4.07 | Within 15% |
| Super 90 | Shotgun | 200.0 | +12.6% | 1.200 | 0.600 | 3.26 | Within 15% |
| M24 | Sniper | 112.5 | -1.5% | 1.333 | 0.000 | 3.43 | Within 15% |
| AWM | Sniper | 99.2 | -13.2% | 1.714 | 0.000 | 3.75 | Within 15% |
| R700 | Sniper | 120.8 | +5.8% | 1.200 | 0.000 | 3.33 | Within 15% |
| L96 | Sniper | 108.5 | -5.0% | 1.429 | 0.000 | 3.53 | Within 15% |
| Scout | Sniper | 130.0 | +13.8% | 1.000 | 0.000 | 3.00 | Within 15% |
| M9 | Pistol | 215.0 | -1.4% | 1.000 | 0.600 | 2.40 | Within 15% |
| Glock 17 | Pistol | 226.7 | +3.9% | 1.059 | 0.706 | 2.31 | Within 15% |
| USP45 | Pistol | 208.0 | -4.6% | 1.154 | 0.692 | 2.50 | Within 15% |
| P226 | Pistol | 212.7 | -2.5% | 1.034 | 0.621 | 2.40 | Within 15% |
| Five-Seven | Pistol | 228.0 | +4.6% | 1.000 | 0.667 | 2.26 | Within 15% |
| M249 | LMG | 256.7 | -4.8% | 0.873 | 0.545 | 3.33 | Within 15% |
| PKM | LMG | 266.7 | -1.1% | 0.840 | 0.480 | 3.75 | Within 15% |
| RPK | LMG | 270.0 | +0.2% | 0.778 | 0.556 | 3.16 | Within 15% |
| MG36 | LMG | 279.0 | +3.5% | 0.774 | 0.484 | 3.00 | Within 15% |
| Stoner 63 | LMG | 275.5 | +2.2% | 0.842 | 0.526 | 3.43 | Within 15% |
| MK14 EBR | Marksman | 229.2 | +2.1% | 0.960 | 0.480 | 3.16 | Within 15% |
| SR-25 | Marksman | 222.3 | -1.0% | 1.043 | 0.522 | 3.33 | Within 15% |
| G28 | Marksman | 234.0 | +4.2% | 0.923 | 0.462 | 3.00 | Within 15% |
| M110 | Marksman | 220.0 | -2.0% | 0.818 | 0.545 | 3.43 | Within 15% |
| SVD | Marksman | 217.0 | -3.3% | 0.857 | 0.571 | 3.53 | Within 15% |
| Combat Knife | Knife | 73.3 | +1.3% | 3.000 | 1.500 | N/A | Within 15% |
| Tanto | Knife | 80.0 | +10.5% | 2.500 | 1.250 | N/A | Within 15% |
| Kukri | Knife | 70.8 | -2.1% | 1.765 | 1.765 | N/A | Within 15% |
| Karambit | Knife | 82.3 | +13.7% | 2.308 | 1.154 | N/A | Within 15% |
| Bowie Knife | Knife | 65.0 | -10.2% | 2.000 | 2.000 | N/A | Within 15% |
| Tactical Axe | Knife | 62.8 | -13.2% | 2.308 | 2.308 | N/A | Within 15% |

## Interpretation

Use range, accuracy, magazine capacity and actual hit rates alongside these numbers. A low-rate precision weapon cannot be balanced by raw DPS alone.
Three inherited rate outliers were adjusted slightly: Scout 65 -> 60 RPM, Karambit 55 -> 52 swings/min, Tactical Axe 25 -> 26 swings/min. Test miss punishment, reach, headshot thresholds and effective TTK before ranked play.
Damage, armor penetration and range are unchanged. The three rate changes are explicit in WEAPON_BALANCE.md. Broad all-class TTK parity has not been established.
