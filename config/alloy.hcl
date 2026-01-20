// Receive OTLP
otelcol.receiver.otlp "default" {
  grpc {
    endpoint = "0.0.0.0:4317"
  }
  http {
    endpoint = "0.0.0.0:4318"
  }

  output {
    logs   = [otelcol.processor.batch.main.input]
    traces = [otelcol.processor.batch.main.input]
  }
}

// Batch processor
otelcol.processor.batch "main" {
  output {
    logs   = [otelcol.exporter.loki.default.input]
    traces = [otelcol.exporter.otlp.tempo.input]
  }
}

// Export traces -> Tempo (OTLP/gRPC)
otelcol.exporter.otlp "tempo" {
  client {
    endpoint = "tempo:4417"
    tls {
      insecure = true
    }
  }
}

// Export logs -> Loki
otelcol.exporter.loki "default" {
  forward_to = [loki.write.local.receiver]
}

loki.write "local" {
  endpoint {
    url = "loki:3100"
  }
}
