# Command: /rlm implement

## Usage

```
/rlm implement <prd-path>
/rlm implement ./docs/prd-voice-ordering.md
/rlm implement ./specs/feature-auth-redesign.md
/rlm implement <prd-path> --dry-run
/rlm implement <prd-path> --phase <phase-number>
```

## Description

Orchestrates the full implementation of a Product Requirements Document (PRD). Analyzes the PRD to extract requirements, detects existing codebase structure, creates an implementation plan, and coordinates multiple specialist agents to build out the feature across all necessary layers (frontend, backend, infrastructure, etc.).

## Options

| Option | Description |
|--------|-------------|
| (default) | Full implementation from PRD |
| `--dry-run` | Generate implementation plan without making changes |
| `--phase <n>` | Execute only a specific phase of the plan |
| `--resume` | Resume from last checkpoint |
| `--skip-tests` | Skip test generation (not recommended) |
| `--skip-review` | Skip security/quality review phase |
| `--output <dir>` | Custom output directory for generated files |

## Agents Invoked

**Always invoked:**
1. **orchestrator** - Coordinates workflow, manages agent handoffs
2. **security** - Reviews implementation for vulnerabilities
3. **observability** - Ensures monitoring/logging is added

**Conditionally invoked based on PRD requirements:**
4. **frontend** - Web UI components and pages
5. **mobile** - iOS/Android implementations
6. **microservices** - Backend APIs and services
7. **cloud_infra** - Infrastructure provisioning (Terraform, K8s)
8. **design_ux** - Design system components, accessibility
9. **data_eng** - Data pipelines, database schemas
10. **aiml** - ML models, AI integrations
11. **devops** - CI/CD pipelines, deployment configs

## Agent Invocation

**CRITICAL: You MUST use the Task tool to invoke RLM sub-agents.**

Each specialized agent (frontend, microservices, cloud_infra, etc.) must be invoked using:

```python
Task(
    subagent_type="general-purpose",
    description=f"RLM {agent_name} implementation",
    prompt=f"""
You are the {agent_name} agent from the RLM Multi-Agent System.

## Your Agent Definition
{read('.claude/agents/rlm/{agent_name}.md')}

## Mode: IMPLEMENTATION

## Requirements from PRD
{extracted_requirements}

## Existing Codebase Patterns
{detected_patterns}

## Your Task
{specific_implementation_task}

## Output Format
Implement the code, then provide a summary in YAML:
```yaml
files_created:
  - path: "..."
    description: "..."
files_modified:
  - path: "..."
    changes: "..."
```
"""
)
```

**Parallel Invocation**: When agents don't depend on each other (e.g., frontend and mobile both depend on API but not each other), invoke them in parallel with multiple Task calls in ONE message.

**Sequential Invocation**: When one agent's output is needed by another (e.g., data_eng → microservices → frontend), wait for each to complete before the next.

## Workflow

