

module "scf_function" {
  source = "../."

  #namespace
  create_namespace     = true
  namespace_name = "test-tf-namespace"
  #function
  create_function      = true
  function_name        = "test-tf-function"
  function_zip_file    = "./complete/go_example/main.zip"
  function_runtime     = "Go1"
  function_handler     = "main"
  function_trigger_config = [
          {
              name="test-timer-trigger2"
              trigger_desc="0 0 0 */1 * * *"
              type="timer"
              cos_region=""
          },
          {
              name="test-timer-trigger3"
              trigger_desc="0 0 */1 * * * *"
              type="timer"
              cos_region=""
           }
      ]
}