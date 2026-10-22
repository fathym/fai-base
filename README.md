# fai-base

`ghcr.io/fathym/fai-base:<fai version>`: Ubuntu 24.04 with Deno and the [fai CLI](https://jsr.io/@fathym/fai) pre-installed at one fai version.

OpenIndustrial's generated workbench Dockerfile starts `FROM` it, so building a hosted workbench doesn't install fai. A build took 1 to 38 minutes when it installed fai, and 8 to 16 seconds on this image.

It's built from [`Dockerfile`](./Dockerfile). Ubuntu rather than Alpine, because fai loads `@db/sqlite`, whose prebuilt library needs glibc 2.38+.

## Building a version

It builds itself. Every hour `build.yml` reads `@fathym/fai` on JSR and builds the image for every stable release (no `-` in the version) that has none yet: JSR's latest, plus any published in the last 7 days. A version that already has an image is skipped, so an hour with no new release builds nothing. Prereleases are not built on their own.

So when OpenIndustrial's pinned fai (`WORKBENCH_FAI_VERSION` in o-industrial/open-industrial-reference-architecture) moves to a stable release, its image is normally here already. To build one now, rebuild a tag, or build a prerelease or an older release:

```
gh workflow run build.yml --repo fathym/fai-base -f fai_version=<version>
```

Run it with no version to do what the hourly schedule does, right away.

GitHub pauses a public repository's schedule after 60 days with no activity in the repository. If that happens, turn it back on with `gh workflow enable build.yml --repo fathym/fai-base`.

Until a version is built, deploys still work, but every build falls back to installing fai. The reference architecture's tests fail while the pinned version has no image here.

## Using it

```dockerfile
FROM ghcr.io/fathym/fai-base:0.0.888
COPY . .
CMD fai run workbench.ts --mode=MCP
```