```python
def execute_implement(prd_path, options=None):
    """
    PRD implementation orchestration workflow.

    IMPORTANT: Use Task tool with subagent_type="general-purpose" to invoke
    each RLM agent. Read the agent definition and include it in the prompt.
    """

    print("## 🚀 PRD Implementation\n")
    print(f"**PRD:** {prd_path}")
    print(f"**Started:** {timestamp()}")
    print()

    # Phase 1: PRD Analysis
    print("### Phase 1: PRD Analysis\n")

    prd = parse_prd(prd_path)

    print(f"**Product:** {prd.title}")
    print(f"**Goals:** {len(prd.goals)}")
    print(f"**Requirements:** {len(prd.requirements.functional)} functional, {len(prd.requirements.non_functional)} non-functional")
    print(f"**Use Cases:** {len(prd.use_cases)}")

    # Extract implementation signals
    signals = extract_implementation_signals(prd)
    print(f"\n**Implementation Signals:**")
    for signal in signals:
        print(f"- {signal.category}: {signal.description}")

    # Phase 2: Codebase Discovery
    print("\n### Phase 2: Codebase Discovery\n")

    codebase = scan_codebase(".")

    print(f"**Existing Structure:**")
    print(f"- Languages: {', '.join(codebase.languages)}")
    print(f"- Frameworks: {', '.join(codebase.frameworks)}")
    print(f"- Has Frontend: {'✓' if codebase.has_frontend else '✗'}")
    print(f"- Has Backend: {'✓' if codebase.has_backend else '✗'}")
    print(f"- Has Mobile: {'✓' if codebase.has_mobile else '✗'}")
    print(f"- Has Infrastructure: {'✓' if codebase.has_infra else '✗'}")

    # Identify patterns to follow
    patterns = detect_patterns(codebase)
    print(f"\n**Detected Patterns:**")
    for pattern in patterns:
        print(f"- {pattern.name}: {pattern.example_file}")

    # Phase 3: Implementation Planning
    print("\n### Phase 3: Implementation Planning\n")

    # Map requirements to implementation tasks
    tasks = map_requirements_to_tasks(prd.requirements, codebase)

    print(f"**Total Tasks:** {len(tasks)}")

    # Group by domain
    by_domain = group_by_domain(tasks)
    for domain, domain_tasks in by_domain.items():
        print(f"- {domain}: {len(domain_tasks)} tasks")

    # Determine execution order (dependencies)
    phases = create_execution_phases(tasks)

    print(f"\n**Execution Phases:** {len(phases)}")
    for i, phase in enumerate(phases, 1):
        print(f"\n**Phase {i}: {phase.name}**")
        print(f"- Agents: {', '.join(phase.agents)}")
        print(f"- Tasks: {len(phase.tasks)}")
        for task in phase.tasks[:3]:
            print(f"  - {task.title}")
        if len(phase.tasks) > 3:
            print(f"  - ... and {len(phase.tasks) - 3} more")

    # Dry run stops here
    if options and options.dry_run:
        print("\n---")
        print("**Dry run complete.** No changes made.")
        return generate_plan_document(phases)

    # Phase 4: Schema & Data Layer
    print("\n### Phase 4: Schema & Data Layer\n")

    if 'data_eng' in by_domain or needs_database_changes(prd):
        print("*Implementing database schemas and migrations...*\n")

        # Read the data_eng agent definition
        data_eng_def = read('.claude/agents/rlm/data-eng.md')
        data_context = filter_context_for_agent('data_eng', codebase)

        # INVOKE USING TASK TOOL - this is the actual invocation
        data_findings = Task(
            subagent_type="general-purpose",
            description="RLM data_eng implementation",
            prompt=f"""
You are the data_eng agent from the RLM Multi-Agent System.

## Your Agent Definition
{data_eng_def}

## Mode: IMPLEMENTATION

## Requirements
{extract_data_requirements(prd)}

## Existing Schemas
{data_context.schemas}

## Existing Patterns to Follow
{patterns.data_patterns}

## Your Task
1. Create database migrations for new tables/columns needed
2. Create/update data models
3. Follow existing patterns in the codebase
4. Output YAML summary of changes

## Output Format
After implementing, provide:
```yaml
migrations:
  - name: "..."
    file: "..."
models:
  - name: "..."
    file: "..."
