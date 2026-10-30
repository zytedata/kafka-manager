# The builder output is only the dist zip, so its packages are not shipped.
# Pin it to the Alpine release that last built this fork.
FROM alpine:3.19 AS builder

RUN apk update && \
    apk add bash openssl wget openjdk11 nodejs openjdk11-jre

COPY . /tmp/cmak
RUN cd /tmp/cmak && ./sbt clean dist
RUN unzip /tmp/cmak/target/universal/cmak-*.zip -d /tmp && \
    mv /tmp/cmak-* /app

# CVE-2026-111497: Alpine 3.19 gets no brotli-libs fix; 3.24 ships 1.2.1.
FROM alpine:3.24

COPY --from=builder /app /app

WORKDIR /app

# The headless JRE does not pull freetype, so brotli-libs is not installed at
# all; the CMAK web UI does not need AWT fonts.
RUN apk add --no-cache openjdk11-jre-headless bash

EXPOSE 9000

ENTRYPOINT ["/app/bin/cmak"]
