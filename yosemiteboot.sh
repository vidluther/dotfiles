Use an 8GB+ USB stick and format it with GUID partition mapping and a partition named Untitled, then run the following in terminal:
#!/bin/bash

set -e
set -x
 
#sudo hdiutil attach /Applications/Install\ OS\ X\ 10.10\ Developer\ Preview.app/Contents/SharedSupport/InstallESD.dmg
sudo hdiutil attach /Applications/Install\ OS\ X\ Yosemite\ Developer\ Preview.app/Contents/SharedSupport/InstallESD.dmg
sudo asr restore -source /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg  -target /Volumes/Untitled -erase -format HFS+
sudo rm /Volumes/OS\ X\ Base\ System/System/Installation/Packages
sudo cp -a /Volumes/OS\ X\ Install\ ESD/Packages /Volumes/OS\ X\ Base\ System/System/Installation/Packages
sudo cp -a /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg /Volumes/OS\ X\ Install\ ESD/BaseSystem.chunklist /Volumes/OS\ X\ Base\ System
