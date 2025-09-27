FROM golang:alpine3.21 AS builder

WORKDIR /app
ENV CGO_ENABLED=1

RUN apk -U --no-cache add build-base git
RUN git clone https://github.com/nkanaev/yarr
RUN cd yarr && go build -tags "sqlite_foreign_keys linux" -ldflags="-s -w -X 'main.Version=2.5'" ./cmd/yarr

FROM alpine:latest
LABEL LastUpdate="2025-09-27"
RUN apk -U --no-cache upgrade && apk add --no-cache ca-certificates && update-ca-certificates

COPY --from=builder /app/yarr/yarr /bin/yarr
ENTRYPOINT ["/bin/yarr", "-addr", "0.0.0.0:7070", "-db", "/data/yarr.db"]
