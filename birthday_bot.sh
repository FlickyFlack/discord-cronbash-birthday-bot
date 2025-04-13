#!/bin/bash

# This script runs on dev mode by default. If you want to set up your crontab, make sure to use the "prod" argument.

DATE_FILE="files/date_file"
RANDOM_LINES_FILE="files/random_lines"
RANDOM_PIC_FILE="files/random_pics"
RANDOM_TITLE_FILE="files/random_titles"
BOT_NAME='Birthday Bot'
AVATAR_URL='https://image.emojipng.com/852/6323852.jpg'
NOTIFY_URL='https://discord.com/api/webhooks/1209490783183306792/I1B4PKdB_oyk6pb5EGkytz2HSv1_pLVd1mV_-vg0Ncezt406np5xjTDq6oNZgT-2mQ3-?wait=true' #This Webhook is no longer valid, I forgot to remove it here lmao
TODAY=$(date +"%d.%m")
SIX_DAYS_BEFORE=$(date -d "+6 day" +"%d.%m")
FIVE_DAYS_BEFORE=$(date -d "+5 day" +"%d.%m")
FOUR_DAYS_BEFORE=$(date -d "+4 day" +"%d.%m")
THREE_DAYS_BEFORE=$(date -d "+3 day" +"%d.%m")
TWO_DAYS_BEFORE=$(date -d "+2 day" +"%d.%m")
ONE_DAY_BEFORE=$(date -d "+1 day" +"%d.%m")

DEV_MODE=true
PROD_MODE=false

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR" || exit 1

while [[ $# -gt 0 ]]; do
    case "$1" in
        prod)
            PROD_MODE=true
            shift
            ;;

	setup)
            if ! crontab -l | grep -q "post_script.sh prod >/dev/null 2>&1"; then
	    (crontab -l ; echo "0 0 * * * $SCRIPT_DIR/birthday_bot.sh prod >/dev/null 2>&1") | crontab -
            fi

            if ! crontab -l | grep -q "delete_script.sh >/dev/null 2>&1"; then
	    (crontab -l ; echo "59 23 * * * $SCRIPT_DIR/delete_script.sh >/dev/null 2>&1") | crontab -
            fi

            if ! crontab -l | grep -q "before_delete_script.sh >/dev/null 2>&1"; then
            (crontab -l ; echo "59 23 * * * $SCRIPT_DIR/before_delete_script.sh >/dev/null 2>&1") | crontab -
            fi

    	    echo "Crontab entries added successfully."
            exit 1
	    ;;

        *)
            echo "Invalid argument: $1"
	    echo "This script runs in dev mode by default (No aruguments)."
	    echo "To run in prod mode, add the 'prod' argument"
            exit 1
            ;;
    esac
done

if [ "$PROD_MODE" == true ]; then
    DEV_MODE=false
fi

while IFS= read -r LINE; do
    if [ "$DEV_MODE" == true ]; then
	STORED_DATE=$(date +"%d.%m")
	UNIX_TIMESTAMP=$(date -d "$(date +%Y)-$(echo $STORED_DATE | awk -F. '{print $2"-"$1}')" +%s)
        NAME="Test"
        USER_ID="<@1209490783183306792>"
	SHOUTOUT="||everyone||"
    else
        STORED_DATE=$(echo "$LINE" | awk '{print $1}')
	UNIX_TIMESTAMP=$(date -d "$(date +%Y)-$(echo $STORED_DATE | awk -F. '{print $2"-"$1}')" +%s)
        NAME=$(echo "$LINE" | awk -F"'" '{print $2}')
        USER_ID=$(echo "$LINE" | grep -oP '<@[^>]+.*$')
	SHOUTOUT="||@everyone||"
    fi

if [ "$TWO_DAYS_BEFORE" == "$STORED_DATE" ] || [ "$ONE_DAY_BEFORE" == "$STORED_DATE" ] || [ "$THREE_DAYS_BEFORE" == "$STORED_DATE" ] || [ "$FOUR_DAYS_BEFORE" == "$STORED_DATE" ] || [ "$FIVE_DAYS_BEFORE" == "$STORED_DATE" ] || [ "$SIX_DAYS_BEFORE" == "$STORED_DATE" ]; then

	RESPONSE_BEFORE=$(curl -s -X POST -H "Content-Type: application/json" -d '{
            "username": "'"$BOT_NAME"'",
            "avatar_url": "'"$AVATAR_URL"'",
            "content": "",
            "tts": false,
            "embeds":
             [
              {
               "id": 10674342,
               "title": "⏰ Geburtstags Erinnerung ⏰",
	       "description": "'$NAME' ('$USER_ID') hat <t:'$UNIX_TIMESTAMP':R>, <t:'$UNIX_TIMESTAMP':D> Geburtstag!\n\nNicht vergessen!",
               "color": 1157399,
               "fields": [],
               "image":
                {
                 "url": ""
                }
              }
             ],
            "components": [],
            "actions": {}
        }' "$NOTIFY_URL")

        BEFORE_MESSAGE_ID=$(echo "$RESPONSE_BEFORE" | jq -r '.id')

	echo "$BEFORE_MESSAGE_ID" >> files/before_message_id
    fi

    if [ "$TODAY" == "$STORED_DATE" ]; then

	RANDOM_LINE=$(shuf -n 1 "$RANDOM_LINES_FILE")
	RANDOM_PIC=$(shuf -n 1 "$RANDOM_PIC_FILE")
	RANDOM_TITLE=$(shuf -n 1 "$RANDOM_TITLE_FILE")

        RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d '{
            "username": "'"$BOT_NAME"'",
            "avatar_url": "'"$AVATAR_URL"'",
            "content": "'"$SHOUTOUT"'",
	    "tts": false,
            "embeds":
	     [
              {
      	       "id": 10674342,
      	       "title": "'"$RANDOM_TITLE"'",
               "description": "Hey '$NAME' ('$USER_ID'), alles Gute zum Geburtstag!\n\n'"$RANDOM_LINE"'",
               "color": 1157399,
               "fields": [],
               "image":
	        {
                 "url": "'"$RANDOM_PIC"'"
     		}
   	      }
 	     ],
            "components": [],
            "actions": {}
        }' "$NOTIFY_URL")

        MESSAGE_ID=$(echo "$RESPONSE" | jq -r '.id')

	echo "$MESSAGE_ID" >> files/message_id
    fi
    if [ "$DEV_MODE" == true ]; then
	    DEV_MODE=false
    fi

done < "$DATE_FILE"
