
source global_setting.sh
OUTPUT_FILE="parse_mp3.txt"
RUN_FILE="run_setmp3info_album.sh"
rm $OUTPUT_FILE
rm $RUN_FILE

ls -al *.mp3 > $OUTPUT_FILE

while read song_info
do
    echo "song_info is $song_info"
    TRACK_NUM=01
    SONG_NAME=`echo $song_info | awk -F" " '{print $9}' | awk -F"." '{print $1}'`
    echo "SONG_NAME is $SONG_NAME"
    echo "setmp3info_singlesone.sh $SONG_NAME $TRACK_NUM" >> $RUN_FILE 
done < $OUTPUT_FILE

source $RUN_FILE
