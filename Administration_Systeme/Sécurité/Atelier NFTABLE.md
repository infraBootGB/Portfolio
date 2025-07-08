Commandes NFtables


Commande	Fonction
sudo nft -f /chemin/vers/fichier.nft	Charge les règles depuis un fichier de configuration (ex. /root/nftables/myrules.nft).
sudo nft list ruleset	Affiche toutes les règles nftables actuellement appliquées.
sudo nft flush ruleset	Supprime toutes les règles nftables actives.
sudo nft add table inet <nom_table>	Crée une nouvelle table (ex. filter) pour IPv4/IPv6.
sudo nft add chain inet <nom_table> <nom_chaîne> { type filter hook input priority 0 \; }	Ajoute une chaîne (ex. input) à une table.
sudo nft add rule inet <nom_table> <nom_chaîne> <condition> <action>	Ajoute une règle à une chaîne (ex. iif lo accept).
sudo nft delete table inet <nom_table>	Supprime une table spécifique.