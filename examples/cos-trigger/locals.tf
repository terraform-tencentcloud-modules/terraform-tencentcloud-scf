locals {
  bucket_name  = "myftb"
  trigger_name = local.bucket_name
  #bucket =
  app_id = data.tencentcloud_user_info.this.app_id
  trigger_region = "ap-guangzhou"
  cos_trigger_conf = <<EOF
      {
          "bucketUrl":"${local.bucket_name}-${local.app_id}.cos.${local.trigger_region}.myqcloud.com",
          "event":"cos:ObjectCreated:*",
          "filter":{"Prefix":"","Suffix":""}
      }
  EOF

}

data "tencentcloud_user_info" "this" {}