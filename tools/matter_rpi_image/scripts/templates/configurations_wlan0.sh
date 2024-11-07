#!/bin/bash
 sudo iptables -A FORWARD -i wlan0 -o wpan0 -j ACCEPT
 sudo iptables -A FORWARD -i wpan0 -o wlan0 -j ACCEPT
