FROM debian:bookworm-slim AS stage

WORKDIR /mmbot

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates cmake make g++ git libcurl4-openssl-dev libssl-dev unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    update-ca-certificates

COPY . /mmbot

RUN ./update

FROM debian:bookworm-slim AS mmbot

WORKDIR /mmbot

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libssl3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    update-ca-certificates

COPY --from=stage /mmbot /mmbot

EXPOSE 10000

CMD bin/mmbot -p 10000 run
