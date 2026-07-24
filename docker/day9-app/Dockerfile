# syntax=docker/dockerfile:1.8
ARG NODE_IMAGE=node:24.18-alpine3.24
FROM ${NODE_IMAGE} AS dependency-stage
WORKDIR /app
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci
FROM dependency-stage AS test-stage
COPY src ./src
COPY test ./test
RUN npm run check && npm test
FROM ${NODE_IMAGE} AS production-dependency-stage
ENV NODE_ENV=production
WORKDIR /app
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci --omit=dev && npm cache clean --force
FROM ${NODE_IMAGE} AS runtime-stage
ARG BUILD_VERSION=local
ARG BUILD_COMMIT=unknown
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.title="Day 9 ECS Fargate App" \
      org.opencontainers.image.version="${BUILD_VERSION}" \
      org.opencontainers.image.revision="${BUILD_COMMIT}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.source="https://github.com/rajeshkumarbasani/devops-100-days"
ENV NODE_ENV=production HOST=0.0.0.0 PORT=3000 APP_VERSION=${BUILD_VERSION}
RUN apk add --no-cache dumb-init=1.2.5-r3
WORKDIR /app
COPY --from=production-dependency-stage --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node package.json ./
COPY --chown=node:node src ./src
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 CMD node -e "fetch('http://127.0.0.1:3000/health/ready').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "src/server.js"]
