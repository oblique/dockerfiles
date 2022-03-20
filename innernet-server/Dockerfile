FROM rust:bullseye as innernet-builder

RUN git clone --depth 1 -b v1.5.4 https://github.com/tonarino/innernet && \
        cd innernet && \
        export SQLITE3_NO_PKG_CONFIG=1 && \
        export SQLITE3_STATIC=1 && \
        export SQLITE3_LIB_DIR=/usr/lib/x86_64-linux-gnu && \
        cargo build -p client --release --bin innernet && \
        cargo build -p server --release --bin innernet-server

FROM debian:11

COPY --from=innernet-builder /innernet/target/release/innernet /usr/bin
COPY --from=innernet-builder /innernet/target/release/innernet-server /usr/bin

VOLUME /config
VOLUME /data

ADD init.sh /
CMD ["/init.sh"]
