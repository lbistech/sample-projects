# Instance Template
resource "google_compute_instance_template" "web_server_template" {
  name_prefix  = "web-server-template-"
  machine_type = var.machine_type
  region       = var.region

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
  }

  network_interface {
    subnetwork = var.subnet_name
    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = templatefile("${path.module}/../../scripts/startup-script.sh", {
    PROJECT_ID = var.project_id
    REGION     = var.region
    DB_NAME    = var.db_name
    DB_IP      = var.db_ip
  })

  tags = ["web-server", "ssh-access"]

  service_account {
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Managed Instance Group
resource "google_compute_region_instance_group_manager" "web_server_group" {
  name   = "web-server-group"
  region = var.region

  base_instance_name = "web-server"
  # target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.web_server_template.id
  }

  named_port {
    name = "http"
    port = 8080
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.web_server_health_check.id
    initial_delay_sec = 300
  }
}

# Health Check
resource "google_compute_health_check" "web_server_health_check" {
  name = "web-server-health-check"

  timeout_sec        = 5
  check_interval_sec = 30

  http_health_check {
    port         = "8080"
    request_path = "/health"
  }
}

# Backend Service
resource "google_compute_backend_service" "web_server_backend" {
  name        = "web-server-backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_health_check.web_server_health_check.id]

  backend {
    group           = google_compute_region_instance_group_manager.web_server_group.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  depends_on = [
    google_compute_health_check.web_server_health_check,
    google_compute_region_instance_group_manager.web_server_group
  ]
}

# URL Map
resource "google_compute_url_map" "web_server_url_map" {
  name            = "web-server-url-map"
  default_service = google_compute_backend_service.web_server_backend.id
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "web_server_proxy" {
  name    = "web-server-proxy"
  url_map = google_compute_url_map.web_server_url_map.id
}

# Global Forwarding Rule (Load Balancer)
resource "google_compute_global_forwarding_rule" "web_server_forwarding_rule" {
  name       = "web-server-forwarding-rule"
  target     = google_compute_target_http_proxy.web_server_proxy.id
  port_range = "80"
}

# Autoscaler
resource "google_compute_region_autoscaler" "web_server_autoscaler" {
  name   = "web-server-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.web_server_group.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = var.instance_count
    cooldown_period = 60

    cpu_utilization {
      target = 0.7
    }
  }
}