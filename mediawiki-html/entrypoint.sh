set -eu

main () {
    make_mediawiki_directory
    mediawiki_is_present
    make_nginx_own_mediawiki
}

make_mediawiki_directory () {
    mkdir -p /var/www/${MEDIAWIKI_HOST}/html/w
}

mediawiki_is_present () {
    if mediawiki_is_not_present; then
        download_mediawiki
        remember_mediawiki_is_present
    fi
}

mediawiki_is_not_present () {
    ! cat /var/www/${MEDIAWIKI_HOST}/URL | grep -q ${MEDIAWIKI_TARBALL_URL}
}

download_mediawiki () {
    rm -rf /var/www/${MEDIAWIKI_HOST}/html/w/*
    wget ${MEDIAWIKI_TARBALL_URL}
    tar -xvf mediawiki-*.tar.gz
    mv mediawiki-*/* /var/www/${MEDIAWIKI_HOST}/html/w
    rm -r mediawiki-*
}

remember_mediawiki_is_present () {
    echo ${MEDIAWIKI_TARBALL_URL} > /var/www/${MEDIAWIKI_HOST}/URL
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
    chown -R 101:101 /var/www/${MEDIAWIKI_HOST}/html/w
}

main
