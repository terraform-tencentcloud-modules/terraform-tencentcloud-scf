locals {
  apigw_trigger_conf = <<EOF
  {
  	"api": {
  		"authRequired": "FALSE",
  		"requestConfig": {
  			"method": "ANY"
  		},
  		"isIntegratedResponse": "FALSE"
  	},
  	"service": {
  		"serviceId": "${tencentcloud_api_gateway_service.service.id}"
  	},
  	"release": {
  		"environmentName": "test"
  	}
  }
  EOF
}