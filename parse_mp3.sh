
source global_setting.sh
OUTPUT_FILE="parse_mp3.txt"

ls -al *.mp3 > $OUTPUT_FILE

while read song_info
do
    echo "song_info is $song_info"
    TRACK_NUM=`echo $song_info | awk -F" " '{print $9}'`
    echo "TRACK_NUM is $TRACK_NUM"
    SONG_NAME=`echo $song_info | awk -F" " '{print $10}'`
    echo "SONG_NAME is $SONG_NAME"
    setmp3info.sh $SONG_NAME $TRACK_NUM
done < $OUTPUT_FILE
