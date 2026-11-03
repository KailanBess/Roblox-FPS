# Repository instructions

- When the user says "read the recommendations from GitHub", "read the
  recommendations", or refers to the saved recommendation draft, read
  `RECOMMENDATIONS.md` at the repository root and its relevant linked notes.
  This is the canonical entry point; do not ask the user to paste the draft.
- Resolve that path relative to this repository, not the operating system root.
  Repository identity: `KailanBess/Roblox-FPS`; the published draft is on `main`.
  Inspect the current checkout/remote state and preserve local changes before
  reconciling newer information. Never reset user work to read recommendations.
- Use the notes as context for the requested task. Reading alone does not authorize
  implementing every proposed feature. Stable recommendation IDs such as REC-02
  identify the user's selected work.
- The core user requirements are no pay-to-win combat and optional player weapon
  creation. Keep combat templates and core creator tools free. Consult
  `game/docs/GAME_IDENTITY.md` and the current fair-play policy before changing
  economy, progression, unlocks or custom-weapon statistics.
- Game code is Roblox Luau and belongs under `game/`. Preserve uploaded root `.txt`
  design documents. Record explicit revisions in `game/docs/` when current user
  requirements differ from those documents.
- Each cloud task already has an isolated checkout. Use it; do not create a Git
  worktree unless the user explicitly requests one.
- For game changes, use appropriate existing checks from `game/`: `luau tests/run.luau`
  and `rojo build default.project.json -o build/RobloxFPS.rbxlx`. This cloud setup
  retains binaries at `/workspace/tools/luau/luau` and `/workspace/tools/rojo/rojo`.
  Documentation-only changes do not require the gameplay test suite.
- Do not claim cross-platform gameplay, Studio physics or hardware performance
  verified solely from standalone Luau tests or a Rojo build. Check the platform
  checklist and clearly report remaining runtime/device tests.
