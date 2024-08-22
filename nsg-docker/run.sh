#!/usr/bin/env bash
#
# Copyright (c) 2024 Happy Gears, Inc.
# author: abondar
# Date: 7/25/2024
#

#
# docker entrypoint script
#

yace --config.file=/opt/netspyglass/home/conf/prometheus-aws-exporter.yml 2>&1