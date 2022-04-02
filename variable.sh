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

 c=(10 20 small big)
 echo First value of the array=${c[0]}
 echo all values of the array=${c[*]}
 echo  count the variables=${c{#}}