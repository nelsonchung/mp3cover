#MP3 file format
#01 三年二班.mp3
#Run command
#setmp3info.sh 三年二班 01

function SHOW_ALBUM() {
    echo $ALBUM_NAME
}

source global_setting.sh
OUTPUT_FILE="Option.txt"
LIST_MAXIMUM=10
rm $OUTPUT_FILE

SONG_NAME="$1"
TRACK_NUM="$2"
echo "Running $0 file......................................................................................."
#0. Clear data
rm $SONG_FILE 

#1. Get the information of song (三年二班)
echo "1. Get the information of song"
#curl -o $SONG_FILE https://www.kkbox.com/tw/tc/search.php?word=$SONG_NAME&search=song&
python $PYTHON_UTILITY_PATH"/setmp3info.py" $SONG_NAME 
#We need to wait 3~5 seconds if we use curl utility
sleep 5 

#2. Get the information of album (葉惠美) included the song
echo "2. Get the information of artist"
#ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -C4 | tail -n 1 | awk -F" " '{print $SONG_NAME}'`
#ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -m1 -C4 | tail -n 1 | awk -F"html\">" '{print $2}' | awk -F"</a>" '{print $1}'`
#echo $ARTIST_NAME
#So far, we list most $LIST_MAXIMUM item
for i in $(seq 1 $LIST_MAXIMUM)
do
    ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" "-m$i" -C4 | tail -n 1 | awk -F"html\">" '{print $2}' | awk -F"</a>" '{print $1}'`
    #if [ "$ARTIST_NAME" != "" ]; then
        echo $ARTIST_NAME >> $OUTPUT_FILE
    #fi
done

option_num=0

while read option
do
    option_num=`expr $option_num + 1`
    echo "$option_num. $option" 
done < $OUTPUT_FILE

echo -n "99. All are wrong."

read -p "請選擇:" userchoose

if [ "$userchoose" == "99" ]; then 
    rm $SONG_FILE 
    echo "Not get artist name, so we need to to C5 setting"
    for i in $(seq 1 $LIST_MAXIMUM)
    do
    ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" "-m$i" -C4 | tail -n 1 | awk -F"html\">" '{print $2}' | awk -F"</a>" '{print $1}'`
        #if [ "$ARTIST_NAME" != "" ]; then
            echo $ARTIST_NAME >> $OUTPUT_FILE
        #fi
    done
    echo "99. All are wrong."
    read userchoose
fi

if [ "$userchoose" == "99" ]; then
    echo "Exit."
    exit
fi
ARTIST_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" "-m$userchoose" -C4 | tail -n 1 | awk -F"html\">" '{print $2}' | awk -F"</a>" '{print $1}'`
echo $ARTIST_NAME
 
echo "3. Get the informatin of album"
#case a: The name of song is the same with album name
#ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" "-m$userchoose" -C11 | tail -n 1 | awk -F"$ALBUM_KEYWORD$SONG_NAME" '{print $1}'`
#ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" "-m$userchoose" -C13 | tail -n 1 | awk -F"$ALBUM_KEYWORD$SONG_NAME" '{print $1}'`
#echo $ALBUM_NAME
ALBUM_NAME=""
#case b: general case
if [ "$ALBUM_NAME" == "" ]; then #some song need to shift to get correct album name
    ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -m$userchoose -C10 | tail -n 1 | awk -F" " '{print $1}'`
    SHOW_ALBUM
    #case c:
    if [ "$ALBUM_NAME" == "" ]; then #some song need to shift to get correct album name
        echo "Not get album name, so we need to to C11 setting"
        ALBUM_NAME=`cat $SONG_FILE | grep "$ALBUM_KEYWORD$SONG_NAME" -m$userchoose -C11 | tail -n 1 | awk -F" " '{print $1}'`
        SHOW_ALBUM
    fi
fi
read -p "album nam is ok?(Y/y/N/n)" userchoose 
if [ "$userchoose" == "N" ] || [ "$userchoose" == "n" ]; then
    ALBUM_NAME="$SONG_NAME"
    echo "Set song name to album name"
fi
SHOW_ALBUM

id3v2 -D $1".mp3"
id3v2 -t $SONG_NAME -a $ARTIST_NAME -A $ALBUM_NAME -T $TRACK_NUM $1".mp3"