```
"""
        )

        print(f"✓ Created {len(data_findings.migrations)} migrations")
        print(f"✓ Updated {len(data_findings.models)} models")
        for migration in data_findings.migrations:
            print(f"  - {migration.name}")
    else:
        print("*No database changes required.*")

    # Phase 5: API & Backend Services
    print("\n### Phase 5: API & Backend Services\n")

    if 'microservices' in by_domain:
        print("*Implementing backend APIs and services...*\n")

        api_context = filter_context_for_agent('microservices', codebase)
        api_findings = execute_agent('microservices', {
            'mode': 'implement',
            'requirements': extract_api_requirements(prd),
            'existing_apis': api_context.apis,
            'patterns': patterns.api_patterns,
            'data_models': data_findings.models if 'data_findings' in locals() else None
        })

        print(f"✓ Created {len(api_findings.endpoints)} endpoints")
        print(f"✓ Updated {len(api_findings.services)} services")
        for endpoint in api_findings.endpoints[:5]:
            print(f"  - {endpoint.method} {endpoint.path}")
        if len(api_findings.endpoints) > 5:
            print(f"  - ... and {len(api_findings.endpoints) - 5} more")
    else:
        print("*No backend changes required.*")

    # Phase 6: Infrastructure
    print("\n### Phase 6: Infrastructure\n")

    if 'cloud_infra' in by_domain:
        print("*Provisioning infrastructure...*\n")

        infra_context = filter_context_for_agent('cloud_infra', codebase)
        infra_findings = execute_agent('cloud_infra', {
            'mode': 'implement',
            'requirements': extract_infra_requirements(prd),
            'existing_infra': infra_context.resources,
            'patterns': patterns.infra_patterns
        })

        print(f"✓ Created {len(infra_findings.resources)} resources")
        for resource in infra_findings.resources:
            print(f"  - {resource.type}: {resource.name}")
    else:
        print("*No infrastructure changes required.*")

    # Phase 7 & 8: Frontend & Mobile Implementation (PARALLEL)
    # These can run in parallel since they both depend on API but not each other
    print("\n### Phase 7 & 8: Frontend & Mobile Implementation\n")

    parallel_tasks = []

    if 'frontend' in by_domain:
        print("*Launching frontend agent...*")

        frontend_def = read('.claude/agents/rlm/frontend.md')
        frontend_context = filter_context_for_agent('frontend', codebase)

        # This Task call runs in PARALLEL with mobile below
        parallel_tasks.append(Task(
            subagent_type="general-purpose",
            description="RLM frontend implementation",
            prompt=f"""
You are the frontend agent from the RLM Multi-Agent System.

## Your Agent Definition
{frontend_def}

## Mode: IMPLEMENTATION

## Requirements
{extract_frontend_requirements(prd)}

## Use Cases to Implement
{prd.use_cases}

## Existing Components
{frontend_context.components}

## Design Tokens
{get_design_tokens(codebase)}

## API Contracts (from microservices phase)
{api_findings.contracts if 'api_findings' in locals() else 'N/A'}

## Patterns to Follow
{patterns.frontend_patterns}

## Your Task
1. Create React/Vue/etc components for the UI
2. Create pages/routes for each use case
3. Connect to API endpoints
4. Follow existing patterns and design tokens
5. Output YAML summary

## Output Format
```yaml
components:
  - name: "..."
    file: "..."
pages:
  - route: "..."
    file: "..."
modified:
  - file: "..."
    changes: "..."
```
"""
        ))

    if 'mobile' in by_domain:
        print("*Launching mobile agent...*")

        mobile_def = read('.claude/agents/rlm/mobile.md')
        mobile_context = filter_context_for_agent('mobile', codebase)

        # This Task call runs in PARALLEL with frontend above
        parallel_tasks.append(Task(
            subagent_type="general-purpose",
            description="RLM mobile implementation",
            prompt=f"""
You are the mobile agent from the RLM Multi-Agent System.

## Your Agent Definition
{mobile_def}

## Mode: IMPLEMENTATION

## Requirements
{extract_mobile_requirements(prd)}

## Use Cases to Implement
{prd.use_cases}

## Existing Screens
{mobile_context.screens}

## API Contracts (from microservices phase)
{api_findings.contracts if 'api_findings' in locals() else 'N/A'}

## Patterns to Follow
{patterns.mobile_patterns}

## Your Task
1. Create mobile screens for each use case
2. Create reusable components
3. Connect to API endpoints
4. Follow existing patterns (React Native/Flutter/Swift/Kotlin)
5. Output YAML summary

## Output Format
```yaml
screens:
  - name: "..."
    file: "..."
components:
  - name: "..."
    file: "..."
