# LoxoneConfig v17+ is 64-bit only. Switch from Alpine/386 (wine32) to Debian/amd64
# with WineHQ stable (wine32+wine64 multilib) so both the 32-bit installer and
# the 64-bit LoxoneConfig.exe run correctly.
FROM jlesage/baseimage-gui:debian-12-v4
LABEL org.opencontainers.image.source="https://github.com/3stradastone/docker-loxone-config"

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget gnupg ca-certificates xterm cabextract x11-xkb-utils unzip && \
    wget -nc -q https://dl.winehq.org/wine-builds/winehq.key && \
    gpg -o /etc/apt/keyrings/winehq-archive.key --dearmor winehq.key && \
    rm winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends winehq-stable winbind && \
    rm -rf /var/lib/apt/lists/* && \
    wget -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/bin/winetricks

COPY init-install.sh /init-install.sh
COPY startapp.sh /startapp.sh

# Set remote resizing as default
# https://github.com/jlesage/docker-baseimage-gui/issues/112
RUN sed -i "s/resize = 'scale';/resize = 'remote';/g" /opt/noVNC/app/ui.js 2>/dev/null || true

RUN chmod a+rx /startapp.sh && chmod a+rx /init-install.sh

RUN set-cont-env APP_NAME "Loxone Config"
