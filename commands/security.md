# Command: /rlm security

## Usage

```
/rlm security [path]
/rlm security ./
/rlm security (uses current directory)
```

## Description

Comprehensive security assessment covering secrets, vulnerabilities, authentication, authorization, and compliance.

## Agents Invoked

1. **security** (primary) - Full security analysis
2. **cloud_infra** - Infrastructure security
3. **devops** - Pipeline security
4. **frontend** - Client-side security
5. **mobile** - Mobile-specific security

## Workflow

```python
def execute_security_scan(path="."):
    """
    Security-focused analysis workflow.
    """
    
    print("## 🔒 Security Assessment\n")
    print("⚠️ **Note:** Full codebase access required for security analysis\n")
    
    # Phase 1: Secrets Scan
    print("### 🔑 Secrets Scan\n")
    
    secrets = scan_for_secrets(path)
    
    if secrets.exposed:
        print(f"**🚨 EXPOSED SECRETS FOUND: {len(secrets.exposed)}**\n")
        for secret in secrets.exposed:
            print(f"- **{secret.type}** in `{secret.location}`")
            print(f"  - Sample: `{secret.redacted}`")
    else:
        print("✅ No exposed secrets detected\n")
    
    print(f"**Secrets Management:** {secrets.management_approach}")
    
    # Phase 2: Dependency Vulnerabilities
    print("\n### 📦 Dependency Vulnerabilities\n")
    
    deps = scan_dependencies(path)
    
    print(f"**Total Packages:** {deps.total}")
    print(f"**Vulnerable:** {deps.vulnerable_count}")
    
    if deps.critical:
        print("\n**🚨 Critical Vulnerabilities:**")
        for vuln in deps.critical:
            print(f"- `{vuln.package}@{vuln.version}`")
            print(f"  - {vuln.cve}: {vuln.description}")
            print(f"  - Fixed in: {vuln.fixed_version}")
    
    # Phase 3: Code Vulnerabilities
    print("\n### 💻 Code Vulnerabilities\n")
    
    code_vulns = analyze_code_security(path)
    
    vuln_types = ['injection', 'xss', 'auth', 'crypto', 'other']
    for vtype in vuln_types:
        vulns = code_vulns.get(vtype, [])
        if vulns:
            print(f"\n**{vtype.upper()}:**")
            for v in vulns:
                print(f"- {v.description}")
                print(f"  - Location: `{v.location}`")
                print(f"  - CWE: {v.cwe}")
    
    # Phase 4: Authentication & Authorization
    print("\n### 🔐 Authentication & Authorization\n")
    
    auth = analyze_auth(path)
    
    print(f"**Auth Methods:** {', '.join(auth.methods)}")
    print(f"**MFA Support:** {'✅' if auth.mfa else '❌'}")
    print(f"**Password Policy:** {auth.password_policy}")
    print(f"**Token Storage:** {auth.token_storage}")
    
    if auth.issues:
        print("\n**⚠️ Issues:**")
        for issue in auth.issues:
            print(f"- {issue}")
    
    # Phase 5: Infrastructure Security
    print("\n### ☁️ Infrastructure Security\n")
    
    infra = analyze_infra_security(path)
    
    if infra.network_exposure:
        print("**Network Exposure:**")
        for exp in infra.network_exposure:
            print(f"- {exp}")
    
    if infra.iam_issues:
        print("\n**IAM Issues:**")
        for issue in infra.iam_issues:
            print(f"- {issue}")
    
    # Phase 6: Compliance
    print("\n### 📋 Compliance Status\n")
    
    compliance = assess_compliance(path)
    
    frameworks = ['SOC 2', 'HIPAA', 'GDPR', 'PCI-DSS']
    for fw in frameworks:
        status = compliance.get(fw.lower().replace(' ', '').replace('-', ''))
        emoji = '✅' if status == 'compliant' else '⚠️' if status == 'partial' else '❌'
        print(f"- **{fw}:** {emoji} {status}")
    
    # Phase 7: Summary & Recommendations
    print("\n## 📊 Risk Summary\n")
    
    print(f"**Overall Risk Level:** {calculate_risk_level(secrets, deps, code_vulns, auth, infra)}")
    
    print("\n## 🔧 Immediate Actions Required\n")
    
    actions = prioritize_security_actions(secrets, deps, code_vulns, auth, infra)
    for i, action in enumerate(actions[:5], 1):
        print(f"{i}. **{action.title}**")
        print(f"   - {action.description}")
        print(f"   - Effort: {action.effort}")
```

