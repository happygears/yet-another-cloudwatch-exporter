#!/usr/bin/env bash
#
# Copyright (c) 2024 Happy Gears, Inc.
# author: abondar
# Date: 7/25/2024
#

#
# docker entrypoint script
#

yace --config.file=/opt/netspyglass/home/conf/prometheus-aws-exporter.yml 2>&1 | tee >(multilog t s10485760 n100 /var/log/nsg/) &

pid=$!

TZ=UTC filebeat -e &

# In order to send combined stdout/stderr of our java app to two places:
# 1 .container stderr (so it gets into admin)
# 2. filebeat stdin input
# We use the trick:
# - Merge both stdout and stderr of java process, then pipe to tee
# - tee sends to container stderr
# - tee pipes to filebeat
#
# Note: we use special syntax > >() in order to make sure this script waits
# for java finish instead of last pipe command (filebeat)
#  > >(tee /dev/stderr | filebeat -e) 2>&1

wait $pid
