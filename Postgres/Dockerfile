FROM postgres:9.3
ARG locale
RUN localedef -i ${locale} -c -f UTF-8 -A /usr/share/locale/locale.alias ${locale}.UTF-8
ENV LANG ${locale}.utf8
