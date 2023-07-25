# REF: https://registry.terraform.io/providers/opsgenie/opsgenie/latest/docs/resources/integration_action
resource "opsgenie_integration_action" "azure_monitor_template" {
  # Plans to be foreach
  integration_id = "${opsgenie_api_integration.test.id}"

  # Azure Monitor - AMCAS Budget 
  create {
    name = "Create Alert - AMCAS Budget"
    tags = ["azure", "budget"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Budget Alert 🚨"

    filter {
      type = "match-all-conditions"
      conditions {
        field          = "schemaId"
        operation      = "equals"
        expected_value = "azureMonitorCommonAlertSchema"
      }      
      conditions {
        field          = "monitoringService"
        operation      = "equals"
        expected_value = "CostAlerts"
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

  # Azure Monitor - AMCAS Service Health
  create {
    name = "Create Alert - AMCAS Service Health"
    tags = ["azure", "servicehealth"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Service Health Alert: [ {{_payload.data.essentials.alertRule}} ] 🚨"

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
        expected_value = "ServiceHealth"
      }      
    }

    description   = chomp(<<-EOT
          🔔 Azure Service Health Alert 🔔

          🚩 Alert Details:
          - Alert Rule: {{_payload.data.essentials.alertRule}}
          - Description: {{_payload.data.essentials.description}}
          - Severity: {{_payload.data.essentials.severity}}
          - Fired DateTime: {{_payload.data.essentials.firedDateTime}}

          📜 Alert Properties:
          - Title: {{_payload.data.alertContext.properties.title}}
          - Service: {{_payload.data.alertContext.properties.service}}
          - Region: {{_payload.data.alertContext.properties.region}}
          - Incident Type: {{_payload.data.alertContext.properties.incidentType}}
          - Tracking ID: {{_payload.data.alertContext.properties.trackingId}}
          - Communication: {{_payload.data.alertContext.properties.communication}}

          🔔 Impact:
          - Stage: {{_payload.data.alertContext.properties.stage}}
          - Impact Start Time: {{_payload.data.alertContext.properties.impactStartTime}}
          - Impact Mitigation Time: {{_payload.data.alertContext.properties.impactMitigationTime}}
          - Impacted Services: {{_payload.data.alertContext.properties.impactedServices}}
          - Impacted Services Table Rows: {{_payload.data.alertContext.properties.impactedServicesTableRows}}
          - Communication ID: {{_payload.data.alertContext.properties.communicationId}}
          - isHIR: {{_payload.data.alertContext.properties.isHIR}}
          - IsSynthetic: {{_payload.data.alertContext.properties.IsSynthetic}}
          - Impact Type: {{_payload.data.alertContext.properties.impactType}}
          - Version: {{_payload.data.alertContext.properties.version}}

          🌟 Alert Context:
          - Channels: {{_payload.data.alertContext.channels}}
          - Correlation ID: {{_payload.data.alertContext.correlationId}}
          - Event Source: {{_payload.data.alertContext.eventSource}}
          - Event Timestamp: {{_payload.data.alertContext.eventTimestamp}}
          - Event Data ID: {{_payload.data.alertContext.eventDataId}}
          - Level: {{_payload.data.alertContext.level}}
          - Operation Name: {{_payload.data.alertContext.operationName}}
          - Operation ID: {{_payload.data.alertContext.operationId}}

          🌐 Resource Information:
          - Signal Type: {{_payload.data.essentials.signalType}}
          - Monitor Condition: {{_payload.data.essentials.monitorCondition}}
          - Monitoring Service: {{_payload.data.essentials.monitoringService}}
          - Alert Target IDs: {{_payload.data.essentials.alertTargetIDs}}
          - Origin Alert ID: {{_payload.data.essentials.originAlertId}}


          🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }  

  # Azure Monitor - AMCAS Resource Health
  create {
    name = "Create Alert - AMCAS Resource Health"
    tags = ["azure", "resourcehealth"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Resource Health Alert: [ {{_payload.data.essentials.alertRule}} ] 🚨"

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
        expected_value = "Resource Health"
      }   
    }

    description   = chomp(<<-EOT
          🔔 Azure Resource Health Alert 🔔

          🚩 Alert Details:
          - Alert Rule: {{_payload.data.essentials.alertRule}}
          - Description: {{_payload.data.essentials.description}}
          - Severity: {{_payload.data.essentials.severity}}
          - Fired DateTime: {{_payload.data.essentials.firedDateTime}}

          📅 Alert Timestamp: {{_payload.data.alertContext.submissionTimestamp}}

          📜 Alert Properties:
          - Title: {{_payload.data.alertContext.properties.title}}
          - Current Health Status: {{_payload.data.alertContext.properties.currentHealthStatus}}
          - Previous Health Status: {{_payload.data.alertContext.properties.previousHealthStatus}}
          - Type: {{_payload.data.alertContext.properties.type}}
          - Cause: {{_payload.data.alertContext.properties.cause}}
          - Configuration Items: {{_payload.data.essentials.configurationItems}}

          🌟 Alert Context:
          - Channels: {{_payload.data.alertContext.channels}}
          - Correlation ID: {{_payload.data.alertContext.correlationId}}
          - Event Source: {{_payload.data.alertContext.eventSource}}
          - Event Timestamp: {{_payload.data.alertContext.eventTimestamp}}
          - Event Data ID: {{_payload.data.alertContext.eventDataId}}
          - Level: {{_payload.data.alertContext.level}}
          - Operation Name: {{_payload.data.alertContext.operationName}}
          - Operation ID: {{_payload.data.alertContext.operationId}}

          🌐 Resource Information:
          - Signal Type: {{_payload.data.essentials.signalType}}
          - Monitor Condition: {{_payload.data.essentials.monitorCondition}}
          - Monitoring Service: {{_payload.data.essentials.monitoringService}}
          - Alert Target IDs: {{_payload.data.essentials.alertTargetIDs}}
          - Origin Alert ID: {{_payload.data.essentials.originAlertId}}


          🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }  

  # Azure Monitor - AMCAS Activity Log 
  create {
    name = "Create Alert - AMCAS ActivityLog"
    tags = ["azure", "activitylog"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Activity Alert: [ {{_payload.data.essentials.alertRule}} ] 🚨"

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
    }

    description   = chomp(<<-EOT
          🔔 Azure Activity Log Alert 🔔

          🚩 Alert Details:
          - Alert Rule: {{_payload.data.essentials.alertRule}}
          - Description: {{_payload.data.essentials.description}}
          - Severity: {{_payload.data.essentials.severity}}
          - Fired DateTime: {{_payload.data.essentials.firedDateTime}}
          - Signal Type: {{_payload.data.essentials.signalType}}
          - Monitor Condition: {{_payload.data.essentials.monitorCondition}}
          - Monitoring Service: {{_payload.data.essentials.monitoringService}}
          - Alert Target IDs: {{_payload.data.essentials.alertTargetIDs}}
          - Configuration Items: {{_payload.data.essentials.configurationItems}}
          - Origin Alert ID: {{_payload.data.essentials.originAlertId}}


          📅 Event Timestamp: {{_payload.data.alertContext.eventTimestamp}}
          🔍 Event ID: {{_payload.data.alertContext.eventDataId}}
          🔒 Authorization Action: {{_payload.data.alertContext.authorization.action}}
          👤 Caller: {{_payload.data.alertContext.caller}}
          🔗 Correlation ID: {{_payload.data.alertContext.correlationId}}
          📢 Event Source: {{_payload.data.alertContext.eventSource}}
          💼 Operation Name: {{_payload.data.alertContext.operationName}}
          📎 Operation ID: {{_payload.data.alertContext.operationId}}
          📄 Level: {{_payload.data.alertContext.level}}
          📊 Status: {{_payload.data.alertContext.status}}
          🔗 Submission Timestamp: {{_payload.data.alertContext.submissionTimestamp}}

          📄 Activity Log Event Description: {{_payload.data.alertContext.properties.message}}
          🌐 Resource Information:
          - Resource ID: {{_payload.data.alertContext.properties.entity}}
          - Event Category: {{_payload.data.alertContext.properties.eventCategory}}
          - Hierarchy: {{_payload.data.alertContext.properties.hierarchy}}
          - Event Channels: {{_payload.data.alertContext.channels}}

          🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }    

  # Azure Monitor - AMCAS Metric
  create {
    name = "Create Alert - AMCAS Metric"
    tags = ["azure", "metric"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Metric Alert: [ {{_payload.data.essentials.alertRule}} ] 🚨"

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
        expected_value = "Metric"
      }

    }

    description   = chomp(<<-EOT
          🔔 Azure Metric Alert 🔔

          🚩 Alert Details:
          - Alert Rule: {{_payload.data.essentials.alertRule}}
          - Description: {{_payload.data.essentials.description}}
          - Severity: {{_payload.data.essentials.severity}}
          - Fired DateTime: {{_payload.data.essentials.firedDateTime}}

          📊 Metrics Condition:
          - Metric Name: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("metricName=", ",")}}
          - Metric Namespace: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("metricNamespace=", ",")}}
          - Operator: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("operator=", ",")}}
          - Threshold: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("threshold=", ",")}}
          - Time Aggregation: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("timeAggregation=", ",")}}
          - Metric Value: {{_payload.data.alertContext.condition.allOf.get(0).substringAfter("metricValue=").substringBefore("}")}}
          - Alert Sensitivity: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("alertSensitivity=", ",")}}

          📅 Alert Timestamp: {{_payload.data.alertContext.condition.windowStartTime}}
          🔚 Window End Time: {{_payload.data.alertContext.condition.windowEndTime}}

          🌐 Resource Information:
          - Alert Target IDs: {{_payload.data.essentials.alertTargetIDs}}
          - Configuration Items: {{_payload.data.essentials.configurationItems}}
          - Origin Alert ID: {{_payload.data.essentials.originAlertId}}
          - Signal Type: {{_payload.data.essentials.signalType}}
          - Monitor Condition: {{_payload.data.essentials.monitorCondition}}
          - Monitoring Service: {{_payload.data.essentials.monitoringService}}

          🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }    

  # Azure Monitor - AMCAS LogV2
  create {
    name            = "Create Alert - AMCAS LogV2"
    tags            = ["azure", "logv2"]
    user            = "Azure"
    alias           = "{{id}}"
    source          = "Azure"
    custom_priority = "P{{severity.extract(/Sev([1-5])/)}}"
    message         = "🚨 Azure Log Alert: [ {{_payload.data.essentials.alertRule}} ] 🚨"

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
        expected_value = "Log"
      }
      conditions {
        field          = "monitoringService"
        operation      = "equals"
        expected_value = "Log Alerts v2"
      }      
    }

    description   = chomp(<<-EOT
          🔔 Azure Log Alert v2 🔔

          🚩 Alert Details:
          - Alert Rule: {{_payload.data.essentials.alertRule}}
          - Description: {{_payload.data.essentials.description}}
          - Severity: {{_payload.data.essentials.severity}}
          - Fired DateTime: {{_payload.data.essentials.firedDateTime}}

          🌟 Alert Context:
          - Search Query: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("searchQuery=", ",")}}
          - Operator: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("operator=", ",")}}
          - Threshold: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("threshold=", ",")}}
          - Time Aggregation: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("timeAggregation=", ",")}}
          - Metric Value: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("metricValue=", ",")}}
          - Link to Search Results UI: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("linkToSearchResultsUI=", ",")}}
          - Link to Filtered Search Results UI: {{_payload.data.alertContext.condition.allOf.get(0).substringBetween("linkToFilteredSearchResultsUI=", ",")}}

          🌐 Resource Information:
          - Signal Type: {{_payload.data.essentials.signalType}}
          - Monitor Condition: {{_payload.data.essentials.monitorCondition}}
          - Monitoring Service: {{_payload.data.essentials.monitoringService}}
          - Alert Target IDs: {{_payload.data.essentials.alertTargetIDs}}
          - Origin Alert ID: {{_payload.data.essentials.originAlertId}}

          🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)

          ----
          🔍 Full Payload:
          {{_payload.data}}
        EOT
    )
  }     

  # Azure Monitor - AMCAS LogV1
  create {
    name = "Create Alert - AMCAS LogV1"
    tags = ["azure", "logv1"]
    user = "Azure"
    alias         = "{{id}}"
    source        = "Azure"
    custom_priority      = "P{{severity.extract(/Sev([1-5])/)}}"
    message       = "🚨 Azure Log Alert: [ {{_payload.data.essentials.alertRule}} ] 🚨"

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
        expected_value = "Log"
      }
      conditions {
        field          = "monitoringService"
        operation      = "equals"
        expected_value = "Log Analytics"
      }    
    }

    description   = chomp(<<-EOT
      🔔 Azure Log Alert 🔔

      🚩 Alert Details:
      - Alert Rule: {{_payload.data.essentials.alertRule}}
      - Description: {{_payload.data.essentials.description}}
      - Severity: {{_payload.data.essentials.severity}}
      - Fired DateTime: {{_payload.data.essentials.firedDateTime}}

      📜 Alert Properties:
      - Threshold: {{_payload.data.alertContext.Threshold}}
      - Operator: {{_payload.data.alertContext.Operator}}
      - Included Search Results: {{_payload.data.alertContext.IncludedSearchResults}}

      🌟 Alert Context:
      - Search Query: {{_payload.data.alertContext.SearchQuery}}
      - Search Interval Start Time: {{_payload.data.alertContext.SearchIntervalStartTimeUtc}}
      - Search Interval End Time: {{_payload.data.alertContext.SearchIntervalEndtimeUtc}}
      - Result Count: {{_payload.data.alertContext.ResultCount}}
      - Link to Search Results: {{_payload.data.alertContext.LinkToSearchResults}}
      - Link to Filtered Search Results UI: {{_payload.data.alertContext.LinkToFilteredSearchResultsUI}}
      - Link to Search Results API: {{_payload.data.alertContext.LinkToSearchResultsAPI}}
      - Link to Filtered Search Results API: {{_payload.data.alertContext.LinkToFilteredSearchResultsAPI}}
      - Severity Description: {{_payload.data.alertContext.SeverityDescription}}
      - Workspace ID: {{_payload.data.alertContext.WorkspaceId}}
      - Search Interval Duration (Min): {{_payload.data.alertContext.SearchIntervalDurationMin}}
      - Alert Type: {{_payload.data.alertContext.AlertType}}
      - Include Search Results: {{_payload.data.alertContext.IncludeSearchResults}}
      - Dimensions: {{_payload.data.alertContext.Dimensions}}
      - Search Interval in Minutes: {{_payload.data.alertContext.SearchIntervalInMinutes}}

      🌐 Resource Information:
      - Signal Type: {{_payload.data.essentials.signalType}}
      - Monitor Condition: {{_payload.data.essentials.monitorCondition}}
      - Monitoring Service: {{_payload.data.essentials.monitoringService}}
      - Alert Target IDs: {{_payload.data.essentials.alertTargetIDs}}
      - Origin Alert ID: {{_payload.data.essentials.originAlertId}}

      🔗 [View Alert Details on Azure Portal](https://portal.azure.com/#view/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/~/alertsV2)

      ----
      🔍 Full Payload:
      {{_payload}}
        EOT
    )
  }    

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