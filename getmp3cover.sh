#!/bin/bash
SONG_FILE="song.html"
ALBUM_FILE="album.html"
MP3_FILE="mp3cover.html"
MP3_COVER_FILE="mp3_cover.jpg"
ALBUM_KEYWORD="<\/strong> - Album Version"

#0. Clear data
rm $SONG_FILE 
rm $ALBUM_FILE
rm $MP3_FILE 

#1. Get the information of song (三年二班)
echo "1. Get the information of song"
#curl -o song.html https://www.kkbox.com/tw/tc/search.php?word=三年二班&search=mix&lang=tc
curl -o $SONG_FILE https://www.kkbox.com/tw/tc/search.php?word=$1&search=mix&lang=tc
#We need to wait 3~5 seconds if we use curl utility
sleep 5

#2. Get the information of album (葉惠美) included the song
echo "2. Get the information of album"
#cat song.html | grep "三年二班<\/strong> - Album Version" -C10 | tail -n 1 | awk -F" " '{print $1}'
ALBUM_NAME=`cat $SONG_FILE | grep "$1$ALBUM_KEYWORD" -C10 | tail -n 1 | awk -F" " '{print $1}'`

#3. Get the cover of album
#curl -o album.html https://www.kkbox.com/tw/tc/search.php?search=mix&word=葉惠美&lang=tc
#curl -o $ALBUM_FILE https://www.kkbox.com/tw/tc/search.php?search=mix&word=$ALBUM_NAME&lang=tc
echo "Album name is "$ALBUM_NAME
python getmp3cover.py $ALBUM_NAME 

#4. Parse the mp3 cover link
mp3_cover_http_link=`cat $MP3_FILE | grep $ALBUM_NAME | grep jpg | awk -F"\"" '{print $2}'`
echo "Mp3 cover http link is "$mp3_cover_http_link
wget $mp3_cover_http_link -O $MP3_COVER_FILE 
