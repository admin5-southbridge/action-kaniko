FROM alpine:3.19 as certs

RUN apk --update add wget ca-certificates --no-cache
RUN mkdir /kaniko

FROM gcr.io/kaniko-project/executor:v1.9.1-debug

SHELL ["/busybox/sh", "-c"]
COPY --from=certs /kaniko/* /kaniko/
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY entrypoint.sh /
COPY files/crane files/jq files/reg /kaniko/

ENTRYPOINT ["/entrypoint.sh"]

LABEL repository="https://github.com/aevea/action-kaniko" \
    maintainer="Alex Viscreanu <alexviscreanu@gmail.com>"
