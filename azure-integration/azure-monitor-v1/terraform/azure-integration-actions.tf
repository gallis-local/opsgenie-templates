# REF: https://registry.terraform.io/providers/opsgenie/opsgenie/latest/docs/resources/integration_action
resource "opsgenie_integration_action" "azure_monitor_template" {
  # Plans to be foreach
  integration_id = "${opsgenie_api_integration.test.id}"

  # Azure Monitor - Common Alert Schema
  create {
    name = "Create Alert - AMCAS"
    tags = ["azure", "amcas"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Alert: [ {{_payload.essentials.alertRule}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "azureMonitorCommonAlertSchema"
      }
    }

    description   = chomp(<<-EOT
          🔔 Common Alert Schema Alert 🔔

          🚩 Alert Details:
          - Alert ID: {{_payload.data.essentials.alertId}}
          - Alert Rule: {{_payload.data.essentials.alertRule}}
          - Severity: {{_payload.data.essentials.severity}}
          - Signal Type: {{_payload.data.essentials.signalType}}
          - Monitor Condition: {{_payload.data.essentials.monitorCondition}}
          - Monitoring Service: {{_payload.data.essentials.monitoringService}}
          - Alert Target IDs: {{_payload.data.essentials.alertTargetIDs}}
          - Configuration Items: {{_payload.data.essentials.configurationItems}}
          - Origin Alert ID: {{_payload.data.essentials.originAlertId}}
          - Fired DateTime: {{_payload.data.essentials.firedDateTime}}
          - Description: {{_payload.data.essentials.description}}

          📅 Event Timestamp: {{_payload.data.alertContext.FormattedOccurrenceTime}}
          💡 Detection Summary: {{_payload.data.alertContext.DetectionSummary}}
          🔍 Detected Value: {{_payload.data.alertContext.DetectedValue}}
          ⚖️ Normal Value: {{_payload.data.alertContext.NormalValue}}

          📊 Insights:
          - Smart Detector ID: {{_payload.data.alertContext.SmartDetectorId}}
          - Smart Detector Name: {{_payload.data.alertContext.SmartDetectorName}}
          - Analysis Timestamp: {{_payload.data.alertContext.AnalysisTimestamp}}

          🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)


          ----
          🔍 Full Payload:
          {{_payload}}
        EOT
    )
  }

  # Azure Monitor - AIP Budget Schema
  create {
    name = "Create Alert - AIP Budget"
    tags = ["azure", "budget"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "📊 Azure Budget Alert: [ {{_payload.data.BudgetName}} ] 📊"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "AIP Budget Notification"
      }
    }

    description   = chomp(<<-EOT
          📊 Azure Budget Alert 📊

          🚀 Budget Details:
          - Subscription Name: {{_payload.data.SubscriptionName}}
          - Subscription ID: {{_payload.data.SubscriptionId}}
          - Department Name: {{_payload.data.DepartmentName}}
          - Account Name: {{_payload.data.AccountName}}
          - Resource Group: {{_payload.data.ResourceGroup}}
          - Spending Amount: {{_payload.data.SpendingAmount}} {{_payload.data.Unit}}
          - Budget Start Date: {{_payload.data.BudgetStartDate}}
          - Budget: {{_payload.data.Budget}} {{_payload.data.Unit}}
          - Budget Creator: {{_payload.data.BudgetCreator}}
          - Budget Name: {{_payload.data.BudgetName}}
          - Budget Type: {{_payload.data.BudgetType}}
          - Notification Threshold Amount: {{_payload.data.NotificationThresholdAmount}} {{_payload.data.Unit}}

          🔗 [View Budget Details on Azure Portal](https://portal.azure.com)

          🔍 Full Payload:
          {{_payload}}
        EOT
    )
  }  

  # Azure Monitor - Service Health
  # TODO: fix filter
  create {
    name = "Create Alert - Service Health"
    tags = ["azure", "servicehealth"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Service Health Alert: [ {{_payload.data.context.activityLog.properties.title}} ] - Status: [ {{_payload.data.context.activityLog.status}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "Microsoft.Insights/activityLogs"
      }
    }

    description   = chomp(<<-EOT
          🔔 Service Health Alert Notification 🔔

          🚩 Alert Details:
          - Status: {{_payload.data.status}}
          - Event Source: {{_payload.data.context.activityLog.eventSource}}
          - Level: {{_payload.data.context.activityLog.level}}
          - Operation Name: {{_payload.data.context.activityLog.operationName}}
          - Operation ID: {{_payload.data.context.activityLog.operationId}}
          - Subscription ID: {{_payload.data.context.activityLog.subscriptionId}}
          - Correlation ID: {{_payload.data.context.activityLog.correlationId}}

          📅 Event Timestamp: {{_payload.data.context.activityLog.eventTimestamp}}
          🆔 Event Data ID: {{_payload.data.context.activityLog.eventDataId}}

          📢 Communication:
          {{_payload.data.context.activityLog.properties.communication}}

          📍 Incident Details:
          - Title: {{_payload.data.context.activityLog.properties.title}}
          - Service: {{_payload.data.context.activityLog.properties.service}}
          - Region: {{_payload.data.context.activityLog.properties.region}}
          - Incident Type: {{_payload.data.context.activityLog.properties.incidentType}}
          - Tracking ID: {{_payload.data.context.activityLog.properties.trackingId}}
          - Impact Start Time: {{_payload.data.context.activityLog.properties.impactStartTime}}
          - Impact Mitigation Time: {{_payload.data.context.activityLog.properties.impactMitigationTime}}
          - Impacted Services: {{_payload.data.context.activityLog.properties.impactedServices.get(0).substringBetween("ServiceName=", "}")}}
          - Impacted Regions: {{_payload.data.context.activityLog.properties.impactedServices.get(0).substringBetween("ImpactedRegions=[", "]")}}

          🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)

          ----
          🔍 Full Payload:
          {{_payload}}
        EOT
    )
  }  

  # Azure Monitor - Resource Health
  # TODO: fix filter
  create {
    name = "Create Alert - Resource Health"
    tags = ["azure", "resourcehealth"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Resource Health Alert: [ {{_payload.data.context.activityLog.operationName}} ] - RG: [ {{_payload.data.context.activityLog.resourceGroupName}} ] - Status: [ {{_payload.data.context.activityLog.status}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "Microsoft.Insights/activityLogs"
      }
    }

    description   = chomp(<<-EOT
          🔔 Azure Resource Health Alert Notification 🔔

          🚩 Alert Details:
          - Status: {{_payload.data.context.activityLog.status}}
          - Alert Rule: {{_payload.data.context.activityLog.operationName}}
          - Caller: {{_payload.data.context.activityLog.caller}}
          - Resource Group: {{_payload.data.context.activityLog.resourceGroupName}}


          📅 Alert Timestamp: {{_payload.data.context.activityLog.eventTimestamp}}
          🔎 Event Source: {{_payload.data.context.activityLog.eventSource}}
          🔧 Level: {{_payload.data.context.activityLog.level}}
          📋 Description: {{_payload.data.context.activityLog.description}}

          🏥 Service Health Details:
          Health Status: {{_payload.data.context.activityLog.properties.currentHealthStatus}}
          Previous Health Status: {{_payload.data.activityLog.context.properties.previousHealthStatus}}
          Type: {{_payload.data.context.activityLog.properties.type}}
          Cause: {{_payload.data.context.activityLog.properties.cause}}

          🔍 Activity Log Details:
          - Operation ID: {{_payload.data.context.activityLog.operationId}}
          - Correlation ID: {{_payload.data.context.activityLog.correlationId}}
          - Caller: {{_payload.data.context.activityLog.caller}}
          - Subscription ID: {{_payload.data.context.activityLog.subscriptionId}}
          - Resource ID: {{_payload.data.context.activityLog.resourceId}}
          - Resource Type: {{_payload.data.context.activityLog.resourceType}}
          - Resource Group: {{_payload.data.context.activityLog.resourceGroupName}}
          - Status: {{_payload.data.context.activityLog.status}}

          📝 Custom Properties:
          {{_payload.data.properties}}

          🌐 Resource Information:
          - Resource ID: {{_payload.data.context.activityLog.resourceId}}
          - Resource Type: {{_payload.data.context.activityLog.resourceType}}
          - Resource Group: {{_payload.data.context.activityLog.resourceGroupName}}
          - Resource Provider: {{_payload.data.context.activityLog.resourceProviderName}}

          🔗 [View Alert Details on Azure Portal]({{portal_link}})

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }  

  # Azure Monitor - Acitvity Log - Azure Common Alert Schema
  create {
    name = "Create Alert - ActivityLog"
    tags = ["azure", "activitylog"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Activity Log Alert: [ {{_payload.data.context.activityLog.operationName}} ] - RG: [ {{_payload.data.context.activityLog.resourceGroupName}} ] - Status: [ {{_payload.data.context.activityLog.status}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "azureMonitorCommonAlertSchema"
      }
      conditions {
        field          = "signalType"
        operation      = "equals"
        expected_value = "Activity Log"
      }    
      conditions {
        field          = "monitoringService"
        operation      = "equals"
        expected_value = "Activity Log - Administrative"
      }           
    }

    description   = chomp(<<-EOT
          🔔 Azure Activity Log Alert Notification 🔔

          🚩 Alert Details:
          - Status: {{_payload.data.context.activityLog.status}}
          - Alert Rule: {{_payload.data.context.activityLog.operationName}}
          - Caller: {{_payload.data.context.activityLog.caller}}
          - Resource Group: {{_payload.data.context.activityLog.resourceGroupName}}


          📅 Alert Timestamp: {{_payload.data.context.activityLog.eventTimestamp}}
          🔎 Event Source: {{_payload.data.context.activityLog.eventSource}}
          🔧 Level: {{_payload.data.context.activityLog.level}}
          📋 Description: {{_payload.data.context.activityLog.description}}

          🔍 Activity Log Details:
          - Operation ID: {{_payload.data.context.activityLog.operationId}}
          - Correlation ID: {{_payload.data.context.activityLog.correlationId}}
          - Caller: {{_payload.data.context.activityLog.caller}}
          - Subscription ID: {{_payload.data.context.activityLog.subscriptionId}}
          - Resource ID: {{_payload.data.context.activityLog.resourceId}}
          - Resource Type: {{_payload.data.context.activityLog.resourceType}}
          - Resource Group: {{_payload.data.context.activityLog.resourceGroupName}}
          - Status: {{_payload.data.context.activityLog.status}}

          📝 Custom Properties:
          {{_payload.data.properties}}

          🌐 Resource Information:
          - Resource ID: {{_payload.data.context.activityLog.resourceId}}
          - Resource Type: {{_payload.data.context.activityLog.resourceType}}
          - Resource Group: {{_payload.data.context.activityLog.resourceGroupName}}
          - Resource Provider: {{_payload.data.context.activityLog.resourceProviderName}}

          🔗 [View Alert Details on Azure Portal]({{portal_link}})

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }    

  # Azure Monitor - MetricAlert
  create {
    name = "Create Alert - MetricAlert"
    tags = ["azure", "metric"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨Azure Metric Alert: [  {{_payload.data.context.name}} ] - RG: [ {{resource_group_name}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "AzureMonitorMetricAlert"
      }
      conditions {
        field          = "status"
        operation      = "equals"
        expected_value = "Activated"
      }      
    }

    description   = chomp(<<-EOT
          🔔 Azure Monitor Metric Alert Notification 🔔

          🚩 Alert Details:
          - Alert Name: {{_payload.data.context.name}}
          - Description: {{_payload.data.context.description}}
          - Condition Type: {{_payload.data.context.conditionType}}
          - Severity: {{_payload.data.context.severity}}
          - Window Size: {{_payload.data.context.condition.windowSize}}

          📅 Alert Timestamp: {{_payload.data.context.timestamp}}
          🔍 Alert ID: {{_payload.data.context.id}}

          🔧 Condition Details:
          - Metric Name: {{condition_metric_name}}
          - Metric Namespace: {{condition_metric_namespace}}
          - Operator: {{condition_operator}}
          - Threshold: {{condition_threshold}}
          - Time Aggregation: {{condition_time_aggregation}}
          - Metric Value: {{condition_metric_value}}

          🌐 Resource Information:
          - Resource ID: {{_payload.data.context.resourceId}}
          - Resource Type: {{_payload.data.context.resourceType}}
          - Resource Group: {{_payload.data.context.resourceGroupName}}
          - Resource Name: {{_payload.data.context.resourceName}}

          🔗 [View Alert Details on Azure Portal]({{_payload.data.context.portalLink}})

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }    

  # Azure Monitor - Availability Test
  create {
    name = "Create Alert - AvailabilityTest"
    tags = ["azure", "availabilitytest"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Availability Test Alert: [  {{_payload.data.data.context.name}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "AzureMonitorMetricAlert"
      }    
    }

    description   = chomp(<<-EOT
          🔔 Azure Availability Test Alert 🔔

          🚩 Alert Details:
          - Alert Name: {{_payload.data.data.context.name}}
          - Description: {{_payload.data.data.context.description}}
          - Condition Type: {{_payload.data.data.context.conditionType}}
          - Severity: {{_payload.data.data.context.severity}}
          - Window Size: {{_payload.data.data.context.condition.windowSize}}

          📅 Alert Timestamp: {{_payload.data.data.context.timestamp}}
          🔍 Alert ID: {{_payload.data.data.context.id}}

          🔧 Condition Details:
          - Metric Name: {{_payload.data.data.context.condition.allOf.get(0).substringBetween("metricName=",",")}}
          - Operator: {{_payload.data.data.context.condition.allOf.get(0).substringBetween("operator=",",")}}
          - Threshold: {{_payload.data.data.context.condition.allOf.get(0).substringBetween("threshold=",",")}}
          - Time Aggregation: {{_payload.data.data.context.condition.allOf.get(0).substringBetween("timeAggregation=",",")}}
          - Metric Value: {{_payload.data.data.context.condition.allOf.get(0).substringBetween("metricValue=",",")}}
          - Web Test Name: {{_payload.data.data.context.condition.allOf.get(0).substringBetween("webTestName=","}")}}

          🌐 Resource Information:
          - Resource ID: {{_payload.data.data.context.resourceId}}
          - Resource Type: {{_payload.data.data.context.resourceType}}
          - Resource Group: {{_payload.data.data.context.resourceGroupName}}
          - Resource Name: {{_payload.data.data.context.resourceName}}

          🔗 [View Alert Details on Azure Portal]({{_payload.data.data.context.portalLink}})

          ----
          🔍 Full Payload:
          {{_payload}}
        EOT
    )
  }   

  # Azure Monitor - LogV2
  create {
    name            = "Create Alert - LogV2"
    tags            = ["azure", "logv2"]
    user            = "Azure"
    alias           = "{{id}}"
    source          = "Azure"
    custom_priority = "P{{severity.extract(/Sev([1-5])/)}}"
    message         = "🚨 Azure Log Alert: [ {{_payload.data.data.essentials.alertRule}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "Microsoft.Insights/LogAlert"
      }    
    }

    description   = chomp(<<-EOT
          🔔 Logs Alert v2 Notification 🔔

          🚩 Alert Details:
          - Alert Rule Name: {{_payload.data.data.essentials.alertRule}}
          - Description: {{_payload.data.data.essentials.description}}
          - Severity: {{_payload.data.data.essentials.severity}}
          - Monitor Condition: {{_payload.data.data.essentials.monitorCondition}}
          - Monitoring Service: {{_payload.data.data.essentials.monitoringService}}

          📅 Alert Timestamp: {{_payload.data.data.essentials.firedDateTime}}
          🔍 Alert ID: {{_payload.data.data.essentials.alertId}}

          🔧 Condition Details:
          - Condition Type: {{_payload.data.data.alertContext.conditionType}}
          - Window Size: {{_payload.data.data.alertContext.condition.windowSize}} 
          - Search Query:  {{_payload.data.data.alertContext.condition.allOf.get(0).substringBetween("searchQuery=", ",")}} 
          - Operator:  {{_payload.data.data.alertContext.condition.allOf.get(0).substringBetween("operator=", ",")}} 
          - Threshold: {{_payload.data.data.alertContext.condition.allOf.get(0).substringBetween("threshold=", ",")}} 
          - Time Aggregation: {{_payload.data.data.alertContext.condition.allOf.get(0).substringBetween("timeAggregation=", ",")}} 
          - Metric Value:  {{_payload.data.data.alertContext.condition.allOf.get(0).substringBetween("metricValue=", ",")}} 

          🌐 Resource Information:
          - Resource IDs: {{_payload.data.data.essentials.alertTargetIDs}}
          - Configuration Items: {{_payload.data.data.essentials.configurationItems}}
          - Origin Alert ID: {{_payload.data.data.essentials.originAlertId}}

          🔗 [View Alert Details on Azure Portal]
          {{portal_link}}

          ----
          🔍 Full Payload:
          {{_payload}}
        EOT
    )
  }     

  # Azure Monitor - LogV1
  # TODO: fix filter
  create {
    name = "Create Alert - LogV1"
    tags = ["azure", "logv1"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Log Alert: [ {{_payload.data.AlertRuleName}} ] 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "Microsoft.Insights/LogAlert"
      }    
    }

    description   = chomp(<<-EOT
          🔔 Log Alert v1 Notification 🔔

          🚩 Alert Details:
          - Alert Rule Name: {{_payload.data.AlertRuleName}}
          - Description: {{_payload.data.Description}}
          - Severity: {{_payload.data.Severity}}
          - Alert Type: {{_payload.data.AlertType}}

          📅 Alert Timestamp: {{_payload.data.SearchIntervalStartTimeUtc}}
          🔍 Alert ID: {{_payload.data.WorkspaceId}}

          🔧 Condition Details:
          - Search Query: {{_payload.data.SearchQuery}}
          - Alert Threshold Operator: {{_payload.data.AlertThresholdOperator}}
          - Alert Threshold Value: {{_payload.data.AlertThresholdValue}}

          🌐 Resource Information:
          - Resource ID: {{_payload.data.ResourceId}}
          - Workspace ID: {{_payload.data.WorkspaceId}}

          🔗 [View Alert Details on Azure Portal]({{_payload.data.LinkToSearchResults}})

          🔗 [View Filtered Alert Results on Azure Portal]({{_payload.data.LinkToFilteredSearchResultsUI}})

          ----
          🔍 Full Payload:
          {{_payload}}
        EOT
    )
  }    

  # Azure Monitor - Catch All
  create {
    name = "Create Alert - Catch All"
    tags = ["azure", "catchall"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "[Azure] {{name}} - {{resource_group_name}} -  {{schemaId}}"
    
    filter {
      type = "match-all"
    }

    description   = chomp(<<-EOT
          Link: {{portal_link}}

          Status: {{status}}
          Severity: {{severity}}
          Name: {{name}}
          ID: {{id}}
          Timestamp: {{timestamp}}
          Rule: {{alertRule}}
          Fired: {{firedDateTime}}
          Monitor Condition: {{monitorCondition}}
          Monitor Service:  {{monitoringService}}
          Condition Time Aggregation: {{condition_time_aggregation}}
          Condition Window Size: {{condition_window_size}}
          Condition Type: {{condition_type}}
          Condition Metric Name: {{condition_metric_name}}
          Condition Metric Namespace: {{condition_metric_namespace}}
          Condition Metric Unit: {{condition_metric_unit}}
          Condition Metric Value: {{condition_metric_value}} 
          Condition Threshold: {{condition_threshold}} 
          Condition Operator: {{condition_operator}} 
          Condition: 
          {{condition_metric_value}} {{condition_metric_unit}} {{condition_operator}} {{condition_threshold}} {{condition_metric_unit}} 

          Subscription: {{subscription_id}}
          Resource Group: {{resource_group_name}}
          Region: {{resource_region}}
          Resource Name : {{resource_name}}
          Resource ID: {{resource_id}}
          Resource Type: {{resource_type}}
          Target: {{alertTargetIDs}}
          Dimensions: {{dimensions}}
          Dimensions List:  {{dimensionList}}

          Alert Context Version: {{alertContextVersion}}
          Version: {{version}}
          Essentials Version: {{essentialsVersion}}
          Schema ID: {{schemaId}}
          Signal Type: {{signalType}}
          Alert Target ID: {{alertTargetIDs}}
          Origin Alert ID: {{originAlertId}}

          Properties: {{properties}}


          Description: 
          {{description}}

          ----
          SERVICE HEALTH-BASED ALERTS
          Health Status: {{_payload.data.context.activityLog.properties.currentHealthStatus}}
          Previous Health Status: {{_payload.data.activityLog.context.properties.previousHealthStatus}}
          Type: {{_payload.data.context.activityLog.properties.type}}
          Cause: {{_payload.data.context.activityLog.properties.cause}}


          ---
          FULL PAYLOAD:
          {{_payload}}
        EOT
    )
  }     

  # Close Notifications
  close {
    name = "Close"
    filter {
      type = "match-any-condition"
      conditions {
        field          = "status"
        operation      = "equals"
        expected_value = "Resolved"
      }
      conditions {
        field          = "monitorCondition"
        operation      = "equals"
        expected_value = "Resolved"
      }
    }
  }


}