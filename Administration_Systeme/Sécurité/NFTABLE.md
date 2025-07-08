### Commandes NFtables


 - Charge les règles depuis un fichier de configuration (ex. /root/nftables/myrules.nft).

        sudo nft -f /chemin/vers/fichier.nft

- Affiche toutes les règles nftables actuellement appliquées.

        sudo nft list ruleset

- Supprime toutes les règles nftables actives

        sudo nft flush ruleset

- Crée une nouvelle table (ex. filter) pour IPv4/IPv6.

        sudo nft add table inet <nom_table>

- Ajoute une chaîne (ex. input) à une table.

        sudo nft add chain inet <nom_table> <nom_chaîne> { type filter hook input priority 0 \; }

- Ajoute une règle à une chaîne (ex. iif lo accept).

        sudo nft add rule inet <nom_table> <nom_chaîne> <condition> <action>

- Supprime une table spécifique.

        sudo nft delete table inet <nom_table>

- règles ct :

    - ConnTrack : ce sont des règles qui nécessite le suivi des connexions
    - Ce sont des règles de firewall de type "statefull"$


### Méthode :

# Configuration `nftables` pour un serveur de test

# Cette configuration crée un pare-feu restrictif pour un serveur de test, bloquant tout sauf le trafic explicitement autorisé.
# Chaque étape est testée pour vérifier ce qui passe et ce qui est bloqué.
# Les règles sont configurées pour être rechargées automatiquement au démarrage.

## Hypothèses et clarifications

# - Réseau interne : `192.168.1.0/24` (plage typique pour un LAN). Remplacez par votre plage si différente.
# - Serveurs DNS récursifs : `8.8.8.8` et `8.8.4.4` (Google DNS, IPv4) ; `2001:4860:4860::8888` et `2001:4860:4860::8844` (IPv6). Remplacez par vos serveurs si nécessaire (voir `/etc/resolv.conf`).
# - Interface réseau : Supposée comme `enp0s3`. Adaptez si nécessaire.
# - Ports standards :
#   - SSH : Port 22 (TCP).
#   - HTTP : Port 80 (TCP).
#   - DNS : Port 53 (UDP/TCP).
# - IPv4 et IPv6 : Configuration pour les deux protocoles, incluant ICMP/ICMPv6 pour ping et Neighbor Discovery.
# - Rechargement : Utilisation du service `nftables` pour charger les règles au démarrage.

## Étape 1 : Bloquer tout le trafic en entrée et en sortie

# Objectif : Bloquer tout le trafic entrant et sortant pour isoler la machine.

# Configuration :
flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        counter drop
    }
    chain output {
        type filter hook output priority 0; policy drop;
        counter drop
    }
}

# Explication :
# - `flush ruleset` : Supprime toutes les règles existantes.
# - `table inet filter` : Crée une table pour IPv4 et IPv6.
# - `chain input` : Filtre le trafic entrant, politique `drop` (bloquer tout).
# - `chain output` : Filtre le trafic sortant, politique `drop`.
# - `counter drop` : Compte les paquets bloqués pour le débogage.

# Test :
# - Charger les règles :
#   sudo nft -f /path/to/rules.nft
# - Vérifier :
#   sudo nft list ruleset
# - Tester :
#   - ping 8.8.8.8 : Doit échouer.
#   - curl http://example.com : Doit échouer.
#   - ssh user@machine (depuis une autre machine) : Doit échouer.
# - Résultat attendu : Aucun trafic ne passe, la machine est isolée.

## Étape 2 : Autoriser les communications locales

# Objectif : Autoriser le trafic sur l'interface `lo` (loopback) pour les communications locales (localhost).

# Configuration :
flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        iif lo accept
        counter drop
    }
    chain output {
        type filter hook output priority 0; policy drop;
        oif lo accept
        counter drop
    }
}