```
"""
        ))

    # Wait for parallel tasks to complete
    # The Task tool returns results when agents finish

    if 'frontend' in by_domain and parallel_tasks:
        frontend_findings = parallel_tasks[0]  # First result
        print(f"✓ Created {len(frontend_findings.components)} components")
        print(f"✓ Created {len(frontend_findings.pages)} pages")
        print(f"✓ Updated {len(frontend_findings.modified)} existing files")

    if 'mobile' in by_domain and len(parallel_tasks) > 1:
        mobile_findings = parallel_tasks[-1]  # Last result
        print(f"✓ Created {len(mobile_findings.screens)} screens")
        print(f"✓ Created {len(mobile_findings.components)} components")

    if not parallel_tasks:
        print("*No frontend or mobile changes required.*")

    # Phase 9: Design System Updates
    print("\n### Phase 9: Design System Updates\n")

    if 'design_ux' in by_domain:
        print("*Updating design system components...*\n")

        design_context = filter_context_for_agent('design_ux', codebase)
        design_findings = execute_agent('design_ux', {
            'mode': 'implement',
            'requirements': extract_design_requirements(prd),
            'existing_tokens': design_context.tokens,
            'existing_components': design_context.components,
            'patterns': patterns.design_patterns
        })

        print(f"✓ Updated {len(design_findings.tokens)} tokens")
        print(f"✓ Created {len(design_findings.components)} design components")
    else:
        print("*No design system changes required.*")

    # Phase 10: AI/ML Components
    print("\n### Phase 10: AI/ML Components\n")

    if 'aiml' in by_domain:
        print("*Implementing AI/ML components...*\n")

        aiml_context = filter_context_for_agent('aiml', codebase)
        aiml_findings = execute_agent('aiml', {
            'mode': 'implement',
            'requirements': extract_aiml_requirements(prd),
            'existing_models': aiml_context.models,
            'patterns': patterns.aiml_patterns
        })

        print(f"✓ Created {len(aiml_findings.models)} models")
        print(f"✓ Created {len(aiml_findings.pipelines)} pipelines")
    else:
        print("*No AI/ML components required.*")

    # Phase 11: Observability Setup
    print("\n### Phase 11: Observability Setup\n")

    print("*Adding monitoring, logging, and tracing...*\n")

    obs_context = filter_context_for_agent('observability', codebase)
    obs_findings = execute_agent('observability', {
        'mode': 'implement',
        'requirements': prd.requirements.non_functional,
        'success_metrics': prd.metrics,
        'new_endpoints': api_findings.endpoints if 'api_findings' in locals() else [],
        'new_components': frontend_findings.components if 'frontend_findings' in locals() else [],
        'patterns': patterns.observability_patterns
    })

    print(f"✓ Added {len(obs_findings.metrics)} metrics")
    print(f"✓ Added {len(obs_findings.dashboards)} dashboard configs")
    print(f"✓ Added {len(obs_findings.alerts)} alert rules")

    # Phase 12: Test Generation
    print("\n### Phase 12: Test Generation\n")

    if not (options and options.skip_tests):
        print("*Generating tests for new code...*\n")

        all_new_files = collect_all_new_files([
            data_findings if 'data_findings' in locals() else None,
            api_findings if 'api_findings' in locals() else None,
            frontend_findings if 'frontend_findings' in locals() else None,
            mobile_findings if 'mobile_findings' in locals() else None,
        ])

        test_findings = generate_tests(all_new_files, prd.use_cases)

        print(f"✓ Generated {len(test_findings.unit_tests)} unit tests")
        print(f"✓ Generated {len(test_findings.integration_tests)} integration tests")
        print(f"✓ Generated {len(test_findings.e2e_tests)} E2E tests")
    else:
        print("*Skipped test generation (--skip-tests)*")

    # Phase 13: CI/CD Updates
    print("\n### Phase 13: CI/CD Updates\n")

    if 'devops' in by_domain or has_new_services(api_findings if 'api_findings' in locals() else None):
        print("*Updating CI/CD pipelines...*\n")

        devops_context = filter_context_for_agent('devops', codebase)
        devops_findings = execute_agent('devops', {
            'mode': 'implement',
            'new_services': api_findings.services if 'api_findings' in locals() else [],
            'new_infra': infra_findings.resources if 'infra_findings' in locals() else [],
            'test_suites': test_findings if 'test_findings' in locals() else None,
            'patterns': patterns.devops_patterns
        })

        print(f"✓ Updated {len(devops_findings.pipelines)} pipelines")
        print(f"✓ Created {len(devops_findings.workflows)} workflows")
    else:
        print("*No CI/CD updates required.*")

    # Phase 14: Security Review
    print("\n### Phase 14: Security Review\n")

    if not (options and options.skip_review):
        print("*Running security review on new code...*\n")

        all_changes = collect_all_changes([
            data_findings if 'data_findings' in locals() else None,
            api_findings if 'api_findings' in locals() else None,
            frontend_findings if 'frontend_findings' in locals() else None,
            infra_findings if 'infra_findings' in locals() else None,
        ])

        security_review = execute_agent('security', {
            'mode': 'review',
            'changes': all_changes,
            'requirements': prd.requirements
        })

        if security_review.critical_issues:
            print(f"⚠️ **{len(security_review.critical_issues)} critical issues found:**")
            for issue in security_review.critical_issues:
                print(f"  - {issue.file}: {issue.description}")
            print("\n*Attempting auto-remediation...*")
            remediate_security_issues(security_review.critical_issues)
        else:
            print("✓ No critical security issues found")

        if security_review.warnings:
            print(f"\n**{len(security_review.warnings)} warnings:**")
            for warning in security_review.warnings[:5]:
                print(f"  - {warning.description}")
    else:
        print("*Skipped security review (--skip-review)*")

    # Phase 15: Cross-Domain Validation
    print("\n### Phase 15: Cross-Domain Validation\n")

    all_findings = {
        'data': data_findings if 'data_findings' in locals() else None,
        'api': api_findings if 'api_findings' in locals() else None,
        'frontend': frontend_findings if 'frontend_findings' in locals() else None,
        'mobile': mobile_findings if 'mobile_findings' in locals() else None,
        'infra': infra_findings if 'infra_findings' in locals() else None,
        'design': design_findings if 'design_findings' in locals() else None,
    }

    validations = validate_cross_domain(all_findings)

    if validations.issues:
        print(f"**{len(validations.issues)} integration issues found:**")
        for issue in validations.issues:
            print(f"- [{issue.severity}] {issue.description}")
            print(f"  Between: {issue.source_agent} ↔ {issue.target_agent}")
    else:
        print("✓ All cross-domain validations passed")

    # Phase 16: Summary
    print("\n## 📋 Implementation Summary\n")

    summary = generate_summary(all_findings)

    print(f"**Files Created:** {summary.files_created}")
    print(f"**Files Modified:** {summary.files_modified}")
    print(f"**Lines of Code:** {summary.lines_added}")
    print(f"**Tests Generated:** {summary.tests_generated}")

    print("\n### Created Artifacts\n")

    print("**Backend:**")
    if 'api_findings' in locals():
        for endpoint in api_findings.endpoints:
            print(f"- `{endpoint.method} {endpoint.path}` - {endpoint.description}")

    print("\n**Frontend:**")
    if 'frontend_findings' in locals():
        for page in frontend_findings.pages:
            print(f"- `{page.route}` - {page.description}")

    print("\n**Database:**")
    if 'data_findings' in locals():
        for migration in data_findings.migrations:
            print(f"- `{migration.name}`")

    # PRD Requirement Coverage
    print("\n### PRD Requirement Coverage\n")

    coverage = calculate_coverage(prd.requirements, all_findings)

    print(f"**Functional Requirements:** {coverage.functional}% covered")
    print(f"**Non-Functional Requirements:** {coverage.non_functional}% covered")

    if coverage.gaps:
        print("\n**Gaps (manual implementation needed):**")
        for gap in coverage.gaps:
            print(f"- {gap.requirement_id}: {gap.description}")

    # Next Steps
    print("\n### Next Steps\n")

    print("1. Review generated code and make adjustments")
    print("2. Run test suite: `npm test` / `pytest` / `go test`")
    print("3. Review database migrations before applying")
    print("4. Update environment variables as needed")
    print("5. Deploy to staging environment")
    print("6. Conduct QA testing against PRD use cases")

    print("\n---")
    print(f"**Implementation complete.** {timestamp()}")

    return summary
```

