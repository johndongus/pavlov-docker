#!/bin/bash
IFS=
STEAM_CLIENT_DLL=$( find ../ -name 'steamclient.so' -print -quit)
UE4_TRUE_SCRIPT_NAME=$(echo \"$0\" | xargs readlink -f)
UE4_PROJECT_ROOT=$(dirname "$UE4_TRUE_SCRIPT_NAME")
ln $STEAM_CLIENT_DLL "$UE4_PROJECT_ROOT/Pavlov/Binaries/Linux/steamclient.so"
chmod +x "$UE4_PROJECT_ROOT/Pavlov/Binaries/Linux/PavlovServer"

LOCAL_IP=`awk 'END{print $1}' /etc/hosts`
RCON_SETTINGS=`cat $UE4_PROJECT_ROOT/Pavlov/Saved/Config/RconSettings.txt | awk '{split($0, a, "="); print a[2]}'`
TEMP_ARR=($RCON_SETTINGS)
RCON_PASSWORD=`echo -n "${TEMP_ARR[0]}" | md5sum | cut -c1-32`
RCON_PORT="${TEMP_ARR[1]}"

generate_gameini () {
method1="bEnabled=true\nbSecured=true\nbCustomServer=true\nServerName=$1\nMaxPlayers=$2\n$3\n$4\n$5"
echo -e $method1
echo -e $method1 > ./Pavlov/Saved/Config/LinuxServer/Game.ini
launch_server & command_line
return 5
}

configure_server () {
      echo "=============================="
   echo "=        Server Setup        ="
   echo "=============================="
read -p "Enter Server Name [Default Server]: " name
name=${name:-Default Server}
echo 


read -p "Enter Max Slots [10]: " slots
slots=${slots:-10}
echo 


read -p "Enable Whitelist (y/N)?" whitelist
case "$choice" in 
  y|Y ) whitelist='whitelist=true';echo ;;
  n|N ) whitelist='whitelist=false';echo ;;
  * ) whitelist='whitelist=false';echo ;;
esac

read -p "Enter a password, or leave blank if not wanted [0000]: " pass
pass=${pass:-}
echo 


read -p "Enter Multiple Maps [UGC1668673188,TDM UGC1668673155,SND]: " maps
maps=${maps:-UGC1668673188,TDM UGC1668673155,SND}
if [[ -z "$maps" ]]; then
   printf '%s\n' "No input entered"
else
   maps2=`echo $maps | tr " " "\n"| sed -e 's/^/MapRotation=(MapId="/'  | sed -e 's/,/",GameMode="/g' | sed -e 's/$/")/' `
   echo "=============================="
   echo "=      Generating Config     ="
   echo "=============================="
   generate_gameini "$name" $slots "$maps2" $whitelist $pass
fi
}









command_line() {
while true
do
        read input

        if [[ $input == help ]] ; then
   echo "=============================="
   echo "=          Help Page         ="
   echo "=============================="
            echo -e "'S configure' - Starts Server Configuration Wizard\n'R Help' - Shows Avaliable Rcon Commands"
        fi


        if [[ $input == "R "* ]] ; then
            #echo "This is a RCON related command"
            input=${input:2}
            echo $input
            ./Rcon $LOCAL_IP $RCON_PORT "b0017664d50a3649bfcf3fbc41a2aeaa" "$input" &
        fi


        if [[ $input == "S "* ]] ; then
            echo "This is a server related command"
                     if [[ $input == "S configure" ]] ; then
                           configure_server
                     fi
                                         if [[ $input == "S reload" ]] ; then
                                         echo 'Reload PavlovServer Proccess'
                          #reload_server
                     fi
        fi
done
}


launch_server(){
"$UE4_PROJECT_ROOT/Pavlov/Binaries/Linux/PavlovServer" -silent PORT=7777 | sed '/heartbeat/d' | sed '/Dormant:/d' &
}

if [ -f "./Pavlov/Saved/Config/LinuxServer/Game.ini" ]; then
    echo "Game.ini = OK"
    launch_server & command_line
else 
    echo "Game.INI is missing, running configuration wizard."
    configure_server

fi


#configure_server
