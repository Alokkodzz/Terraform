output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.TF_eks_cluster.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.TF_eks_cluster.name
}