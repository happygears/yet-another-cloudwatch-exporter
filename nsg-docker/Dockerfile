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

# Download and install filebeat
RUN curl -sSfo /tmp/filebeat.deb https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.10.0-amd64.deb && \
    apt-get -y install -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" /tmp/filebeat.deb && \
    rm -f  /tmp/filebeat.deb
COPY nsg-docker/files/    /

RUN mkdir /var/lib/filebeat && mkdir /var/log/nsg/

# ensure correct permissions on files
RUN chmod -R go-w /etc/filebeat /usr/share/filebeat/module /var/lib/filebeat /var/log/nsg/
RUN chown -R exporter:exporter /var/log/nsg/

COPY nsg-docker/run.sh  /run.sh
RUN chmod +x /run.sh

CMD exec /run.sh

USER exporter

