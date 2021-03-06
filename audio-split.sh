#!/bin/sh
# This is a quick and simple solution for downloading and splitting youtube mixes
# Requirements:
#    awk
#    exiftool
#    ffmpeg
#    youtube-dl
# Usage:
#     youtube-dl --add-metadata -icxf bestaudio/best URL
#     eval $(audio-spilt FILE OUTDIR)
# This is it! Tracks should be now in OUTDIR

outdir="$2"
if [ -z "$outdir" ]; then outdir=$(echo "$1.dir" | tr " " "_");fi
mkdir -p "$outdir"

exiftool -s -s -s -b -Description "$1" | awk -v dir="$outdir" -v filename="$1" \
	'BEGIN{fileformat=filename; gsub(".*\\.", "", fileformat); timestamps[1]=0}
	/[0-9]:[0-9][0-9]/{
	 gsub("([A-Za-z\\(\\) ])+$","",$0)
	 time=$NF;
	 gsub("\"","",$0);
	 split($0, album, " (-|–) ");
	 gsub(" ([0-9]+:)?[0-9]+:[0-9]+","",album[2]);
	 gsub(":", " ", time);
	 gsub("^ ","",album[2]);
	 tnum=length(timestamps);
	 saveto=dir"/"tnum"_"tolower(album[1]"-"album[2]"."fileformat);
	 $0=time;
	 if (NF == 3) {timestamp = $1*3600+$2*60+$3;}
	 else {timestamp = $1*60+$2};
	 if (timestamp == 0) {games[1]=album[1]; titles[1]=album[2]; savetos[1]=saveto; next };
	 titles[tnum+1] = album[2];
	 games[tnum+1] = album[1];
	 timestamps[tnum+1]=timestamp
	 prevtime = timestamp-timestamps[tnum];
	 saveto=dir"/"tnum+1"_"tolower(album[1]"-"album[2]"."fileformat);
	 gsub(" ", "_", savetos[tnum]);
	 savetos[tnum+1] = saveto;
	 command="ffmpeg -i \"%s\" -acodec copy -ss %s -t %s -metadata:s:a:0 title=\"%s\" -metadata:s:a:0 artist=\"%s\" -metadata title=\"%s\" -metadata artist=\"%s\" -metadata track=\"%s\" \"%s\";\n";
	 printf(command,filename,timestamps[tnum],prevtime,titles[tnum],games[tnum],titles[tnum],games[tnum],tnum,savetos[tnum]);
	 }
	END{
	 tnum++;
	 gsub(" ", "_", savetos[tnum]);
	 gsub("-t %s ","",command);
	 printf(command,filename,timestamps[tnum],titles[tnum],games[tnum],titles[tnum],games[tnum],tnum,savetos[tnum]);
	 }'
