#!/bin/bash

# Interfejs do monitorowania (hotspot)
INTERFACE="wlp2s0"

# Folder docelowy na zrzuty
OUTPUT_DIR="/home/miki/Magisterka/mitm_proj/pcap_logs"
mkdir -p "$OUTPUT_DIR"

# Nazwa pliku z timestampem
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="$OUTPUT_DIR/capture_$TIMESTAMP.pcap"

# Informacje dla użytkownika
echo "🔍 Start tcpdump na interfejsie: $INTERFACE"
echo "💾 Zapis do pliku: $OUTPUT_FILE"
echo "📡 Naciśnij CTRL+C, aby zakończyć przechwytywanie..."

# Uruchom tcpdump (bez filtrowania – wszystko co wchodzi i wychodzi)
# sudo tcpdump -i "$INTERFACE" -w "$OUTPUT_FILE"
sudo tcpdump -i "$INTERFACE" port 80 or port 443 -w "$OUTPUT_FILE"
# Komunikat po zakończeniu
echo "✅ Przechwytywanie zakończone."
echo "📂 Zrzut zapisany w: $OUTPUT_FILE"
