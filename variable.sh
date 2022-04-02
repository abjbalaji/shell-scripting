#!/bin/bash

a=100
b=Hello

echo ${a}times
echo ${b}

DATE=02-04-2022
echo today date is $DATE

DATE=$(date +%T)
echo Today date is updated as $DATE
 a=10
 b=20
 ADD=$(($a+$b))
 echo addition is $ADD