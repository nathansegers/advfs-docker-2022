# To prevent invalidating the cache on Package.json version updates, use this dependency file
FROM node:19.0.0-alpine AS deps

# Install the JQ package
RUN apk add jq

# Copy over the package.json which will always invalidate cache
COPY package.json /tmp

RUN jq ' { dependencies, devDependencies, scripts }' < /tmp/package.json > /tmp/deps.json

# Build stage, use this to build your app into Javascript files.
FROM node:19.0.0 as build-stage

WORKDIR /code

COPY ["package-lock.json*",  "./"]
# As this file hasn't been changed, the cache isn't invalidated
COPY --from=deps /tmp/deps.json ./package.json
# Running `npm ci` makes sure we are not upgrading the packages because they are already in the `package-lock` file.
# This is often used if you just want to install the packages without upgrading them.
RUN npm ci

COPY ["tsconfig.json", "nodemon.json", "./"]

COPY ./src /code/src

RUN npm run build

WORKDIR /code/dist

# Use alpine for the last image, as it's the smallest.
FROM node:19.0.0-alpine AS production-container

WORKDIR /code
COPY ["package-lock.json*",  "./"]
# As this file hasn't been changed, the cache isn't invalidated
COPY --from=deps /tmp/deps.json ./package.json
# Only take the packages we need
RUN npm ci --omit=dev

COPY --from=build-stage /code/dist /code/dist

WORKDIR /code/dist

# Expose the port for easier access
EXPOSE 3000