## Output Template

```markdown
## 🔒 Security Assessment

⚠️ **Note:** Full codebase access required for security analysis

### 🔑 Secrets Scan

**🚨 EXPOSED SECRETS FOUND: 3**

- **AWS Access Key** in `config/settings.py:45`
  - Sample: `AKIA***************XYZ`
- **Database Password** in `.env.example:12`
  - Sample: `db_pass=prod***`
- **GitHub Token** in `scripts/deploy.sh:8`
  - Sample: `ghp_***************************`

**Secrets Management:** Environment variables (no vault)

### 📦 Dependency Vulnerabilities

**Total Packages:** 847
**Vulnerable:** 12

**🚨 Critical Vulnerabilities:**
- `lodash@4.17.15`
  - CVE-2021-23337: Prototype pollution
  - Fixed in: 4.17.21
- `node-fetch@2.6.0`
  - CVE-2022-0235: Improper handling of headers
  - Fixed in: 2.6.7

### 💻 Code Vulnerabilities

**INJECTION:**
- SQL string concatenation
  - Location: `api/users.py:78`
  - CWE: CWE-89
- Command injection risk
  - Location: `scripts/process.py:34`
  - CWE: CWE-78

**XSS:**
- dangerouslySetInnerHTML with user input
  - Location: `components/Comment.tsx:23`
  - CWE: CWE-79

### 🔐 Authentication & Authorization

**Auth Methods:** JWT, OAuth2
**MFA Support:** ❌
**Password Policy:** Weak (no complexity requirements)
**Token Storage:** localStorage ⚠️

**⚠️ Issues:**
- No MFA available for user accounts
- Tokens stored in localStorage (XSS risk)
- JWT has 24h expiry (too long)
- No password complexity requirements

### ☁️ Infrastructure Security

**Network Exposure:**
- RDS database accessible from 0.0.0.0/0 🚨
- Redis ElastiCache in public subnet

**IAM Issues:**
- `api-task-role` has s3:* permission (overly broad)
- Lambda function has admin access

### 📋 Compliance Status

- **SOC 2:** ⚠️ partial
- **HIPAA:** ❌ non-compliant
- **GDPR:** ⚠️ partial
- **PCI-DSS:** ❌ non-compliant

## 📊 Risk Summary

**Overall Risk Level:** 🔴 CRITICAL

| Category | Risk |
|----------|------|
| Secrets | 🔴 Critical |
| Dependencies | 🟠 High |
| Code | 🟠 High |
| Auth | 🟠 High |
| Infrastructure | 🔴 Critical |

## 🔧 Immediate Actions Required

1. **Rotate exposed AWS credentials**
   - Remove from code, use IAM roles, rotate keys immediately
   - Effort: Low (1 hour)

2. **Fix RDS public accessibility**
   - Move to private subnet, use VPC endpoints
   - Effort: Medium (4 hours)

3. **Update vulnerable dependencies**
   - Run `npm audit fix` and `pip-audit --fix`
   - Effort: Low (2 hours)

4. **Fix SQL injection vulnerability**
   - Use parameterized queries
   - Effort: Low (1 hour)

5. **Implement proper token storage**
   - Move from localStorage to httpOnly cookies
   - Effort: Medium (4 hours)
```

## Severity Definitions

| Severity | Description | Action |
|----------|-------------|--------|
| Critical | Active exploitation possible | Fix within 24 hours |
| High | Significant risk | Fix within 1 week |
| Medium | Moderate risk | Fix within 1 month |
| Low | Minor risk | Track in backlog |
