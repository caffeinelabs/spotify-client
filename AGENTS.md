# AGENTS.md

A generated Motoko client library for the Spotify Web API, distributed as the `spotify-client` mops package for use in Internet Computer canisters.

## Generated code — do not hand-edit

This is **OpenAPI Generator output** (generator version `7.22.0`, see `.openapi-generator/VERSION`). Everything under `src/` is generated from Spotify's OpenAPI spec; the full manifest of generated paths is `.openapi-generator/FILES`. Do not hand-edit generated files — changes belong in the codegen templates/spec and are lost on the next regeneration. `.openapi-generator-ignore` lists the only paths protected from being overwritten.

## Layout

- `src/Config.mo` — shared `Config` type and `defaultConfig` (base URL, cycles, auth) threaded into every API call.
- `src/Apis/` — one module per Spotify API group (Albums, Artists, Player, Search, ...). Each operation has a module-level `async*` form and a class-level `async` form.
- `src/Models/` — one Motoko type per OpenAPI schema.
- `SKILL.md` — connector skill describing OAuth flows, token handling, and `is_replicated`/cycles guidance for callers.

## Toolchain

- Package manager: **mops**. The Motoko compiler is pinned in `mops.toml` (`[toolchain] moc = "1.4.1"`); use that version.
- Install dependencies with `mops install` (resolved versions are locked in `mops.lock`).
- `mops.toml` `[package].files` controls what gets published: `SKILL.md`, `src/Config.mo`, `src/Apis/**/*.mo`, `src/Models/**/*.mo`.
- Some dependencies are pinned to specific forks/versions with inline comments in `mops.toml`'s `[dependencies]` — preserve those pins and their explanatory comments when editing.

## Consuming / deploying

`icp.yaml` configures a consumer canister via icp-cli using recipe `@dfinity/motoko@v4.1.0`. The `README.md` documents the local (`icp network start -d`, `icp deploy`) and mainnet (`icp deploy -e ic`) flows.

## Conventions

- Bump `version` in `mops.toml` and add a matching entry to `CHANGELOG.md` (Keep a Changelog / SemVer) for every published change.
- API calls make IC HTTP outcalls and cost cycles; `defaultConfig.cycles` is `30_000_000_000`. HTTP/management-canister types come from `mo:ic/Types`.
- Never hardcode or log Spotify bearer tokens; auth is supplied per call via `Config.auth`.
