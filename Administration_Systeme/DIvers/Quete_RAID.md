#### 1 RAID 1 Fonctionnel

        wilder@wilder-VBox:~$ cat /proc/mdstat
        Personalities : [raid1] [linear] [raid0] [raid6] [raid5] [raid4] [raid10] 
        md127 : active raid1 sdd1[2] sdb1[0]
            5236736 blocks super 1.2 [2/2] [UU]
        
        wilder@wilder-VBox:~$ sudo mdadm --detail /dev/md127
        /dev/md127:
                Version : 1.2
            Creation Time : Wed May 28 11:03:27 2025
                Raid Level : raid1
                Array Size : 5236736 (4.99 GiB 5.36 GB)
            Used Dev Size : 5236736 (4.99 GiB 5.36 GB)
            Raid Devices : 2
            Total Devices : 2
            Persistence : Superblock is persistent

            Update Time : Thu Jun  5 21:10:04 2025
                    State : clean 
            Active Devices : 2
        Working Devices : 2
            Failed Devices : 0
            Spare Devices : 0

        Consistency Policy : resync

                    Name : wilder-VBox:0  (local to host wilder-VBox)
                    UUID : 1fb75f8c:50e1ffd4:36c187c4:6ed4293d
                    Events : 39

            Number   Major   Minor   RaidDevice State
            0       8       17        0      active sync   /dev/sdb1
            2       8       49        1      active sync   /dev/sdd1

### Création d'un autre type de RAID


        172  sudo fdisk /dev/sde
        173  sudo fdisk /dev/sdf
        174  sudo fdisk /dev/sdg
        
        177  fdisk -l
      
        183  sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sde /dev/sdf /dev/sdg
        184  cat /proc/mdstat
     
        186  sudo mdadm --detail /dev/md0
       
        209  sudo mkfs.ext4 /dev/md127 -L DataRAID5
        213  sudo mkdir /home/wilder/DataRAID5
        215  sudo mount /dev/md127 /home/wilder/DataRAID5/

        230  sudo mdadm --detail /dev/md127
        231  sudo update-initramfs -u
        232  sudo reboot
        233  lsblk
       
        243  sudo chmod 777 DataRAID5 ;)
        244  history
        wilder@wilder-VBox:~$ 
