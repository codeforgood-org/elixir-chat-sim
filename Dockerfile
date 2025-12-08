# Multi-stage Dockerfile for Chat Simulator
# Build stage
FROM hexpm/elixir:1.15.7-erlang-26.1.2-alpine-3.18.4 AS build

# Install build dependencies
RUN apk add --no-cache build-base git

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV
ENV MIX_ENV=prod

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy application files
COPY config ./config
COPY lib ./lib

# Compile the project
RUN mix compile

# Build the escript
RUN mix escript.build

# Runtime stage
FROM alpine:3.23.0

# Install runtime dependencies
RUN apk add --no-cache \
    ncurses-libs \
    libstdc++ \
    libgcc

# Create non-root user
RUN addgroup -g 1000 chat && \
    adduser -D -u 1000 -G chat chat

# Set working directory
WORKDIR /app

# Copy the escript from build stage
COPY --from=build --chown=chat:chat /app/chat_simulator .

# Switch to non-root user
USER chat

# Set the entrypoint
ENTRYPOINT ["./chat_simulator"]
