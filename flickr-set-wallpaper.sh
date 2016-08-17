#!/bin/bash
ping -c 1 8.8.8.8 > /dev/null
PING_OK=$?

while [ "$PING_OK" != "0" ];
do
	echo $PING_OK
	sleep 10
	ping -c 1 8.8.8.8 > /dev/null
	PING_OK=$?
done


SFONDO_OK=1
while [ "$SFONDO_OK" != 0 ];
do

IMG_TEMP="/tmp/sfondo$RANDOM.jpg"

#### CHANGE IT ####
USER_ID="00000000000@0000000"
API_KEY="00000000000000000000000000000"
###################

ID=$(nodejs -pe 'JSON.parse(process.argv[1]).photos.photo[Math.floor(Math.random() * JSON.parse(process.argv[1]).photos.photo.length)].id' "$(curl --data "nojsoncallback=1&method=flickr.favorites.getList&user_id=$USER_ID&api_key=$API_KEY&format=json" -s 'https://api.flickr.com/services/rest/?jsoncallback=?')")

URL=$(nodejs -pe 'JSON.parse(process.argv[1]).sizes.size[10].source' "$(curl --data "nojsoncallback=1&method=flickr.photos.getSizes&photo_id=$ID&api_key=$API_KEY&format=json" -s 'https://api.flickr.com/services/rest/?jsoncallback=?')")

rm -rf /tmp/sfondo*
wget --quiet $URL -O $IMG_TEMP
SFONDO_OK=$?

gsettings set org.gnome.desktop.background picture-uri "file:////$IMG_TEMP" 2>/dev/null
gsettings set org.gnome.desktop.background picture-options "stretched" 2>/dev/null
# fbsetbg -f $IMG_TEMP

done

# echo $ID
# echo $URL
# echo $IMG_TEMP
