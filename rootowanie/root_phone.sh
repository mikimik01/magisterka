#!/bin/bash

# === KONFIGURACJA ===
TWRP_IMG="twrp-3.7.0_9-0-herolte.img"
MAGISK_APK="Magisk-v28.1.apk"
MAGISK_ZIP="Magisk-v28.1.zip"

# === FUNKCJA: kompilacja Heimdall ze źródeł ===
build_heimdall() {
    echo ""
    echo "⚙️  Kompilacja Heimdall ze źródeł..."

    sudo apt update
    sudo apt install -y git cmake build-essential libusb-1.0-0-dev

    git clone https://github.com/Benjamin-Dobell/Heimdall.git || exit 1
    cd Heimdall || exit 1
    mkdir -p build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    make -j$(nproc)
    sudo make install
    cd ../..  # wróć do katalogu nadrzędnego
}

# === START ===
clear
echo "📱 Rootowanie Samsung Galaxy S7 (herolte) – Ubuntu Linux"
echo "⚠️  Rootowanie unieważnia gwarancję i może wyłączyć KNOX!"
read -p "Czy chcesz kontynuować? (tak/nie): " go
if [[ "$go" != "tak" ]]; then
    echo "❌ Anulowano."
    exit 0
fi

echo ""
echo "📦 Sprawdzanie plików..."
[ ! -f "$TWRP_IMG" ] && wget -O "$TWRP_IMG" "https://dl.twrp.me/herolte/twrp-3.7.0_9-0-herolte.img"
[ ! -f "$MAGISK_APK" ] && wget -O "$MAGISK_APK" "https://github.com/topjohnwu/Magisk/releases/download/v28.1/Magisk-v28.1.apk"
[ ! -f "$MAGISK_ZIP" ] && cp "$MAGISK_APK" "$MAGISK_ZIP"
echo "✅ Pliki gotowe."

echo ""
echo "🔍 Sprawdzanie Heimdalla..."
heimdall version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❗ Heimdall nie działa — kompiluję z GitHub..."
    build_heimdall
else
    echo "✅ Heimdall zainstalowany."
fi

# Zatrzymaj ModemManager jeśli działa
echo ""
echo "⛔ Wyłączanie ModemManager..."
sudo systemctl stop ModemManager.service

echo ""
echo "🔌 Sprawdzanie połączenia ADB..."
adb devices
read -p "Upewnij się, że urządzenie jest widoczne powyżej i naciśnij Enter..."

echo ""
echo "📴 Przejdź w DOWNLOAD MODE: VOL DOWN + HOME + POWER → potem VOL UP"
read -p "Naciśnij Enter, gdy telefon będzie w DOWNLOAD MODE..."

echo ""
echo "📡 Sprawdzanie Heimdall detect..."
sudo heimdall detect || { echo "❌ Urządzenie nie wykryte. Sprawdź kabel i tryb download."; exit 1; }
echo "✅ Urządzenie wykryte."

echo ""
echo "💾 Flashowanie TWRP Recovery (z pominięciem błędu rozmiaru)..."
sudo heimdall flash --RECOVERY "$TWRP_IMG" --no-reboot --skip-size-check || {
  echo "❌ Flashowanie nie powiodło się."; exit 1;
}

echo ""
echo "⚠️  Po flashu NATYCHMIAST: VOL UP + HOME + POWER → wejdź do TWRP!"
read -p "Naciśnij Enter, gdy już jesteś w TWRP..."

echo ""
echo "📲 Przesyłanie Magisk na urządzenie..."
adb push "$MAGISK_ZIP" /sdcard/

echo ""
echo "📦 W TWRP kliknij: Install → wybierz Magisk ZIP → Swipe to confirm"
read -p "Gdy zainstalujesz Magisk i uruchomisz system, naciśnij Enter..."

echo ""
echo "✅ Root zakończony. Zainstaluj Magisk App, sprawdź status ROOT: ✅"
