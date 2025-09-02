# # Install dependencies only when needed
# FROM node:16-alpine AS deps
# WORKDIR /app
# COPY package.json package-lock.json* yarn.lock* pnpm-lock.yaml* ./

# RUN \
#   if [ -f package-lock.json ]; then npm ci; \
#   elif [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
#   elif [ -f pnpm-lock.yaml ]; then npm install -g pnpm && pnpm install --frozen-lockfile; \
#   else npm install; \
#   fi

# # Build the app
# FROM node:16-alpine AS builder
# WORKDIR /app
# COPY --from=deps /app/node_modules ./node_modules
# COPY . .

# ENV NODE_OPTIONS=--openssl-legacy-provider
# RUN npm run build

# # Production image
# FROM node:16-alpine AS runner
# WORKDIR /app

# ENV NODE_ENV=production
# ENV NODE_OPTIONS=--openssl-legacy-provider
# ENV PORT=3000

# COPY --from=builder /app/public ./public
# COPY --from=builder /app/.next ./.next
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/package.json ./package.json
# COPY --from=builder /app/next.config.js ./next.config.js

# EXPOSE 3000
# CMD ["npm", "start"]





# Step 1: Use official Tomcat as base image
FROM tomcat:9.0

# Step 2: Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Step 3: Copy WAR file built by Maven
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Step 4: Expose port 8080
EXPOSE 8080

# Step 5: Start Tomcat
CMD ["catalina.sh", "run"]
