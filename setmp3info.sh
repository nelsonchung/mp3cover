#MP3 file format
#01 三年二班.mp3
#Run command
#setmp3info.sh 三年二班 01

source global_setting.sh
SONG_NAME="$1"
TRACK_NUM="$2"
echo "Running $0 file......................................................................................."
#0. Clear data
rm $SONG_FILE 

#1. Get the information of song (三年二班)
echo "1. Get the information of song"
curl -o $SONG_FILE https://www.kkbox.com/tw/tc/search.php?word=$SONG_NAME&search=song
#We need to wait 3~5 seconds if we use curl utility
sleep 5 

#2. Get the information of album (葉惠美) included the song
echo "2. Get the information of artist"
#ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C4 | tail -n 1 | awk -F" " '{print $SONG_NAME}'`
ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C4 | tail -n 1 | awk -F"html\">" '{print $2}' | awk -F"</a>" '{print $1}'`
echo $ARTIST_NAME
if [ "$ARTIST_NAME" == "" ]; then #some song need to shift to get correct artist name
    echo "Not get artist name, so we need to to C11 setting"
    ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C5 | tail -n 1 | awk -F"html\">" '{print $2}' | awk -F"</a>" '{print $1}'`
    echo $ARTIST_NAME
fi
 
echo "3. Get the informatin of album"
ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C10 | tail -n 1 | awk -F" " '{print $1}'`
echo $ALBUM_NAME
if [ "$ALBUM_NAME" == "" ]; then #some song need to shift to get correct album name
    echo "Not get album name, so we need to to C11 setting"
    ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C11 | tail -n 1 | awk -F" " '{print $1}'`
    echo $ALBUM_NAME
fi

id3v2 -D $1".mp3"
id3v2 -t $SONG_NAME -a $ARTIST_NAME -A $ALBUM_NAME -T $TRACK_NUM $1".mp3"
