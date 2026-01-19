# Review Report Template

## Metadata

```yaml
report:
  type: full_stack_review
  generated: "{{timestamp}}"
  path: "{{analyzed_path}}"
  duration: "{{analysis_duration}}"
  agents_used: {{agents_list}}
```

---

# Full-Stack Review Report

**Project:** {{project_name}}  
**Analyzed:** {{timestamp}}  
**Path:** `{{analyzed_path}}`

---

## Executive Summary

| Metric | Value |
|--------|-------|
| Overall Health | {{health_score}}/100 |
| Critical Issues | {{critical_count}} |
| High Priority Issues | {{high_count}} |
| Total Recommendations | {{total_recommendations}} |

**Risk Level:** {{risk_level}}

### Top 3 Priorities

1. {{priority_1}}
2. {{priority_2}}
3. {{priority_3}}

---

## Project Overview

### Structure

```
{{directory_tree}}
```

### Detected Components

| Component | Detected | Agent |
|-----------|----------|-------|
| Infrastructure | {{infra_detected}} | cloud_infra |
| Backend Services | {{backend_detected}} | microservices |
| Frontend (Web) | {{frontend_detected}} | frontend |
| Mobile Apps | {{mobile_detected}} | mobile |
| Design System | {{design_detected}} | design_ux |
| ML/AI Systems | {{ml_detected}} | aiml |
| Data Pipelines | {{data_detected}} | data_eng |
| CI/CD | {{cicd_detected}} | devops |

### Technology Stack

**Languages:** {{languages}}  
**Frameworks:** {{frameworks}}  
**Databases:** {{databases}}  
**Cloud:** {{cloud_provider}}

---

## Agent Findings

### Infrastructure (cloud_infra)

{{#if infra_findings}}
**Resources:** {{infra_resource_count}}  
**IaC Tool:** {{iac_tool}}

**Key Findings:**
{{#each infra_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}

**Cost Optimization:** {{infra_cost_savings}}
{{else}}
_No infrastructure detected_
{{/if}}

---

### Backend Services (microservices)

{{#if backend_findings}}
**Services:** {{service_count}}  
**Architecture:** {{architecture_pattern}}

**Key Findings:**
{{#each backend_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}

**Resilience Score:** {{resilience_score}}/100
{{else}}
_No backend services detected_
{{/if}}

---

### Frontend (frontend)

{{#if frontend_findings}}
**Framework:** {{frontend_framework}}  
**Bundle Size:** {{bundle_size}}

**Core Web Vitals:**
| Metric | Value | Status |
|--------|-------|--------|
| LCP | {{lcp}} | {{lcp_status}} |
| INP | {{inp}} | {{inp_status}} |
| CLS | {{cls}} | {{cls_status}} |

**Key Findings:**
{{#each frontend_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}
{{else}}
_No frontend detected_
{{/if}}

---

### Mobile (mobile)

{{#if mobile_findings}}
**Platforms:** {{mobile_platforms}}

**Key Findings:**
{{#each mobile_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}
{{else}}
_No mobile apps detected_
{{/if}}

---

### Design System (design_ux)

{{#if design_findings}}
**System:** {{design_system_name}}  
**Components:** {{component_count}}

**Accessibility:** {{wcag_level}}
- Critical Issues: {{a11y_critical}}
- Serious Issues: {{a11y_serious}}

**Key Findings:**
{{#each design_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}
{{else}}
_No design system detected_
{{/if}}

---

### AI/ML Systems (aiml)

{{#if ml_findings}}
**Models:** {{model_count}}  
**MLOps Level:** {{mlops_level}}

**Key Findings:**
{{#each ml_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}
{{else}}
_No ML systems detected_
{{/if}}

---

### Data Engineering (data_eng)

{{#if data_findings}}
**Pipelines:** {{pipeline_count}}  
**Orchestrator:** {{orchestrator}}

**Key Findings:**
{{#each data_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}
{{else}}
_No data pipelines detected_
{{/if}}

---

### DevOps (devops)

{{#if devops_findings}}
**CI/CD Platform:** {{cicd_platform}}  
**Workflows:** {{workflow_count}}

**DORA Metrics:**
| Metric | Rating |
|--------|--------|
| Deploy Frequency | {{dora_frequency}} |
| Lead Time | {{dora_lead_time}} |
| Change Failure | {{dora_failure_rate}} |
| MTTR | {{dora_mttr}} |

**Key Findings:**
{{#each devops_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}
{{else}}
_No CI/CD detected_
{{/if}}

---

### Security (security)

**Overall Risk:** {{security_risk}}

**Summary:**
| Category | Status |
|----------|--------|
| Secrets | {{secrets_status}} |
| Dependencies | {{deps_status}} |
| Code Vulnerabilities | {{code_vuln_status}} |
| Infrastructure | {{infra_security_status}} |

**Key Findings:**
{{#each security_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}

---

### Observability (observability)

**Coverage:** {{observability_coverage}}

**Three Pillars:**
| Pillar | Status |
|--------|--------|
| Metrics | {{metrics_status}} |
| Logs | {{logs_status}} |
| Traces | {{traces_status}} |

**Key Findings:**
{{#each observability_findings.issues}}
- [{{this.severity}}] {{this.description}}
{{/each}}

---

## Cross-Domain Validation

{{#each cross_validations}}
### {{this.type}}

**Agents:** {{this.agents}}  
**Status:** {{this.status}}

{{#if this.issues}}
**Issues Found:**
{{#each this.issues}}
- {{this}}
{{/each}}
{{else}}
✅ No issues found
{{/if}}

{{/each}}

---

## Prioritized Recommendations

### 🔴 Critical (Fix Immediately)

{{#each critical_issues}}
{{@index}}. **{{this.issue}}**
   - Source: {{this.source}}
   - Impact: {{this.impact}}
   - Fix: {{this.fix}}
   - Effort: {{this.effort}}

{{/each}}

### 🟠 High Priority (This Sprint)

{{#each high_issues}}
{{@index}}. **{{this.issue}}**
   - Source: {{this.source}}
   - Fix: {{this.fix}}
   - Effort: {{this.effort}}

{{/each}}

### 🟡 Medium (Next Sprint)

{{#each medium_issues}}
- [{{this.source}}] {{this.issue}}
{{/each}}

### 📅 Backlog

{{backlog_count}} additional items tracked.

---

## Implementation Roadmap

| Week | Focus Area | Key Tasks | Owner |
|------|------------|-----------|-------|
{{#each roadmap}}
| {{this.week}} | {{this.focus}} | {{this.tasks}} | {{this.owner}} |
{{/each}}

---

## Appendix

### Agent Output Details

<details>
<summary>Full Agent Outputs (YAML)</summary>

```yaml
{{full_agent_outputs}}
```

</details>

### Files Analyzed

<details>
<summary>File List ({{files_analyzed_count}} files)</summary>

{{#each files_analyzed}}
- `{{this}}`
{{/each}}

</details>

---

*Generated by RLM Multi-Agent System v1.0*
