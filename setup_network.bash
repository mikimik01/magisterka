#!/bin/bash

# Włącz przekazywanie pakietów IP tymczasowo
sudo sysctl -w net.ipv4.ip_forward=1

# Upewnij się, że przekazywanie pakietów IP jest ustawione na stałe
if ! grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
    echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

# Sprawdź i dodaj reguły iptables tylko jeśli ich nie ma

# NAT (maskarada)
if ! sudo iptables -t nat -C POSTROUTING -o enp0s31f6 -j MASQUERADE 2>/dev/null; then
    sudo iptables -t nat -A POSTROUTING -o enp0s31f6 -j MASQUERADE
    echo "Dodano regułę MASQUERADE"
fi

# Forward: z hotspotu do internetu
if ! sudo iptables -C FORWARD -i wlp2s0 -o enp0s31f6 -j ACCEPT 2>/dev/null; then
    sudo iptables -A FORWARD -i wlp2s0 -o enp0s31f6 -j ACCEPT
    echo "Dodano regułę FORWARD wlp2s0 -> enp0s31f6"
fi

# Forward: z internetu do hotspotu (dla połączeń już ustanowionych)
if ! sudo iptables -C FORWARD -i enp0s31f6 -o wlp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null; then
    sudo iptables -A FORWARD -i enp0s31f6 -o wlp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    echo "Dodano regułę FORWARD enp0s31f6 -> wlp2s0 (RELATED,ESTABLISHED)"
fi

# Zapisz reguły, jeśli zainstalowany jest netfilter-persistent
if command -v netfilter-persistent &> /dev/null; then
    sudo netfilter-persistent save
    echo "Reguły iptables zapisane na stałe."
else
    echo "⚠️  netfilter-persistent nie jest zainstalowany. Reguły znikną po restarcie."
    echo "Aby to naprawić: sudo apt install iptables-persistent"
fi

# Sprawdź, czy interfejs wlp2s0 jest aktywny
if ! ip addr show wlp2s0 | grep -q "inet "; then
    echo "Restartuję interfejs wlp2s0..."
    sudo ip link set wlp2s0 down
    sleep 1
    sudo ip link set wlp2s0 up
fi

echo "Restartuję interfejs wlp2s0..."
sudo ip link set wlp2s0 down
sleep 1
sudo ip link set wlp2s0 up