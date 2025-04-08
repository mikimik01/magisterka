#!/bin/bash

KEY_NAME="id_ed25519"
EMAIL="mikolajkmieciak@gmail.com"  # <- Zmień na swój adres e-mail z GitHuba
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$KEY_NAME"

# 1. Tworzenie katalogu ~/.ssh jeśli nie istnieje
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# 2. Sprawdź, czy klucz już istnieje
if [ -f "$KEY_PATH" ]; then
    echo "✅ Klucz SSH już istnieje: $KEY_PATH"
else
    echo "🔑 Tworzenie nowego klucza SSH..."
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

# 3. Uruchomienie agenta SSH
echo "🚀 Uruchamianie agenta SSH..."
eval "$(ssh-agent -s)"

# 4. Dodanie klucza do agenta
ssh-add "$KEY_PATH"

# 5. Wyświetlenie klucza publicznego
echo -e "\n📋 Skopiuj poniższy klucz publiczny i wklej go na GitHubie:"
echo "🔗 https://github.com/settings/keys"
echo "--------------------------------------------------"
cat "${KEY_PATH}.pub"
echo "--------------------------------------------------"
