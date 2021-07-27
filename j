
#!/bin/bash
group=`awk -F, '{print $2}' users.csv `
groups=`echo $group | sed -e 's/\s\+/,/g'`
while IFS=, read -r username group shell homedir status; do
        groupadd  $group
        password=`date +%s | sha256sum | base64 | head -c 32` 

        useradd ${username}  -m -d /home/${username} -s ${shell} -g ${group} -p ${password}

        chmod -R 774 /home/${username} #3 ) 

        chage --lastday 0 ${username} 
        echo -e "${username},${password}" >> cred.txt 

        usermod -aG ${groups} ${username}

        if [[ ${status} == "N" ]]
        then
                userdel -r ${username}
        else
                echo "do nothing "
        fi
done < users.csv  
