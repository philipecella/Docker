#! /bin/bash

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini

if [ "${DISABLE_MYSQL}" != "yes" ]; then

    VOLUME_HOME="/var/lib/mysql"

    if [[ ! -d $VOLUME_HOME/mysql ]]; then
        echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
        echo "=> Installing MySQL ..."
        mysql_install_db > /dev/null 2>&1
        echo "=> Done!"
        /create_mysql_admin_user.sh
    else
        echo "=> Using an existing volume of MySQL"
    fi

else
    echo "=> Using an external database"
    rm /etc/supervisor/conf.d/supervisord-mysqld.conf
fi


exec supervisord -n