# Frontend Audit Report Template

## Metadata

```yaml
report:
  type: frontend_audit
  generated: "{{timestamp}}"
  path: "{{analyzed_path}}"
  framework: "{{framework}}"
  health_score: {{health_score}}
```

---

# Frontend Audit Report

**Project:** {{project_name}}  
**Audited:** {{timestamp}}  
**Path:** `{{analyzed_path}}`

---

## Executive Summary

| Metric | Value | Status |
|--------|-------|--------|
| Overall Health | {{health_score}}/100 | {{health_status}} |
| Performance Score | {{perf_score}}/100 | {{perf_status}} |
| Accessibility Score | {{a11y_score}}/100 | {{a11y_status}} |
| Code Quality Score | {{quality_score}}/100 | {{quality_status}} |
| Security Score | {{security_score}}/100 | {{security_status}} |

### Key Metrics

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Initial Bundle | {{initial_bundle}} | < 200KB | {{bundle_status}} |
| LCP | {{lcp}} | < 2.5s | {{lcp_status}} |
| INP | {{inp}} | < 200ms | {{inp_status}} |
| CLS | {{cls}} | < 0.1 | {{cls_status}} |

---

## Technology Stack

### Framework

| Attribute | Value |
|-----------|-------|
| Framework | {{framework_name}} |
| Version | {{framework_version}} |
| Meta-framework | {{meta_framework}} |
| Rendering Strategy | {{rendering_strategy}} |

### Dependencies

| Category | Technology |
|----------|------------|
| State Management | {{state_management}} |
| Routing | {{routing}} |
| Styling | {{styling}} |
| Data Fetching | {{data_fetching}} |
| Testing | {{testing_framework}} |
| Build Tool | {{build_tool}} |

---

## Performance Analysis

### Bundle Analysis

**Total Bundle Size:** {{total_bundle_size}}  
**Initial Load:** {{initial_bundle}}  
**Code Split Chunks:** {{chunk_count}}

#### Largest Dependencies

