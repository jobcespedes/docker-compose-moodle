ARG ARG_NGINX_IMAGE_FROM=quay.io/krestomatio/nginx
FROM ${ARG_NGINX_IMAGE_FROM}

ARG NGINX_UID=1000
ARG MY_TZ=America/Costa_Rica

ENV CTR_USER_ID=${NGINX_UID}
ENV TZ=${MY_TZ}

USER 0

COPY conf/container-entrypoint.d ${CTR_ENTRYPOINT_OPT_PATH}/

RUN container-setup
RUN container-setup-nginx

USER ${CTR_USER_ID}

WORKDIR $NGINX_DOCUMENTROOT

EXPOSE $NGINX_PORT

LABEL Description="This image is used for configuring nginx for moodle" \
      Version="1.0"
