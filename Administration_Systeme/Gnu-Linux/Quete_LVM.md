
### 1 - Ajoute un nouveau disque à la machine et ajoute le au groupe de volume debian-vg pour au moins doubler l'espace du groupe de volume


  -     root@vbox:~# vgdisplay
        --- Volume group ---
        VG NAME               vbox-vg
        System ID             
        Format                lvm2
        Metadata Areas        1
        Metadata Sequence No  6
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                3
        Open LV               3
        Max PV                0
        Cur PV                1
        Act PV                1
        VG Size               <19.52 GiB
        PE Size               4.00 MiB
        Total PE              4997
        Alloc PE / Size       4997 / <19.52 GiB
        Free  PE / Size       0 / 0
        VG UUID               QTEYLC-vN0Q-KPTe-IQ0O-GF9I-2TEu-D7KLEQ


  -     root@vbox:~# pvcreate /dev/sdb
        Physical volume "/dev/sdb" successfully created.
        root@vbox:~# pvdisplay /dev/sdb
        "/dev/sdb" is a new physical volume of "20,00 GiB"
        --- NEW Physical volume ---
        PV NAME              /dev/sdb
        VG NAME              
        PV Size              20,00 GiB
        Allocatable          NO
        PE Size              0
        Total PE             0
        Free PE              0
        Allocated PE         0
        PV UUID              bkwKPY-xg0B-64At-c00f-x44r-b3HL-H365PV

 -      root@vbox:~# vgextend vbox-vg /dev/sdb
        Volume group "vbox-vg" successfully extended

        root@vbox:~# vgdisplay
        --- Volume group ---
        VG NAME               vbox-vg
        System ID
        Format                lvm2
        Metadata Areas        2
        Metadata Sequence No  11
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                3
        Open LV               3
        Max PV                0
        Cur PV                2
        Act PV                2
        VG Size               <39.52 GiB
        PE Size               4.00 MiB
        Total PE              10116
        Alloc PE / Size       4997 / <19.52 GiB
        Free  PE / Size       5119 / <20.00 GiB
        VG UUID               QTEYLC-vN0Q-KPTe-IQ0O-GF9I-2TEu-D7KLEQ

### 2 - La création d'un snapshot du LV home

 -      root@vbox:~# lvdisplay /dev/vbox-vg/home
        --- Logical volume ---
        LV Path                /dev/vbox-vg/home
        LV Name                home
        VG Name                vbox-vg
        LV UUID                t1L5T-B1Ey-x0SP-L1aJ-i0vF-mD19-0uPrCP
        LV Write Access        read/write
        LV Creation host, time vbox, 2025-06-02 21:27:36 +0200
        LV Status              available
        # open                 1
        LV Size                <11.76 GiB
        Current LE             3010
        Segments               1
        Allocation             inherit
        Read ahead sectors     auto
        - currently set to     256
        Block device           254:2

 -      root@vbox:~# lvcreate -L 4G -s -n home-snap /dev/vbox-vg/home
        Logical volume "home-snap" created.

 -      root@vbox:~# lvdisplay /dev/vbox-uppercase-vg/home-snap
        --- Logical volume ---
        LV Path                /dev/vbox-vg/home-snap
        LV Name                home-snap
        VG Name                vbox-vg
        LV UUID                TO4LaD-k455-hnce-80we-Bn00-qbGZ-39SY0U
        LV Write Access        read/write
        LV Creation host, time vbox, 2025-06-02 23:20:00 +0200
        LV snapshot status     active destination for home
        LV Status              available
        # open                 0
        LV Size                <11.76 GiB
        Current LE             3010
        COW-table size         4,00 GiB
        COW-table LE           1024
        Allocated to snapshot  0,01%
        Snapshot chunk size    4,00 KiB
        Segments               1
        Allocation             inherit
        Read ahead sectors     auto
        - currently set to     256
        Block device           254:5

### 3 - Monte le snapshot créé sur /home-snap

- 
        root@vbox:~# mkdir /home-snap
        root@vbox:~# mount /dev/vbox-vg/home-snap /home-snap

        root@vbox:~# df -h
        SYS. DE FICHIERS        TAILLE Utilisé Dispo Uti% MONTÉ SUR
        udev                      5,9G      0  5,9G   0% /dev
        tmpfs                     1,2G   624K  1,2G   1% /run
        /dev/mapper/vbox--vg-root 6,7G   1,7G  4,7G  27% /
        tmpfs                     5,9G      0  5,9G   0% /dev/shm
        tmpfs                     5,0M      0  5,0M   0% /run/lock
        /dev/sda1                455M   104M  327M  25% /boot
        /dev/mapper/vbox--vg-home  12G    40K  1,2G   1% /home
        tmpfs                     1,2G    40K  1,2G   1% /run/user/0
        /dev/mapper/vbox--vg-home--snap 12G    40K  1,2G   1% /home-snap
        root@vbox:~# df -h /home-snap
        SYS. DE FICHIERS        TAILLE Utilisé Dispo Uti% MONTÉ SUR
        /dev/mapper/vbox--vg-home--snap 12G    40K  1,2G   1% /home-snap

