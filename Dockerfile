# Build container Image
FROM alpine as cmatrixbuilder

WORKDIR cmatrix

RUN apk update --no-cache && \
    apk add git autoconf automake alpine-sdk ncurses-dev ncurses-static && \
    git clone https://github.com/spurin/cmatrix.git . && \
    autoreconf -i && \
    mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts && \
    ./configure LDFLAGS="-static" && \
    make
# cmatrix container image 
FROM alpine

LABEL org.opencontainers.image.authors="Adnan Bhatti" \
      org.opencontainers.image.description="Container image for https://github.com/abishekvashok/cmatrix"

RUN apk update --no-cache && \
    apk add ncurses-terminfo-base && \
    adduser -g "Adnan Bhatti" -s /usr/sbin/nologin -D -H arbhatti

COPY --from=cmatrixbuilder /cmatrix/cmatrix /cmatrix

USER arbhatti 
ENTRYPOINT ["./cmatrix"]
CMD ["-M Hello from Rabab"]
