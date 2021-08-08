#!/bin/bash
cred=$(cat credentials)
[ $? != 0 ] && echo error
file=$1
cat $file | curl -F 'f:1=<-' $cred@ix.io 2> /dev/null
[ $? != 0 ] && echo error
