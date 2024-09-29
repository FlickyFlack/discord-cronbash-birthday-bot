#!/bin/bash

NOTIFY_URL='https://discord.com/api/webhooks/1209490783183306792/I1B4PKdB_oyk6pb5EGkytz2HSv1_pLVd1mV_-vg0Ncezt406np5xjTDq6oNZgT-2mQ3-'

while IFS= read -r MESSAGE_ID; do
    curl -X DELETE "$NOTIFY_URL/messages/$MESSAGE_ID"

done < /root/birthday_bot/files/before_message_id

truncate -s 0 /root/birthday_bot/files/before_message_id
