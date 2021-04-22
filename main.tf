module "json_dash1" {
  source = "./modules/json_nr1_dashboard"
  template = templatefile("${path.module}/resources/template.json",{
    DASHBOARD_NAME = "TF Dashboard Example",  # Example set the dashboard name. Add ${DASHBOARD_NAME} to template where applicable.
    ACCOUNT_ID = "1"                          # Example set the ID of the account for queries. Add ${ACCOUNT_ID} to template where applicable
  })
}