| Package | Size | % of Bundle | Recommendation |
|---------|------|-------------|----------------|
{{#each largest_deps}}
| {{this.name}} | {{this.size}} | {{this.percentage}} | {{this.recommendation}} |
{{/each}}

#### Bundle Composition

```
{{bundle_composition_chart}}
```

### Core Web Vitals

| Metric | Value | Target | Status | Impact |
|--------|-------|--------|--------|--------|
| LCP (Largest Contentful Paint) | {{lcp}} | < 2.5s | {{lcp_status}} | {{lcp_impact}} |
| INP (Interaction to Next Paint) | {{inp}} | < 200ms | {{inp_status}} | {{inp_impact}} |
| CLS (Cumulative Layout Shift) | {{cls}} | < 0.1 | {{cls_status}} | {{cls_impact}} |
| TTFB (Time to First Byte) | {{ttfb}} | < 800ms | {{ttfb_status}} | {{ttfb_impact}} |
| FCP (First Contentful Paint) | {{fcp}} | < 1.8s | {{fcp_status}} | {{fcp_impact}} |

### Performance Issues

{{#each perf_issues}}
#### {{@index}}. {{this.title}}

- **Impact:** {{this.impact}}
- **Location:** `{{this.location}}`
- **Fix:** {{this.fix}}
- **Effort:** {{this.effort}}

{{/each}}

### Optimization Opportunities

| Opportunity | Potential Savings | Effort |
|-------------|-------------------|--------|
{{#each optimization_opportunities}}
| {{this.opportunity}} | {{this.savings}} | {{this.effort}} |
{{/each}}

---

## Code Quality

### TypeScript

| Metric | Value | Target |
|--------|-------|--------|
| TypeScript Enabled | {{ts_enabled}} | Yes |
| Strict Mode | {{ts_strict}} | Yes |
| `any` Usage | {{any_count}} | 0 |
| Type Coverage | {{type_coverage}} | > 90% |

### Patterns & Anti-Patterns

**Good Patterns Detected:**
{{#each good_patterns}}
- ✅ {{this}}
{{/each}}

**Anti-Patterns Detected:**
{{#each anti_patterns}}
- ⚠️ {{this.pattern}}
  - Location: `{{this.location}}`
  - Fix: {{this.fix}}
{{/each}}

### Testing

| Metric | Value | Target |
|--------|-------|--------|
| Test Files | {{test_file_count}} | - |
| Test Coverage | {{test_coverage}} | > 80% |
| Unit Tests | {{unit_test_count}} | - |
| Integration Tests | {{integration_test_count}} | - |
| E2E Tests | {{e2e_test_count}} | - |

### Linting & Formatting

| Tool | Status | Issues |
|------|--------|--------|
| ESLint | {{eslint_status}} | {{eslint_issues}} |
| Prettier | {{prettier_status}} | {{prettier_issues}} |
| TypeScript | {{tsc_status}} | {{tsc_issues}} |

---

## Accessibility (WCAG 2.1 AA)

### Compliance Summary

**Current Level:** {{wcag_level}}  
**Target Level:** AA

| Severity | Count | Examples |
|----------|-------|----------|
| Critical | {{a11y_critical}} | {{a11y_critical_examples}} |
| Serious | {{a11y_serious}} | {{a11y_serious_examples}} |
| Moderate | {{a11y_moderate}} | {{a11y_moderate_examples}} |
| Minor | {{a11y_minor}} | {{a11y_minor_examples}} |

### Issues by Category

{{#each a11y_categories}}
#### {{this.category}}

{{#each this.issues}}
- **{{this.rule}}** ({{this.wcag}})
  - Count: {{this.count}}
  - Example: `{{this.example}}`
  - Fix: {{this.fix}}
{{/each}}

{{/each}}

### Accessibility Checklist

| Requirement | Status | Notes |
|-------------|--------|-------|
| Color Contrast (4.5:1) | {{contrast_status}} | {{contrast_notes}} |
| Keyboard Navigation | {{keyboard_status}} | {{keyboard_notes}} |
| Focus Indicators | {{focus_status}} | {{focus_notes}} |
| Alt Text | {{alt_text_status}} | {{alt_text_notes}} |
| Form Labels | {{form_labels_status}} | {{form_labels_notes}} |
| ARIA Usage | {{aria_status}} | {{aria_notes}} |
| Semantic HTML | {{semantic_status}} | {{semantic_notes}} |
| Skip Links | {{skip_links_status}} | {{skip_links_notes}} |

---

## Design System Implementation

### Overview

| Attribute | Value |
|-----------|-------|
| Design System | {{design_system_name}} |
| Token Usage | {{token_usage}} |
| Component Coverage | {{component_coverage}} |

### Token Implementation

| Token Category | Defined | Implemented | Drift |
|----------------|---------|-------------|-------|
| Colors | {{colors_defined}} | {{colors_impl}} | {{colors_drift}} |
| Typography | {{type_defined}} | {{type_impl}} | {{type_drift}} |
| Spacing | {{spacing_defined}} | {{spacing_impl}} | {{spacing_drift}} |
| Shadows | {{shadows_defined}} | {{shadows_impl}} | {{shadows_drift}} |
| Borders | {{borders_defined}} | {{borders_impl}} | {{borders_drift}} |

### Design Drift Issues

{{#each design_drift}}
- **{{this.component}}**: {{this.issue}}
  - Design: {{this.design_value}}
  - Code: {{this.code_value}}
{{/each}}

---

## Security

### Client-Side Security

| Check | Status | Notes |
|-------|--------|-------|
| XSS Prevention | {{xss_status}} | {{xss_notes}} |
| CSP Configured | {{csp_status}} | {{csp_notes}} |
| HTTPS Only | {{https_status}} | {{https_notes}} |
| Secure Cookies | {{cookies_status}} | {{cookies_notes}} |
| Sensitive Data in localStorage | {{localstorage_status}} | {{localstorage_notes}} |

### Dependency Vulnerabilities

| Severity | Count |
|----------|-------|
| Critical | {{vuln_critical}} |
| High | {{vuln_high}} |
| Medium | {{vuln_medium}} |
| Low | {{vuln_low}} |

{{#if security_issues}}
### Security Issues

{{#each security_issues}}
- **{{this.issue}}**
  - Location: `{{this.location}}`
  - Risk: {{this.risk}}
  - Fix: {{this.fix}}
{{/each}}
{{/if}}

---

## API Integration

### Data Fetching

| Attribute | Value |
|-----------|-------|
| Library | {{data_fetching_lib}} |
| Caching Strategy | {{caching_strategy}} |
| Error Handling | {{error_handling}} |
| Loading States | {{loading_states}} |
| Optimistic Updates | {{optimistic_updates}} |

### API Issues

{{#each api_issues}}
- {{this}}
{{/each}}

---

## Recommendations

### 🔴 Critical

{{#each critical_recommendations}}
{{@index}}. **{{this.issue}}**
   - Impact: {{this.impact}}
   - Fix: {{this.fix}}
   - Effort: {{this.effort}}
   - Files: {{this.files}}

{{/each}}

### 🟠 High Priority

{{#each high_recommendations}}
{{@index}}. **{{this.issue}}**
   - Fix: {{this.fix}}
   - Effort: {{this.effort}}

{{/each}}

### 🟡 Medium

{{#each medium_recommendations}}
- {{this.issue}} ({{this.effort}})
{{/each}}

### 📅 Backlog

{{#each low_recommendations}}
- {{this.issue}}
{{/each}}

---

## Implementation Roadmap

| Phase | Focus | Tasks | Est. Effort |
|-------|-------|-------|-------------|
{{#each roadmap}}
| {{this.phase}} | {{this.focus}} | {{this.tasks}} | {{this.effort}} |
{{/each}}

---

## Appendix

### Files Analyzed

- Components: {{component_count}}
- Pages: {{page_count}}
- Utilities: {{util_count}}
- Tests: {{test_count}}
- Total: {{total_files}}

### Tool Versions

| Tool | Version |
|------|---------|
{{#each tool_versions}}
| {{this.tool}} | {{this.version}} |
{{/each}}

---

*Generated by RLM Frontend Agent v1.0*
