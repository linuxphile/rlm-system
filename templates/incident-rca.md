# Incident RCA Template

## Metadata

```yaml
report:
  type: incident_rca
  generated: "{{timestamp}}"
  incident_id: "{{incident_id}}"
  severity: "{{severity}}"
  status: "{{status}}"
```

---

# Incident Root Cause Analysis

**Incident ID:** {{incident_id}}  
**Title:** {{incident_title}}  
**Severity:** {{severity}}  
**Status:** {{status}}

---

## Incident Summary

| Field | Value |
|-------|-------|
| **Start Time** | {{start_time}} |
| **Detection Time** | {{detection_time}} |
| **Mitigation Time** | {{mitigation_time}} |
| **Resolution Time** | {{resolution_time}} |
| **Duration** | {{total_duration}} |
| **Time to Detect (TTD)** | {{ttd}} |
| **Time to Mitigate (TTM)** | {{ttm}} |
| **Impact** | {{impact_summary}} |
| **Affected Services** | {{affected_services}} |
| **Affected Users** | {{affected_users}} |

### Description

{{incident_description}}

---

## Timeline

```
{{timeline_start}} ─────────────────────────────────────────────── {{timeline_end}}
│
{{#each timeline_events}}
├─ {{this.time}} [{{this.type}}] {{this.description}}
{{/each}}
│
└─ {{resolution_time}} RESOLVED
```

### Detailed Timeline

| Time | Event | Actor | Details |
|------|-------|-------|---------|
{{#each timeline_events}}
| {{this.time}} | {{this.type}} | {{this.actor}} | {{this.details}} |
{{/each}}

---

## Impact Analysis

### Service Impact

| Service | Impact Level | Duration | Error Rate |
|---------|--------------|----------|------------|
{{#each service_impacts}}
| {{this.service}} | {{this.level}} | {{this.duration}} | {{this.error_rate}} |
{{/each}}

### User Impact

- **Total Users Affected:** {{total_users_affected}}
- **Geographic Regions:** {{affected_regions}}
- **Customer Segments:** {{affected_segments}}

### Business Impact

- **Revenue Impact:** {{revenue_impact}}
- **SLA Breach:** {{sla_breach}}
- **Customer Communications:** {{customer_comms}}

---

## Root Cause Analysis

### Contributing Factors

```
                    ┌─────────────────┐
                    │    INCIDENT     │
                    │  {{incident_type}}  │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   TRIGGER     │   │  CONDITION    │   │    IMPACT     │
│───────────────│   │───────────────│   │───────────────│
│ {{trigger}}   │   │ {{condition}} │   │ {{impact}}    │
└───────────────┘   └───────────────┘   └───────────────┘
```

### Five Whys Analysis

{{#each five_whys}}
**Why {{@index}}:** {{this.question}}  
**Answer:** {{this.answer}}

{{/each}}

### Root Cause

**Primary Root Cause:**
{{root_cause_primary}}

**Contributing Factors:**
{{#each contributing_factors}}
- {{this}}
{{/each}}

---

## Technical Analysis

### Agent Findings

{{#each agent_analysis}}
#### {{this.agent}} Analysis

**Scope:** {{this.scope}}

**Findings:**
{{#each this.findings}}
- {{this}}
{{/each}}

{{#if this.evidence}}
**Evidence:**
```
{{this.evidence}}
```
{{/if}}

{{/each}}

### Failure Chain

```
{{#each failure_chain}}
[{{this.component}}] {{this.failure}}
    │
    ▼
{{/each}}
[END USERS] {{user_visible_symptom}}
```

### Configuration/Code Changes

{{#if recent_changes}}
| Time | Type | Change | Author | Correlation |
|------|------|--------|--------|-------------|
{{#each recent_changes}}
| {{this.time}} | {{this.type}} | {{this.change}} | {{this.author}} | {{this.correlation}} |
{{/each}}
{{else}}
No recent changes identified in the incident window.
{{/if}}

---

## Response Analysis

### Detection

- **How Detected:** {{detection_method}}
- **Alert Fired:** {{alert_fired}}
- **Detection Gap:** {{detection_gap}}

### Response

- **Initial Responder:** {{initial_responder}}
- **Escalation Path:** {{escalation_path}}
- **Communication:** {{communication_summary}}

### Mitigation

**Actions Taken:**
{{#each mitigation_actions}}
1. {{this.action}} ({{this.time}})
   - Result: {{this.result}}
{{/each}}

**What Worked:**
{{#each what_worked}}
- {{this}}
{{/each}}

**What Didn't Work:**
{{#each what_didnt_work}}
- {{this}}
{{/each}}

---

## Remediation

### Immediate Actions (Completed)

{{#each immediate_actions}}
- [x] {{this.action}} - {{this.owner}} ({{this.status}})
{{/each}}

### Short-term Actions (1-2 weeks)

{{#each short_term_actions}}
- [ ] {{this.action}}
  - Owner: {{this.owner}}
  - Due: {{this.due_date}}
  - Ticket: {{this.ticket}}
{{/each}}

### Long-term Actions (1-3 months)

{{#each long_term_actions}}
- [ ] {{this.action}}
  - Owner: {{this.owner}}
  - Due: {{this.due_date}}
  - Ticket: {{this.ticket}}
{{/each}}

---

## Prevention

### Detection Improvements

| Gap | Improvement | Priority |
|-----|-------------|----------|
{{#each detection_improvements}}
| {{this.gap}} | {{this.improvement}} | {{this.priority}} |
{{/each}}

### Resilience Improvements

| Weakness | Improvement | Priority |
|----------|-------------|----------|
{{#each resilience_improvements}}
| {{this.weakness}} | {{this.improvement}} | {{this.priority}} |
{{/each}}

### Process Improvements

{{#each process_improvements}}
- {{this}}
{{/each}}

---

## Lessons Learned

### What Went Well

{{#each lessons_well}}
- {{this}}
{{/each}}

### What Could Be Improved

{{#each lessons_improve}}
- {{this}}
{{/each}}

### Action Items from Retrospective

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
{{#each retro_actions}}
| {{this.action}} | {{this.owner}} | {{this.due}} | {{this.status}} |
{{/each}}

---

## Appendix

### Related Incidents

{{#if related_incidents}}
| Incident | Date | Similarity |
|----------|------|------------|
{{#each related_incidents}}
| {{this.id}} | {{this.date}} | {{this.similarity}} |
{{/each}}
{{else}}
No related incidents identified.
{{/if}}

### Supporting Data

<details>
<summary>Metrics During Incident</summary>

```
{{metrics_data}}
```

</details>

<details>
<summary>Relevant Logs</summary>

```
{{relevant_logs}}
```

</details>

<details>
<summary>Alert History</summary>

```
{{alert_history}}
```

</details>

### Participants

| Role | Name |
|------|------|
| Incident Commander | {{ic}} |
| Technical Lead | {{tech_lead}} |
| Communications | {{comms}} |
| Scribe | {{scribe}} |

---

## Sign-off

| Role | Name | Date | Approved |
|------|------|------|----------|
| Engineering Lead | {{eng_lead}} | {{eng_date}} | {{eng_approved}} |
| Product Owner | {{product_owner}} | {{product_date}} | {{product_approved}} |
| SRE Lead | {{sre_lead}} | {{sre_date}} | {{sre_approved}} |

---

*Generated by RLM Incident Analysis v1.0*
