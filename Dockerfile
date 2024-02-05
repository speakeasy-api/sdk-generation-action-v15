## Build
FROM golang:1.21-alpine as builder

### Install Node
RUN apk add --update --no-cache nodejs npm

### Install Python
RUN apk add --update --no-cache python3 py3-pip

### Build Speakeasy Action

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

WORKDIR /

COPY --from=builder /action /action

ENTRYPOINT ["/action"]