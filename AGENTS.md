# AGENTS.md

A Motoko client library for the Spotify Web API, distributed as a [Mops](https://mops.one) package named `spotify-client`.

## Generated code — do not hand-edit

This repository is produced by [OpenAPI Generator](https://openapi-generator.tech)
(`MotokoClientCodegen`). The following are regenerated from the OpenAPI spec and
should never be edited by hand:

- `src/Config.mo`
- `src/Apis/` — one module per Spotify API group
- `src/Models/` — one module per schema type

`.openapi-generator-ignore` controls which files the generator is allowed to
overwrite. To change generated output, change the generator inputs/templates, not
the output files.

## Toolchain

- The Motoko compiler is pinned in `mops.toml`: `moc = "1.4.1"` under `[toolchain]`.
  Use this exact version; type-check behavior depends on it.
- Dependencies and their versions are declared in `mops.toml` and locked in
  `mops.lock`. `serde-core` is a pinned fork (see the comment in `mops.toml`); do not
  replace it with upstream.
- `.mops/` is a local install directory and is gitignored.

## Layout

- `src/` — the entire published library. `mops.toml` `files` restricts what is
  published to `SKILL.md`, `src/Config.mo`, `src/Apis/**`, and `src/Models/**`.
- `SKILL.md` — a Caffeine connector skill describing how to call this library from a
  canister (OAuth flows, cycles/`is_replicated` guidance). Keep it in sync with the
  public API surface.
- `icp.yaml` — example `icp-cli` deploy recipe for a consumer canister; it is not this
  package's own build config.

## Conventions

- All API operations come in two forms: a module-level form (`async* T`, takes `config`
  as the first argument) and a class-level form bound to a config at construction.
- Config defaults live in `src/Config.mo` (`defaultConfig`): `baseUrl` is preset,
  `cycles = 30_000_000_000`, all optional fields `null`.
- Record the user-visible effect of any change in `CHANGELOG.md`; it follows
  [Keep a Changelog](https://keepachangelog.com/) and SemVer, and the version there must
  match `[package].version` in `mops.toml`.
- `repository` and release tags use the form `vX.Y.Z` (see `CHANGELOG.md`).
