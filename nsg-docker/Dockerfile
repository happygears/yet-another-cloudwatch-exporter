FROM golang:1.22 as builder

WORKDIR /opt/

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

ENV GOOS linux
ENV CGO_ENABLED=0

ARG VERSION
RUN go build -v -ldflags "-X main.version=$VERSION" -o yace ./cmd/yace

FROM ubuntu:20.04

EXPOSE 5000
#ENTRYPOINT ["yace"]
#CMD ["--config.file=/tmp/config.yml"]
RUN addgroup --gid 1000 exporter
RUN useradd -u 1000 -g exporter exporter -b /exporter

WORKDIR /exporter/

RUN apt -y update && apt -y install ca-certificates daemontools less procps unzip curl rsyslog rsyslog-relp && apt clean all
COPY --from=builder /opt/yace /usr/local/bin/yace

# ensure correct permissions on files
RUN chmod -R go-r /run/secrets/

COPY nsg-docker/run.sh  /run.sh
RUN chmod +x /run.sh

CMD exec /run.sh

USER exporter