# Explication :
# - `iif lo accept` : Autorise le trafic entrant sur l'interface loopback.
# - `oif lo accept` : Autorise le trafic sortant vers l'interface loopback.

# Test :
# - Charger les règles :
#   sudo nft -f /path/to/rules.nft
# - Tester :
#   - ping localhost : Doit réussir.
#   - curl http://127.0.0.1 : Doit réussir si un service local est actif.
#   - ping 8.8.8.8 : Doit échouer.
#   - ssh user@machine : Doit échouer.
# - Résultat attendu : Communications locales fonctionnent, trafic externe bloqué.

## Étape 3 : Autoriser ICMP et ICMPv6 en entrée et en sortie

# Objectif : Autoriser les paquets ICMP (IPv4) et ICMPv6 (IPv6) pour le ping et les fonctionnalités essentielles d'IPv6 (Neighbor Discovery).

# Configuration :
flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        iif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        counter drop
    }
    chain output {
        type filter hook output priority 0; policy drop;
        oif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        counter drop
    }
}

# Explication :
# - `meta nfproto ipv4 icmp type { ... }` : Autorise ICMP pour ping et gestion des erreurs (IPv4).
# - `meta nfproto ipv6 icmpv6 type { ... }` : Autorise ICMPv6 pour ping et Neighbor Discovery (IPv6, RFC 4890).

# Test :
# - Charger les règles :
#   sudo nft -f /path/to/rules.nft
# - Tester :
#   - ping 8.8.8.8 : Doit réussir.
#   - ping6 2001:4860:4860::8888 : Doit réussir.
#   - curl http://example.com : Doit échouer.
#   - ssh user@machine : Doit échouer.
#   - Depuis une autre machine : ping <ip_serveur> : Doit réussir.
# - Résultat attendu : Ping fonctionne dans les deux sens, autres connexions bloquées.

## Étape 4 : Autoriser les requêtes DNS sortantes et réponses entrantes

# Objectif : Autoriser les requêtes DNS (port 53, UDP/TCP) vers `8.8.8.8`/`8.8.4.4` (IPv4) et `2001:4860:4860::8888`/`2001:4860:4860::8844` (IPv6), ainsi que leurs réponses.

# Configuration :
flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        iif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        ip saddr { 8.8.8.8, 8.8.4.4 } udp sport 53 ct state established,related accept
        ip saddr { 8.8.8.8, 8.8.4.4 } tcp sport 53 ct state established,related accept
        ip6 saddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } udp sport 53 ct state established,related accept
        ip6 saddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } tcp sport 53 ct state established,related accept
        counter drop
    }
    chain output {
        type filter hook output priority 0; policy drop;
        oif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        ip daddr { 8.8.8.8, 8.8.4.4 } udp dport 53 ct state new accept
        ip daddr { 8.8.8.8, 8.8.4.4 } tcp dport 53 ct state new accept
        ip6 daddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } udp dport 53 ct state new accept
        ip6 daddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } tcp dport 53 ct state new accept
        counter drop
    }
}

# Explication :
# - `ip daddr { 8.8.8.8, 8.8.4.4 } udp dport 53 ct state new accept` : Requêtes DNS sortantes (UDP).
# - `ip saddr { 8.8.8.8, 8.8.4.4 } udp sport 53 ct state established,related accept` : Réponses DNS entrantes.
# - Règles similaires pour TCP (DNS volumineux) et IPv6.

# Test :
# - Charger les règles :
#   sudo nft -f /path/to/rules.nft
# - Tester :
#   - nslookup google.com : Doit réussir.
#   - dig google.com : Doit réussir.
#   - nslookup google.com 1.1.1.1 : Doit échouer (car non autorisé).
#   - curl http://example.com : Doit échouer.
#   - ssh user@machine : Doit échouer.
# - Résultat attendu : Requêtes DNS vers `8.8.8.8`/`8.8.4.4` fonctionnent, autres serveurs bloqués.

