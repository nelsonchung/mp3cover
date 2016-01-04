
source global_setting.sh
OUTPUT_FILE="parse_mp3.txt"

ls -al *.mp3 > $OUTPUT_FILE

while read song_info
do
    TRACK_NUM=`cat $song_info | awk -F" " '{print $9}'`
    SONG_NAME=`cat $song_info | awk -F" " '{print $10}'`
    setmp3info.sh $SONG_NAME $TRACK_NUM
done < $OUTPUT_FILE
