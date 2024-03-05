# Discord CronBash Birthday Bot

This "Bot" is technicall not a Bot in its technical sense, but rather a super lightweight script executed at midnight that checks if its the birthday of a user that has been previously supplied by the admin of the Linux Machine. It does not need any additional tools or packages except curl and jq, which is provided by every regular install.

The script checks at 00:00 if its someones birthday and sends a discord notification pinging everyone in the channel. At midnight, it automatically deletes the message it has posted.

Its also features user supplied titles, pictures and birthday greetings. You can supply joyful wishes or you can greet them in a more personal manner.
There are 10 example titles and greetings, along with a few Birthday Pepes, like this one:
![Happy Pepe :)](https://www.memeatlas.com/images/pepes/pepe-happy-holding-birthday-cake.jpg)



# Setup
## Supplying the Discord Webhook
The Discord Webhook needs to be placed inside the `birthday_bot.sh`-Script in the `User Supplied Variables` Section at the very top. Make sure that you paste the link in between the apostrophes.

```
# User Supplied Variables

BOT_NAME='Birthday Bot'
AVATAR_URL='https://image.emojipng.com/852/6323852.jpg'
NOTIFY_URL='YourWebHookHere'
[...]
```
| Variable | Default-Value | Description |  Mandatory to change |
|---|---|---|---|
|  BOT_NAME |  Birthday Bot | Literal Name of the "User" that will post in the Channel  | NO
| AVATAR_URL  |  [Link to the picture](https://image.emojipng.com/852/6323852.jpg)  |  A link to the profile picture of the "User" | NO
| NOTIFY_URL | YourWebHookHere | Your Discord Webhook |YES|


### To get the Discord Webhook:
1.  Open the Discord channel you want to receive birthday notifications to.
2.  From the channel menu, select  **Edit channel**.
3.  Select  **Integrations**.
4.  If there are no existing webhooks, select  **Create Webhook**. Otherwise, select  **View Webhooks**  then  **New Webhook**.
5.  Copy the URL from the  **WEBHOOK URL**  field.
6.  Select  **Save**.

## Date File
The `date-file` is located in the `files`-directory and has to be supplied in the following format:
| Date | Display Name | Discord ID |
|:---:|:---:|:---:|
| 01.01 | 'John' | <@123456...> |
| 31.06 | 'Daniel' | <@123456...> |
| 01.12 | 'Mary & Jane' | <@1234...>&<@5678...> |

Make sure the Discord ID is enclosed by the `<@...>`Symbols, otherwise the tagging might not work.
Examples are also provided in the date-file.
For multiple entries on the same day, either use a new line with the same date or use the formatting shown above.
To edit the files, just use the file editor of your choice (Vim, Nano, Vi, etc.)

The Display-Name is the literal name beeing displayed in the birthday greetings.

### To get the Discord User ID:

Make Sure You Have Developer Mode Enabled
You'll find Developer Mode in User Settings > Advanced.
Once you have enabled the Developer Mode, right click on any user you want to get the ID from and select "Copy User-ID"
[The official Discord Documentation may help you further with screenshots.](https://support.discord.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID)


## Optional Files
The optional files are:
| Location/Name | Description |
|---|:---|
| files/random_lines | A line chosen at random that accompanies the birthday wishes |
| files/random_titles | A random title of the birthday announcement|
| files/random_pics | A random picture attached in the discord message|

Each line inside the `random_`-Files represents a new entry and can be freely customized.

For example `random_titles`:
``` 
🎉 Incoming Birthday! Get Ready to Celebrate! 🎂
🎈 Brace Yourself: It's a Special Day Announcement! 🎁
🌟 A Birthday Spectacle is Approaching! 🎊
```
`random_pics`:
```
https://www.memeatlas.com/images/pepes/pepe-happy-holding-birthday-cake.jpg
https://th.bing.com/th/id/OIP.pvWwTaAE9Q08uIp09Vl6ZgHaH8?pid=ImgDet&w=196&h=210&c=7&dpr=1,5
https://th.bing.com/th/id/OIP.ciGioL01SjpFYsRy2LTSrQHaHa?pid=ImgDet&w=196&h=196&c=7&dpr=1,5
```

## Crontab Setup
Just type the following command from inside the git repository to add the script to your crontab if you wish to automate it:
```
./birthday_bot.sh setup
```

# Connection Test
To test the connection and the Discord Webhook, simply run the script without any arguments.
```
./birthday_bot.sh
```
The resulting Post should look something like this:
![](https://cdn.discordapp.com/attachments/144924471688429569/1214641048970731601/image.png?ex=65f9d9a1&is=65e764a1&hm=2a7db2440ec67032b8e50e4f3800cdbddb6f58e9bf01a72b6acc6b4599a88954&)

