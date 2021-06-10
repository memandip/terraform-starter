output "nginx_external_port" {
  description = "value"
  value = docker_container.nginx.ports[0].external
}

output "nginx_external_port_ip" {
  description = "Nginx external port"
  value = docker_container.nginx.ports[0].ip
}