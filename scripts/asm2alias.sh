#! /bin/bash

ctrlfile=asm_isa_cu_table
humanfile=asm_isa_alias
tempfile=asm_isa_temp

cat $humanfile > $tempfile
rm $humanfile
touch $humanfile
while IFS="\n" read -r line
do
	if [ -z "$line" ]
	then
		continue
	fi

	IFS=':';
	lineargs=($line);
	instr=${lineargs[0]};

	IFS=' '
	hit=$(grep "$instr" $tempfile);
	hitlist=($hit)
	hitline=${hitlist[0]}
	if [ -z $hitline ]
	then
		echo $hitline
		echo "$instr " >> $humanfile
	else
		echo $hitline >> $humanfile
	fi

done < $ctrlfile
rm $tempfile

