variable "template" {
  type = string
}

# Create a dashboard that will then be replaced by the JSON version
# Must have at least two pages otherwise GUID will change on update.
resource "newrelic_one_dashboard" "tf_dash" {
  name = "Terraform Dashboard Placeholder"
  page {
    name = "Temp Page 1"
    widget_markdown {
      title = "Terraform dashboard"
      row    = 1
      column = 1
      text = "This dashboard will be replaced by terraform"
    }
  }
  page {
    name = "Temp Page 2"
    widget_markdown {
      title = "Terraform dashboard"
      row    = 1
      column = 91
      text = "This dashboard will be replaced by terraform"
    }
  }
  lifecycle {
    ignore_changes = all
  }
}

# JSON updater
resource "null_resource" "dashboard" {
  depends_on = [ newrelic_one_dashboard.tf_dash ] #indicate that we are dependnednt on the dashboard being created above
  triggers = {
    dashtemplate = var.template
  }
  provisioner "local-exec" {
    command = "${path.module}/update_dash.js ${newrelic_one_dashboard.tf_dash.id} ${base64encode(var.template)}"
  }
}
