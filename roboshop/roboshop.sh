#!/bin/bash

if [ ! -e components/$1.sh ]; then
  echo file does not exist
  exit
fi
bash components/$1.sh