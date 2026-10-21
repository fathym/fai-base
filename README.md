# fai-base

`ghcr.io/fathym/fai-base:<fai version>`: Ubuntu 24.04 with Deno and the [fai CLI](https://jsr.io/@fathym/fai) pre-installed at one fai version.

OpenIndustrial's generated workbench Dockerfile starts `FROM` it, so building a hosted workbench doesn't install fai. A build took 1 to 38 minutes when it installed fai, and 8 to 16 seconds on this image.

It's built from [`Dockerfile`](./Dockerfile). Ubuntu rather than Alpine, because fai loads `@db/sqlite`, whose prebuilt library needs glibc 2.38+.

## Building a version

OpenIndustrial pins the fai its workbenches run (`WORKBENCH_FAI_VERSION` in o-industrial/open-industrial-reference-architecture). When that pin moves, build the image for the new version first:

```
gh workflow run build.yml --repo fathym/fai-base -f fai_version=<version>
```

Until it's built, deploys still work, but every build falls back to installing fai. The reference architecture's tests fail while the pinned version has no image here.

## Using it

```dockerfile
FROM ghcr.io/fathym/fai-base:0.0.888
COPY . .
CMD fai run workbench.ts --mode=MCP
```
