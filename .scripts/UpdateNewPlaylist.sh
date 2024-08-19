cd /home/me/piShare/Ext/Musik
find . \( -name "*.mp3" -o -name "*.wav" -o -name "*.flac" \) -mtime -10 |grep -oP '[.]\/\K.+' > ../mpd/playlists/new.m3u 
mpc update --wait
