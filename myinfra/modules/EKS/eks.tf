resource "aws_iam_role" "TF_cluster_role" {
  name = "TF_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "TF_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.TF_cluster_role.name
}

resource "aws_eks_cluster" "TF_eks_cluster" {
  name = "TF_eks_cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.TF_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.TF_cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "TF_nodegroup_role" {
  name = "TF_nodegroup_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "TF_AmazonEKSWorkerNodePolicy" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ])

  role       = aws_iam_role.TF_nodegroup_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "TF_nodegroup" {
  for_each = var.node_groups
  cluster_name    = aws_eks_cluster.TF_eks_cluster.name
  node_group_name = "TF_nodegroup"
  node_role_arn   = aws_iam_role.TF_nodegroup_role.arn
  subnet_ids      = var.subnet_ids

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.TF_AmazonEKSWorkerNodePolicy,
  ]
}