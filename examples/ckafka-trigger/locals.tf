locals {
  ckafka_trigger_conf = <<EOF
  {
        "maxMsgNum":"1",
        "offset":"latest"
    }
  EOF
  ckafka_topic_name="ckafka-topic-tf-test-12346"
}