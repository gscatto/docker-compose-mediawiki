FROM 283124aa-c663-4ec0-900d-82cab0ab7c29
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget && \
    rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
