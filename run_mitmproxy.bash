#!/bin/bash

# Ścieżka do folderu projektu
BASE_DIR="/home/miki/Magisterka/mitm_proj"

# Katalog na logi mitmproxy
LOG_DIR="$BASE_DIR/mitm_logs"
mkdir -p "$LOG_DIR"

# Timestamp dla unikalności pliku
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Plik do zapisu sesji mitmproxy (można potem analizować lub wczytać)
FLOW_FILE="$LOG_DIR/mitm_$TIMESTAMP.flows"

# Interfejs, na którym mitmproxy będzie nasłuchiwać (hotspot IP)
LISTEN_HOST="10.42.0.1"
PORT="8080"

echo "🚦 Uruchamianie mitmproxy na $LISTEN_HOST:$PORT"
echo "💾 Logi sesji będą zapisane do: $FLOW_FILE"
echo "➡️  Naciśnij Q w terminalu mitmproxy lub CTRL+C, aby zakończyć."

# Uruchom mitmproxy i zapisuj logi do pliku
mitmproxy --listen-host "$LISTEN_HOST" --listen-port "$PORT" --save-stream-file "$FLOW_FILE"
