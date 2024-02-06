main () {
    make_mediawiki_directory
    install_mediawiki
    make_nginx_own_mediawiki
}

make_mediawiki_directory () {
    mkdir -p /var/www/${MEDIAWIKI_HOST}/html
}

install_mediawiki () {
    echo '<html><body><h1>Hello, world!</h1></body></html>' > /var/www/${MEDIAWIKI_HOST}/html/index.html
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
    chown -R 101:101 /var/www/${MEDIAWIKI_HOST}/html
}

main
