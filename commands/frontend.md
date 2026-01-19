# Command: /rlm frontend

## Usage

```
/rlm frontend [path]
/rlm frontend ./src
/rlm frontend (uses current directory)
```

## Description

Deep analysis of web frontend code focusing on performance, code quality, accessibility, and design system implementation.

## Agents Invoked

1. **frontend** (primary) - Framework, bundle, performance, code quality
2. **design_ux** - Design system implementation, accessibility
3. **security** - Client-side security (XSS, CSP)
4. **observability** - RUM coverage, error tracking

## Workflow

```python
def execute_frontend_audit(path="."):
    """
    Frontend-focused analysis workflow.
    """
    
    # Phase 1: Framework Detection
    print("## 🎨 Frontend Analysis\n")
    
    framework = detect_framework(path)
    print(f"**Framework:** {framework.name} {framework.version}")
    print(f"**Meta-framework:** {framework.meta or 'None'}")
    print(f"**Rendering:** {framework.rendering}")
    print()
    
    # Phase 2: Performance Deep-Dive
    print("### ⚡ Performance Analysis\n")
    
    bundle = analyze_bundle(path)
    print(f"**Initial Bundle:** {bundle.initial_size}")
    print(f"**Total Size:** {bundle.total_size}")
    print(f"**Chunks:** {bundle.chunk_count}")
    print()
    
    print("**Largest Dependencies:**")
    for dep in bundle.largest_deps[:5]:
        print(f"- {dep.name}: {dep.size}")
    
    if bundle.issues:
        print("\n**⚠️ Issues:**")
        for issue in bundle.issues:
            print(f"- {issue}")
    
    # Phase 3: Code Quality
    print("\n### 📝 Code Quality\n")
    
    quality = analyze_code_quality(path)
    print(f"**TypeScript:** {'Strict' if quality.ts_strict else 'Loose' if quality.ts_enabled else 'None'}")
    print(f"**Test Coverage:** {quality.test_coverage}")
    print(f"**Any Usage:** {quality.any_count} instances")
    print(f"**ESLint Issues:** {quality.lint_issues}")
    
    # Phase 4: Accessibility
    print("\n### ♿ Accessibility\n")
    
    a11y = analyze_accessibility(path)
    print(f"**WCAG Level:** {a11y.wcag_level}")
    print(f"**Automated Issues:** {a11y.issue_count}")
    
    if a11y.issues:
        print("\n**Issues by Severity:**")
        for severity, issues in a11y.issues_by_severity.items():
            print(f"- {severity}: {len(issues)}")
    
    # Phase 5: Design System
    print("\n### 🎯 Design System Implementation\n")
    
    design = analyze_design_implementation(path)
    print(f"**Design System:** {design.name or 'None detected'}")
    print(f"**Token Usage:** {design.token_usage}")
    
    if design.drift:
        print("\n**⚠️ Design Drift:**")
        for item in design.drift[:5]:
            print(f"- {item}")
    
    # Phase 6: Security
    print("\n### 🔒 Client-Side Security\n")
    
    security = analyze_frontend_security(path)
    print(f"**XSS Prevention:** {security.xss_status}")
    print(f"**CSP Configured:** {security.csp}")
    print(f"**Vulnerable Dependencies:** {security.vuln_count}")
    
    # Phase 7: Recommendations
    print("\n## 📋 Recommendations\n")
    
    all_recommendations = collect_recommendations([
        frontend_findings, design_findings, security_findings
    ])
    
    for priority in ['critical', 'high', 'medium', 'low']:
        recs = [r for r in all_recommendations if r['priority'] == priority]
        if recs:
            print(f"\n### {priority.title()}\n")
            for rec in recs:
                print(f"- **{rec['issue']}**")
                print(f"  - Fix: {rec['fix']}")
                print(f"  - Effort: {rec['effort']}")
```

## Output Template

```markdown
## 🎨 Frontend Analysis

**Framework:** React 18.2.0
**Meta-framework:** Next.js 14.1
**Rendering:** Hybrid (SSR + CSR)

### ⚡ Performance Analysis

**Initial Bundle:** 287KB ⚠️ (target: <200KB)
**Total Size:** 1.2MB
**Chunks:** 23

**Largest Dependencies:**
- lodash: 72KB (use lodash-es)
- moment: 67KB (use date-fns)
- @mui/material: 145KB (tree-shake)

**Core Web Vitals:**
| Metric | Value | Status |
|--------|-------|--------|
| LCP | 2.8s | ⚠️ Needs Work |
| INP | 180ms | ✅ Good |
| CLS | 0.05 | ✅ Good |

**⚠️ Issues:**
- No code splitting for routes
- Images not using next/image
- Missing font preloading

### 📝 Code Quality

**TypeScript:** Loose (strict: false)
**Test Coverage:** 62%
**Any Usage:** 47 instances
**ESLint Issues:** 12

**Patterns Detected:**
- ✓ React Query for data fetching
- ✓ Error boundaries present
- ⚠️ Prop drilling in 3 components
- ⚠️ useEffect with empty deps (potential bugs)

### ♿ Accessibility

**WCAG Level:** A (Target: AA)
**Automated Issues:** 28

**Issues by Severity:**
- Critical: 3 (missing form labels)
- Serious: 8 (color contrast)
- Moderate: 12 (missing alt text)
- Minor: 5 (link text)

### 🎯 Design System Implementation

**Design System:** Acme UI
**Token Usage:** Partial

**⚠️ Design Drift:**
- Button border-radius: design=8px, code=4px
- Primary color: design=#0066CC, code=#0055BB
- Spacing scale not followed in Card component

### 🔒 Client-Side Security

**XSS Prevention:** Partial ⚠️
**CSP Configured:** No ❌
**Vulnerable Dependencies:** 3

**Issues:**
- dangerouslySetInnerHTML in Comment.tsx:23
- Missing CSP headers
- lodash 4.17.15 has known vulnerabilities

## 📋 Recommendations

### Critical

- **Fix form labels for accessibility**
  - Fix: Add htmlFor to labels, associate with inputs
  - Effort: Low

- **Address XSS risk in Comment component**
  - Fix: Sanitize HTML with DOMPurify
  - Effort: Low

### High

- **Reduce initial bundle size by 40%**
  - Fix: Replace lodash/moment, enable tree-shaking
  - Effort: Medium

- **Implement Content Security Policy**
  - Fix: Add CSP headers via middleware
  - Effort: Medium

### Medium

- **Enable TypeScript strict mode**
  - Fix: Update tsconfig, fix type errors
  - Effort: High

- **Fix color contrast issues**
  - Fix: Adjust secondary text color
  - Effort: Low
```

## Performance Targets

| Metric | Target | Action if Exceeded |
|--------|--------|-------------------|
| Initial Bundle | < 200KB | Code split, analyze deps |
| LCP | < 2.5s | Optimize images, preload |
| INP | < 200ms | Reduce JS execution |
| CLS | < 0.1 | Reserve space for async |
| Lighthouse | > 90 | Address all issues |
