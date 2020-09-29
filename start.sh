#!/bin/sh
STEAM_CLIENT_DLL=$( find ../ -name 'steamclient.so' -print -quit)
UE4_TRUE_SCRIPT_NAME=$(echo \"$0\" | xargs readlink -f)
UE4_PROJECT_ROOT=$(dirname "$UE4_TRUE_SCRIPT_NAME")
mkdir -p "$HOME/.steam/sdk64"
mkdir -p /tmp/workshop/7777
ln $STEAM_CLIENT_DLL "$HOME/.steam/sdk64/steamclient.so"
ln $STEAM_CLIENT_DLL "$UE4_PROJECT_ROOT/Pavlov/Binaries/Linux/steamclient.so"
chmod +x "$UE4_PROJECT_ROOT/Pavlov/Binaries/Linux/PavlovServer"
"$UE4_PROJECT_ROOT/Pavlov/Binaries/Linux/PavlovServer" $@
