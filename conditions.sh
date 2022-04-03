#!/bin/bash
a="abc"
if [ "$a"=="abc" ]
then
  echo 1.both are equal
fi
if [ "$a"!="abc" ]
then
  echo 2.both are not equal
fi
if [ -z "$a" ]
then
  echo 3. a having some date
fi
if [ -z "$b" ]
then
  echo 4. b having empty date
fi