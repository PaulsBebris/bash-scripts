#!/bin/bash
#set -e
CONF_SUFIX=.conf

if [[ $# -ne 4 ]]; then
    printf "%s\n" "you must supply arguments in exact order: host, port, nix-user, ip-address"
    exit 1
fi    
printf "%s\n" "Create vhost directories in /var/www/"
mkdir -p /var/www/$1/html /var/www/$1/logs
if [[ $# -ne 4 ]]; then
    printf "%s\n" "Vhost directories created! Now Create index file"
    printf "%s" "<h3>"$1:$2"</h3>" > /var/www/$1/html/index.html
fi
if [[ $# -ne 4 ]]; then
    printf "%s\n" "Index file created! Now grant permission to: $3 on directory: /var/www/$1"
fi
chown -R $3:www-data /var/www/$1
if [[ $# -ne 4 ]]; then
    printf "%s\n" "Permissions are done! Now create sites available for: $1"
fi
cp /home/$3/bin/scripts/assets/site-sample.conf /etc/apache2/sites-available/$1$CONF_SUFIX
if [[ $# -ne 4 ]]; then
    printf "%s\n" "Sites available for: $1 created! Now create symlink in sites-available"
fi
ln -s -f /etc/apache2/sites-available/$1$CONF_SUFIX /etc/apache2/sites-enabled/
if [[ $# -ne 4 ]]; then
    printf "%s\n" "Symlink in sites-available created! Now add entry in  /etc/hosts"
fi
printf "%s\t%s" $4 $1 >> /etc/hosts

printf "Edit v-host .conf file\n"
sed -i -e 's/HOST/'$1'/g' /etc/apache2/sites-available/$1$CONF_SUFIX
sed -i -e 's/PORT/'$2'/g' /etc/apache2/sites-available/$1$CONF_SUFIX

printf "Restart apache\n"
systemctl restart apache2.service
exit 0










