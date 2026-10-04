output "namespace_name" {
  description = "Kubernetes namespace created by Terraform"
  value       = kubernetes_namespace.obbygate.metadata[0].name
}