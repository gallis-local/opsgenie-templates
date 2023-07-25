# OpsGenie - Azure Monitor Templates

This project contains Azure Monitor templates for OpsGenie integration. The templates are designed off of the Azure Monitor Alerts Action Group Webhook integration that has 12 different Webhook samples

## Versions

The following versions are available:
  * V1 - Azure Monitor Alerts Action Group Webhook integration using the V1 Webhook
  * Common Alert Schema - Azure Monitor Alerts Action Group Webhook integration using the Common Alert Schema

## How to use - Automation

Terraform templates to deploy the OpsGenie Azure Monitor Integration are available in the `terraform` folder.

## How to use - Manual

Apply to OpsGenie Azure Monitor Integration. Ensure that the filters are configured to ensure the webhook alerts are rendered using the proper template. Follow the configured Filter settings in each template.

NOTE: Activity Log based alerts are pending proper filtering based on OpsGenie Variables. The current templates will not fire alerts for Activity Log based alerts using the proper template till resolved.

## Common Alert Schema

Follow Folder Readme

## V1 Template Usage

Follow Folder Readme