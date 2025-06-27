# Stage 1: The build stage
FROM golang:1.23-bookworm AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod, go.sum, and the vendor directory first.
COPY go.mod go.sum ./

RUN go mod tidy

RUN go mod vendor

RUN go mod verify

# Copy the rest of your application's source code.
COPY . .

# Build the application using the vendored modules.
RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -v -o /app/main .

# --- Stage 2: The final/production stage ---
FROM ubuntu:latest
WORKDIR /app
COPY --from=builder /app/main .

EXPOSE 8080

# The command to run the application. Your Go app will then use os.Getenv("PORT"), etc.
ENTRYPOINT ["/app/main"]