## Implementation Signal Detection

The command analyzes the PRD to detect what needs to be built:

```yaml
signal_patterns:
  frontend:
    keywords:
      - "user interface"
      - "UI"
      - "dashboard"
      - "form"
      - "page"
      - "screen"
      - "component"
      - "button"
      - "modal"
    use_case_patterns:
      - "user sees"
      - "user clicks"
      - "user enters"
      - "displays"
      - "shows"

  backend:
    keywords:
      - "API"
      - "endpoint"
      - "service"
      - "server"
      - "authentication"
      - "authorization"
      - "webhook"
    use_case_patterns:
      - "system processes"
      - "validates"
      - "stores"
      - "retrieves"
      - "sends notification"

  mobile:
    keywords:
      - "mobile app"
      - "iOS"
      - "Android"
      - "push notification"
      - "native"
      - "React Native"
      - "Flutter"
    use_case_patterns:
      - "on mobile"
      - "native experience"

  database:
    keywords:
      - "store"
      - "persist"
      - "database"
      - "schema"
      - "table"
      - "migration"
      - "data model"
    use_case_patterns:
      - "saved to"
      - "retrieved from"
      - "historical data"

  infrastructure:
    keywords:
      - "scale"
      - "deploy"
      - "hosting"
      - "CDN"
      - "load balancer"
      - "container"
      - "kubernetes"
    nfr_patterns:
      - "availability"
      - "uptime"
      - "concurrent users"

  aiml:
    keywords:
      - "AI"
      - "ML"
      - "machine learning"
      - "model"
      - "prediction"
      - "recommendation"
      - "natural language"
      - "LLM"
    use_case_patterns:
      - "AI suggests"
      - "predicts"
      - "recommends"
      - "classifies"
```

