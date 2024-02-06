set -eu

main () {
    mediawiki_is_present
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
    tar -xvf mediawiki-*.tar.gz
    mv mediawiki-*/* /mediawiki
    rm -r mediawiki-*
}

remember_mediawiki_is_present () {
    echo ${MEDIAWIKI_TARBALL_URL} > /mediawiki/MEDIAWIKI_TARBALL_URL
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
