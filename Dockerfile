# Step 1: Base image for build stage - use official node image with alpine base
FROM node:alpine as build-stage

# Step 2: Set the working directory to /app
WORKDIR /app

# Step 3: Copy in all the files needed to install dependencies
COPY package*.json ./

# Step 4: Install dependencies and clean npm cache
RUN npm install && npm cache clean --force

# Step 5: Copy in all the files from the current directory
COPY . .

# Step 6: Build the application
RUN npm run build

# Step 7: Bring in the base image for NGINX (alpine)
FROM nginx:alpine

# Step 8: Set working directory to the html folder for nginx
WORKDIR /usr/share/nginx/html

# Step 9: Copy over the build files from build-stage
COPY --from=build-stage /app/build .

# Step 10: Replace the default NGINX config with the application's version
COPY nginx.conf /etc/nginx/conf.d/default.conf

# No CMD needed, NGINX base image already provides the default command
