FROM golang:1.17-alpine3.16 AS builder

WORKDIR /app
ENV CGO_ENABLED=1

RUN apk -U --no-cache add git gcc musl-dev
RUN git clone https://github.com/nkanaev/yarr
RUN cd yarr && go build -tags "sqlite_foreign_keys linux" -ldflags="-s -w -X 'main.Version=2.4-eriol'" ./cmd/yarr

FROM alpine:3.18
LABEL LastUpdate="2023-10-24"
COPY --from=builder /app/yarr/yarr /bin/yarr
RUN apk -U --no-cache upgrade
ENTRYPOINT ["/bin/yarr", "-addr", "0.0.0.0:7070", "-db", "/data/yarr.db"]
