#!/bin/bash

flacpath=/in
alacpath=/out

alacsuffix=.m4a

function recode() {
	fileinfo=`file "$flacfile"`
	
	#if not stereo, zet file in lijst en doe er verder niets mee
	stereo=`echo "$fileinfo"| grep -c "stereo"`

	if [ $stereo == 1 ]; then
		
		/usr/bin/avconv -y -i "$flacfile" -c:a alac -vn -ar 44100 -sample_fmt s16p "$alacout" artwork.jpg </dev/null
		if [ -e "artwork.jpg" ]; then
			/usr/local/bin/AtomicParsley "$alacout" --artwork artwork.jpg --overWrite
			rm artwork.jpg
		else
			/usr/bin/avconv -y -i "$flacfile" -c:a alac -vn -ar 44100 -sample_fmt s16p "$alacout"</dev/null
		fi	
	else
		echo "$flacfile" >> /out/nietomzetbarefiles.txt
	fi
}

find $flacpath -name '*.flac' 1>filelist.txt

while IFS= read -r flacfile
do
    fileding=${flacfile%.*c}
    dirding=${flacfile%/*c}
    tussenstuk=${dirding/$flacpath/}
    filenaam=`basename "$flacfile" .flac`
    alacout=$alacpath$tussenstuk/$filenaam$alacsuffix
    if [ -e "$alacout" ]; then
    	#echo "file bestaat al, enkel te checken of de alac nieuwer is dan de flac"
    	#indien de alac ouder is dan de flac, dan zal de flac geupdate zijn en zal de file opnieuw gemaakt moeten wordne
    	if [ "$alacout" -ot "$flacfile" ]; then
    		rm "$alacout"
    		recode
    	fi
    else
    	#echo "file bestaat nog niet, moeten we hem maar gaan maken"
    	if [ -e "\"$alacpath$tussenstuk\"" ]; then
    		echo "dir bestaat al: $alacpath$tussenstuk"
    	else
    		mkdir -p "$alacpath$tussenstuk"
    	fi
    	echo $flacfile
    	recode 
    fi
       
done < "filelist.txt"