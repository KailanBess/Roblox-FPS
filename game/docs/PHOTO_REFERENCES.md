# Photographic references used for the voxel revision

These images were found online, downloaded locally and visually inspected during
this revision. Links are pinned to the reference repository's commit so the inputs
can be reviewed. Photos are reference material only: they are not included in the
model pack, used as textures, or claimed as original game artwork.

The repository filenames are not reliable weapon identifications: for example,
`ak1.jpg` shows an AR-style rifle, not an AK. Family descriptions below follow the
visible shape. This is a visual interpretation pass, not certification of exact
manufacturer, variant, dimensions, or photo provenance.

| Inspected image | Visible reference used | Changes informed |
| --- | --- | --- |
| [AR-style side view](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/ak1.jpg) | Receiver/magwell junction, magazine sweep, angled grip and buttstock | Continuous inserted magazine neck, magwell rim and restrained curvature |
| [AR-style angled view](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/ak2.jpg) | Lower receiver/magwell proportions and stock opening | Inserted magazine profile and receiver transition |
| [Ribbed carbine forearm](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/ak3.jpg) | Rounded/ribbed forearm and sight tower, separate receiver rail | M4 ribbed voxel forearm; top rail ends at receiver instead of hovering over forearm |
| [SCAR-style rifle](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/ak4.jpg) | Tall continuous upper, folding-stock hinge, cheek rest and seated magazine | SCAR monolithic upper and explicit hinge; magazine-to-receiver fit |
| [Scoped rifle side view](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/ak5.jpg) | Shorter exposed magazine and forearm/receiver relationship | Short marksman magazine and continuous upper insertion |
| [Polymer pistol](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/glock.jpg) | Grip-contained magazine, flush base plate, slide and trigger-guard separation | Internal magazine insert and fitted base plate instead of an external rifle magazine |
| [Pistol side view](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/barreta.jpg) | Grip angle and base-plate seating | Pistol insertion/base-plate check; filename was not used as a Beretta identity reference |
| [Bolt-action chassis close-up](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/savage.jpg) | Magazine seated inside chassis and enclosed trigger-guard area | Sniper magazine neck/core seated into chassis, with no visible air slot |
| [Scoped chassis rifle side view](https://github.com/khaymanii/BuyGun/blob/1c4943fa6227a32fb02263700eadc2b748b03488/public/assets/images/s1.jpg) | Magazine/chassis overlap, scope placement and stock proportions | Chassis insertion silhouette check |

These references cover the families shown above. Other roster entries retain
stylized family-based geometry; an exact photographic match for every one of the
35 named variants has not been established. The supplied game stats are unchanged.

## Magazine-fit verification

Each visible box magazine now has an authored core seating region, inserted
upward into the receiver, chassis or grip and surrounded by a magwell rim.
The top-mounted P90 magazine and belt boxes have their own mounting regions.
Tests require every voxel in those regions to be occupied, including the full
width of the neck, rather than accepting a single shared corner or a connection
through the trigger guard. The KSG uses twin tube magazines rather than a box.
Whole-assembly connection and iron-sight checks still run for all 35 firearms.
These are visual-model checks, not real firearm construction or function tests.

See `assets/VoxelWeapons-magazine-fit.png` for side-view close-ups of the seating
areas. Rendered previews show original voxel geometry, not the reference photos.
