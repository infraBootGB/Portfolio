## Modifier son shell

1) INstallation de EZA

- Ajouter le dépôt et installer eza
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.amd64.repo | sudo tee /etc/apt/keyrings/gierens.asc
        sudo chmod 644 /etc/apt/keyrings/gierens.asc
        sudo sh -c 'echo "deb [signed-by=/etc/apt/keyrings/gierens.asc] http://deb.gierens.de stable main" > /etc/apt/sources.list.d/eza.list'
        sudo apt update
        sudo apt install -y eza

- Installation des polices d'icônes

        sudo apt install fonts-font-awesome -y

- CONFIGURATION DES ALIAS
    Editer le fichier bash.rc

        # Commentez les anciens alias ls
        # alias ll='ls -alF'
        # alias la='ls -A'
        # alias l='ls -CF'

        # Ajoutez les nouveaux alias eza
        alias l='eza --icons --color=always --group-directories-first'
        alias ll='eza -alF --icons --color=always --group-directories-first'
        alias la='eza -a --icons --color=always --group-directories-first'
        alias l.='eza -a | egrep "^\."'
        alias lt='eza --tree --icons --color=always'

    Recharger la configuration :

        source ~/.bashrc

- modifier le prompt

    faire une copie de sauvagard

        cp ~/.bashrc ~/.bashrcSave

    modifier laligne ps1

        # Commentez la ligne originale
        # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

        # Ajoutez votre nouvelle ligne de prompt (exemple avec un emoji)
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\](\[\033[01;34m\]\u💀️\h\[\033[01;32m\])-[\[\033[01;37m\]\w\[\033[01;32m\]]\[\033[01;34m\]\$ '