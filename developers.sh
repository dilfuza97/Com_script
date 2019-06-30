#!/bin/bash
developers='/tmp/developers.txt'
if [[ -f "$developers" ]]
then
    while IFS=' ' read -r developer pubkey
    do
        if grep -q $developer /etc/passwd
        then
            if [ -z "$pubkey" ]
            then
                echo "" | sudo tee /home/$developer/.ssh/authorized_keys 1>/dev/null
                echo "Developer " $developer " exists in the system, access removed"
            else
                echo "$pubkey" | sudo tee -a /home/$developer/.ssh/authorized_keys 1>/dev/null
                echo "Developer " $developer " exists in the system, access granted"
            fi
        else
            if [ ! -z "$pubkey" ]
            then
                sudo useradd  $developer
                sudo mkdir /home/$developer/.ssh
                echo "$pubkey" | sudo tee -a /home/$developer/.ssh/authorized_keys 1>/dev/null
                sudo chown -R $developer:$developer /home/$developer/.ssh
                sudo chmod -R go-rx /home/$developer/.ssh
                echo "Developer " $developer " added to the system, access granted"
            else
                echo "Developer " $developer " doesn't exist on the system, ignoring the removal of access"
            fi
        fi
    done < "$developers"
else
  echo "The file doesn't exist"
fi
