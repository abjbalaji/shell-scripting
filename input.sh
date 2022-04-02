#!/bin/bash
read -p 'Enter your name :' name
echo your name is : $name

echo script name  : $0
echo 1st argument is :$1
echo 2nd arguments is : $2
echo all the args : $*
echo no. of args :$#