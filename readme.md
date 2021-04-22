# Terraform New Relic NR1 Dashboards with JSON
Example project showing how a dashboard can be managed in terraform but configured via a json template rather than HCL. This allows the dashboard to be designed in the UI, downloaded via the "Copy JSON to Clipboard" and then used as an input template to terraform, thus reducing the toil of maintaining widgets with HCL.

Ensure that the new relic license key is set in the env var `NEWRELIC_API_KEY`. The account ID can also be set in the env var `NEW_RELIC_ACCOUNT_ID` but is not used by the script itself.

The source JSON can include templates in the form "${variable_name}". Simply add each token to the map as in the example. You only need to do this if you want to make the template dynamic.

Module Usage example:
```main.tf
module "json_dash1" {
  source = "./modules/json_nr1_dashboard"
  template = templatefile("${path.module}/resources/template-simple.json", 
    { 
      DASHBOARD_NAME   = "Example JSON TF Dashboard"         # Set the dashbaord name. Add ${DASHBOARD_NAME} to template where applicable.
      ACCOUNT_ID = 1                                         # Set the ID of the account for queries. Add ${ACCOUNT_ID} to template where applicable.
    }
  )
}
```

## First time installation
The module uses a nodejs script to perfroma the update. In the module directory `modues/json_nr1_dashboard` run `npm install` to install the dependencies.

## Getting a dashboard template
Existing dashboard JSON can be aquired using the "Copy JSON to clipboard" button on a dashboard. Alternatively it can be retrieved via the API. Heres a helper script for that: modules/json_nr1_dashboard/get_dash.sh

## How it works
This works by leveraging the null_resource resource type. The content of the JSON file is used as the trigger to this resource - so when it changes the resource is marked as requring an update and it uses a local provisioner to upload the JSON to New Relic via the GraphQL API.


