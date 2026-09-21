# AGENTS.md

`spotify-client` is a Motoko (mops) library providing a generated client for the Spotify Web API, for use inside Internet Computer canisters.

## Generated code — do not hand-edit

This package is produced by [OpenAPI Generator](https://openapi-generator.tech) (version pinned in `.openapi-generator/VERSION`). Regeneration overwrites these paths, so edits to them will be lost:

- `src/Apis/**` and `src/Models/**` — generated API and model modules
- `src/Config.mo` — generated shared config types and `defaultConfig`
- `README.md`, `icp.yaml`, `mops.toml`

`.openapi-generator/FILES` lists every generated file. To keep a manual change to a generated path, add that path to `.openapi-generator-ignore`. Durable non-generated files include `SKILL.md`, `CHANGELOG.md`, and `LICENSE`.

## Toolchain

- Motoko compiler is pinned: `moc = "1.4.1"` in `mops.toml` `[toolchain]`. Do not change it casually — generated code targets this version.
- Dependencies are managed by [mops](https://mops.one) and locked in `mops.lock`.

## Layout

- `src/Apis/` — one module per Spotify API group (Albums, Artists, Player, Search, ...).
- `src/Models/` — request/response record and variant types.
- `src/Config.mo` — `Config` type and `defaultConfig` (base URL, cycles, auth, `is_replicated`).

## Conventions and gotchas

- Every operation has two forms: a module-level function (`async* T`, takes `config` as first argument) and a class-level method (`async T`, config captured at construction). See `README.md` for usage.
- The `files` key in `mops.toml` is an allowlist of what gets published; a new source path must be added there to ship.
- API calls are IC HTTPS outcalls and cost cycles; `defaultConfig.cycles` is 30 G. `is_replicated = ?false` lowers cost for reads but should stay unset for mutations. See `SKILL.md` for details.
- Auth is an OAuth 2.0 Bearer token obtained off-chain; never hardcode or log tokens. See `SKILL.md`.
- `.gitignore` excludes `.mops/` (the local dependency cache); do not commit it.

## Build / test / lint

There are no `Makefile`, `package.json` scripts, or CI workflows under `.github/workflows/` in this repository, and no committed build/test scripts. Build and type-checking are done with the `moc`/`mops` toolchain above against your consuming canister; do not invent project-specific commands.
