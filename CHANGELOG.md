# Changelog

All notable changes to this package are documented in this file.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Entries before `0.2.1` are uncatalogued; see the git log for prior history.

## [0.2.1](https://github.com/caffeinelabs/spotify-client/releases/tag/v0.2.1) — 2026-05-24

### Added

- `SKILL.md` at the package root — Caffeine connector skill describing how to call the Spotify Web API from a Motoko canister: dual OAuth-flow guidance (Client Credentials vs Authorization Code w/ PKCE), token refresh policy, `is_replicated` recommendation per endpoint kind, 429/`Retry-After` handling, and a worked example using `search` / `getTrack` / `pauseAUsersPlayback`.
- `icp.yaml` recipe for `icp-cli` (`@dfinity/motoko@v4.1.0`) deploys.
- `ic = "4.0.0"` dependency in `mops.toml` for management-canister bindings (`HttpRequestArgs` / `HttpRequestResult` / `HttpHeader` are now imported from `mo:ic/Types`).

### Changed

- **icp-cli toolchain mode**: all API modules now import HTTP types from `mo:ic/Types` instead of inlining their snake-case shape. PascalCase is uniform across vanilla / `dfx` / `icp-cli` modes — body references no longer churn type names depending on the deployment mode.
- **Per-type primitive array decoding**: endpoints returning `[Bool]` (e.g. `checkUsersSavedAlbums`) decode through a per-type branch driven by `x-return-array-element-is-{text,int,nat,float,bool,blob}` vendor extensions, rather than the previous hardcoded `#Text(_)` arm that crashed on non-text element types.

### Fixed

- `checkUsersSavedAlbums` and similar `[Bool]`-returning endpoints no longer trap during result decoding (consequence of the per-type primitive array dispatch above).