## Execution Phase Templates

```yaml
phase_templates:

  data_first:
    description: "Database and data model changes"
    agents: [data_eng]
    prerequisites: []
    outputs: [migrations, models, schemas]

  api_layer:
    description: "Backend API implementation"
    agents: [microservices]
    prerequisites: [data_first]
    outputs: [endpoints, services, contracts]

  infrastructure:
    description: "Cloud infrastructure provisioning"
    agents: [cloud_infra]
    prerequisites: [api_layer]
    outputs: [resources, configs]

  frontend_ui:
    description: "Web frontend implementation"
    agents: [frontend, design_ux]
    prerequisites: [api_layer]
    outputs: [components, pages, styles]

  mobile_ui:
    description: "Mobile app implementation"
    agents: [mobile]
    prerequisites: [api_layer]
    outputs: [screens, components]

  ml_components:
    description: "AI/ML model integration"
    agents: [aiml]
    prerequisites: [data_first, api_layer]
    outputs: [models, pipelines, integrations]

  observability:
    description: "Monitoring and logging"
    agents: [observability]
    prerequisites: [api_layer, frontend_ui, mobile_ui]
    outputs: [metrics, dashboards, alerts]

  testing:
    description: "Test generation"
    agents: [orchestrator]
    prerequisites: [all_implementation_phases]
    outputs: [unit_tests, integration_tests, e2e_tests]

  cicd:
    description: "CI/CD pipeline updates"
    agents: [devops]
    prerequisites: [testing]
    outputs: [workflows, pipelines]

  security_review:
    description: "Security audit of changes"
    agents: [security]
    prerequisites: [all_phases]
    outputs: [findings, remediations]
```

## Output Template

