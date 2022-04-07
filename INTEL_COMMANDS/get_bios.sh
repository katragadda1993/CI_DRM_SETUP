#!/bin/sh
echo "\e[33mGeting BIOS Information\e[0m"
sudo dmidecode | grep  "Product Name"
sudo dmidecode --type bios | egrep "Vendor|Version|Release Date"

