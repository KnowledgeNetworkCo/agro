FROM node:10.16-slim as ship

ENV APP_ROOT /home/app

RUN apt-get update; \
    apt-get install -y ca-certificates; \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${APP_ROOT}

## use/enable node user
RUN chown node:node -R ${APP_ROOT}
USER node

# Turn down the verbosity to default level.
ENV NPM_CONFIG_LOGLEVEL info

# Wrapper/boot-strapper
WORKDIR ${APP_ROOT}
COPY --chown=node:node app/ ./

RUN rm -rf node_modules/ ; rm package-lock.json; npm i; npm run build; ls -lah

EXPOSE 3333

CMD ["npm", "start"]