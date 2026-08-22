# syntax=docker/dockerfile:1.8
ARG NODE_IMAGE=node:24-alpine

FROM ${NODE_IMAGE} AS dependencies
WORKDIR /app
COPY package.json ./
RUN --mount=type=cache,target=/root/.npm npm install --ignore-scripts

FROM dependencies AS test
COPY src ./src
COPY test ./test
RUN npm run check && npm test

FROM ${NODE_IMAGE} AS production-dependencies
ENV NODE_ENV=production
WORKDIR /app
COPY package.json ./
RUN --mount=type=cache,target=/root/.npm npm install --omit=dev --ignore-scripts && npm cache clean --force

FROM ${NODE_IMAGE} AS runtime
ARG BUILD_VERSION=local
ARG BUILD_COMMIT=unknown
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.title="DevOps 100 Days App" \
      org.opencontainers.image.version="${BUILD_VERSION}" \
      org.opencontainers.image.revision="${BUILD_COMMIT}" \
      org.opencontainers.image.created="${BUILD_DATE}"
ENV NODE_ENV=production HOST=0.0.0.0 PORT=3000 APP_VERSION=${BUILD_VERSION}
RUN apk add --no-cache dumb-init
WORKDIR /app
COPY --from=production-dependencies --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node package.json ./
COPY --chown=node:node src ./src
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:3000/health/ready').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"
ENTRYPOINT ["dumb-init","--"]
CMD ["node","src/server.js"]
