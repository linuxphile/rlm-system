# Command: /rlm compare

## Usage

```
/rlm compare <before> <after>
/rlm compare main feature/new-architecture
/rlm compare v1.0.0 v2.0.0
/rlm compare ./old-system ./new-system
```

## Description

Architecture comparison and diff analysis between two versions, branches, or codebases. Identifies changes in architecture, dependencies, performance characteristics, and potential risks.

## Agents Invoked

All relevant agents based on what changed:
- Changes in infrastructure → **cloud_infra**
- Changes in services → **microservices**
- Changes in frontend → **frontend**
- Changes in mobile → **mobile**
- Changes in ML → **aiml**
- Changes in data → **data_eng**
- All comparisons → **security**, **devops**

## Workflow

```python
def execute_comparison(before, after):
    """
    Architecture comparison workflow.
    """
    
    print(f"## 🔄 Architecture Comparison\n")
    print(f"**Before:** {before}")
    print(f"**After:** {after}")
    print()
    
    # Phase 1: Change Detection
    print("### 📊 Change Summary\n")
    
    changes = detect_changes(before, after)
    
    print(f"**Files Changed:** {changes.files_changed}")
    print(f"**Files Added:** {changes.files_added}")
    print(f"**Files Removed:** {changes.files_removed}")
    print(f"**Lines Added:** +{changes.lines_added}")
    print(f"**Lines Removed:** -{changes.lines_removed}")
    
    # Phase 2: Categorize Changes
    print("\n### 📁 Changes by Category\n")
    
    categories = categorize_changes(changes)
    
    for category, files in categories.items():
        if files:
            print(f"**{category}:** {len(files)} files")
    
    # Phase 3: Architecture Delta
    print("\n### 🏗️ Architecture Delta\n")
    
    before_arch = analyze_architecture(before)
    after_arch = analyze_architecture(after)
    
    # Services
    print("#### Services\n")
    
    new_services = after_arch.services - before_arch.services
    removed_services = before_arch.services - after_arch.services
    
    if new_services:
        print(f"**Added:** {', '.join(new_services)}")
    if removed_services:
        print(f"**Removed:** {', '.join(removed_services)}")
    
    # Dependencies
    print("\n#### Dependencies\n")
    
    dep_diff = compare_dependencies(before, after)
    
    if dep_diff.added:
        print(f"**Added:** {len(dep_diff.added)}")
        for dep in dep_diff.added[:5]:
            print(f"  - {dep.name}@{dep.version}")
    
    if dep_diff.removed:
        print(f"**Removed:** {len(dep_diff.removed)}")
    
    if dep_diff.upgraded:
        print(f"**Upgraded:** {len(dep_diff.upgraded)}")
    
    # Phase 4: Impact Analysis
    print("\n### ⚡ Impact Analysis\n")
    
    for category in categories:
        agent = get_agent_for_category(category)
        
        print(f"#### {category}\n")
        
        impact = agent.analyze_impact(
            before_context=filter_context(before, category),
            after_context=filter_context(after, category),
            changes=categories[category]
        )
        
        print(f"**Risk Level:** {impact.risk_level}")
        
        if impact.breaking_changes:
            print(f"**⚠️ Breaking Changes:**")
            for bc in impact.breaking_changes:
                print(f"  - {bc}")
        
        if impact.performance_impact:
            print(f"**Performance Impact:** {impact.performance_impact}")
        
        print()
    
    # Phase 5: Risk Assessment
    print("### ⚠️ Risk Assessment\n")
    
    risks = assess_risks(changes, before_arch, after_arch)
    
    for risk in risks:
        emoji = '🔴' if risk.level == 'high' else '🟡' if risk.level == 'medium' else '🟢'
        print(f"{emoji} **{risk.title}**")
        print(f"   - {risk.description}")
        print(f"   - Mitigation: {risk.mitigation}")
    
    # Phase 6: Recommendations
    print("\n### 📋 Migration Recommendations\n")
    
    recommendations = generate_migration_recommendations(changes, risks)
    
    print("**Before Deployment:**")
    for rec in recommendations.pre_deploy:
        print(f"- [ ] {rec}")
    
    print("\n**Deployment Strategy:**")
    print(f"- Recommended: {recommendations.deploy_strategy}")
    print(f"- Rollback Plan: {recommendations.rollback_plan}")
    
    print("\n**After Deployment:**")
    for rec in recommendations.post_deploy:
        print(f"- [ ] {rec}")
```

## Change Categories

