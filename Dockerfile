FROM ubuntu:18.04

ENV SERVER_TYPE=pc

RUN dpkg --add-architecture i386;
RUN apt-get update && \
    apt-get install gcc-8-base:i386 libc6:i386 libgcc1:i386 libstdc++6:i386 curl -y

RUN adduser --disabled-password --gecos "" steam && \
    mkdir /pavlov && \
    chown steam:steam /pavlov


WORKDIR /pavlov
USER steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -;ls

RUN if [ "$SERVER_TYPE" = "pc" ]; then ./steamcmd.sh +login anonymous +force_install_dir /pavlov/server/ +app_update 622970 +exit; fi && \
    if [ "$SERVER_TYPE" = "pc_beta" ]; then ./steamcmd.sh +login anonymous +force_install_dir /pavlov/server/ +app_update 622970 -beta beta_server +exit; fi && \
    if [ "$SERVER_TYPE" = "shack" ]; then ./steamcmd.sh +login anonymous +force_install_dir /pavlov/server/ +app_update 622970 -beta shack +exit; fi


ADD Game.ini             /pavlov/server/Pavlov/Saved/Config/LinuxServer/
ADD RconSettings.txt     /pavlov/server/Pavlov/Saved/Config/
ADD mods.txt             /pavlov/server/Pavlov/Saved/Config/
ADD start.sh             /pavlov/server/

USER root
RUN chown -R steam:steam /pavlov/server/*
USER steam

RUN chmod +x /pavlov/server/start.sh && \
    mkdir -p /pavlov/server/Pavlov/Saved/Logs && \
    mkdir -p /pavlov/server/Pavlov/Saved/Config/LinuxServer


CMD ["/pavlov/server/start.sh"]
