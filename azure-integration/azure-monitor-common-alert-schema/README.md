# V1 Template Usage


## How to use - Automation

Terraform templates to deploy the OpsGenie Azure Monitor Integration are available in the `terraform` folder.

## How to use - Manual

Apply to OpsGenie Azure Monitor Integration. Ensure that the filters are configured to ensure the webhook alerts are rendered using the proper template. Follow the configured Filter settings in each template.

NOTE: Activity Log based alerts are pending proper filtering based on OpsGenie Variables. The current templates will not fire alerts for Activity Log based alerts using the proper template till resolved.

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

Needs fix - denotes OpsGenie Filter is not working as expected for inbound alert metadata

* Create Alert - AIP Budget
* Create Alert - Service Health (needs fix)
* Create Alert - Resource Health (needs fix)
* Create Alert - ActivityLog 
* Create Alert - MetricAlert 
* Create Alert - Availability Test 
* Create Alert - AMCAS Metric
* Create Alert - AMCAS Activity Log
* Create Alert - AMCAS

## Documentation

[OpsGenie Variables](https://support.atlassian.com/opsgenie/docs/dynamic-fields-in-opsgenie-integrations/)