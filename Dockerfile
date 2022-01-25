FROM ubuntu:20.04 as builder

# Install base depends
RUN echo "baseversion=0.1" && apt update && apt install -y gdb curl lib32gcc1 libc++-dev unzip

# Add less privileged user
RUN useradd -ms /bin/bash steam
USER steam
WORKDIR /home/steam

# Install steam
RUN echo "steamversion=0.1" && mkdir ~/Steam && cd ~/Steam && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Install Pavlov
RUN echo "pavlovversion=0.1" && \
    ~/Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/pavlovserver \
      +app_update 622970 -beta shack +exit && \
    ~/Steam/steamcmd.sh +login anonymous +app_update 1007 +quit && \
    mkdir -p ~/.steam/sdk64 && \
    cp ~/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so ~/.steam/sdk64/steamclient.so && \
    cp ~/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so \
      ~/pavlovserver/Pavlov/Binaries/Linux/steamclient.so && \
    chmod +x ~/pavlovserver/PavlovServer.sh && \
    mkdir -p /home/steam/pavlovserver/Pavlov/Saved/Logs && \
    mkdir -p /home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer && \
    mkdir -p /home/steam/pavlovserver/Pavlov/Saved/maps

# Config
COPY mods.txt       /home/steam/pavlovserver/Pavlov/Saved/Config/mods.txt
COPY whitelist.txt  /home/steam/pavlovserver/Pavlov/Saved/Config/whitelist.txt
COPY blacklist.txt  /home/steam/pavlovserver/Pavlov/Saved/Config/blacklist.txt
COPY Game.ini       /home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer/Game.ini

# Maps
# TODO
# cd ~/pavlovserver/Pavlov/Saved/maps
# wget https://cdn.discordapp.com/attachments/841189246903386122/898218113223516241/inst-all.sh
# chmod +x  inst-all.sh
# ./inst-all.sh
EXPOSE 7777
EXPOSE 8177
