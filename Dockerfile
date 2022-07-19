FROM golang:1.18-alpine3.16 as builder

WORKDIR /build
RUN apk add --no-cache upx

COPY go.mod .
RUN go mod download
COPY main.go .

RUN go build -ldflags "-w -s" -o app .
RUN upx --best app

FROM scratch
WORKDIR /app
COPY --from=builder /build/app .
USER 1000:1000

CMD ["/app/app"]

