#!/bin/bash
// TODO put all in if`s
if [$#<4]; then
    printf "%s\n" Arguments must be: domain, port, nix-user, ip-address
    exit 1
fi

// script arguments are in order: domain, port, local-user, ip-address

CONF_SUFIX=.conf

echo "Create vhost in /var/www/"
mkdir -p /var/www/$1/html /var/www/$1/logs
echo "Create index file"
echo "<h3>"$1:$2"</h3>" > /var/www/$1/html/index.html

echo "Grant permission to: $3 on directory: /var/www/$1"
chown -R $3:www-data /var/www/$1
echo "Create sites available for: $1"
cp /home/$3/bin/scripts/assets/site-sample.conf /etc/apache2/sites-available/$1$CONF_SUFIX
echo "Create symlink to site available"
ln -s -f /etc/apache2/sites-available/$1$CONF_SUFIX /etc/apache2/sites-enabled/
echo "Add $1 to /etc/hosts"
echo $4    $1 >> /etc/hosts

echo "Edit v-host .conf file"
sed -i -e 's/HOST/'$1'/g' /etc/apache2/sites-available/$1$CONF_SUFIX
sed -i -e 's/PORT/'$2'/g' /etc/apache2/sites-available/$1$CONF_SUFIX

echo "Restart apache"
systemctl restart apache2.service


