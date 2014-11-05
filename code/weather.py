from spark_cloud import SparkCloud
from xml.dom import minidom
import urllib

OPENWEATHER = "http://api.openweathermap.org/data/2.5/weather?q="
CITY = "YOUR-CITY"
MODE = "&mode=xml"
URL = (OPENWEATHER + CITY + MODE)

ACCESS_TOKEN = 'YOUR-SPARK-ACCESS-TOKEN'
spark = SparkCloud(ACCESS_TOKEN)

# List devices, functions and variables
print spark.devices
print spark.marvin.functions
print spark.marvin.variables

# Access device
spark.marvin

# Tell if a device is connected
connected = spark.marvin.connected
while connected == True:
  xmldoc = minidom.parse(urllib.urlopen(URL))
  rain = xmldoc.getElementsByTagName('weather')[0]
  rain = rain.getAttributeNode('number').nodeValue
  rain = int(rain)
  if rain > 500 and rain < 504:
    spark.marvin.lightOn()
  elif rain == 511:
    spark.marvin.lightOn()
  elif rain > 520 and rain < 522:
    spark.marvin.lightOn()
  elif rain == 531:
    spark.marvin.lightOn()
  else:
    spark.marvin.lightOff()
  connected = spark.marvin.connected
  pass
