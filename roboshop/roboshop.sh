#!/bin/bash

if [ ! -e components/$1.sh ]; then
  echo file does not exist
  exit
bash components/$1.sh