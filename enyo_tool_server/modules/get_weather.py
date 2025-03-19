import geocoder
import os

latlng = geocoder.ipinfo("me").latlng;

os.execvp("curl", ["-X", "https://dragon.best/api/glax_weather.json?location=&lon="+str(latlng[1])+"&lat="+str(latlng[0])+"&units=imperial"])
