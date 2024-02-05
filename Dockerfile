## Build
FROM golang:1.21-alpine as builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY *.go ./
COPY internal/ ./internal/
COPY pkg/ ./pkg/

RUN go build -o /action

## Deploy
FROM golang:1.21-alpine

RUN apk update
RUN apk add git

### Install Node
RUN apk add --update --no-cache nodejs npm

### Install Python
RUN apk add python3=3.8.2-r2 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.11/main

WORKDIR /

COPY --from=builder /action /action

ENTRYPOINT ["/action"]