# Azure Common Alert Schema Template

Support Autoclosing based on Azure Alert closure and Catch-All

## How to use - Automation

Terraform templates to deploy the OpsGenie Azure Monitor Integration are available in the `terraform` folder.

## How to use - Manual

Apply to OpsGenie Azure Monitor Integration. Ensure that the filters are configured to ensure the webhook alerts are rendered using the proper template. Follow the configured Filter settings in each template.

## Templates

The following templates are available:
  
  * Activity Log Alert
  * Metrics Alert
    * Availability Tests Alert
  * Resource Health Alert
  * Service Helath Alert
  * Log V1 Alert 
  * Log V2 Alert 
  * Budget Alert
  * Smart Alert (Azure Monitor Common Alert Schema)

## Filter Order

* Create Alert - AIP Budget
* Create Alert - Service Health
* Create Alert - Resource Health 
* Create Alert - ActivityLog 
* Create Alert - MetricAlert 
* Create Alert - AMCAS Metric
* Create Alert - AMCAS Activity Log
* Create Alert - AMCAS
* Create Alert - Catch-All

## Documentation

[OpsGenie Variables](https://support.atlassian.com/opsgenie/docs/dynamic-fields-in-opsgenie-integrations/)
