#!/bin/bash
SONG_FILE="song.html"
ALBUM_FILE="album.html"
MP3_FILE="mp3cover.html"
MP3_COVER_FILE="mp3_cover.jpg"
#ALBUM_KEYWORD="<\/strong> - Album Version"
ALBUM_KEYWORD="<strong class=\"keyword c1\">"
SONG_INDEX_KEYWORD_START="alt=\""
SONG_INDEX_KEYWORD_END="\""

#0. Clear data
rm $SONG_FILE 
rm $ALBUM_FILE
rm $MP3_FILE 

#1. Get the information of song (三年二班)
echo "1. Get the information of song"
#curl -o song.html https://www.kkbox.com/tw/tc/search.php?word=三年二班&search=mix&lang=tc
#curl -o $SONG_FILE https://www.kkbox.com/tw/tc/search.php?word=$1&search=mix&lang=tc
curl -o $SONG_FILE https://www.kkbox.com/tw/tc/search.php?word=$1&search=song
#We need to wait 3~5 seconds if we use curl utility
sleep 5

#2. Get the information of album (葉惠美) included the song
echo "2. Get the information of album"
#2.1: find mp3 cover via song index and do 4. Parse the mp3 cover link
mp3_cover_http_link=`cat $SONG_FILE | grep $SONG_INDEX_KEYWORD_START$1$SONG_INDEX_KEYWORD_END | grep jpg | awk -F"\"" '{print $2}'`

if [ "$mp3_cover_http_link" == "" ]; then
    #2.2: find mp3 cover via album name
    #cat song.html | grep "三年二班<\/strong> - Album Version" -C10 | tail -n 1 | awk -F" " '{print $1}'
    ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$1" -C10 | tail -n 1 | awk -F" " '{print $1}'`
    if [ "$ALBUM_NAME" == "" ]; then #some song need to shift to get correct album name
        ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$1" -C11 | tail -n 1 | awk -F" " '{print $1}'`
    fi
    
    #3. Get the cover of album
    #curl -o album.html https://www.kkbox.com/tw/tc/search.php?search=mix&word=葉惠美&lang=tc
    #curl -o $ALBUM_FILE https://www.kkbox.com/tw/tc/search.php?search=mix&word=$ALBUM_NAME&lang=tc
    echo "Album name is "$ALBUM_NAME
    python getmp3cover.py $ALBUM_NAME 

#4. Parse the mp3 cover link
    mp3_cover_http_link=`cat $MP3_FILE | grep $ALBUM_NAME | grep jpg | awk -F"\"" '{print $2}'`
fi
echo "Mp3 cover http link is "$mp3_cover_http_link
wget $mp3_cover_http_link -O $MP3_COVER_FILE 

:<<MARK
MARK

