// @description('Deployment region')
// param location string

@description('E-mail address for all alerts')
param notificationEmail string

@description('Teams/Slack webhook URI (leave "" to skip)')
param teamsWebhookUri string = ''

@description('(Optional) Log Analytics workspace ID for heartbeat alert')
param logAnalyticsWorkspaceId string = ''

@description('Region for Action Group')
param actionGroupLocation string = 'global'

@description('Region for alert rules (must be in the allowed list)')
param alertRuleLocation   string = 'eastus'



//─────────────────────────── Action Group ───────────────────────────
resource ag 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: 'watchdog-ag'
  location: actionGroupLocation       // any region works
  properties: {
    groupShortName: 'watchdog'
    enabled: true
    emailReceivers: [
      {
        name: 'PrimaryEmail'
        emailAddress: notificationEmail
      }
    ]
    webhookReceivers: empty(teamsWebhookUri) ? [] : [
      {
        name: 'TeamsHook'
        serviceUri: teamsWebhookUri
        useCommonAlertSchema: true
      }
    ]
  }
}

//──────────────────────── Heartbeat alert 5 min ──────────────────────
resource heartbeatRule 'Microsoft.Insights/scheduledQueryRules@2022-08-01-preview' = if (!empty(logAnalyticsWorkspaceId)) {
  name: 'watchdog-heartbeat-missing'
  location: alertRuleLocation 
  properties: {
    enabled: true
    description: 'Alert if any VM stops sending heartbeat for 5 minutes'
    severity: 2
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    scopes: [
      logAnalyticsWorkspaceId
    ]
    criteria: {
      allOf: [
        {
          query: '''
            Heartbeat
            | summarize LastSeen=max(TimeGenerated) by Computer
            | where LastSeen < ago(5m)
          '''
          timeAggregation: 'Count'
          threshold: 0
          operator: 'GreaterThan'
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
    actions: {
      actionGroups: [
        ag.id
      ]
    }
  }
}

//────────── expose Action-Group ID to parent templates ───────────────
output actionGroupId string = ag.id

