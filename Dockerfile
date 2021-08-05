FROM rust:latest as builder
WORKDIR /usr/src/msull92-com

# Vendor and build dependencies by using a dummy app
RUN cargo init
COPY Cargo.lock .
COPY Cargo.toml .
RUN cargo build --release

# Build our code
COPY ./src src
RUN cargo build --release && cargo install --path .
COPY ./templates templates


# Get a clean slate
FROM debian:stable-slim
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=8000
WORKDIR /app
RUN apt-get update && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/msull92-com/templates templates
COPY --from=builder /usr/local/cargo/bin/msull92-com /bin
EXPOSE 8000
CMD ["msull92-com"]