## Étape 5 : Autoriser SSH entrant depuis le réseau interne

# Objectif : Autoriser les connexions SSH (port 22, TCP) depuis `192.168.1.0/24` et les réponses sortantes correspondantes.

# Configuration :
flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        iif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        ip saddr { 8.8.8.8, 8.8.4.4 } udp sport 53 ct state established,related accept
        ip saddr { 8.8.8.8, 8.8.4.4 } tcp sport 53 ct state established,related accept
        ip6 saddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } udp sport 53 ct state established,related accept
        ip6 saddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } tcp sport 53 ct state established,related accept
        ip saddr 192.168.1.0/24 tcp dport 22 ct state new accept
        counter drop
    }
    chain output {
        type filter hook output priority 0; policy drop;
        oif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        ip daddr { 8.8.8.8, 8.8.4.4 } udp dport 53 ct state new accept
        ip daddr { 8.8.8.8, 8.8.4.4 } tcp dport 53 ct state new accept
        ip6 daddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } udp dport 53 ct state new accept
        ip6 daddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } tcp dport 53 ct state new accept
        ip daddr 192.168.1.0/24 tcp sport 22 ct state established,related accept
        counter drop
    }
}

# Explication :
# - `ip saddr 192.168.1.0/24 tcp dport 22 ct state new accept` : Connexions SSH entrantes depuis le réseau interne.
# - `ip daddr 192.168.1.0/24 tcp sport 22 ct state established,related accept` : Réponses SSH sortantes.

# Test :
# - Charger les règles :
#   sudo nft -f /path/to/rules.nft
# - Tester :
#   - Depuis `192.168.1.0/24` : ssh user@<ip_serveur> : Doit réussir.
#   - Depuis hors `192.168.1.0/24` : ssh user@<ip_serveur> : Doit échouer.
#   - Vérifier : ss -tuln (port 22 en écoute).
# - Résultat attendu : SSH accessible uniquement depuis le réseau interne.

## Étape 6 : Autoriser HTTP entrant depuis n'importe où

# Objectif : Autoriser les connexions HTTP (port 80, TCP) depuis n'importe quelle adresse et les réponses sortantes.

# Configuration :
flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        iif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        ip saddr { 8.8.8.8, 8.8.4.4 } udp sport 53 ct state established,related accept
        ip saddr { 8.8.8.8, 8.8.4.4 } tcp sport 53 ct state established,related accept
        ip6 saddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } udp sport 53 ct state established,related accept
        ip6 saddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } tcp sport 53 ct state established,related accept
        ip saddr 192.168.1.0/24 tcp dport 22 ct state new accept
        tcp dport 80 ct state new accept
        counter drop
    }
    chain output {
        type filter hook output priority 0; policy drop;
        oif lo accept
        meta nfproto ipv4 icmp type { echo-request, echo-reply, destination-unreachable, time-exceeded } accept
        meta nfproto ipv6 icmpv6 type { echo-request, echo-reply, destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
        ip daddr { 8.8.8.8, 8.8.4.4 } udp dport 53 ct state new accept
        ip daddr { 8.8.8.8, 8.8.4.4 } tcp dport 53 ct state new accept
        ip6 daddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } udp dport 53 ct state new accept
        ip6 daddr { 2001:4860:4860::8888, 2001:4860:4860::8844 } tcp dport 53 ct state new accept
        ip daddr 192.168.1.0/24 tcp sport 22 ct state established,related accept
        tcp sport 80 ct state established,related accept
        counter drop
    }
}

# Explication :
# - `tcp dport 80 ct state new accept` : Connexions HTTP entrantes depuis n'importe quelle adresse.
# - `tcp sport 80 ct state established,related accept` : Réponses HTTP sortantes.

# Test :
# - Charger les règles :
#   sudo nft -f /path/to/rules.nft
# - Tester :
#   - Depuis n'importe où : curl http://<ip_serveur> : Doit réussir