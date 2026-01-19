# Command: /rlm prd

## Usage

```
/rlm prd "<product description>"
/rlm prd "AI-powered voice automation for restaurant phone orders"
/rlm prd "Design token management system for cross-platform apps"
/rlm prd --review ./docs/existing-prd.md
/rlm prd --template
```

## Description

Creates comprehensive, research-backed Product Requirement Documents or reviews existing PRDs for completeness and quality. Follows a structured framework that emphasizes customer research, clear scoping, and actionable requirements.

## Options

| Option | Description |
|--------|-------------|
| (default) | Create new PRD from product description |
| `--review <file>` | Review and improve existing PRD |
| `--template` | Output blank PRD template |
| `--competitive <product>` | Focus on competitive analysis |
| `--lightweight` | Abbreviated PRD for smaller features |

## Agents Invoked

1. **product_manager** (primary) - PRD structure, requirements, prioritization
2. **design_ux** - User research, personas, accessibility requirements
3. **security** - Compliance, data handling requirements
4. **observability** - Success metrics, analytics requirements

## Workflow

```python
def create_prd(product_description, options=None):
    """
    PRD creation workflow.
    """
    
    print("## 📋 Product Requirements Document\n")
    print(f"**Product:** {product_description}")
    print(f"**Created:** {timestamp()}")
    print()
    
    # Phase 1: Context Gathering
    print("### Phase 1: Context Gathering\n")
    
    # Identify product type and domain
    product_type = classify_product(product_description)
    print(f"**Product Type:** {product_type}")
    
    # Search for relevant context
    if has_existing_docs():
        context = gather_existing_documentation()
        print(f"**Found:** {len(context.files)} relevant documents")
    
    # Research competitors
    print("\n*Researching competitive landscape...*\n")
    competitors = web_search(f"{product_description} competitors alternatives")
    
    # Phase 2: Structure Definition
    print("### Phase 2: PRD Structure\n")
    
    prd = PRDDocument()
    
    # Overview
    print("#### Overview")
    prd.overview = generate_overview(product_description, context)
    print(f"> {prd.overview.summary[:200]}...")
    
    # Goals
    print("\n#### Goals")
    prd.goals = generate_goals(product_description, product_type)
    for goal in prd.goals[:3]:
        print(f"- {goal}")
    
    # Non-Goals  
    print("\n#### Non-Goals")
    prd.non_goals = generate_non_goals(product_description, product_type)
    for ng in prd.non_goals[:3]:
        print(f"- {ng}")
    
    # Phase 3: Audience Definition
    print("\n### Phase 3: Audience Definition\n")
    
    # Primary persona
    prd.audience = generate_personas(product_description)
    print(f"**Primary Persona:** {prd.audience.primary.name}")
    print(f"- {prd.audience.primary.description}")
    
    # Phase 4: Competitive Analysis
    print("\n### Phase 4: Competitive Analysis\n")
    
    prd.competitive = analyze_competitors(competitors)
    print(f"**Analyzed:** {len(prd.competitive)} competitors")
    
    for comp in prd.competitive[:3]:
        print(f"\n**{comp.name}**")
        print(f"- Strengths: {', '.join(comp.strengths[:2])}")
        print(f"- Weaknesses: {', '.join(comp.weaknesses[:2])}")
    
    # Phase 5: Requirements
    print("\n### Phase 5: Requirements Definition\n")
    
    # Use cases
    print("#### Key Use Cases")
    prd.use_cases = generate_use_cases(product_description, prd.audience)
    for i, uc in enumerate(prd.use_cases.primary[:4], 1):
        print(f"{i}. {uc.title}")
    
    # Functional requirements
    print("\n#### Functional Requirements")
    prd.requirements = generate_requirements(prd.use_cases)
    
    must_have = [r for r in prd.requirements.functional if r.priority == 'must']
    print(f"**Must Have:** {len(must_have)} requirements")
    
    # Non-functional requirements
    print("\n#### Non-Functional Requirements")
    prd.nfr = generate_nfr(product_type)
    for nfr in prd.nfr[:3]:
        print(f"- [{nfr.category}] {nfr.requirement}")
    
    # Phase 6: Assumptions & Constraints
    print("\n### Phase 6: Assumptions & Constraints\n")
    
    print("#### Assumptions")
    prd.assumptions = generate_assumptions(product_description, prd.audience)
    for a in prd.assumptions[:3]:
        print(f"- {a.assumption}")
        print(f"  ⚠️ *Needs validation via user research*")
    
    print("\n#### Constraints")
    prd.constraints = generate_constraints(product_type)
    for c in prd.constraints[:3]:
        print(f"- {c}")
    
    # Phase 7: Success Metrics
    print("\n### Phase 7: Success Metrics\n")
    
    prd.metrics = generate_success_metrics(prd.goals, product_type)
    for m in prd.metrics[:4]:
        print(f"- **{m.metric}**: {m.target} (measured by {m.measurement})")
    
    # Phase 8: Research Questions
    print("\n### Phase 8: Open Research Questions\n")
    
    prd.research = generate_research_questions(prd)
    
    print("**User Research:**")
    for q in prd.research.user[:3]:
        print(f"- {q}")
    
    print("\n**Technical Research:**")
    for q in prd.research.technical[:3]:
        print(f"- {q}")
    
    # Phase 9: Quality Check
    print("\n### Phase 9: PRD Quality Check\n")
    
    quality = check_prd_quality(prd)
    
    print(f"**Completeness:** {quality.completeness}%")
    print(f"**Research-Backed:** {quality.research_backed}%")
    print(f"**Actionable:** {quality.actionable}%")
    
    if quality.gaps:
        print("\n**Gaps to Address:**")
        for gap in quality.gaps:
            print(f"- ⚠️ {gap}")
    
    # Phase 10: Generate Document
    print("\n### Phase 10: Generate PRD Document\n")
    
    output_path = generate_prd_document(prd)
    print(f"✅ PRD generated: {output_path}")
    
    return prd
```

