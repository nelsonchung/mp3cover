#!/bin/bash
source global_setting.sh
SONG_INDEX_KEYWORD_START="alt=\""
SONG_INDEX_KEYWORD_END="\""
PYTHON_UTILITY_PATH="/home/cbn/Nelson/git/mp3cover/"

SONG_NAME="$1"
echo "Try to get $SONG_NAME mp3 file................................................................................................................"
#0. Clear data
rm $SONG_FILE 
rm $ALBUM_FILE
rm $MP3_FILE 

#1. Get the information of song (三年二班)
echo "1. Get the information of song"
#curl -o song.html https://www.kkbox.com/tw/tc/search.php?word=三年二班&search=mix&lang=tc
#curl -o $SONG_FILE https://www.kkbox.com/tw/tc/search.php?word=$SONG_NAME&search=mix&lang=tc
curl -o $SONG_FILE https://www.kkbox.com/tw/tc/search.php?word=$SONG_NAME&search=song
#We need to wait 3~5 seconds if we use curl utility
sleep 5

#2. Get the information of album (葉惠美) included the song
echo "2. Get the information of album"
#2.1: find mp3 cover via song index and do 4. Parse the mp3 cover link
mp3_cover_http_link=`cat $SONG_FILE | grep $SONG_INDEX_KEYWORD_START$SONG_NAME$SONG_INDEX_KEYWORD_END | grep jpg | awk -F"\"" '{print $2}'`

if [ "$mp3_cover_http_link" == "" ]; then
    #2.2: find mp3 cover via album name
    #We have problem when we have many options in this stage.
    #We will always get last one because we use "tail -n 1"
    #cat song.html | grep "三年二班<\/strong> - Album Version" -C10 | tail -n 1 | awk -F" " '{print $SONG_NAME}'
    echo "Try to get album name with C10 setting"
    ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C10 | tail -n 1 | awk -F" " '{print $SONG_NAME}'`
    if [ "$ALBUM_NAME" == "" ]; then #some song need to shift to get correct album name
        echo "Not get album name, so we need to to C11 setting"
        ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C11 | tail -n 1 | awk -F" " '{print $SONG_NAME}'`
    fi
    
    #3. Get the cover of album
    #curl -o album.html https://www.kkbox.com/tw/tc/search.php?search=mix&word=葉惠美&lang=tc
    #curl -o $ALBUM_FILE https://www.kkbox.com/tw/tc/search.php?search=mix&word=$ALBUM_NAME&lang=tc
    echo "Album name is "$ALBUM_NAME
    python $PYTHON_UTILITY_PATH"getmp3cover.py" $ALBUM_NAME 

#4. Parse the mp3 cover link
    mp3_cover_http_link=`cat $MP3_FILE | grep $ALBUM_NAME | grep jpg | awk -F"\"" '{print $2}'`
fi
echo "Mp3 cover http link is "$mp3_cover_http_link
#wget $mp3_cover_http_link -O $MP3_COVER_FILE 
wget $mp3_cover_http_link -O $SONG_NAME".jpg" 

:<<MARK
MARK

