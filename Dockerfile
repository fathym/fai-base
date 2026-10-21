# The fai base image for hosted workbenches: Deno and the fai CLI, installed once per fai version.
# OpenIndustrial's generated workbench Dockerfile starts FROM ghcr.io/fathym/fai-base:<version>
# when it exists, so a workbench build no longer installs fai (1 to 38 minutes in QA's runs).
#
# Ubuntu 24.04 (glibc 2.39), not Alpine (musl): fai loads @db/sqlite, whose prebuilt native
# library needs glibc 2.38+. The deno binary comes from the official denoland/deno:bin image.
FROM denoland/deno:bin AS deno_bin
FROM ubuntu:24.04
COPY --from=deno_bin /deno /usr/local/bin/deno
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*
ARG FAI_VERSION
# --minimum-dependency-age=0: a fai version published minutes ago passes Deno's 24h age gate.
RUN test -n "$FAI_VERSION" && deno install -A -g -n fai --minimum-dependency-age=0 "jsr:@fathym/fai@${FAI_VERSION}"
ENV PATH=/root/.deno/bin:$PATH
WORKDIR /app
