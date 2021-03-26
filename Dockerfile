FROM golang:1.16 as builder

RUN git clone --branch v3.0.3 --single-branch https://github.com/gammazero/nexus.git ${GOPATH}/src/github.com/gammazero/nexus \
    && cd ${GOPATH}/src/github.com/gammazero/nexus/nexusd \
    && make nexusd && CGO_ENABLED=0 go install
RUN cp ${GOPATH}/src/github.com/gammazero/nexus/nexusd/etc/nexus.json ./

FROM scratch
COPY --from=builder /go/bin/nexusd /bin/nexusd

VOLUME /etc/nexus
COPY --from=builder /go/nexus.json /etc/nexus/nexus.json

CMD ["/bin/nexusd", "-c", "etc/nexus/nexus.json"]
