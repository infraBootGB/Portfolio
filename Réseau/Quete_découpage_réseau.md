## Réseau symétrique


Adressse IP : *172.16.10.0/24*

### - 1 - Calcul du nombre d'hotes

Nombre de bits disponibles **pour les hotes : 32-24 = 8**


Nombre d'adresses disponibles :

2^(nb de bits hôte) soit 2⁸=256 adresses

Ces 256 adresses sont réparties sur les 4 services :

soit 256/4= **64 adresses par service.**


### - 2 - Organisation du réseau






 | Pôles              | Nb de bureaux | Besoins en équipements | Nb d adresses attribuées | Nom du réseau | Adresse réseau  | Adresse de diffusion | Adresse début de plage   | Adresse fin de plage |
 | --- | --- | --- | --- | --- | --- | --- | --- | --- |
 |Pôle informatique | 	6 | 	50 | 	64 | Réseau 1 | 172.16.10.0 | 172.16.10.63 | 172.16.10.1 | 172.16.10.62 |
 |Pôle développement | 6 | 12 | 64 | Réseau 2 | 172.16.10.64 | 172.16.10.127 | 172.16.10.65 | 172.16.10.126 |
 |Pôle Administratif | 4 | 20 | 64 | Réseau 3 | 172.16.10.128 | 172.16.10.191 | 172.16.10.129 | 172.16.10.190 |
 |Pôle Technicien | 4 | 20 | 64 | Réseau 4 | 172.16.10.192 | 172.16.10.255 | 172.16.10.193 | 172.16.10.254 | 


### - 3 - Calcul des adresses réseau

- Réseau 1 :
IP réseau de départ *172.16.10.0* + 63 adresses --> *172.16.10.63* = adresse de diffusion réseau 1. Total 64 adresses.

- Réseau 2:
Adresse de diffusion réseau 1 + 1 = adresse réseau Réseau 2 soit *172.16.10.64* --> +63 adresses = *172.16.10.127* = adresse de diffusion réseau 2. Total 64 adresses.

- Réseau 3 :
Adresse de diffusion réseau 2 + 1 = adresse réseau Réseau 3 soit *172.16.10.128*  --> + 63 adresses = *172.16.10.191* = adresse de diffusion réseau 3. Total 64 adresses.

- Réseau 4 :
Adresse de diffusion réseau 3 + 1 = adresse réseau Réseau 4 soit *172.16.10.192*  --> + 63 adresses = *172.16.10.255* = adresse de diffusion réseau 4. Total 64 adresses.


### - 4 - Calcul des CIDR

Il y a 64 adresse par sous-réseau soit : 2⁶--> donc 6 bits pour les hotes :

32 bits par adresse IPv4

Donc 32 - 6 = 26 bits pour le réseau.

Donc chaque réseau à un CIDR /26

- CIDR Réseau 1 : 172.16.10.0/26

- CIDR Réseau 2 : 172.16.10.64/26

- CIDR Réseau 3 : 172.16.10.128/26

- CIDR Réseau 4 : 172.16.10.192/26









## Réseau asymétrique


### - 1 - Calcul du nombre d'hotes par service en fonction des puissances de 2 :

- Pôle informatique : besoin 50 environ + 2 adresses (réseau et diffusion) = 52 --> 2⁶ soit 64 adresses

- Pôle développement : besoin 12 environ + 2 adresses (réseau et diffusion) = 14 --> 2⁴ soit 16 adresses

- Pôle administratif : besoin 20 environ + 2 adresses (réseau et diffusion) = 22 --> 2⁵ soit 32 adresses

- Pôle technicien : besoin 20 environ + 2 adresses (réseau et diffusion) = 22 --> 2⁵ soit 32 adresses


### - 2 - Organisation du réseau


| Pôles              | Nb de bureaux | Besoins en équipements | Nb d adresses attribuées | Nom du réseau | Adresse réseau  | Adresse de diffusion | Adresse début de plage   | Adresse fin de plage |
 | --- | --- | --- | --- | --- | --- | --- | --- | --- |
 |Pôle informatique | 	6 | 	50 | 	64 | Réseau 1 | 172.16.10.0 | 172.16.10.63 | 172.16.10.1 | 172.16.10.62 |
 |Pôle développement | 6 | 12 | 16 | Réseau 2 | 172.16.10.64 | 172.16.10.79 | 172.16.10.65 | 172.16.10.78 |
 |Pôle Administratif | 4 | 20 | 32 | Réseau 3 | 172.16.10.80 | 172.16.10.111 | 172.16.10.81 | 172.16.10.110 |
 |Pôle Technicien | 4 | 20 | 32 | Réseau 4 | 172.16.10.112 | 172.16.10.143 | 172.16.10.113 | 172.16.10.142 | 



### - 3 - Calcul des CIDR


Pôle informatique : 64 adresses soit 2⁶ pour le réseau.
32 - 6 = 26--> Réseau 1 : 172.16.10.0/26

- Pôle développement :  16 adresses soit 2⁴ pour le réseau
32 - 4 = 28--> Réseau 2 : 172.16.10.64/28

- Pôle administratif : 32 adresses soit 2⁵ pour le réseau
32 - 5 = 27--> Réseau 3 : 172.16.10.80/27

- Pôle technicien : 32 adresses soit 2⁵ pour le réseau
32 - 5 = 27--> Réseau 4 : 172.16.10.112/27


























