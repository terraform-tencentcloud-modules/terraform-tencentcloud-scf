# Apply for cos_role
resource "tencentcloud_cam_role" "apigw_role" {
  name     = "SCF_APIGW_Role"
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
          "scf.qcloud.com",
          "apigateway.qcloud.com"
        ]
      }
    }
  ]
}
EOF

  description = "cos log enable grant"
}

# Apply for ckafka_role
resource "tencentcloud_cam_policy" "apigw_policy" {
  name     = "SCF_APIGW_POLICY_123"
  document = <<EOF
    {
        "version": "2.0",
        "statement": [
            {
              "action": [
                         "name/apigw:*",
                         "name/scf:*",
                         "name/cls:*",
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
  role_id   = tencentcloud_cam_role.apigw_role.id
  policy_id = tencentcloud_cam_policy.apigw_policy.id
}

#Reference api gateway resource
resource "tencentcloud_api_gateway_service" "service" {
  service_name  = "tf-niceservice"
  protocol      = "http&https"
  service_desc  = "TF your nice service"
  net_type      = ["INNER", "OUTER"]
  ip_version    = "IPv4"
  release_limit = 500
  pre_limit     = 500
  test_limit    = 500
}


module "scf_function" {
  source = "../.."

  #namespace
  create_namespace     = false
  namespace_name       = "test-scf-namespace"
  namespace_description= ""
  #function
  create_function      = true
  function_name        = "test-apigw-function"
  function_description = "test-apigw-function-desc"
  function_zip_file    = "../complete/go_example/main.zip"
  function_runtime     = "Go1"
  function_handler     = "main"
  function_role        = tencentcloud_cam_role.apigw_role.name
  function_trigger_config = [
      {
          name="test-apigw-trigger"
          trigger_desc=local.apigw_trigger_conf
          type="apigw"
          cos_region=""
      }
  ]
}