### 3. Configuration Windows Serveur Core
<span id="Configuration Windows Server Core"></span>

Pour la machine Windows Server Core, nous avons fait un clone de la machine template Windows Server Core sur Proxmox.

#### Réseau

- Configuration IP du serveur Windows Core  

`New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "172.16.10.2" -PrefixLength 24 -DefaultGateway "172.16.10.254"`

- Paramétrage du DNS via le choix n°8 dans le menu du serveur.

Nous avons ajouté l'IP du contrôleur de domaine en DNS principla soit : 

`172.16.10.1`

En DNS secondaire nous avons indiqué la boucle locale du Windows Server Core

`127.0.0.1`

#### Intégration au domaine billu.lan 

L'ajout a été fait via le controleur de domaine installé sur l'autre serveur windows

![Ajout au domaine](Ressources/Ajout_Ajout_windows_core_au_domaine)

