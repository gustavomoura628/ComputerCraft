#!/bin/bash
cred=$(cat credentials)
[ $? != 0 ] && echo error
data=$(cat uploadData)
[ $? != 0 ] && echo error

function abs(){
    x=$1
    [ "$x" -lt 0 ] && x=$(( x * -1 ))
    echo $x
}
IFS=$'\n'
for line in $data
do
    file=$(awk '{print $1}' <<< $line)
    id=$(awk '{print $2}' <<< $line)
    echo $file $id
    oldfile=".tmpoldfile"
    curl "http://ix.io/$id" 2>/dev/null > $oldfile
    diff=$(( $(cat $file | wc -c) -  $(cat $oldfile | wc -c) ))
    diff $file $oldfile > /dev/null 2>&1 && echo "NO CHANGE TO FILE" && continue
    cat $file | curl -F 'f:1=<-' -F "id:1=$id" $cred@ix.io > /dev/null 2>&1
    [ $? != 0 ] && echo error
    printf "%d BYTES " "$(abs $diff)"
    [ $diff -ge 0 ] && echo "ADDED"
    [ $diff -lt 0 ] && echo "REMOVED"
    echo
done
