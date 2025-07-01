# Dockerfile
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Copiar go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copiar código fonte
COPY . .

# Build da aplicação
RUN go build -o main .

# Imagem final
FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /root/

# Copiar binário
COPY --from=builder /app/main .

# Expor porta
EXPOSE 8080

# Executar aplicação
CMD ["./main"]