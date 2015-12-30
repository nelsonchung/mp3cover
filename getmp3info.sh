:<<FORMAT
id3v1 tag info for 思念會驚/09 幸福在叫我.mp3:
Title  : ?????                           Artist: ???
Album  : ????                            Year: 2011, Genre: Pop (13)
Comment:                                 Track: 9
id3v2 tag info for 思念會驚/09 幸福在叫我.mp3:
TIT2 (Title/songname/content description): 幸福在叫我
TPE1 (Lead performer(s)/Soloist(s)): 蕭煌奇
TALB (Album/Movie/Show title): 思念會驚
TYER (Year): 2011
TRCK (Track number/Position in set): 9/10
TPOS (Part of a set): 0/0
TCON (Content type): Pop (13)
PRIV (Private frame):  (unimplemented)
APIC (Attached picture): (幸福在叫我)[, 3]: image/jpeg, 6653 bytes
FORMAT

if [ $# -le 0 ]; then
    echo "There is something wrong about command"
    echo "command format: getmp3info.sh songname"
    exit
fi

#Get title
title=`id3v2 -l "$1" | grep TIT2 | awk -F": " '{print $2}'`
echo "title is $title"

#Get soloist 
soloist=`id3v2 -l "$1" | grep TPE1 | awk -F": " '{print $2}'`
echo "soloist is $soloist"

#Get album
album=`id3v2 -l "$1" | grep TALB | awk -F": " '{print $2}'`
echo "album is $album"
