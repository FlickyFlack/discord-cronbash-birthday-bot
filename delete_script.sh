#!/bin/bash

NOTIFY_URL='https://discord.com/api/webhooks/1209490783183306792/I1B4PKdB_oyk6pb5EGkytz2HSv1_pLVd1mV_-vg0Ncezt406np5xjTDq6oNZgT-2mQ3-'
MESSAGE_ID=$(cat /root/birthday_bot/files/message_id)

curl -X DELETE "$NOTIFY_URL/messages/$MESSAGE_ID"
