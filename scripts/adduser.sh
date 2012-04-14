#!/bin/bash

SMBCONF=/etc/samba/smb.conf

date +$SMBCONF-'%F-%T' | xargs sudo cp $SMBCONF

while read line
do
        # create user
        (echo $line; echo $line) | sudo adduser --home /home/$line --shell /bin/bash $line

        # samba
        sudo echo "" >> $SMBCONF
        sudo echo "["$line"]" >> $SMBCONF
        sudo echo "     comment = "$line" Home Directory" >> $SMBCONF
        sudo echo "     path = /home/"$line >> $SMBCONF
        sudo echo "     valid users = "$line >> $SMBCONF
        sudo cat >> $SMBCONF << "EOF"
        browseable = yes
        guest ok = no
        read only = no
        writeable = yes
        create mask = 0644
EOF




        (echo $line; echo $line) | sudo smbpasswd -s -a $line

done < $1

# restart services
sudo service smbd restart
sudo service vsftpd restart

