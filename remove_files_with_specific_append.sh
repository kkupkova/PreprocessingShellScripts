#!/bin/bash
# DESCRIPTION!!!
# this command will go through the files in current folder and within subfolders
#and will remove all the files containing the string defined under -name

find . -name "*.sorted" -print0 | xargs -0 rm

