#!/bin/bash


#User Supplied Variables

BOT_NAME='Birthday Bot'
AVATAR_URL='https://image.emojipng.com/852/6323852.jpg'
NOTIFY_URL='YourWebHookHere'

# This script runs on dev mode by default. If you want to manually run in prod mode, use the "prod" argument

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

DATE_FILE="files/date_file"
RANDOM_LINES_FILE="files/random_lines"
RANDOM_PIC_FILE="files/random_pics"
RANDOM_TITLE_FILE="files/random_titles"
TODAY=$(date +"%d.%m")

while IFS= read -r LINE; do
    if [ "$DEV_MODE" == true ]; then
	STORED_DATE=$(date +"%d.%m")
        NAME="Test"
        USER_ID="<@1209490783183306792>"
	SHOUTOUT="||everyone||"
    else
        STORED_DATE=$(echo "$LINE" | awk '{print $1}')
        NAME=$(echo "$LINE" | awk -F"'" '{print $2}')
        USER_ID=$(echo "$LINE" | grep -oP '<@[^>]+.*$')
	SHOUTOUT="||@everyone||"
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
               "description": "Hey '$NAME' ('$USER_ID'), happy birthday!\n\n'"$RANDOM_LINE"'",
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

	echo "$MESSAGE_ID" > files/message_id
    fi
    if [ "$DEV_MODE" == true ]; then
	    DEV_MODE=false
    fi

done < "$DATE_FILE"