```markdown
# Implementation Report

## Metadata

| Field | Value |
|-------|-------|
| **PRD** | AI-Powered Voice Ordering |
| **Started** | 2025-01-19 10:00:00 |
| **Completed** | 2025-01-19 11:45:00 |
| **Status** | Complete |

---

## Implementation Summary

| Metric | Value |
|--------|-------|
| Files Created | 47 |
| Files Modified | 12 |
| Lines Added | 3,842 |
| Tests Generated | 89 |
| Migrations Created | 3 |
| API Endpoints | 8 |

---

## Phases Executed

### Phase 1: Data Layer
- Created `migrations/20250119_create_orders_table.sql`
- Created `migrations/20250119_create_menu_items_table.sql`
- Created `models/Order.ts`
- Created `models/MenuItem.ts`

### Phase 2: API Layer
- `POST /api/v1/orders` - Create new order
- `GET /api/v1/orders/:id` - Get order details
- `PUT /api/v1/orders/:id` - Update order
- `POST /api/v1/orders/:id/complete` - Complete order
- `GET /api/v1/menu` - Get menu items
- `POST /api/v1/calls/webhook` - Voice call webhook

### Phase 3: Frontend
- Created `pages/orders/index.tsx` - Order management dashboard
- Created `pages/orders/[id].tsx` - Order detail view
- Created `components/OrderCard.tsx`
- Created `components/MenuEditor.tsx`
- Updated `layouts/DashboardLayout.tsx`

### Phase 4: Observability
- Added metrics: `orders_created_total`, `order_completion_time`
- Created Grafana dashboard: `voice-ordering-dashboard.json`
- Added alerts: `high_order_failure_rate`, `voice_latency_exceeded`

---

## PRD Requirement Coverage

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| FR-001: Answer calls | ✓ | `POST /api/v1/calls/webhook` |
| FR-002: Natural speech | ✓ | OpenAI Whisper integration |
| FR-003: Menu modifications | ✓ | `PUT /api/v1/orders/:id` |
| FR-004: Order confirmation | ✓ | `OrderConfirmation` component |
| FR-005: POS integration | ⚠️ | Stub created, needs POS API keys |

---

## Security Review Results

**Critical Issues:** 0
**Warnings:** 2

- `api/orders.ts:45` - Consider rate limiting on order creation
- `components/MenuEditor.tsx:78` - Add CSRF token to form

---

## Next Steps

1. [ ] Review generated migrations before running
2. [ ] Add POS API credentials to environment
3. [ ] Run full test suite
4. [ ] Deploy to staging
5. [ ] QA against PRD use cases
```

## Checkpoints & Resume

The command saves checkpoints after each phase:

```yaml
checkpoint_schema:
  id: "impl_20250119_100000"
  prd_path: "./docs/prd-voice-ordering.md"
  prd_hash: "sha256:abc123..."
  current_phase: 5
  completed_phases:
    - phase: 1
      agent: data_eng
      outputs: [...]
      timestamp: "2025-01-19T10:05:00Z"
    - phase: 2
      agent: microservices
      outputs: [...]
      timestamp: "2025-01-19T10:15:00Z"
  pending_phases: [6, 7, 8, 9, 10]

checkpoint_location: ".rlm/checkpoints/"
```

Resume with: `/rlm implement ./docs/prd.md --resume`

## Integration with PRD Command

Works seamlessly with PRDs generated by `/rlm prd`:

```bash
# Generate PRD
/rlm prd "Voice ordering system for restaurants"
# Creates: ./docs/prd-voice-ordering-20250119.md

# Implement PRD
/rlm implement ./docs/prd-voice-ordering-20250119.md
```

## Tips

1. **Start with `--dry-run`** - Review the plan before implementation
2. **Use `--phase` for large PRDs** - Implement incrementally
3. **Review migrations carefully** - Data changes are hard to undo
4. **Check API contracts** - Ensure frontend/backend alignment
5. **Run security review** - Don't skip with `--skip-review`
6. **Test early and often** - Generated tests catch integration issues
