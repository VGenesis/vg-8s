#! /bin/bash

hexfile=asm_isa_hex_table
ctrlfile=asm_isa_cu_table
romfile=asm_isa_cu_rom

hexcode=0

echo "" > $hexfile
echo "v2.0 raw" > $romfile
while IFS='\n' read -r line
do
	IFS=':'
	lines=($line)
	instr=${lines[0]};
	cbits=${lines[1]};

	if [ -z $instr ]; then 
		continue
	fi
	IFS='|'
	cseqs=($cbits)
	ctrlseq="";
	fillnum=16;
	for i in ${cseqs[@]}
	do
		ctrlcode=0;
		IFS=' '
		csigs=($i);
		for sig in ${csigs[@]}
		do
			let "ctrlcode+=$((2**$sig))"
		done
		ctrlseq="$ctrlseq $(printf "%x" "$ctrlcode")"
		let "fillnum-=1"
	done
	echo "$instr:0x$(printf "%x" "$hexcode"):$ctrlseq" >> $hexfile
	ctrlseq="$ctrlseq ${fillnum}x0"
	echo $ctrlseq >> $romfile
	let "hexcode+=1"
done < $ctrlfile
