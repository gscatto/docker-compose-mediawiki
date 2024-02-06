set -eu

main () {
    mediawiki_is_present
    mediawiki_is_installed
    make_nginx_own_mediawiki
}

mediawiki_is_present () {
    if mediawiki_is_not_present; then
        download_mediawiki
        remember_mediawiki_is_present
    fi
}

mediawiki_is_not_present () {
    ! cat /mediawiki/MEDIAWIKI_TARBALL_URL | grep -q ${MEDIAWIKI_TARBALL_URL}
}

download_mediawiki () {
    rm -rf /mediawiki/*
    wget ${MEDIAWIKI_TARBALL_URL}
    tar -xf mediawiki-*.tar.gz
    cp -r mediawiki-*/* /mediawiki
    rm -rf mediawiki-*
}

remember_mediawiki_is_present () {
    echo ${MEDIAWIKI_TARBALL_URL} > /mediawiki/MEDIAWIKI_TARBALL_URL
}

mediawiki_is_installed () {
    if mediawiki_is_not_installed; then
        install_mediawiki
    fi
}

mediawiki_is_not_installed () {
    ! [ -f /mediawiki/LocalSettings.php ]
}

install_mediawiki () {
    (
        cd /mediawiki;
        php maintenance/install.php --pass=${MEDIAWIKI_ADMIN_PASS}  --dbuser=${MEDIAWIKI_DB_USER} --dbserver=mariadb --dbpass=${MEDIAWIKI_DB_PASS} --installdbuser=root --installdbpass=${MARIADB_ROOT_PASSWORD} --server=http://${MEDIAWIKI_HOST} --scriptpath=${MEDIAWIKI_SCRIPT_PATH} ${MEDIAWIKI_WIKI_NAME} ${MEDIAWIKI_ADMIN_USER}
    )
}

make_nginx_own_mediawiki () {
    # User and group id
    #
    # Since 1.17.0, both alpine- and debian-based images variants use
    # the same user and group ids to drop the privileges for worker
    # processes.
    #
    # $ id
    # uid=101(nginx) gid=101(nginx) groups=101(nginx)
    #
    # Source: https://hub.docker.com/_/nginx
    chown -R 101:101 /mediawiki
}

main
