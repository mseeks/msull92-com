FROM rust:latest as builder
WORKDIR /usr/src/msull92-com
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
RUN apt-get update && rm -rf /var/lib/apt/lists/*
COPY --from=builder ./temlates ./templates
COPY --from=builder /usr/local/cargo/bin/msull92-com /usr/local/bin/msull92-com
EXPOSE 8000
CMD ["msull92-com"]