```yaml
infrastructure:
  patterns:
    - "*.tf"
    - "kubernetes/**"
    - "docker-compose*"
    - "helm/**"
  agent: cloud_infra

backend:
  patterns:
    - "src/**/*.{go,py,java,ts}"
    - "api/**"
    - "services/**"
  agent: microservices

frontend:
  patterns:
    - "**/*.{tsx,jsx,vue,svelte}"
    - "package.json"
    - "next.config*"
  agent: frontend

mobile:
  patterns:
    - "ios/**"
    - "android/**"
    - "lib/**/*.dart"
  agent: mobile

data:
  patterns:
    - "dbt/**"
    - "airflow/**"
    - "data/**"
  agent: data_eng

ml:
  patterns:
    - "models/**"
    - "ml/**"
    - "*.ipynb"
  agent: aiml

cicd:
  patterns:
    - ".github/**"
    - ".gitlab-ci*"
    - "Jenkinsfile"
  agent: devops
```

## Output Template

```markdown
## 🔄 Architecture Comparison

**Before:** main (commit abc123)
**After:** feature/microservices-v2 (commit def456)

### 📊 Change Summary

**Files Changed:** 127
**Files Added:** 34
**Files Removed:** 8
**Lines Added:** +4,532
**Lines Removed:** -1,876

### 📁 Changes by Category

**Infrastructure:** 12 files
**Backend:** 67 files
**Frontend:** 28 files
**CI/CD:** 8 files
**Data:** 12 files

### 🏗️ Architecture Delta

#### Services

**Added:**
- notification-service (new)
- analytics-service (new)

**Removed:**
- monolith-api (decomposed)

**Modified:**
- user-service (major refactor)
- order-service (API v2)

#### Communication Patterns

| Before | After |
|--------|-------|
| Sync HTTP only | Sync HTTP + Async Kafka |
| Direct DB access | API-only access |
| Shared database | Database per service |

#### Dependencies

**Added:** 12
  - @kafka/client@3.0.0
  - prisma@5.0.0
  - zod@3.22.0
  - ...

**Removed:** 5
  - sequelize@6.0.0 (replaced by Prisma)
  - ...

**Upgraded:** 8
  - react: 17.0.2 → 18.2.0
  - typescript: 4.9 → 5.3
  - ...

### ⚡ Impact Analysis

#### Backend

**Risk Level:** 🟡 Medium

**⚠️ Breaking Changes:**
- API v1 endpoints deprecated
- User model schema changed
- Authentication flow refactored

**Performance Impact:**
- Expected latency reduction: 30-40%
- Added async processing overhead
- New Kafka dependency

#### Frontend

**Risk Level:** 🟢 Low

**Changes:**
- React 18 upgrade (concurrent features)
- New notification UI components
- Updated API client for v2

**Performance Impact:**
- Bundle size: +12KB (new features)
- Improved rendering with React 18

#### Infrastructure

**Risk Level:** 🟡 Medium

**Changes:**
- Added Kafka cluster (3 brokers)
- New databases: notification-db, analytics-db
- Updated networking for service mesh

**Cost Impact:**
- Estimated increase: +$800/month
- Kafka cluster: $500
- Additional databases: $300

### ⚠️ Risk Assessment

🔴 **Database Migration Risk**
   - User table schema changes require migration
   - Mitigation: Blue-green migration with rollback plan

🟡 **API Breaking Changes**
   - v1 → v2 requires client updates
   - Mitigation: Run v1 and v2 in parallel for 30 days

🟡 **New Service Dependencies**
   - notification-service is now critical path
   - Mitigation: Implement circuit breaker, fallback

🟢 **Frontend React 18 Upgrade**
   - Well-tested upgrade path
   - Mitigation: Gradual rollout with feature flags

### 📋 Migration Recommendations

**Before Deployment:**
- [ ] Run database migration in staging
- [ ] Load test Kafka cluster
- [ ] Update API documentation
- [ ] Notify API consumers of v2
- [ ] Verify monitoring for new services

**Deployment Strategy:**
- Recommended: Blue-green deployment
- Duration: 2-hour maintenance window
- Rollback Plan: DNS switch to blue environment

**Deployment Order:**
1. Infrastructure (Kafka, DBs)
2. Backend services (parallel deployment)
3. Frontend
4. Switch traffic (10% → 50% → 100%)

**After Deployment:**
- [ ] Monitor error rates for 24 hours
- [ ] Verify Kafka consumer lag
- [ ] Check new service latencies
- [ ] Validate data consistency
- [ ] Deprecation notice for API v1

### 📈 Metrics to Watch

| Metric | Baseline | Expected | Alert Threshold |
|--------|----------|----------|-----------------|
| API Latency p99 | 200ms | 150ms | > 300ms |
| Error Rate | 0.1% | 0.1% | > 0.5% |
| Kafka Lag | N/A | < 1000 | > 10000 |
| DB Connections | 50 | 80 | > 150 |
```

## Comparison Types

| Type | Use Case |
|------|----------|
| Branch comparison | Feature branch vs main |
| Version comparison | Release tags |
| Directory comparison | Different codebases |
| Point-in-time | Git commits |
