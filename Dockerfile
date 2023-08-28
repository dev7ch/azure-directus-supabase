# base node image
FROM node:18-bullseye-slim as base

# set for base and all layer that inherit from it
ENV NODE_ENV production

# Install all node_modules, including dev dependencies
FROM base as deps

WORKDIR /directus

ADD package*.json ./
RUN npm install --production=false

# Setup production node_modules
FROM base as production-deps

WORKDIR /directus

COPY --from=deps /directus/node_modules /directus/node_modules

ADD package*.json ./
RUN npm prune --production

# Finally, build the production image with minimal footprint
FROM base

ENV PORT=8055

ENV NODE_ENV="production"

WORKDIR /directus

COPY --from=production-deps /directus/node_modules /directus/node_modules

ADD . .

EXPOSE 8055

CMD ["bash", "start.sh"]
