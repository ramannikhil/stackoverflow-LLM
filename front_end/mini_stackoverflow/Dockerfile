# Step 1: Builder image
FROM node:18-slim AS builder

# Set working directory
WORKDIR /app

# Install dependencies needed for building (e.g., sharp)
RUN apt-get update && \
    apt-get install -y dumb-init python3 make g++ && \
    rm -rf /var/lib/apt/lists/*

# Copy package files and Prisma schema
COPY package*.json ./
COPY prisma ./prisma

# Install dependencies (clean & reproducible)
RUN npm ci

# Generate Prisma client
RUN npx prisma generate

# Copy the rest of the application code
COPY . .

# Build React.tsx application
RUN npm run build --verbose

# Step 2: Production runtime image
FROM node:18-slim AS runner

# Set working directory
WORKDIR /app

# Install dumb-init for better signal handling (especially for Kubernetes)
RUN apt-get update && \
    apt-get install -y dumb-init && \
    rm -rf /var/lib/apt/lists/*

# Copy only necessary files from the builder
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma

# ✅ Copy Prisma generated client (needed at runtime)
COPY --from=builder /app/node_modules/.prisma /app/node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma /app/node_modules/@prisma

# Expose port for React.tsx app
EXPOSE 3000

# Start app with dumb-init
CMD ["dumb-init", "npm", "start"]
