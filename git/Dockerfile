# https://git-scm.com/book/it/v2/Git-on-the-Server-Setting-Up-the-Server
FROM alpine:3.19.1
RUN apk add --update-cache git openssh tini && \
    rm -rf /var/cache/apk/* && \
    adduser -D -h /home/git git && \
    sed -i s/git:!/"git:*"/g /etc/shadow && \
    ssh-keygen -A && \
    sed -i 's/^#PasswordAuthentication.*$/PasswordAuthentication no/g'  /etc/ssh/sshd_config && \
    mkdir -p /opt/git && \
    chown -R git:git /opt/git
USER git
RUN git config --global init.defaultBranch main && \
    git config --global user.name "git" && \
    git config --global user.email "git@localhost"
USER root
ENTRYPOINT ["/sbin/tini", "--", "/usr/sbin/sshd", "-D", "-e"]
