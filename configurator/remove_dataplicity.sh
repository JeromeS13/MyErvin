#!/bin/bash
# Removes Dataplicity
sudo rm -f /etc/supervisor/conf.d/tuxtunnel.conf
sudo service supervisor restart