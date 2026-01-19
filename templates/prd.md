# Product Requirements Document

## Metadata

| Field | Value |
|-------|-------|
| **Title** | {{product_title}} |
| **Version** | {{version}} |
| **Author** | {{author}} |
| **Status** | {{status}} |
| **Last Updated** | {{date}} |
| **Stakeholders** | {{stakeholders}} |

---

## Overview

### Problem Statement

> Short description of the problem we're solving. What pain exists? Who feels it? What's the cost of not solving it?

{{problem_statement}}

### Solution Summary

> What are we building to solve this problem? High-level description, no implementation details.

{{solution_summary}}

### Strategic Alignment

> How does this fit with company strategy, mission, or existing product roadmap?

{{strategic_alignment}}

---

## Goals

> Specific objectives this product must achieve. Measurable where possible. No implementation details.

{{#each goals}}
- {{this}}
{{/each}}

---

## Non-Goals

> Explicit statements of what this product will NOT do. Prevents scope creep and clarifies boundaries.

{{#each non_goals}}
- {{this}}
{{/each}}

---

## Audience

### Primary Persona: {{persona_name}}

**Demographics:** {{demographics}}

**Description:**
{{persona_description}}

**Needs:**
{{#each persona_needs}}
- {{this}}
{{/each}}

**Pain Points:**
{{#each persona_pain_points}}
- {{this}}
{{/each}}

### Secondary Personas

{{#each secondary_personas}}
#### {{this.name}}

{{this.description}}

{{/each}}

---

## Existing Solutions & Issues

> Analysis of current options and why they're insufficient.

{{#each existing_solutions}}
### {{this.name}}

**What it does:** {{this.description}}

**Issues:**
{{#each this.issues}}
- {{this}}
{{/each}}

{{/each}}

---

## Assumptions

> Things we're taking as given. **Every assumption must link to research evidence.**

### User Assumptions

{{#each user_assumptions}}
- {{this.assumption}}
  - *Evidence:* [{{this.evidence_source}}]({{this.evidence_link}})
{{/each}}

### Technical Assumptions

{{#each technical_assumptions}}
- {{this.assumption}}
  - *Status:* {{this.validation_status}}
{{/each}}

### Market Assumptions

{{#each market_assumptions}}
- {{this.assumption}}
  - *Evidence:* [{{this.evidence_source}}]({{this.evidence_link}})
{{/each}}

---

## Constraints

> Limitations that bound our solution space.

### Technical Constraints

{{#each technical_constraints}}
- {{this}}
{{/each}}

### Business Constraints

{{#each business_constraints}}
- {{this}}
{{/each}}

### Timeline Constraints

{{timeline_constraints}}

### Resource Constraints

{{#each resource_constraints}}
- {{this}}
{{/each}}

---

## Key Use Cases

> The core scenarios in which users interact with the product.

{{#each use_cases}}
### {{@index}}. {{this.title}}

**Actor:** {{this.actor}}

**Preconditions:**
{{#each this.preconditions}}
- {{this}}
{{/each}}

**Flow:**
{{#each this.flow}}
{{@index}}. {{this}}
{{/each}}

**Postconditions:**
{{#each this.postconditions}}
- {{this}}
{{/each}}

**Acceptance Criteria:**
{{#each this.acceptance_criteria}}
- [ ] {{this}}
{{/each}}

---

{{/each}}

## Requirements

### Functional Requirements

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|---------------------|
{{#each functional_requirements}}
| {{this.id}} | {{this.description}} | {{this.priority}} | {{this.acceptance_criteria}} |
{{/each}}

### Non-Functional Requirements

| Category | Requirement | Target |
|----------|-------------|--------|
{{#each non_functional_requirements}}
| {{this.category}} | {{this.requirement}} | {{this.target}} |
{{/each}}

---

## Success Metrics

> How we know if we've succeeded. Must be measurable.

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
{{#each success_metrics}}
| {{this.metric}} | {{this.target}} | {{this.measurement}} |
{{/each}}

---

## Research

### User Research

> Key questions and findings from user interviews, surveys, and analytics.

{{#each user_research}}
#### {{this.question}}

{{this.finding}}

*Source:* {{this.source}}

{{/each}}

### Technical Research

> Feasibility studies, architecture decisions, and technical validation.

{{#each technical_research}}
#### {{this.question}}

{{this.finding}}

*Status:* {{this.status}}

{{/each}}

### Open Questions

> Things we still need to figure out.

{{#each open_questions}}
- [ ] {{this}}
{{/each}}

---

## Timeline

| Phase | Duration | Deliverables |
|-------|----------|--------------|
{{#each timeline}}
| {{this.phase}} | {{this.duration}} | {{this.deliverables}} |
{{/each}}

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
{{#each risks}}
| {{this.risk}} | {{this.likelihood}} | {{this.impact}} | {{this.mitigation}} |
{{/each}}

---

## Appendix

### Glossary

{{#each glossary}}
- **{{this.term}}**: {{this.definition}}
{{/each}}

### References

{{#each references}}
- [{{this.title}}]({{this.link}})
{{/each}}

### Related Documents

{{#each related_docs}}
- [{{this.title}}]({{this.link}})
{{/each}}

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
{{#each version_history}}
| {{this.version}} | {{this.date}} | {{this.author}} | {{this.changes}} |
{{/each}}

---

## Approvals

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product Lead | | | |
| Engineering Lead | | | |
| Design Lead | | | |
| Executive Sponsor | | | |

---

*Generated by RLM Product Manager Agent*
