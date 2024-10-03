data "aws_subnet" "selected" {
  availability_zone = "eu-central-1a"
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ssm_access" {
  name        = "SSMAccessPolicy"
  path        = "/"
  description = "Allow access through SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ],
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "ssm-showcase"
  }
}

resource "aws_iam_role" "instance" {
  name                = "ssm-showcase"
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.ssm_access.arn]
  tags = {
    Name = "ssm-showcase"
  }
}

resource "aws_iam_instance_profile" "instance" {
  name = "ssm-showcase"
  role = aws_iam_role.instance.name
  tags = {
    Name = "ssm-showcase"
  }
}

resource "aws_key_pair" "instance" {
  key_name   = "ssm-showcase"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0gR5gW8HNGrBY9dA0AGzFpyrSKA1ld1oqOtZ29Rlq7rAotEh13qNdFpJyIMJ1mXwZXPZLimPzBwlkUS7GQh6d0rQsClJhl4syEyn6OCz3WWT99bdFXciZUK3NPTkDoL895EGYmwpWwq/ZUfLmgEcl1f7bO7qEJ54RxAEL+LbLHBma6fDu95kfc1W+iJv1Cv0bQ2JjT9UBMDqGbLFmzmqKE4qei4r9718VtDnL71No6cNoCZJl07qv2IWMtwrTvd3Y6MwXb2+p/4YmkrpfXqnqnJk4jqrvZN3pxoGvsnTqmLbh+5v+0O6K35ks3d5Qb4jsoR1ATCwx6IueL9X80Ii2rXzskBUzSfpB3mkXAbkrqXKMMGHZTdqjPDTExTXp2qQjJPpzlXD2bhOVhx3bE0obf5Aholpx47ryDLf1bxqSR9Bkp8ybk05r/VDuVViDyCPBG1gv9GglzLHuVlq+Os80kkiBhZrxNaL2EHBf+74QY9I93PQNDslwn/TGm9ocRX8= efalanga@ironhide"
  tags = {
    Name = "ssm-showcase"
  }
}

resource "aws_launch_template" "debian_ssm_agent" {
  name = "Debian_SSM_agent"
  description = "A basic Debian instance with already installed SSM manager"
  image_id = "ami-0584590e5f0e97daa" //Debian
  user_data = filebase64("debian_ssm_template_userdata.sh")

  tags = {
    Name = "ssm-showcase"
  }
}

resource "aws_instance" "showcaseInstance" {
  launch_template {
    name = aws_launch_template.debian_ssm_agent.name
  }
  subnet_id         = data.aws_subnet.selected.id
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.instance.key_name
  source_dest_check = true
  tenancy           = "default"
  root_block_device {
    volume_size = 30
    tags = {
      "Name" = "ssm-showcase"
    }
  }

  iam_instance_profile = aws_iam_instance_profile.instance.name

  tags = {
    Name = "ssm-showcase"
  }
}
