ARG ARG_POSTGRES_IMAGE_FROM
FROM ${ARG_POSTGRES_IMAGE_FROM}

ARG POSTGRES_UID=1000
ARG MY_TZ=America/Costa_Rica

ENV CTR_USER_ID=${POSTGRES_UID}
ENV TZ=${MY_TZ}

USER 0

COPY conf/container-entrypoint.d ${CTR_ENTRYPOINT_OPT_PATH}/

RUN container-setup

RUN container-setup-postgres

USER ${CTR_USER_ID}

EXPOSE $POSTGRES_PORT

LABEL Description="This image is used for the configuration of the database layer" \
      Version="1.0"
