#!/bin/sh

if [ ! -d "/config/wine/drive_c/Program Files (x86)/Loxone" ]; then
  xterm -e "/init-install.sh" || exit 1
fi

export WINEDEBUG=-all
export QTWEBENGINE_CHROMIUM_FLAGS="--no-sandbox"
setxkbmap $XLANG
exec wine "/config/wine/drive_c/Program Files (x86)/Loxone/LoxoneConfig/LoxoneConfig.exe"