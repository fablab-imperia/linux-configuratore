#!/bin/bash
apt update -y
apt upgrade -y
apt install $(grep -vE "#" list.txt | tr "\n" " ")