### 4 - Constate que /home-snap est bien une copie de /home

-       root@vbox:~# ls -l /home-snap
        total 20
        drwxr-xr-x 2 root  root  16384 2 juin 21:27 lost+found
        drwxr-xr-x 2 wilder wilder  4096 2 juin 21:38 wilder
        root@vbox:~# ls -l /home
        total 20
        drwxr-xr-x 2 root  root  16384 2 juin 21:27 lost+found
        drwxr-xr-x 2 wilder wilder  4096 2 juin 21:38 wilder
        root@vbox:~#


### 5- On peut alors travailler sur /home-snap et y faire des modifications. En supposant qu'on a maintenant plus besoin de la copie, démonte /home-snap

-       umount /home-snap

-       root@vbox:/dev/vbox-vg# mount
        sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
        proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
        udev on /dev type devtmpfs (rw,nosuid,relatime,size=6152k,nr_inodes=1519113,mode=755,inode64)
        devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
        tmpfs on /run type tmpfs (rw,nosuid,nodev,noexec,relatime,size=122640k,mode=755,inode64)
        /dev/mapper/vbox--vg-root on / type ext4 (rw,relatime,errors=remount-ro)
        securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
        tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
        tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=5120k,inode64)
        cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate)
        pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
        bpf on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,relatime,mode=700)
        systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=30,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=16916)
        debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
        mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime)
        tracefs on /sys/kernel/debug/tracing type tracefs (rw,nosuid,nodev,noexec,relatime)
        hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,pagesize=2M)
        configfs on /sys/kernel/config type configfs (rw,nosuid,nodev,noexec,relatime)
        fusectl on /sys/fs/fuse/connections type fusectl (rw,nosuid,nodev,noexec,relatime)
        ramfs on /run/credentials/systemd-sysctl.service type ramfs (rw,nosuid,nodev,noexec,relatime,mode=700)
        ramfs on /run/credentials/systemd-sysusers.service type ramfs (rw,nosuid,nodev,noexec,relatime,mode=700)
        ramfs on /run/credentials/systemd-tmpfiles-setup-dev.service type ramfs (rw,nosuid,nodev,noexec,relatime,mode=700)
        /dev/mapper/vbox--vg-home on /home type ext4 (rw,relatime)
        /dev/sda1 on /boot type ext4 (rw,relatime)
        ramfs on /run/credentials/systemd-tmpfiles-setup.service type ramfs (rw,nosuid,nodev,noexec,relatime,mode=700)
        binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,nosuid,nodev,noexec,relatime)
        tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,noexec,relatime,size=122636k,nr_inodes=395159,mode=700,inode64)
        /dev/mapper/vbox--vg-home--snap on /home-snap type ext4 (rw,relatime)
        root@vbox:/dev/vbox-vg#

-       root@vbox:/dev/vbox-vg# touch /home-snap/test.txt
        root@vbox:    

-       cd /home-snap
        root@vbox:/home-snap# ls
        lost+found  test.txt  wilder
        root@vbox:/home-snap#
 
### 6 - L'affichage des LV n'affiche plus le snapshot et le LV home n'est plus la source d'aucun snapshot

-       root@vbox:~# lvremove /dev/vbox-vg/home-snap
        Do you really want to remove active logical volume vbox-vg/home-snap? [y/n]: y
        Logical volume "home-snap" successfully removed.
        root@vbox:~#

-         --- Logical volume ---
        LV Path                /dev/vbox-vg/root
        LV Name                root
        VG Name                vbox-vg
        LV UUID                MGfIZy-vIrW-e1fe-4TdP-8Ut1-8Ur4-VS2xJY
        LV Write Access        read/write
        LV Creation host, time vbox, 2025-06-02 21:27:35 +0200
        LV Status              available
        # open                 1
        LV Size                <6,81 GiB
        Current LE             1743
        Segments               1
        Allocation             inherit
        Read ahead sectors     auto
        - currently set to     256
        Block device           254:0

        --- Logical volume ---
        LV Path                /dev/vbox-vg/swap_1
        LV Name                swap_1
        VG Name                vbox-vg
        LV UUID                JFQR1H-0LCc-4hEM-0GTe-7iLL-2cLA-DeaA
        LV Write Access        read/write
        LV Creation host, time vbox, 2025-06-02 21:27:35 +0200
        LV Status              available
        # open                 2
        LV Size                976,00 MiB
        Current LE             244
        Segments               1
        Allocation             inherit
        Read ahead sectors     auto
        - currently set to     256
        Block device           254:1

        --- Logical volume ---
        LV Path                /dev/vbox-vg/home
        LV Name                home
        VG Name                vbox-vg
        LV UUID                t1L5T-B1Ey-x0SP-L1aJ-i0vF-mD19-0uPrCP
        LV Write Access        read/write
        LV Creation host, time vbox, 2025-06-02 21:27:36 +0200
        LV Status              available
        # open                 1
        LV Size                <11,76 GiB
        Current LE             3010
        Segments               1
        Allocation             inherit
        Read ahead sectors     auto
        - currently set to     256
        Block device           254:2