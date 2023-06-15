FROM alpine:3

RUN apk update && \
    apk add bash openssl wget openjdk11 nodejs openjdk11-jre

COPY . /tmp/cmak
RUN cd /tmp/cmak && ./sbt clean dist
RUN unzip /tmp/cmak/target/universal/cmak-*.zip -d /tmp && \
    mv /tmp/cmak-* /app

WORKDIR /app

EXPOSE 9000

ENTRYPOINT ["/app/bin/cmak"]
