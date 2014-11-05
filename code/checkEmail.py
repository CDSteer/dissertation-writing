from spark_cloud import SparkCloud
import feedparser

#Gmail details - Change these to match your account details
USERNAME="YOUR-EMAIL"
PASSWORD="YOUR-PASSWORD"
PROTO="https://"
SERVER="mail.google.com"
PATH="/gmail/feed/atom"

ACCESS_TOKEN = 'YOUR_ACCESS_TOKEN'

spark = SparkCloud(ACCESS_TOKEN)

# List devices
print spark.devices

# Access device
spark.devices['marvin']
# Or, shortcut form
# spark.marvin

# List functions and variables of a device
print spark.marvin.functions
print spark.marvin.variables

# Tell if a device is connected
connected = spark.marvin.connected
while connected == True:
  newmails = int(feedparser.parse(
      PROTO + USERNAME + ":" + PASSWORD + "@" + SERVER + PATH
  )["feed"]["fullcount"])
  #print newmails
  # Output data to serial port
  print newmails
  if newmails > 0:
    spark.marvin.lightOn()
  else:
    spark.marvin.lightOff()
  connected = spark.marvin.connected
  pass