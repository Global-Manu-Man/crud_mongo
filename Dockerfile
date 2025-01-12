# Build stage
FROM node:22-slim AS builder
WORKDIR /app
# Copy package files
COPY package*.json ./
# Install dependencies with specific npm configuration
ENV NPM_CONFIG_CACHE=/app/.npm
RUN npm ci
# Copy source code
COPY . .

# Production stage
FROM node:20-alpine AS production
WORKDIR /app

# Install curl for healthcheck
RUN apk add --no-cache curl

# Create non-root user
RUN addgroup -S nodejs && \
    adduser -S nodejs -G nodejs && \
    chown -R nodejs:nodejs /app

# Copy files from builder
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/src ./src

# Switch to non-root user
USER nodejs

# Set environment variable
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000
CMD ["npm", "start"]
