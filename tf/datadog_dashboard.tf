# =====================================================
# Datadog Dashboard for LTI Recruiter
# =====================================================

resource "datadog_dashboard" "lti_overview" {
  title       = "LTI Recruiter - ${var.environment} - Infrastructure Overview"
  description = "Overview dashboard for the LTI Recruiter application infrastructure"
  layout_type = "ordered"

  # ==========================================
  # System Overview
  # ==========================================
  widget {
    group_definition {
      title       = "Host Overview"
      layout_type = "ordered"

      widget {
        hostmap_definition {
          title = "Host Map - CPU Usage"
          request {
            fill {
              q = "avg:system.cpu.user{env:${var.environment},project:lti-recruiter} by {host}"
            }
          }
          style {
            palette      = "green_to_orange"
            palette_flip = false
          }
          scope = ["env:${var.environment}", "project:lti-recruiter"]
        }
      }
    }
  }

  # ==========================================
  # Backend Metrics
  # ==========================================
  widget {
    group_definition {
      title       = "Backend Service"
      layout_type = "ordered"

      widget {
        timeseries_definition {
          title = "Backend - CPU Usage (%)"
          request {
            query {
              metric_query {
                name        = "cpu"
                data_source = "metrics"
                query       = "avg:system.cpu.user{service:backend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Backend - Memory Usage"
          request {
            query {
              metric_query {
                name        = "mem"
                data_source = "metrics"
                query       = "avg:system.mem.used{service:backend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Backend - Network I/O (bytes)"
          request {
            query {
              metric_query {
                name        = "net_in"
                data_source = "metrics"
                query       = "avg:system.net.bytes_rcvd{service:backend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
          request {
            query {
              metric_query {
                name        = "net_out"
                data_source = "metrics"
                query       = "avg:system.net.bytes_sent{service:backend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Backend - Disk I/O"
          request {
            query {
              metric_query {
                name        = "disk_read"
                data_source = "metrics"
                query       = "avg:system.io.r_s{service:backend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
          request {
            query {
              metric_query {
                name        = "disk_write"
                data_source = "metrics"
                query       = "avg:system.io.w_s{service:backend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
        }
      }
    }
  }

  # ==========================================
  # Frontend Metrics
  # ==========================================
  widget {
    group_definition {
      title       = "Frontend Service"
      layout_type = "ordered"

      widget {
        timeseries_definition {
          title = "Frontend - CPU Usage (%)"
          request {
            query {
              metric_query {
                name        = "cpu"
                data_source = "metrics"
                query       = "avg:system.cpu.user{service:frontend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Frontend - Memory Usage"
          request {
            query {
              metric_query {
                name        = "mem"
                data_source = "metrics"
                query       = "avg:system.mem.used{service:frontend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Frontend - Network I/O (bytes)"
          request {
            query {
              metric_query {
                name        = "net_in"
                data_source = "metrics"
                query       = "avg:system.net.bytes_rcvd{service:frontend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
          request {
            query {
              metric_query {
                name        = "net_out"
                data_source = "metrics"
                query       = "avg:system.net.bytes_sent{service:frontend,env:${var.environment}} by {host}"
              }
            }
            display_type = "line"
          }
        }
      }
    }
  }

  # ==========================================
  # Docker Container Metrics
  # ==========================================
  widget {
    group_definition {
      title       = "Docker Containers"
      layout_type = "ordered"

      widget {
        timeseries_definition {
          title = "Container CPU Usage"
          request {
            query {
              metric_query {
                name        = "docker_cpu"
                data_source = "metrics"
                query       = "avg:docker.cpu.usage{env:${var.environment}} by {container_name}"
              }
            }
            display_type = "bars"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Container Memory (RSS)"
          request {
            query {
              metric_query {
                name        = "docker_mem"
                data_source = "metrics"
                query       = "avg:docker.mem.rss{env:${var.environment}} by {container_name}"
              }
            }
            display_type = "line"
          }
        }
      }

      widget {
        timeseries_definition {
          title = "Container Network (bytes)"
          request {
            query {
              metric_query {
                name        = "docker_net_rx"
                data_source = "metrics"
                query       = "avg:docker.net.bytes_rcvd{env:${var.environment}} by {container_name}"
              }
            }
            display_type = "line"
          }
          request {
            query {
              metric_query {
                name        = "docker_net_tx"
                data_source = "metrics"
                query       = "avg:docker.net.bytes_sent{env:${var.environment}} by {container_name}"
              }
            }
            display_type = "line"
          }
        }
      }
    }
  }

  # ==========================================
  # Health Checks
  # ==========================================
  widget {
    group_definition {
      title       = "Service Health Checks"
      layout_type = "ordered"

      widget {
        check_status_definition {
          title    = "Backend Health"
          check    = "http.can_connect"
          grouping = "cluster"
          tags     = ["instance:backend_health", "env:${var.environment}"]
        }
      }

      widget {
        check_status_definition {
          title    = "Frontend Health"
          check    = "http.can_connect"
          grouping = "cluster"
          tags     = ["instance:frontend_health", "env:${var.environment}"]
        }
      }

      widget {
        check_status_definition {
          title    = "Datadog Agent"
          check    = "datadog.agent.up"
          grouping = "cluster"
          tags     = ["env:${var.environment}"]
        }
      }
    }
  }
}

output "datadog_dashboard_url" {
  description = "URL of the Datadog monitoring dashboard"
  value       = datadog_dashboard.lti_overview.url
}
