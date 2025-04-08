#!/bin/bash

# 👉 Zmienne konfiguracyjne
FRIDA_VERSION="16.1.4"
ARCH="arm64"
FRIDA_FILENAME="frida-server-$FRIDA_VERSION-android-$ARCH"
FRIDA_LOCAL="frida-server"
TMP_DIR="/data/local/tmp"

echo ""
read -p "📦 Podaj nazwę pakietu aplikacji (np. com.example.app): " PACKAGE

if [ -z "$PACKAGE" ]; then
  echo "❌ Nie podano nazwy pakietu."
  exit 1
fi

if [ ! -f "unpinning.js" ]; then
  echo "⬇️  Pobieram skrypt do obchodzenia SSL pinningu..."
  wget https://raw.githubusercontent.com/pcipolloni/frida-netflix/master/unpinning/unpinning.js -O unpinning.js
fi

echo "📱 Sprawdzam połączenie ADB..."
adb devices | grep -w "device" > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ Brak urządzenia ADB. Sprawdź debugowanie USB."
    exit 1
fi
echo "✅ Urządzenie ADB widoczne."

echo "🔍 Sprawdzam, czy telefon ma root (komenda 'su')..."
adb shell which su > /dev/null
HAS_SU=$?

if [ "$HAS_SU" -eq 0 ]; then
    echo "✅ Root wykryty. Uruchamiam frida-server jako root..."

    # Pobierz frida-server jeśli nie istnieje
    if [ ! -f "$FRIDA_LOCAL" ]; then
        echo "⬇️  Pobieram frida-server $FRIDA_VERSION ($ARCH)..."
        wget "https://github.com/frida/frida/releases/download/$FRIDA_VERSION/$FRIDA_FILENAME.xz"
        xz -d "$FRIDA_FILENAME.xz"
        mv "$FRIDA_FILENAME" "$FRIDA_LOCAL"
        chmod +x "$FRIDA_LOCAL"
    fi

    echo "📦 Wysyłam frida-server na urządzenie..."
    adb push "$FRIDA_LOCAL" "$TMP_DIR/"

    echo "🚀 Uruchamiam frida-server jako root..."
    adb shell su -c "chmod +x $TMP_DIR/frida-server && nohup $TMP_DIR/frida-server > /dev/null 2>&1 &"
    sleep 2

    echo "🎯 Ładuję Fridę do procesu aplikacji: $PACKAGE"
    frida -U -n "$PACKAGE" -l unpinning.js

else
    echo "⚠️  Brak roota – przełączam na tryb spawn (bez rootowania)."
    echo "🎯 Uruchamiam aplikację przez Fridę: $PACKAGE"
    frida -U --no-pause --spawn "$PACKAGE" -l unpinning.js
fi
