#Reference vpc module
module "vpc" {
    source  = "terraform-tencentcloud-modules/vpc/tencentcloud"
    version = "1.1.0"

    vpc_name = "test-simple-vpc"
    vpc_cidr = "10.0.0.0/16"

    subnet_name  = "test-simple-vpc"
    subnet_cidrs = ["10.0.0.0/24"]
    availability_zones = ["ap-guangzhou-6"]
    destination_cidrs = ["1.0.1.0/24"]
    next_type         = ["EIP"]
    next_hub          = ["0"]

    tags = {
      module = "vpc"
    }

    vpc_tags = {
      test = "vpc"
    }

    subnet_tags = {
      test = "subnet"
    }
}
# Apply for ckafka_role
resource "tencentcloud_cam_role" "ckafka_role" {
  name     = "SCF_CKAFKA_ROLE_123"
  document = <<EOF
{
  "version": "2.0",
  "statement": [
    {
      "action": [
        "name/sts:AssumeRole"
      ],
      "effect": "allow",
      "principal": {
           "service": [
                     "scf.qcloud.com"
                   ]
      }
    }
  ]
}
EOF
  description = ""
}

# Apply for ckafka_role
resource "tencentcloud_cam_policy" "ckafka_policy" {
  name     = "SCF_CKAFKA_POLICY_123"
  document = <<EOF
    {
        "version": "2.0",
        "statement": [
            {
              "action": [
                         "name/ckafka:*",
                         "name/monitor:GetMonitorData"
                   ],
               "resource": ["*"],
               "effect": "allow"
            }
        ]
    }
EOF
  description = ""
}

resource "tencentcloud_cam_role_policy_attachment" "foo" {
  role_id   = tencentcloud_cam_role.ckafka_role.id
  policy_id = tencentcloud_cam_policy.ckafka_policy.id
}
data "tencentcloud_user_info" "this" {}

#reference ckafka resource
resource "tencentcloud_ckafka_instance" "ckafka" {
  disk_size           = 500
  disk_type           = "CLOUD_BASIC"
  period              = 1
  instance_name       = "ckafka-instance-tf-test"
  specifications_type = "profession"
  kafka_version       = "2.4.1"
  msg_retention_time  = 1300
  multi_zone_flag     = true
  partition           = 800
  #public_network      = 3
  renew_flag          = 0
  subnet_id           = module.vpc.subnet_id[0]
  vpc_id              = module.vpc.vpc_id
  zone_id             = 100006
  zone_ids = [
      100006,
      100007,
    ]
  config {
    auto_create_topic_enable   = true
    default_num_partitions     = 3
    default_replication_factor = 3
  }

  dynamic_retention_config {
    bottom_retention        = 0
    disk_quota_percentage   = 0
    enable                  = 1
    step_forward_percentage = 0
  }
}
#reference ckafka-topic resource
resource "tencentcloud_ckafka_topic" "ckafka-topic" {
  instance_id                    = tencentcloud_ckafka_instance.ckafka.id
  topic_name                     = local.ckafka_topic_name
  note                           = "topic note"
  replica_num                    = 2
  partition_num                  = 1
  enable_white_list              = false
  ip_white_list                  = null
  clean_up_policy                = "delete"
  sync_replica_min_num           = 1
  unclean_leader_election_enable = false
  segment                        = 3600000
  retention                      = 60000
  max_message_bytes              = 0
}

module "scf_function" {
  source = "../.."

  #namespace
  create_namespace     = true
  namespace_name       = "test-scf-namespace"
  namespace_description= ""
  #function
  create_function      = true
  function_name        = "test-function"
  function_description = "test-function-desc"
  function_zip_file    = "../complete/go_example/main.zip"
  function_runtime     = "Go1"
  function_handler     = "main"
  function_role        = tencentcloud_cam_role.ckafka_role.name
  function_vpc_id      = module.vpc.vpc_id
  function_subnet_id   = module.vpc.subnet_id[0]
  function_trigger_config = [
      {
          name="${tencentcloud_ckafka_instance.ckafka.id}-${local.ckafka_topic_name}"
          trigger_desc=local.ckafka_trigger_conf
          type="ckafka"
          cos_region=""
      }
  ]
}