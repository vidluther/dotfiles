# Local MaxMind DB 

This is where we store the maxmind geo ip database..
Look up YOUR_LICENSE_KEY in 1Password then do the following

```zsh
export YOUR_LICENSE_KEY='YOURSECRETKEYSORS'
curl -o maxmind.tar.gz https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=YOUR_LICENSE_KEY&suffix=tar.gz
tar zxvf maxmind.tar.gz 
```

Now use the db as you see fit/are allowed by the license. 
