#Build Container Image

FROM alpine AS cmatrixbuilder

WORKDIR /cmatrix

RUN apk update --no-cache && \
    apk add git autoconf automake alpine-sdk ncurses-dev ncurses-static && \
    git clone https://github.com/spurin/cmatrix.git . && \
    autoreconf -i && \
    mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts && \
    ./configure LDFLAGS="-static" && \ 
    make

# cmatrix Container Image

FROM alpine

LABEL org.opencontainers.image.authors="Tor Lert" \
      org.opencontainers.image.description="Tor cmatrix container image"

RUN apk update --no-cache && \
    apk add ncurses-terminfo-base && \
    adduser -g "Thomas Aderson" -s /usr/sbin/nologin -D -H thomas

COPY --from=cmatrixbuilder /cmatrix/cmatrix /cmatrix

USER thomas
ENTRYPOINT ["./cmatrix"]
CMD ["-b"]