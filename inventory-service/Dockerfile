FROM golang:1.21-alpine AS builder

WORKDIR /app
RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux go build -o inventory-service .

FROM alpine:3.18

WORKDIR /app
COPY --from=builder /app/inventory-service .

EXPOSE 8002
CMD ["./inventory-service"]
