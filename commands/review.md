# Command: /rlm review

## Usage

```
/rlm review [path]
/rlm review ./src
/rlm review (uses current directory)
```

## Description

Performs a comprehensive full-stack review of the codebase, automatically detecting project types and invoking relevant sub-agents.

## Workflow

```python
def execute_review(path="."):
    """
    Full-stack review workflow.
    """
    
    # Phase 1: Discovery
    print("## 🔍 Analyzing Project Structure\n")
    
    structure = scan_directory(path)
    detected = detect_project_types(structure)
    
    print(f"**Path:** {path}")
    print(f"**Files:** {structure.file_count}")
    print(f"**Languages:** {structure.languages}")
    print()
    
    # Phase 2: Component Detection
    print("### Detected Components\n")
    
    components = {
        "Infrastructure": detected.get('infrastructure', False),
        "Backend Services": detected.get('backend', False),
        "Frontend (Web)": detected.get('frontend', False),
        "Mobile Apps": detected.get('mobile', False),
        "Design System": detected.get('design', False),
        "ML/AI Systems": detected.get('ml', False),
        "Data Pipelines": detected.get('data', False),
        "CI/CD": detected.get('ci_cd', False),
    }
    
    for component, present in components.items():
        status = "✓" if present else "✗"
        print(f"- {component}: {status}")
    
    # Phase 3: Agent Selection
    agents = select_agents(detected)
    print(f"\n**Selected Agents:** {', '.join(agents)}\n")
    
    # Phase 4: Execute Agents
    print("## 🤖 Running Sub-Agent Analysis\n")
    
    findings = {}
    for agent in agents:
        print(f"### {agent.title()}")
        agent_context = filter_context(path, agent)
        findings[agent] = execute_agent(agent, agent_context)
        print_agent_summary(findings[agent])
        print()
    
    # Phase 5: Cross-Domain Validation
    print("## 🔗 Cross-Domain Validation\n")
    
    validations = validate_cross_domain(findings)
    for v in validations:
        print(f"- **{v['type']}** ({v['severity']}): {v['details']}")
    
    # Phase 6: Synthesis
    print("\n## 📋 Synthesized Findings\n")
    
    prioritized = synthesize_findings(findings, validations)
    
    print("### 🔴 Critical (Fix Immediately)\n")
    for issue in prioritized['critical']:
        print(f"- [{issue['source']}] {issue['issue']}")
        print(f"  - **Impact:** {issue['impact']}")
        print(f"  - **Fix:** {issue['fix']}")
    
    print("\n### 🟠 High Priority (This Sprint)\n")
    for issue in prioritized['high']:
        print(f"- [{issue['source']}] {issue['issue']}")
    
    print("\n### 🟡 Medium (Next Sprint)\n")
    for issue in prioritized['medium'][:10]:  # Top 10
        print(f"- [{issue['source']}] {issue['issue']}")
    
    print("\n### 📅 Backlog\n")
    print(f"- {len(prioritized['low'])} additional items")
    
    # Phase 7: Generate Report
    print("\n## 📊 Implementation Roadmap\n")
    
    generate_roadmap(prioritized)
```

## Detection Patterns

```yaml
infrastructure:
  - "*.tf"
  - "*.tfvars"
  - "kubernetes/*.yaml"
  - "helm/**"
  - "docker-compose*.yaml"

backend:
  - "src/**/*.{go,py,java,ts}"
  - "api/**/*"
  - "services/**/*"
  - "openapi*.yaml"

frontend:
  - "*.tsx"
  - "*.vue"
  - "next.config.*"
  - "vite.config.*"
  - "package.json" (with react/vue/angular)

mobile:
  - "ios/**/*.swift"
  - "android/**/*.kt"
  - "lib/**/*.dart"
  - "App.tsx" (React Native)

design:
  - "design-system/**/*"
  - "**/*.stories.*"
  - "tokens/**/*"

ml:
  - "models/**/*"
  - "*.ipynb"
  - "ml/**/*"
  - "pipelines/**/*"

data:
  - "dbt/**/*"
  - "airflow/**/*"
  - "data/**/*"
  - "etl/**/*"

ci_cd:
  - ".github/workflows/*"
  - ".gitlab-ci.yml"
  - "Jenkinsfile"
```

## Output Template

The command produces output following `templates/review-report.md`.

## Example Output

```markdown
## 🔍 Analyzing Project Structure

**Path:** ./my-project
**Files:** 1,247
**Languages:** TypeScript, Python, Go, SQL

### Detected Components

- Infrastructure: ✓
- Backend Services: ✓
- Frontend (Web): ✓
- Mobile Apps: ✗
- Design System: ✓
- ML/AI Systems: ✗
- Data Pipelines: ✓
- CI/CD: ✓

**Selected Agents:** cloud_infra, microservices, frontend, design_ux, data_eng, devops, security, observability

## 🤖 Running Sub-Agent Analysis

### Cloud_Infra
- 3 Terraform modules analyzed
- 2 high-severity issues found
- Cost optimization: $500/mo potential savings

### Frontend
- React 18 + Next.js 14 detected
- Bundle size: 287KB (needs optimization)
- 12 accessibility issues

[... more agents ...]

## 🔗 Cross-Domain Validation

- **api_contract_mismatch** (high): Frontend expects /api/v2/users but backend only has /api/v1/users
- **design_drift** (medium): Button component has different border-radius in web vs design tokens

## 📋 Synthesized Findings

### 🔴 Critical (Fix Immediately)

- [security] Hardcoded AWS credentials in config/settings.py
  - **Impact:** Full AWS account compromise possible
  - **Fix:** Remove from code, use IAM roles, rotate keys

- [security] SQL injection in api/users.py:78
  - **Impact:** Database compromise
  - **Fix:** Use parameterized queries

### 🟠 High Priority (This Sprint)

- [frontend] Initial bundle 287KB exceeds 200KB target
- [microservices] No circuit breaker on payment service calls
- [observability] Missing correlation IDs
- [devops] No automated rollback configured

### 🟡 Medium (Next Sprint)

- [design_ux] 5 components have contrast issues
- [data_eng] fact_orders table breaching SLA
- [cloud_infra] RDS could use reserved instances
- [frontend] 47 TypeScript 'any' usages
[... 6 more items ...]

### 📅 Backlog

- 23 additional items

## 📊 Implementation Roadmap

| Week | Focus | Items |
|------|-------|-------|
| 1 | Security | Fix credentials, SQL injection |
| 2 | Reliability | Circuit breakers, rollback |
| 3 | Performance | Bundle optimization, SLAs |
| 4 | Quality | Design drift, TypeScript |
```

## Options

| Option | Description |
|--------|-------------|
| `--security-only` | Only run security agent |
| `--frontend-only` | Only run frontend stack agents |
| `--backend-only` | Only run backend stack agents |
| `--quick` | Skip low-priority analysis |
| `--output <file>` | Save report to file |
