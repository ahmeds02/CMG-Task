FROM alpine:latest
RUN apk add --no-cache bash
WORKDIR /app
COPY cmg /app
CMD ["./temperature_analysis.sh"]
