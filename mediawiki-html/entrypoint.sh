set -eu

main () {
    make_mediawiki_directory
    install_mediawiki
    make_nginx_own_mediawiki
}

make_mediawiki_directory () {
    mkdir -p /var/www/${MEDIAWIKI_HOST}/html/w
}

install_mediawiki () {
    if ! cat /var/www/${MEDIAWIKI_HOST}/URL | grep -q ${MEDIAWIKI_TARBALL_URL}; then
        rm -rf /var/www/${MEDIAWIKI_HOST}/html/w/*
        wget ${MEDIAWIKI_TARBALL_URL}
        tar -xvf mediawiki-*.tar.gz
        mv mediawiki-*/* /var/www/${MEDIAWIKI_HOST}/html/w
        rm -r mediawiki-*
        echo ${MEDIAWIKI_TARBALL_URL} > /var/www/${MEDIAWIKI_HOST}/URL
    fi
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
