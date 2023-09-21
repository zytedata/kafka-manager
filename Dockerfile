FROM alpine:3 AS builder

RUN apk update && \
    apk add bash openssl wget openjdk11 nodejs openjdk11-jre

COPY . /tmp/cmak
RUN cd /tmp/cmak && ./sbt clean dist
RUN unzip /tmp/cmak/target/universal/cmak-*.zip -d /tmp && \
    mv /tmp/cmak-* /app

FROM alpine:3

COPY --from=builder /app /app

WORKDIR /app

RUN apk update --no-cache && \
    apk add openjdk11-jre bash

EXPOSE 9000

ENTRYPOINT ["/app/bin/cmak"]
