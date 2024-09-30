resource "kubernetes_config_map" "cloudwatch_config_map" {
  metadata {
    name = "aws-logging"
    namespace = "aws-observability"
  }

  data = {
    flb_log_cw = "true"
    "filters.conf" = <<-EOF
    [FILTER]
        Name parser
        Match *
        Key_name log
        Parser crio
    [FILTER]
        Name kubernetes
        Match kube.*
        Merge_Log On
        Keep_Log Off
        Buffer_Size 0
        Kube_Meta_Cache_TTL 300s
    EOF
    "output.conf" = <<-EOF
    [OUTPUT]
        Name cloudwatch_logs
        Match   kube.*
        region eu-central-1
        log_group_name obi-logs
        log_stream_prefix from-fluent-bit-
        log_retention_days 60
        auto_create_group true
    EOF
    "parsers.conf" = <<-EOF
    [PARSER]
        Name crio
        Format Regex
        Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>P|F) (?<log>.*)$
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L%z
    EOF
  }
}