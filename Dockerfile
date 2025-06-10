FROM mirror.gcr.io/library/alpine:3.19 as certs

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories && apk add wget ca-certificates --no-cache

FROM gcr.io/kaniko-project/executor:v1.9.1-debug

SHELL ["/busybox/sh", "-c"]
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY files/crane files/jq files/reg /kaniko/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

LABEL repository="https://github.com/aevea/action-kaniko" \
    maintainer="Alex Viscreanu <alexviscreanu@gmail.com>"
