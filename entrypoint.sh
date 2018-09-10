#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Update Rust Server
./steam/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 258550 +quit

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

if [ -f OXIDE_FLAG ] || [ "${OXIDE}" = 1 ]; then
    echo "Updating uMod..."
    curl -sSL "https://umod.org/games/rust/download" > oxide.zip
    unzip -o -q oxide.zip
    rm oxide.zip
    echo "Done updating uMod!"
fi

# Fix for Rust not starting
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)

# Run the Server
node /wrapper.js "${MODIFIED_STARTUP}"
