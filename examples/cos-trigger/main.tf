# Apply for cos_role
resource "tencentcloud_cam_role" "cos_role" {
  name     = "SCF_CLS_Role"
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

  description = "cos log enable grant"
}

# Apply for ckafka_role
resource "tencentcloud_cam_policy" "cos_policy" {
  name     = "SCF_COS_POLICY_123"
  document = <<EOF
    {
        "version": "2.0",
        "statement": [
            {
              "action": [
                         "name/cos:*",
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
  role_id   = tencentcloud_cam_role.cos_role.id
  policy_id = tencentcloud_cam_policy.cos_policy.id
}

#Reference cos module
resource "tencentcloud_cos_bucket" "mycos" {
  bucket = "${local.bucket_name}-${local.app_id}"
  acl    = "private"
}


module "scf_function" {
  source = "../.."

  #namespace
  create_namespace     = true
  namespace_name       = "test-scf-namespace"
  namespace_description= ""
  #function
  create_function      = true
  function_name        = "test-cos-function"
  function_description = "test-cos-function-desc"
  function_zip_file    = "../complete/go_example/main.zip"
  function_runtime     = "Go1"
  function_handler     = "main"
  function_role        = tencentcloud_cam_role.cos_role.name
  function_trigger_config = [
      {
          name="${local.bucket_name}-${local.app_id}"
          trigger_desc=local.cos_trigger_conf
          type="cos"
          cos_region=local.trigger_region
      }
  ]
}