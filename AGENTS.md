# AGENTS.md

A Motoko client library for the Spotify Web API, distributed as a [mops](https://mops.one) package (`spotify-client`).

## Generated code — do not hand-edit

Everything under `src/` (`Config.mo`, `Apis/`, `Models/`) is produced by the
[OpenAPI Generator](https://openapi-generator.tech) (Motoko client generator) from
Spotify's OpenAPI spec. Do not edit these files by hand; changes belong in the
generator/template and are reproduced by regeneration. `.openapi-generator-ignore`
lists the few paths the generator must not overwrite.

## Toolchain

- Motoko compiler is pinned to `moc = "1.4.1"` in `mops.toml` (`[toolchain]`). Use
  that version via mops (`mops toolchain`) rather than a system `moc`.
- Dependencies are declared in `mops.toml` and locked in `mops.lock`. Install with
  `mops install`. The install directory `.mops/` is gitignored — never commit it.

## Build / type-check

This package has no Makefile, no npm scripts, and no CI workflows; there are no
project-defined build, test, lint, or format commands. Consumers compile it as a
mops dependency. To type-check a Motoko source file against installed deps use the
pinned compiler, e.g. `moc --check <file>` (or the mops-managed equivalent).

## Layout

- `src/Apis/` — one module per Spotify API group (Albums, Artists, Player, etc.).
  Each operation exists in two forms: a module-level `async*` function taking
  `config` as its first argument, and a class-level `async` method with config
  captured at construction. Prefer the module-level form inside a canister.
- `src/Models/` — one Motoko type per Spotify schema object.
- `src/Config.mo` — `defaultConfig` (base URL preset, `cycles = 30_000_000_000`,
  optional fields `null`).
- `SKILL.md` — usage/auth guidance (OAuth flows, tokens, cycles, `is_replicated`).

## Conventions

- Types use PascalCase uniformly across vanilla / dfx / icp-cli modes.
- API calls are HTTPS outcalls via the IC management canister and cost cycles;
  ensure the calling canister is funded.
- Auth is an OAuth 2.0 Bearer token supplied by the caller via `config.auth`;
  tokens are minted off-chain and must never be hardcoded or logged. `/me/*`
  endpoints, library writes, and player commands require a user (Authorization
  Code) token; catalog reads work with a Client Credentials token.
- `icp.yaml` configures icp-cli deploys (`@dfinity/motoko@v4.1.0`).
