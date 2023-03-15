# SCF Namespace
resource "tencentcloud_scf_namespace" "this" {
  count           = var.create_namespace ? 1 : 0
  namespace       = var.namespace_name
  description     = var.namespace_description
}

# SCF Function
resource "tencentcloud_scf_function" "this" {
  count              = var.create_function ? 1 : 0
  namespace          = local.function_namespace_name
  name               = var.function_name
  description        = var.function_description
  zip_file           = var.function_zip_file
  cos_bucket_name    = var.function_cos_bucket_name == "" ? null : var.function_cos_bucket_name
  cos_object_name    = var.function_cos_object_name == "" ? null : var.function_cos_object_name
  cos_bucket_region  = var.function_cos_bucket_region == "" ? null : var.function_cos_bucket_region
  runtime            = var.function_runtime
  handler            = var.function_handler
  mem_size           = var.function_mem_size
  timeout            = var.function_timeout
  cls_logset_id      = var.function_cls_logset_id
  cls_topic_id       = var.function_cls_topic_id
  vpc_id             = var.function_vpc_id
  subnet_id          = var.function_subnet_id
  enable_public_net  = var.function_enable_public_net
  dynamic "triggers"{
     for_each = var.function_trigger_config
     content {
        name         = triggers.value.name
        trigger_desc = triggers.value.trigger_desc
        type         = triggers.value.type
        cos_region   = triggers.value.cos_region
     }
  }

}
