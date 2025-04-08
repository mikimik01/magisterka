exit#!/bin/bash

FRIDA_VERSION="16.1.4"
ARCH="arm64"
FRIDA_FILENAME="frida-server-$FRIDA_VERSION-android-${ARCH}"
FRIDA_LOCAL="frida-server"
TMP_DIR="/data/local/tmp"

echo "📱 Sprawdzam połączenie ADB..."
adb devices | grep -w "device" > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Brak urządzenia ADB. Sprawdź połączenie USB i debugowanie."
    exit 1
fi
echo "✅ Urządzenie ADB wykryte."

echo "🔍 Sprawdzam, czy frida-server już działa..."
adb shell ps | grep frida-server > /dev/null
if [ $? -eq 0 ]; then
    echo "⚠️  frida-server już działa na urządzeniu."
else
    echo "⬇️  Pobieram frida-server $FRIDA_VERSION ($ARCH)..."
    if [ ! -f "$FRIDA_LOCAL" ]; then
        wget "https://github.com/frida/frida/releases/download/$FRIDA_VERSION/$FRIDA_FILENAME.xz"
        xz -d "$FRIDA_FILENAME.xz"
        mv "$FRIDA_FILENAME" "$FRIDA_LOCAL"
        chmod +x "$FRIDA_LOCAL"
    fi

    echo "📦 Wysyłam frida-server na urządzenie..."
    adb push "$FRIDA_LOCAL" "$TMP_DIR/"

    echo "🚀 Uruchamiam frida-server..."
    adb shell "chmod +x $TMP_DIR/frida-server && $TMP_DIR/frida-server > /dev/null 2>&1 &"
    sleep 2
fi

echo "🔌 Sprawdzam, czy port 27042 jest otwarty (frida-server działa)..."
adb shell netstat -an | grep 27042 > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ frida-server działa na porcie 27042."
else
    echo "❌ frida-server nie nasłuchuje na porcie 27042. Coś poszło nie tak."
    exit 1
fi

echo "🔍 Uruchamiam frida-ps -U (lista aplikacji)..."
frida-ps -U
if [ $? -ne 0 ]; then
    echo "❌ Nie udało się połączyć z frida-server. Sprawdź wersje, SELinux lub uruchom ręcznie."
    exit 1
fi

echo "🎉 Wszystko działa! Gotowy do hookowania 💉"