## Output Template

```markdown
# Product Requirements Document

## Metadata

| Field | Value |
|-------|-------|
| **Title** | AI-Powered Voice Automation for Restaurant Phone Orders |
| **Version** | 0.1 (Draft) |
| **Author** | Product Team |
| **Status** | Draft |
| **Last Updated** | 2025-01-19 |
| **Stakeholders** | Engineering, Design, Sales, Support |

---

## Overview

### Problem Statement

Restaurant owners lose significant revenue to missed phone calls during peak hours. Staff are often too busy to answer phones, leading to lost orders and frustrated customers. Current solutions require expensive hardware or complex integrations.

### Solution Summary

An AI-powered voice automation system that answers restaurant phone calls, takes orders naturally, and integrates with existing POS systems. The system handles common inquiries (hours, menu, reservations) and seamlessly transfers complex requests to staff.

### Strategic Alignment

This product aligns with our mission to help small businesses compete with larger chains by providing enterprise-grade technology at accessible price points.

---

## Goals

- Answer 100% of incoming calls within 3 rings
- Successfully complete 80% of order-taking calls without human intervention
- Reduce staff phone time by 70% during peak hours
- Achieve 90% customer satisfaction rating on AI interactions
- Integrate with top 5 POS systems within 6 months
- Reach $100K MRR within 12 months of launch

---

## Non-Goals

- **Not supporting walk-in ordering** - This is phone-only initially
- **Not replacing staff entirely** - Human escalation path is critical
- **Not building custom POS** - We integrate, not compete
- **Not handling complex modifications** - Start with standard menu items
- **Not multi-language in V1** - English only for initial launch
- **Not supporting fine dining** - Focus on quick-service restaurants

---

## Audience

### Primary Persona: Sam the Sandwich Shop Owner

**Demographics:** 35-50 years old, owns 1-3 locations, 5-15 employees

**Description:** Sam has been running their sandwich shop for 8 years. During lunch rush (11am-1pm), they lose an estimated 10-15 calls per day because staff are too busy making sandwiches to answer the phone. Each missed call represents ~$15 in lost revenue.

**Needs:**
- Answer every call, especially during rush hours
- Take accurate orders without errors
- Not slow down in-store operations
- Affordable solution (can't justify $500+/month)

**Pain Points:**
- Hiring dedicated phone staff isn't cost-effective
- Voicemail doesn't capture orders
- Current IVR systems frustrate customers
- Can't track how many calls they're missing

### Secondary Persona: Regional Chain Manager

**Description:** Manages 10-25 locations for a regional chain. Needs consistent phone experience across all locations and centralized reporting.

---

## Existing Solutions & Issues

### Competitor Analysis

| Competitor | Strengths | Weaknesses | Our Differentiation |
|------------|-----------|------------|---------------------|
| **Slang.ai** | Good NLU, restaurant focus | $400+/mo, limited POS integration | Lower price, better POS coverage |
| **PolyAI** | Enterprise-grade | Very expensive, overkill for SMB | SMB-focused pricing and simplicity |
| **Traditional IVR** | Cheap | Frustrating UX, no AI | Natural conversation |
| **Answering Services** | Human touch | $2-5 per call, inconsistent | Predictable flat rate |
| **Staff Answering** | Personal | Pulls from other duties | Dedicated, always available |

---

## Assumptions

> ⚠️ Each assumption should link to research evidence

- **Users prefer natural conversation over IVR trees** ([Interview 1](), [Interview 4](), [Survey Results]())
- **Most phone orders are relatively simple** (< 5 items, standard modifications) - *Needs validation*
- **Restaurant owners check POS integration first** ([Interview 2](), [Interview 7]())
- **Price sensitivity is high** ($100-200/mo acceptable, $400+ is a hard no) - *Needs validation*
- **Customers are increasingly comfortable with AI voice** ([Industry Report]())
- **Call volume peaks are predictable** (meal times) ([POS Data Analysis]())

---

## Constraints

### Technical Constraints
- Must achieve < 500ms response latency for natural conversation
- Must handle background noise (kitchen, customers)
- Must integrate with POS via existing APIs (no custom hardware)
- Must work with standard phone lines (no VoIP requirement)

### Business Constraints
- Target price point: $99-149/month per location
- Must be profitable at 100 customers
- No on-site installation (fully remote setup)
- Support team capacity: 2 FTEs at launch

### Timeline Constraints
- Beta launch: Q2 2025
- GA launch: Q3 2025
- First 5 POS integrations: Q4 2025

---

## Key Use Cases

### 1. Take a Phone Order

**Actor:** Customer calling to place an order

**Preconditions:**
- Restaurant is open (or within order-ahead window)
- AI system is active
- Menu is configured in system

**Flow:**
1. Customer calls restaurant
2. AI answers: "Thanks for calling [Restaurant], I can help you place an order. What would you like today?"
3. Customer states order items
4. AI confirms each item and asks about modifications
5. AI reads back complete order
6. AI collects name and pickup/delivery preference
7. AI provides total and estimated time
8. AI confirms order is placed
9. Order appears in POS system

**Acceptance Criteria:**
- [ ] Order accuracy ≥ 95%
- [ ] Call duration ≤ 3 minutes for average order
- [ ] Order appears in POS within 5 seconds
- [ ] Customer can interrupt/correct at any point

### 2. Answer Common Questions

**Actor:** Customer with a question

**Flow:**
1. Customer asks about hours/location/menu
2. AI provides accurate information
3. AI offers to help with anything else

**Acceptance Criteria:**
- [ ] Handles: hours, address, menu items, prices, dietary info
- [ ] Accurate 99% of the time
- [ ] Under 30 seconds for simple questions

### 3. Escalate to Human

**Actor:** Customer with complex request

**Flow:**
1. AI recognizes it cannot handle request
2. AI offers to transfer to staff
3. If staff available: warm transfer with context
4. If staff unavailable: take message or callback number

**Acceptance Criteria:**
- [ ] Never dead-ends the customer
- [ ] Context passed to staff
- [ ] < 10 second transfer time

### 4. Initial Setup

**Actor:** Restaurant owner/manager

**Flow:**
1. Sign up and connect phone number
2. Import menu from POS or upload manually
3. Configure business hours
4. Test with sample calls
5. Go live

**Acceptance Criteria:**
- [ ] Setup completable in < 30 minutes
- [ ] No technical expertise required
- [ ] Clear test/preview before going live

---

## Requirements

### Functional Requirements

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|---------------------|
| FR-001 | Answer incoming calls | Must | < 3 rings, 24/7 availability |
| FR-002 | Understand natural speech orders | Must | 95% intent accuracy |
| FR-003 | Handle menu modifications | Must | Standard mods (no onions, extra cheese) |
| FR-004 | Read back order for confirmation | Must | 100% of completed orders |
| FR-005 | Send order to POS | Must | Within 5 seconds, accurate |
| FR-006 | Answer FAQ (hours, location) | Must | Pre-configured responses |
| FR-007 | Transfer to human | Must | Warm transfer with context |
| FR-008 | Handle hold/callback | Should | When staff unavailable |
| FR-009 | Multi-item orders | Must | Up to 10 items per call |
| FR-010 | Order modifications mid-call | Should | Add/remove/change items |
| FR-011 | Upselling prompts | Could | "Would you like to add..." |
| FR-012 | Daily call summary email | Should | Orders, transfers, issues |

### Non-Functional Requirements

| Category | Requirement | Target |
|----------|-------------|--------|
| Performance | Response latency | < 500ms |
| Performance | Concurrent calls | 10 per location |
| Reliability | Uptime | 99.9% |
| Reliability | Call completion rate | > 98% |
| Security | Call recordings | Encrypted, 90-day retention |
| Security | PCI compliance | No credit card handling in V1 |
| Usability | Setup time | < 30 minutes |
| Usability | Training required | None |
| Scalability | Locations per account | Unlimited |

---

## Success Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Order Completion Rate | 80% | Orders completed / Total order calls |
| Order Accuracy | 95% | Correct orders / Total orders |
| Customer Satisfaction | 90% | Post-call survey |
| Avg Handle Time | < 3 min | Call duration for orders |
| Staff Time Saved | 70% | Before/after phone time |
| MRR | $100K | Stripe dashboard |
| Churn Rate | < 5% | Monthly cohort analysis |
| NPS | > 40 | Quarterly survey |

---

## Research

### User Research Questions

1. **How many calls do restaurants miss during peak hours?**
   - *Finding:* Average of 12-18 missed calls during lunch rush (11am-1pm)
   - *Source:* [POS call log analysis](), [Owner interviews]()

2. **What's the acceptable price point?**
   - *Finding:* $100-150/month seen as reasonable, $200+ triggers "let me think about it"
   - *Source:* [Pricing survey]() - *Needs more data*

3. **What POS systems are most common?**
   - *Finding:* Toast (35%), Square (25%), Clover (20%), Other (20%)
   - *Source:* [Market research]()

### Technical Research Questions

1. **Can we achieve < 500ms latency with current LLM providers?**
   - *Status:* In progress - testing Anthropic, OpenAI, Groq

2. **How do we handle background noise in kitchen environments?**
   - *Status:* Need acoustic testing

### Open Questions

- [ ] How do customers feel about AI answering? (Schedule focus group)
- [ ] What's the refund/satisfaction guarantee policy?
- [ ] Do we charge per-call overage or hard cap?

---

## Timeline

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| Discovery | 4 weeks | Research complete, PRD approved |
| Design | 3 weeks | UX flows, voice persona, system architecture |
| Build - Core | 8 weeks | Call handling, NLU, basic ordering |
| Build - Integrations | 4 weeks | Toast + Square POS |
| Beta | 4 weeks | 10 pilot restaurants |
| Launch Prep | 2 weeks | Docs, support training, marketing |
| GA Launch | - | Public availability |

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| AI makes ordering errors | Medium | High | Human review option, easy correction flow |
| Customers hang up on AI | Medium | High | Natural voice, quick response, easy escalation |
| POS integration delays | High | Medium | Start with most common POS, build adapter layer |
| Competitor launches similar | Medium | Medium | Focus on SMB, price advantage |
| Latency issues | Low | High | Multi-provider failover, edge deployment |

---

## Appendix

### Glossary

- **NLU**: Natural Language Understanding
- **POS**: Point of Sale system
- **IVR**: Interactive Voice Response
- **ASR**: Automatic Speech Recognition
- **TTS**: Text to Speech

### References

- [Market sizing analysis]()
- [Competitor feature matrix]()
- [User interview recordings]()
- [Technical feasibility study]()

---

*Document Version History*

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2025-01-19 | PM Team | Initial draft |
```

