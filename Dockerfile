# Use the official lightweight Node.js 12 image.
# https://hub.docker.com/_/node
FROM node:14-buster

# Create and change to the app directory.
WORKDIR /usr/src/app

RUN apt-get update
RUN apt-get -y install graphicsmagick imagemagick ghostscript libde265-0 libde265-dev libde265-examples libheif-dev libheif-examples libheif1 tesseract-ocr tesseract-ocr-eng tesseract-ocr-tur

# Enable PDF in ImageMagic & Convert
ARG imagemagic_config=/etc/ImageMagick-6/policy.xml
RUN if [ -f $imagemagic_config ] ; then sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' $imagemagic_config ; else echo did not see file $imagemagic_config ; fi

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
# If you add a package-lock.json, speed your build by switching to 'npm ci'.
# RUN npm ci --only=production
RUN npm ci install

# Copy local code to the container image.
COPY . ./

RUN npm run test


