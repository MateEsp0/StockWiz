FROM golang:1.21-alpine AS builder

WORKDIR /app
RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY main.go . 

RUN CGO_ENABLED=0 GOOS=linux go build -o api-gateway .

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/api-gateway .

EXPOSE 8000
CMD ["./api-gateway"]
