#!/bin/bash
cp trackpoint_parameters.* /etc/systemd/system/
cp trackpoint_configuration.sh /usr/local/bin/
systemctl enable trackpoint_parameters.path
