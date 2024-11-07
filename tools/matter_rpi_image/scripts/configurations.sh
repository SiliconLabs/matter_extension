#!/bin/bash
 sudo iptables -A FORWARD -i eth0 -o wpan0 -j ACCEPT
 sudo iptables -A FORWARD -i wpan0 -o eth0 -j ACCEPT
