# syntax=docker/dockerfile:1.7

ARG NODE_VERSION=24.18-alpine3.24

FROM node:${NODE_VERSION} AS dependency-stage

WORKDIR /app

COPY package.json package-lock.json ./

RUN --mount=type=cache,target=/root/.npm \
    npm ci

FROM dependency-stage AS test-stage

WORKDIR /app

COPY src ./src
COPY test ./test

RUN npm run check
RUN npm run test:ci

FROM node:${NODE_VERSION} AS production-dependency-stage

ENV NODE_ENV=production

WORKDIR /app

COPY package.json package-lock.json ./

RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev \
    && npm cache clean --force

FROM node:${NODE_VERSION} AS runtime-stage

ARG BUILD_VERSION=local
ARG BUILD_COMMIT=unknown
ARG BUILD_DATE=unknown

LABEL org.opencontainers.image.title="Day 8 DevOps Application" \
      org.opencontainers.image.description="Production Node.js application for DevOps 100 Days Day 8" \
      org.opencontainers.image.version="${BUILD_VERSION}" \
      org.opencontainers.image.revision="${BUILD_COMMIT}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.source="https://github.com/rajeshkumarbasani/devops-100-days"

ENV NODE_ENV=production \
    PORT=3000 \
    HOST=0.0.0.0 \
    APP_VERSION="${BUILD_VERSION}"

RUN apk add --no-cache dumb-init=1.2.5-r4

WORKDIR /app

COPY --from=production-dependency-stage \
    --chown=node:node /app/node_modules ./node_modules

COPY --chown=node:node package.json ./
COPY --chown=node:node src ./src

USER node

EXPOSE 3000

HEALTHCHECK \
    --interval=30s \
    --timeout=5s \
    --start-period=15s \
    --retries=3 \
    CMD node -e "fetch('http://127.0.0.1:3000/health/ready').then(r => { if (!r.ok) process.exit(1) }).catch(() => process.exit(1))"

ENTRYPOINT ["dumb-init", "--"]

CMD ["node", "src/server.js"]