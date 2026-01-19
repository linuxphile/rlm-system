# Command: /rlm incident

## Usage

```
/rlm incident "<description>"
/rlm incident "API latency spike at 2pm, users seeing 504 errors"
/rlm incident "Payment failures for European customers"
/rlm incident "Mobile app crashes on startup after latest release"
```

## Description

Structured incident investigation and root cause analysis. Starts with observability data and traces through the system to identify root causes.

## Agents Invoked (Dynamically)

1. **observability** (always first) - Build timeline, identify affected components
2. **Based on symptoms:**
   - API issues → **microservices**, **cloud_infra**
   - Frontend issues → **frontend**, **observability**
   - Mobile issues → **mobile**, **observability**
   - Data issues → **data_eng**, **microservices**
   - Security incidents → **security** (all access)
   - Infrastructure → **cloud_infra**, **devops**

## Workflow

```python
def execute_incident_investigation(description):
    """
    Incident investigation workflow.
    """
    
    print("## 🚨 Incident Investigation\n")
    print(f"**Reported Issue:** {description}")
    print(f"**Investigation Started:** {timestamp()}")
    print()
    
    # Phase 1: Initial Triage
    print("### 🔍 Phase 1: Initial Triage\n")
    
    symptoms = extract_symptoms(description)
    print("**Identified Symptoms:**")
    for symptom in symptoms:
        print(f"- {symptom}")
    
    affected_layers = identify_affected_layers(symptoms)
    print(f"\n**Potentially Affected Layers:** {', '.join(affected_layers)}")
    
    # Phase 2: Timeline Construction
    print("\n### 📅 Phase 2: Timeline Construction\n")
    
    print("*Querying observability data...*\n")
    
    # Invoke observability agent
    timeline = observability_agent.build_timeline(symptoms)
    
    print("**Event Timeline:**")
    print("```")
    for event in timeline.events:
        print(f"{event.time} | {event.severity} | {event.source} | {event.message}")
    print("```")
    
    # Phase 3: Layer-by-Layer Analysis
    print("\n### 🔬 Phase 3: Layer Analysis\n")
    
    for layer in affected_layers:
        print(f"#### {layer.title()}\n")
        
        agent = get_agent(layer)
        findings = agent.investigate_incident(symptoms, timeline)
        
        if findings.anomalies:
            print("**Anomalies Detected:**")
            for anomaly in findings.anomalies:
                print(f"- {anomaly}")
        
        if findings.potential_causes:
            print("\n**Potential Causes:**")
            for cause in findings.potential_causes:
                print(f"- {cause.description} (confidence: {cause.confidence})")
        
        print()
    
    # Phase 4: Correlation Analysis
    print("### 🔗 Phase 4: Correlation Analysis\n")
    
    correlations = find_correlations(timeline, layer_findings)
    
    print("**Correlated Events:**")
    for corr in correlations:
        print(f"- {corr.event_a} → {corr.event_b}")
        print(f"  - Correlation: {corr.strength}")
        print(f"  - Hypothesis: {corr.hypothesis}")
    
    # Phase 5: Root Cause Determination
    print("\n### 🎯 Phase 5: Root Cause Analysis\n")
    
    root_causes = determine_root_causes(correlations, layer_findings)
    
    print("**Most Likely Root Cause(s):**")
    for i, cause in enumerate(root_causes, 1):
        print(f"\n**{i}. {cause.title}** (Confidence: {cause.confidence}%)")
        print(f"   - Evidence: {cause.evidence}")
        print(f"   - Impact Chain: {' → '.join(cause.impact_chain)}")
    
    # Phase 6: Remediation
    print("\n### 🔧 Phase 6: Remediation\n")
    
    print("**Immediate Actions:**")
    for action in root_causes[0].immediate_actions:
        print(f"- [ ] {action}")
    
    print("\n**Longer-term Fixes:**")
    for fix in root_causes[0].long_term_fixes:
        print(f"- [ ] {fix}")
    
    # Phase 7: Prevention
    print("\n### 🛡️ Phase 7: Prevention\n")
    
    print("**Recommendations to Prevent Recurrence:**")
    for rec in generate_prevention_recommendations(root_causes):
        print(f"- {rec}")
```

## Symptom Pattern Matching

```yaml
api_latency:
  keywords: ["latency", "slow", "timeout", "504", "503"]
  initial_agents: ["observability", "microservices", "cloud_infra"]
  
error_spike:
  keywords: ["errors", "500", "exceptions", "failures"]
  initial_agents: ["observability", "microservices", "security"]
  
frontend_issues:
  keywords: ["page", "loading", "blank", "javascript", "render"]
  initial_agents: ["observability", "frontend", "cloud_infra"]
  
mobile_crash:
  keywords: ["crash", "app", "mobile", "iOS", "Android", "startup"]
  initial_agents: ["observability", "mobile", "microservices"]
  
data_issues:
  keywords: ["data", "missing", "stale", "pipeline", "ETL"]
  initial_agents: ["observability", "data_eng", "microservices"]
  
