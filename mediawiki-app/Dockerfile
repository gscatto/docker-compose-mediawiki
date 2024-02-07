FROM alpine
ARG MEDIAWIKI_TARBALL_URL
ADD ${MEDIAWIKI_TARBALL_URL} mediawiki.tar.gz
RUN mkdir /mediawiki && \
    tar -xf mediawiki.tar.gz && \
    cp -r mediawiki-*/* /mediawiki && \
    chown -R 101:101 /mediawiki && \
    rm -rf mediawiki-*
ENTRYPOINT ["/bin/true"]

