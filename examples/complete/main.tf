/**
* 先测试基本功能，关于日志，cos,vpc subnet. 我们后面看看
**/


#The cls Module is not supported for now
#cls logset
resource "tencentcloud_cls_logset" "logset" {
  logset_name = "bob-scf-demo"
    tags = {
      "createdBy" = "terraform"
    }
}
# cls topic
resource "tencentcloud_cls_topic" "topic" {
    topic_name           = "bob-scf-topic"
    logset_id            = tencentcloud_cls_logset.logset.id
    auto_split           = false
    max_split_partitions = 20
    partition_count      = 1
    period               = 10
    storage_type         = "hot"
    tags = {
      "test" = "test",
    }
}

#Reference function module
module "vpc" {
    source  = "terraform-tencentcloud-modules/vpc/tencentcloud"
    version = "1.1.0"

    vpc_name = "bob-simple-vpc"
    vpc_cidr = "10.0.0.0/16"

    subnet_name  = "bob-simple-vpc"
    subnet_cidrs = ["10.0.0.0/24"]

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


module "scf_function" {
  source = "../.."

  #namespace
  create_namespace     = var.create_namespace
  namespace_name       = var.namespace_name
  namespace_description= var.namespace_description
  #function
  create_function      = true
  #function_namespace  = var.function_namespace
  function_name        = var.function_name
  function_description = var.function_description
  function_zip_file    = var.function_zip_file
  function_runtime     = var.function_runtime
  function_handler     = var.function_handler
  function_cls_logset_id = tencentcloud_cls_logset.logset.id
  function_cls_topic_id  = tencentcloud_cls_topic.topic.id
  function_vpc_id      = module.vpc.vpc_id
  function_subnet_id   = module.vpc.subnet_id[0]
  function_trigger_config = var.function_trigger_config
}