security_incident:
  keywords: ["breach", "unauthorized", "attack", "suspicious", "compromised"]
  initial_agents: ["security", "observability", "cloud_infra"]
  
deployment_issues:
  keywords: ["deploy", "release", "rollout", "new version"]
  initial_agents: ["devops", "observability", "microservices"]
```

## Output Template

```markdown
## 🚨 Incident Investigation

**Reported Issue:** API latency spike at 2pm, users seeing 504 errors
**Investigation Started:** 2024-01-15 14:23:00 UTC
**Status:** Investigating

### 🔍 Phase 1: Initial Triage

**Identified Symptoms:**
- HTTP 504 Gateway Timeout errors
- Increased API response times
- User-facing impact confirmed

**Potentially Affected Layers:** API Gateway, Backend Services, Database, Infrastructure

### 📅 Phase 2: Timeline Construction

**Event Timeline:**
```
13:45:00 | INFO  | deployment | order-service v2.3.4 deployed
13:52:00 | WARN  | db-monitor | Connection pool utilization 85%
13:58:00 | WARN  | db-monitor | Connection pool utilization 95%
14:00:00 | ERROR | order-service | Database connection timeout
14:01:00 | ERROR | api-gateway | Upstream timeout: order-service
14:02:00 | ALERT | monitoring | Error rate exceeded threshold
14:05:00 | ERROR | user-service | Cascade: Unable to fetch orders
```

**Key Observations:**
- Deployment preceded incident by 15 minutes
- Database connection pool exhaustion started at 13:52
- Cascade began at 14:00

### 🔬 Phase 3: Layer Analysis

#### Microservices

**Anomalies Detected:**
- order-service response time increased from 50ms to 8000ms
- Connection pool exhausted (100/100 connections in use)
- No new connections could be established

**Potential Causes:**
- Database query regression in v2.3.4 (confidence: 85%)
- Missing connection timeout configuration (confidence: 60%)

#### Cloud Infrastructure

**Anomalies Detected:**
- RDS CPU increased from 30% to 95%
- Active connections jumped from 50 to 100 (max)

**Potential Causes:**
- Expensive query pattern (confidence: 80%)
- Missing database index (confidence: 70%)

#### Database

**Query Analysis:**
- New query in v2.3.4: `SELECT * FROM orders WHERE user_id = ? ORDER BY created_at`
- Missing index on `orders(user_id, created_at)`
- Query execution time: 800ms → should be <10ms

### 🔗 Phase 4: Correlation Analysis

**Correlated Events:**
- deployment (13:45) → db CPU spike (13:52)
  - Correlation: Strong (0.95)
  - Hypothesis: New code introduced expensive query

- db connection exhaustion (13:58) → 504 errors (14:01)
  - Correlation: Direct causation
  - Hypothesis: No connections = service unavailable

### 🎯 Phase 5: Root Cause Analysis

**Most Likely Root Cause(s):**

**1. Missing Database Index** (Confidence: 90%)
   - Evidence: Query plan shows full table scan on 2M row table
   - Impact Chain: New query → Full scan → Slow response → Pool exhaustion → 504s

**2. Insufficient Connection Pool Size** (Contributing Factor)
   - Evidence: Pool size (100) inadequate for slow query volume
   - Impact Chain: Slow queries hold connections → Exhaustion → Failure

### 🔧 Phase 6: Remediation

**Immediate Actions:**
- [ ] Rollback order-service to v2.3.3
- [ ] Increase RDS instance size temporarily
- [ ] Clear connection pool / restart services

**Longer-term Fixes:**
- [ ] Add index: `CREATE INDEX idx_orders_user_created ON orders(user_id, created_at)`
- [ ] Implement query performance testing in CI/CD
- [ ] Add connection pool monitoring with alerting
- [ ] Configure query timeout limits

### 🛡️ Phase 7: Prevention

**Recommendations to Prevent Recurrence:**
- Add database query analysis to deployment pipeline
- Implement slow query alerting (> 100ms)
- Add connection pool utilization to SLOs
- Create runbook for connection pool exhaustion
- Schedule load testing with realistic data volumes

---

## 📊 Incident Summary

| Attribute | Value |
|-----------|-------|
| Duration | 23 minutes |
| Impact | ~500 users affected |
| Root Cause | Missing database index |
| Resolution | Rollback + index creation |
| Severity | P2 |
```

## RCA Template Fields

```yaml
incident_report:
  id: string
  title: string
  severity: P1|P2|P3|P4
  status: investigating|mitigated|resolved
  
  timeline:
    detected: datetime
    acknowledged: datetime
    mitigated: datetime
    resolved: datetime
    
  impact:
    users_affected: number
    revenue_impact: string
    slo_breach: boolean
    
  root_cause:
    primary: string
    contributing: string[]
    confidence: percentage
    
  remediation:
    immediate: string[]
    long_term: string[]
    
  prevention:
    process_changes: string[]
    technical_changes: string[]
    monitoring_changes: string[]
    
  lessons_learned: string[]
```
