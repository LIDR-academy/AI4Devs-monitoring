Chatbot usado: Cursor modo agente (modelo auto)

# Generación de los ficheros Terraform
Actúa como un DevSecOps senior experto en Datadog y AWS.

Quiero implementar un canal de monitorización de Datadog en AWS para esta aplicación. Modifica el código de Terraform en @tf/ para agregar un nuevo agente de Datadog en una instancia de EC2 que se integre con AWS y nuestra aplicación.

Aquí hay documentación al respecto:
@https://registry.terraform.io/providers/DataDog/datadog/latest/docs 
@https://docs.datadoghq.com/es/integrations/guide/aws-terraform-setup/ 

# Debugging e instrucciones para desplegar

Ahora quiero desplegar esta infraestructura usando terraform. Cómo puedo hacerlo?
Ignora el tfstate que hay, ahora mismo no tengo ninguna infra desplegada, empiezo de 0. Debería eliminar esos archivos? Si es así, hazlo.


# Notas
No he sido capaz de poder desplegar la infraestructura y el dashboard. Parece que hay algún error con las credenciales de Datadog. Por más que he investigado, no he podido averiguar el problema de permisos. El resto de la infra en AWS se despliega correctamente.

(Dejo aquí el output del terraform plan)

$ terraform plan
data.aws_iam_policy_document.datadog_aws_integration_assume_role: Reading...
data.aws_iam_policy_document.datadog_agent_policy: Reading...
data.aws_iam_policy_document.datadog_aws_integration: Reading...
data.aws_iam_policy_document.datadog_aws_integration_assume_role: Read complete after 0s [id=580750011]
data.aws_iam_policy_document.datadog_agent_policy: Read complete after 0s [id=258485304]
data.aws_iam_policy_document.datadog_aws_integration: Read complete after 0s [id=14102341]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform planned the following actions, but then encountered a problem:

  # data.aws_iam_policy_document.s3_access_policy will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "s3_access_policy" {
      + id            = (known after apply)
      + json          = (known after apply)
      + minified_json = (known after apply)

      + statement {
          + actions   = [
              + "s3:GetObject",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
            ]
        }
    }

  # aws_iam_instance_profile.ec2_instance_profile will be created
  + resource "aws_iam_instance_profile" "ec2_instance_profile" {
      + arn         = (known after apply)
      + create_date = (known after apply)
      + id          = (known after apply)
      + name        = "lti-project-ec2-instance-profile"
      + name_prefix = (known after apply)
      + path        = "/"
      + role        = "lti-project-ec2-role"
      + tags_all    = (known after apply)
      + unique_id   = (known after apply)
    }

  # aws_iam_policy.datadog_agent_policy will be created
  + resource "aws_iam_policy" "datadog_agent_policy" {
      + arn              = (known after apply)
      + attachment_count = (known after apply)
      + id               = (known after apply)
      + name             = "datadog-agent-policy"
      + name_prefix      = (known after apply)
      + path             = "/"
      + policy           = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:DescribeLogStreams",
                          + "logs:DescribeLogGroups",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                          + "ec2:DescribeVolumes",
                          + "ec2:DescribeTags",
                          + "cloudwatch:PutMetricData",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id        = (known after apply)
      + tags_all         = (known after apply)
    }

  # aws_iam_policy.datadog_aws_integration will be created
  + resource "aws_iam_policy" "datadog_aws_integration" {
      + arn              = (known after apply)
      + attachment_count = (known after apply)
      + description      = "Política para la integración de Datadog con AWS"
      + id               = (known after apply)
      + name             = "DatadogAWSIntegrationPolicy"
      + name_prefix      = (known after apply)
      + path             = "/"
      + policy           = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "xray:GetTraceSummaries",
                          + "xray:BatchGetTraces",
                          + "tag:GetTagValues",
                          + "tag:GetTagKeys",
                          + "tag:GetResources",
                          + "support:*",
                          + "sqs:ReceiveMessage",
                          + "sqs:ListQueues",
                          + "sqs:GetQueueAttributes",
                          + "sns:Publish",
                          + "sns:List*",
                          + "ses:Get*",
                          + "s3:PutBucketNotification",
                          + "s3:ListAllMyBuckets",
                          + "s3:GetBucketTagging",
                          + "s3:GetBucketNotification",
                          + "s3:GetBucketLogging",
                          + "s3:GetBucketLocation",
                          + "route53:List*",
                          + "route53:Get*",
                          + "redshift:DescribeLoggingStatus",
                          + "redshift:DescribeClusters",
                          + "rds:List*",
                          + "rds:Describe*",
                          + "logs:TestMetricFilter",
                          + "logs:PutSubscriptionFilter",
                          + "logs:DescribeSubscriptionFilters",
                          + "logs:DeleteSubscriptionFilter",
                          + "lambda:RemovePermission",
                          + "lambda:List*",
                          + "lambda:GetPolicy",
                          + "lambda:AddPermission",
                          + "kinesis:List*",
                          + "kinesis:Describe*",
                          + "health:DescribeEvents",
                          + "health:DescribeEventDetails",
                          + "health:DescribeAffectedEntities",
                          + "es:ListTags",
                          + "es:ListDomainNames",
                          + "es:DescribeElasticsearchDomains",
                          + "elasticmapreduce:List*",
                          + "elasticmapreduce:Describe*",
                          + "elasticloadbalancing:Describe*",
                          + "elasticfilesystem:Describe*",
                          + "elasticache:List*",
                          + "elasticache:Describe*",
                          + "ecs:List*",
                          + "ecs:Describe*",
                          + "ec2:Get*",
                          + "ec2:Describe*",
                          + "dynamodb:List*",
                          + "dynamodb:Describe*",
                          + "directconnect:Describe*",
                          + "codedeploy:List*",
                          + "codedeploy:BatchGet*",
                          + "cloudwatch:List*",
                          + "cloudwatch:Get*",
                          + "cloudwatch:Describe*",
                          + "cloudtrail:GetTrailStatus",
                          + "cloudtrail:DescribeTrails",
                          + "cloudfront:ListDistributions",
                          + "cloudfront:GetDistributionConfig",
                          + "budgets:ViewBudget",
                          + "autoscaling:Describe*",
                          + "apigateway:GET",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id        = (known after apply)
      + tags_all         = (known after apply)
    }

  # aws_iam_policy.s3_access_policy will be created
  + resource "aws_iam_policy" "s3_access_policy" {
      + arn              = (known after apply)
      + attachment_count = (known after apply)
      + id               = (known after apply)
      + name             = "s3-access-policy"
      + name_prefix      = (known after apply)
      + path             = "/"
      + policy           = (known after apply)
      + policy_id        = (known after apply)
      + tags_all         = (known after apply)
    }

  # aws_iam_role.datadog_aws_integration will be created
  + resource "aws_iam_role" "datadog_aws_integration" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Condition = {
                          + StringEquals = {
                              + "sts:ExternalId" = "datadog-external-id-273995959520"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS = "arn:aws:iam::412381753143:root"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "Rol para la integración de Datadog con AWS"
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "DatadogIntegrationRole"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_iam_role.ec2_role will be created
  + resource "aws_iam_role" "ec2_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ec2.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "lti-project-ec2-role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_iam_role_policy_attachment.attach_datadog_agent_policy will be created
  + resource "aws_iam_role_policy_attachment" "attach_datadog_agent_policy" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "lti-project-ec2-role"
    }

  # aws_iam_role_policy_attachment.attach_s3_access_policy will be created
  + resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "lti-project-ec2-role"
    }

  # aws_iam_role_policy_attachment.datadog_aws_integration will be created
  + resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "DatadogIntegrationRole"
    }

  # aws_iam_role_policy_attachment.datadog_aws_integration_security_audit will be created
  + resource "aws_iam_role_policy_attachment" "datadog_aws_integration_security_audit" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
      + role       = "DatadogIntegrationRole"
    }

  # aws_instance.backend will be created
  + resource "aws_instance" "backend" {
      + ami                                  = "ami-075d39ebbca89ed55"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = "lti-project-ec2-instance-profile"
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Environment" = "production"
          + "Monitoring"  = "datadog"
          + "Name"        = "lti-project-backend"
          + "Service"     = "backend"
        }
      + tags_all                             = {
          + "Environment" = "production"
          + "Monitoring"  = "datadog"
          + "Name"        = "lti-project-backend"
          + "Service"     = "backend"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (sensitive value)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # aws_instance.frontend will be created
  + resource "aws_instance" "frontend" {
      + ami                                  = "ami-075d39ebbca89ed55"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = "lti-project-ec2-instance-profile"
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.medium"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Environment" = "production"
          + "Monitoring"  = "datadog"
          + "Name"        = "lti-project-frontend"
          + "Service"     = "frontend"
        }
      + tags_all                             = {
          + "Environment" = "production"
          + "Monitoring"  = "datadog"
          + "Name"        = "lti-project-frontend"
          + "Service"     = "frontend"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (sensitive value)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # aws_s3_bucket.code_bucket will be created
  + resource "aws_s3_bucket" "code_bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "ai4devs-project-code-bucket"
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags_all                    = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule (known after apply)

      + grant (known after apply)

      + lifecycle_rule (known after apply)

      + logging (known after apply)

      + object_lock_configuration (known after apply)

      + replication_configuration (known after apply)

      + server_side_encryption_configuration (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

  # aws_s3_bucket_object.backend_zip will be created
  + resource "aws_s3_bucket_object" "backend_zip" {
      + acl                    = "private"
      + arn                    = (known after apply)
      + bucket                 = "ai4devs-project-code-bucket"
      + bucket_key_enabled     = (known after apply)
      + content_type           = (known after apply)
      + etag                   = (known after apply)
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "backend.zip"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + source                 = "./../backend.zip"
      + storage_class          = (known after apply)
      + tags_all               = (known after apply)
      + version_id             = (known after apply)
    }

  # aws_s3_bucket_object.frontend_zip will be created
  + resource "aws_s3_bucket_object" "frontend_zip" {
      + acl                    = "private"
      + arn                    = (known after apply)
      + bucket                 = "ai4devs-project-code-bucket"
      + bucket_key_enabled     = (known after apply)
      + content_type           = (known after apply)
      + etag                   = (known after apply)
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "frontend.zip"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + source                 = "./../frontend.zip"
      + storage_class          = (known after apply)
      + tags_all               = (known after apply)
      + version_id             = (known after apply)
    }

  # aws_security_group.backend_sg will be created
  + resource "aws_security_group" "backend_sg" {
      + arn                    = (known after apply)
      + description            = "Allow HTTP and SSH access"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
                # (1 unchanged attribute hidden)
            },
        ]
      + name                   = "lti-project-backend-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.frontend_sg will be created
  + resource "aws_security_group" "frontend_sg" {
      + arn                    = (known after apply)
      + description            = "Allow HTTP and SSH access"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 3000
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 3000
                # (1 unchanged attribute hidden)
            },
        ]
      + name                   = "lti-project-frontend-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # null_resource.generate_zip will be created
  + resource "null_resource" "generate_zip" {
      + id       = (known after apply)
      + triggers = {
          + "always_run" = (known after apply)
        }
    }

Plan: 18 to add, 0 to change, 0 to destroy.
╷
│ Warning: Argument is deprecated
│
│   with datadog_dashboard.ai4devs_main_dashboard,
│   on datadog_monitoring.tf line 8, in resource "datadog_dashboard" "ai4devs_main_dashboard":
│    8:   is_read_only  = false
│
│ This field is deprecated and non-functional. Use `restricted_roles` instead to define which roles are required to edit the dashboard.
│
│ (and 12 more similar warnings elsewhere)
╵
╷
│ Warning: Deprecated Resource
│
│   with aws_s3_bucket_object.backend_zip,
│   on s3.tf line 17, in resource "aws_s3_bucket_object" "backend_zip":
│   17: resource "aws_s3_bucket_object" "backend_zip" {
│
│ use the aws_s3_object resource instead
│
│ (and one more similar warning elsewhere)
╵
╷
│ Error: 403 Forbidden
│
│   with provider["registry.terraform.io/datadog/datadog"],
│   on provider.tf line 18, in provider "datadog":
│   18: provider "datadog" {
│
╵