## PRD Review Mode

When using `--review`, the agent evaluates:

```yaml
review_checklist:
  structure:
    - "Has all required sections?"
    - "Logical flow and organization?"
    
  problem_definition:
    - "Is the problem clearly stated?"
    - "Is there evidence of the problem?"
    - "Is the impact quantified?"
    
  audience:
    - "Are personas specific and realistic?"
    - "Are needs based on research?"
    - "Are pain points validated?"
    
  scope:
    - "Are goals measurable?"
    - "Are non-goals explicit?"
    - "Is scope appropriate for timeline?"
    
  requirements:
    - "Are requirements testable?"
    - "Is prioritization clear?"
    - "Are acceptance criteria specific?"
    
  research:
    - "Are assumptions linked to evidence?"
    - "Are open questions identified?"
    - "Is competitive analysis current?"
    
  actionability:
    - "Can engineering estimate from this?"
    - "Are dependencies identified?"
    - "Is timeline realistic?"
```

## Tips for Better PRDs

1. **Start with problems, not solutions** - Define the pain before the pill
2. **Link every assumption to research** - No gut feelings
3. **Be explicit about non-goals** - Prevents scope creep
4. **Make requirements testable** - "Fast" → "< 200ms p95"
5. **Include open questions** - Show intellectual honesty
6. **Version your PRDs** - They're living documents
7. **Get engineering input early** - Feasibility matters
