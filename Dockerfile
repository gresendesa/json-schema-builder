# Stage 1: Build
# Use Node 20, as seen in the CI/CD configuration
FROM node:20-alpine AS build

WORKDIR /app

# Install pnpm (used by the project)
RUN npm i -g pnpm

# Copy dependency files and install
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Run the build script
RUN pnpm run build

# Stage 2: Runtime
# Use Nginx to serve the static files
FROM nginx:alpine AS runtime

# Copy the static files generated from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 (Nginx default)
EXPOSE 80

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]