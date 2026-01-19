# Security Report Template

## Metadata

```yaml
report:
  type: security_assessment
  generated: "{{timestamp}}"
  path: "{{analyzed_path}}"
  risk_level: "{{overall_risk}}"
  confidence: "{{confidence}}"
```

---

# Security Assessment Report

**Project:** {{project_name}}  
**Assessed:** {{timestamp}}  
**Path:** `{{analyzed_path}}`

---

## Executive Summary

| Metric | Value |
|--------|-------|
| Overall Risk Level | {{overall_risk}} |
| Critical Vulnerabilities | {{critical_count}} |
| High Vulnerabilities | {{high_count}} |
| Medium Vulnerabilities | {{medium_count}} |
| Exposed Secrets | {{secrets_count}} |
| Vulnerable Dependencies | {{vuln_deps_count}} |

### Risk Matrix

```
              LIKELIHOOD
           Low    Med    High
        ┌──────┬──────┬──────┐
   High │      │      │ {{risk_high_high}} │
IMPACT  ├──────┼──────┼──────┤
   Med  │      │ {{risk_med_med}} │      │
        ├──────┼──────┼──────┤
   Low  │ {{risk_low_low}} │      │      │
        └──────┴──────┴──────┘
```

### Immediate Action Required

{{#if immediate_actions}}
{{#each immediate_actions}}
1. **{{this.title}}** - {{this.urgency}}
{{/each}}
{{else}}
No immediate actions required.
{{/if}}

---

## Detailed Findings

### 🔑 Secrets Exposure

**Status:** {{secrets_status}}

{{#if exposed_secrets}}
| Type | Location | Severity | Action |
|------|----------|----------|--------|
{{#each exposed_secrets}}
| {{this.type}} | `{{this.location}}` | {{this.severity}} | {{this.action}} |
{{/each}}

**Recommendations:**
- Rotate all exposed credentials immediately
- Remove secrets from version control
- Implement secrets management (Vault, AWS Secrets Manager, etc.)
- Add pre-commit hooks to prevent future leaks
{{else}}
✅ No exposed secrets detected
{{/if}}

**Secrets Management:** {{secrets_management}}

---

### 📦 Dependency Vulnerabilities

**Total Packages:** {{total_packages}}  
**Vulnerable:** {{vulnerable_packages}}

{{#if critical_deps}}
#### Critical Vulnerabilities

| Package | Version | CVE | Fixed In |
|---------|---------|-----|----------|
{{#each critical_deps}}
| {{this.name}} | {{this.version}} | {{this.cve}} | {{this.fixed_in}} |
{{/each}}
{{/if}}

{{#if high_deps}}
#### High Vulnerabilities

| Package | Version | CVE | Fixed In |
|---------|---------|-----|----------|
{{#each high_deps}}
| {{this.name}} | {{this.version}} | {{this.cve}} | {{this.fixed_in}} |
{{/each}}
{{/if}}

**Remediation Commands:**
```bash
# npm
npm audit fix --force

# pip
pip-audit --fix

# General
{{package_manager}} update {{vulnerable_package_list}}
```

---

### 💻 Code Vulnerabilities

{{#if injection_vulns}}
#### Injection Vulnerabilities

| Type | Location | CWE | Description |
|------|----------|-----|-------------|
{{#each injection_vulns}}
| {{this.type}} | `{{this.location}}` | {{this.cwe}} | {{this.description}} |
{{/each}}
{{/if}}

{{#if xss_vulns}}
#### Cross-Site Scripting (XSS)

| Location | CWE | Description |
|----------|-----|-------------|
{{#each xss_vulns}}
| `{{this.location}}` | {{this.cwe}} | {{this.description}} |
{{/each}}
{{/if}}

{{#if auth_vulns}}
#### Authentication/Authorization Issues

| Issue | Location | Impact |
|-------|----------|--------|
{{#each auth_vulns}}
| {{this.issue}} | `{{this.location}}` | {{this.impact}} |
{{/each}}
{{/if}}

{{#if crypto_vulns}}
#### Cryptographic Issues

| Issue | Location | Recommendation |
|-------|----------|----------------|
{{#each crypto_vulns}}
| {{this.issue}} | `{{this.location}}` | {{this.recommendation}} |
{{/each}}
{{/if}}

---

### 🔐 Authentication & Authorization

**Authentication Methods:** {{auth_methods}}

| Control | Status | Notes |
|---------|--------|-------|
| Multi-Factor Authentication | {{mfa_status}} | {{mfa_notes}} |
| Password Policy | {{password_policy_status}} | {{password_policy_notes}} |
| Session Management | {{session_status}} | {{session_notes}} |
| Token Storage | {{token_storage_status}} | {{token_storage_notes}} |
| Rate Limiting | {{rate_limit_status}} | {{rate_limit_notes}} |

**Authorization Model:** {{auth_model}}

{{#if auth_issues}}
**Issues:**
{{#each auth_issues}}
- {{this}}
{{/each}}
{{/if}}

---

### ☁️ Infrastructure Security

{{#if network_exposure}}
#### Network Exposure

| Resource | Exposure | Risk | Remediation |
|----------|----------|------|-------------|
{{#each network_exposure}}
| {{this.resource}} | {{this.exposure}} | {{this.risk}} | {{this.remediation}} |
{{/each}}
{{/if}}

{{#if iam_issues}}
#### IAM Issues

| Resource | Issue | Risk |
|----------|-------|------|
{{#each iam_issues}}
| {{this.resource}} | {{this.issue}} | {{this.risk}} |
{{/each}}
{{/if}}

{{#if container_issues}}
#### Container Security

| Issue | Location | Risk |
|-------|----------|------|
{{#each container_issues}}
| {{this.issue}} | `{{this.location}}` | {{this.risk}} |
{{/each}}
{{/if}}

---

### 🛡️ Security Headers

| Header | Status | Recommendation |
|--------|--------|----------------|
| Content-Security-Policy | {{csp_status}} | {{csp_recommendation}} |
| X-Frame-Options | {{xfo_status}} | {{xfo_recommendation}} |
| X-Content-Type-Options | {{xcto_status}} | {{xcto_recommendation}} |
| Strict-Transport-Security | {{hsts_status}} | {{hsts_recommendation}} |
| X-XSS-Protection | {{xxss_status}} | {{xxss_recommendation}} |
| Referrer-Policy | {{rp_status}} | {{rp_recommendation}} |

---

### 📋 Compliance Assessment

| Framework | Status | Gap Count | Priority Gaps |
|-----------|--------|-----------|---------------|
| SOC 2 | {{soc2_status}} | {{soc2_gaps}} | {{soc2_priority}} |
| HIPAA | {{hipaa_status}} | {{hipaa_gaps}} | {{hipaa_priority}} |
| GDPR | {{gdpr_status}} | {{gdpr_gaps}} | {{gdpr_priority}} |
| PCI-DSS | {{pci_status}} | {{pci_gaps}} | {{pci_priority}} |

{{#if compliance_gaps}}
#### Key Compliance Gaps

{{#each compliance_gaps}}
- **[{{this.framework}}]** {{this.gap}}
  - Remediation: {{this.remediation}}
{{/each}}
{{/if}}

---

### 📊 Logging & Monitoring

| Capability | Status | Notes |
|------------|--------|-------|
| Audit Logging | {{audit_logging_status}} | {{audit_logging_notes}} |
| Security Events | {{security_events_status}} | {{security_events_notes}} |
| Alerting | {{alerting_status}} | {{alerting_notes}} |
| Incident Response | {{ir_status}} | {{ir_notes}} |

---

## Remediation Plan

### Immediate (24-48 hours)

{{#each immediate_remediation}}
1. **{{this.title}}**
   - Description: {{this.description}}
   - Steps: {{this.steps}}
   - Owner: {{this.owner}}
{{/each}}

### Short-term (1-2 weeks)

{{#each short_term_remediation}}
1. **{{this.title}}**
   - Description: {{this.description}}
   - Effort: {{this.effort}}
{{/each}}

### Medium-term (1-3 months)

{{#each medium_term_remediation}}
1. **{{this.title}}**
   - Description: {{this.description}}
   - Effort: {{this.effort}}
{{/each}}

---

## Security Posture Improvement

### Quick Wins

{{#each quick_wins}}
- [ ] {{this}}
{{/each}}

### Security Hardening Checklist

- [ ] Enable MFA for all users
- [ ] Implement secrets management
- [ ] Enable dependency scanning in CI/CD
- [ ] Configure security headers
- [ ] Implement rate limiting
- [ ] Enable audit logging
- [ ] Set up security alerting
- [ ] Document incident response procedures

---

## Appendix

### Scanning Tools Used

- Secret Detection: {{secret_tool}}
- Dependency Scanning: {{dep_tool}}
- Static Analysis: {{sast_tool}}
- Infrastructure Scanning: {{infra_tool}}

### Full Vulnerability List

<details>
<summary>All Vulnerabilities ({{total_vulns}})</summary>

```yaml
{{full_vulnerability_list}}
```

</details>

### References

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE/SANS Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

*Generated by RLM Security Agent v1.0*
