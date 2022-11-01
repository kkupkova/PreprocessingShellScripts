#!/bin/bash

# do not put any spaces to assigning variable
colors=(blue red green)
echo ${colors[@]} #prints all values
echo ${colors[0]} #prints first value

# the backticks make the date or current directory appear- can be stored
# into the variable
echo `date`
echo date
p=`pwd`
echo currentd path: $p

# if we have a $ sign it looks at the character behind it and sees it as a variable
echo Cool. You won $100,000 in the lottery
#if I want to actually display the $ sign- use / before it
echo Cool. You won \$100,000 in the lottery

firstName=Peter
lastName=Miller
# string concatenation- just put the two strings into quotes
fullName="$firstName $lastName"

echo Hello $fullName

echo Where are the $lastName s?
echo Where are the $lastNames?
echo Where are the ${lastName}s?


# '' hard quotes - takes everything within literalry vs. ""

echo 'Where is Mr. $lastName'
echo "Where is Mr. $lastName"

echo 'I want $2'
echo "I want $2"

value=2
echo The cost is \$$value

# export value - will send value to all of the current shells
#--------IF--------------
if [[ $name = "Tom" ]]
then
  echo ${name}, you are assigned to room 12
elif [[ $name = "Henry" ]]
then
  echo ${name}, you are assigned to room 13
elif [[ -z $name ]]
then
  echo You did not tell me your name
else
  echo "${name}, I don't know where your room is "
fi

#------CASE------------
filename=ahoj.py
case $filename in
	*.C)
	echo "C source file"
  ;;
  *.py)
  echo "Python script file"
  ;;
  *)
  echo "I don't know, what the file is"
  ;;
esac

#---- FOR ----

for i in 0{1..9} {90..100}
do
  echo "Loop3: I am in step $i"
done

for i in 00{1..9} 0{10..99} 100
do
  echo "Loop3: I am in step $i"
done

#another way how to do similar = intil we reach 10 increase by 2
name="file"
IMAX=10
for (( i=0 ; i <${IMAX} ; i=i+2 ))
do
  echo "${name}.${i}"
done


# ARITHMETIC - in double parenthesis
x=$((4+20))
echo $x

# string operrations
jmeno="Kristyna"
echo $jmeno
#get lenght of a string
echo "Your name has ${#jmeno} letters"
# clipping string
echo "I turnred you into a ${jmeno%"na"}."

single_repl=${jmeno/"t"/"*"}
echo $single_repl

# run loop through array
mojePole=(Ahoj jak se mas !)
for (( i = 0; i <= ${#mojePole}; i++ )); do
  echo ${mojePole[i]}
done

# or less matlab like and more python-like approach
for i in ${mojePole[@]}; do
  echo $i
done
