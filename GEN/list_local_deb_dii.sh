#!/bin/sh

echo "\e[33mList Compiled debs present in Local PC\e[0m"

ssh mastan@10.145.169.54  ls  -lrt /home/mastan/worksapce/git-pile/dii-tools/gr/CI_DII_BUILDS/
