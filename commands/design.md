# Command: /rlm design

## Usage

```
/rlm design [path]
/rlm design ./packages/ui
/rlm design (searches for design system in project)
```

## Description

Comprehensive design system health check covering tokens, components, accessibility, documentation, and cross-platform consistency.

## Agents Invoked

1. **design_ux** (primary) - Design system analysis, accessibility
2. **frontend** - Web implementation verification
3. **mobile** - Native implementation verification
4. **observability** - UX metrics tracking

## Workflow

```python
def execute_design_audit(path="."):
    """
    Design system focused analysis workflow.
    """
    
    print("## 🎨 Design System Audit\n")
    
    # Phase 1: Design System Discovery
    ds = discover_design_system(path)
    
    print(f"**Design System:** {ds.name or 'Not found'}")
    print(f"**Location:** {ds.location}")
    print(f"**Maturity:** {ds.maturity}")
    print()
    
    # Phase 2: Token Architecture
    print("### 🎨 Token Architecture\n")
    
    tokens = analyze_tokens(ds.location)
    
    print("| Category | Count | Structure |")
    print("|----------|-------|-----------|")
    print(f"| Colors | {tokens.colors} | {tokens.color_structure} |")
    print(f"| Typography | {tokens.typography} | {tokens.type_structure} |")
    print(f"| Spacing | {tokens.spacing} | {tokens.space_structure} |")
    print(f"| Shadows | {tokens.shadows} | {tokens.shadow_structure} |")
    
    print(f"\n**Theme Support:**")
    print(f"- Light: {'✅' if tokens.light_theme else '❌'}")
    print(f"- Dark: {'✅' if tokens.dark_theme else '❌'}")
    print(f"- High Contrast: {'✅' if tokens.high_contrast else '❌'}")
    
    # Phase 3: Component Inventory
    print("\n### 📦 Component Inventory\n")
    
    components = analyze_components(ds.location)
    
    print(f"**Total Components:** {components.total}")
    print(f"**With Stories:** {components.with_stories}")
    print(f"**With Tests:** {components.with_tests}")
    print(f"**Documented:** {components.documented}")
    
    print("\n**Coverage by Category:**")
    for category, coverage in components.coverage.items():
        bar = "█" * int(coverage/10) + "░" * (10-int(coverage/10))
        print(f"- {category}: {bar} {coverage}%")
    
    # Phase 4: Accessibility Audit
    print("\n### ♿ Accessibility Audit\n")
    
    a11y = audit_accessibility(ds.location)
    
    print(f"**WCAG Level:** {a11y.level}")
    print(f"**Automated Issues:** {a11y.total_issues}")
    
    print("\n**Issues by Rule:**")
    for rule, count in a11y.by_rule.items():
        print(f"- {rule}: {count}")
    
    # Phase 5: Implementation Verification
    print("\n### 🔍 Implementation Verification\n")
    
    # Web
    if has_web_implementation(path):
        web = verify_web_implementation(ds, path)
        print(f"**Web Implementation:**")
        print(f"- Token Alignment: {web.token_alignment}%")
        print(f"- Component Coverage: {web.component_coverage}%")
        print(f"- Drift Issues: {len(web.drift)}")
    
    # iOS
    if has_ios_implementation(path):
        ios = verify_ios_implementation(ds, path)
        print(f"\n**iOS Implementation:**")
        print(f"- Token Alignment: {ios.token_alignment}%")
        print(f"- Component Coverage: {ios.component_coverage}%")
        print(f"- Drift Issues: {len(ios.drift)}")
    
    # Android
    if has_android_implementation(path):
        android = verify_android_implementation(ds, path)
        print(f"\n**Android Implementation:**")
        print(f"- Token Alignment: {android.token_alignment}%")
        print(f"- Component Coverage: {android.component_coverage}%")
        print(f"- Drift Issues: {len(android.drift)}")
    
    # Phase 6: Documentation Quality
    print("\n### 📚 Documentation Quality\n")
    
    docs = assess_documentation(ds.location)
    
    checks = [
        ("Storybook/Docs Site", docs.has_storybook),
        ("Usage Guidelines", docs.has_usage),
        ("Code Examples", docs.has_examples),
        ("Do/Don't Examples", docs.has_do_dont),
        ("Accessibility Notes", docs.has_a11y_notes),
        ("Changelog", docs.has_changelog),
    ]
    
    for check, status in checks:
        emoji = '✅' if status else '❌'
        print(f"- {check}: {emoji}")
    
    # Phase 7: Recommendations
    print("\n## 📋 Recommendations\n")
    
    recommendations = synthesize_design_recommendations()
    output_recommendations(recommendations)
```

## Token Analysis Details

### Color System Checks

```yaml
checks:
  - semantic_naming: "Are colors named by purpose (primary, danger) not value (blue, red)?"
  - primitive_layer: "Is there a primitive layer for raw values?"
  - contrast_pairs: "Are accessible contrast pairs defined?"
  - dark_mode: "Does dark mode maintain semantic meaning?"
  - brand_alignment: "Do brand colors have consistent tints/shades?"
```

### Typography Checks

```yaml
checks:
  - type_scale: "Is there a consistent ratio (1.2, 1.25, 1.333)?"
  - responsive: "Do sizes adapt to viewport/platform?"
  - line_heights: "Are line heights appropriate (1.4-1.6 for body)?"
  - font_weights: "Are weights limited (3-4 max)?"
  - fallbacks: "Are system font fallbacks defined?"
```

### Spacing Checks

```yaml
checks:
  - base_unit: "Is there a base unit (4px or 8px)?"
  - scale: "Is spacing a consistent scale?"
  - naming: "Semantic names (compact, comfortable) or t-shirt sizes?"
  - layout_tokens: "Are layout-specific tokens defined?"
```

## Output Template

```markdown
## 🎨 Design System Audit

**Design System:** Acme UI
**Location:** packages/design-system
**Maturity:** Developing

### 🎨 Token Architecture

| Category | Count | Structure |
|----------|-------|-----------|
| Colors | 47 | Semantic + Primitive |
| Typography | 12 | Scale (1.25 ratio) |
| Spacing | 8 | 4px base |
| Shadows | 4 | Elevation-based |

**Theme Support:**
- Light: ✅
- Dark: ❌ (Gap)
- High Contrast: ❌

**Token Issues:**
- 3 duplicate color tokens (blue-500, blue-primary, brand-blue)
- Typography scale breaks at h1 (jumps 1.5x instead of 1.25x)
- No semantic spacing tokens (only raw values)

### 📦 Component Inventory

**Total Components:** 34
**With Stories:** 31 (91%)
**With Tests:** 18 (53%)
**Documented:** 28 (82%)

**Coverage by Category:**
- Primitives: ██████████ 100%
- Forms: ████████░░ 80%
- Layout: ██████████ 100%
- Feedback: ███████░░░ 75%
- Navigation: █████░░░░░ 50%
- Data: ██████░░░░ 60%

**Missing Components:**
- Navigation: Breadcrumb, Stepper
- Data: DataGrid, VirtualList
- Feedback: Skeleton, Progress

### ♿ Accessibility Audit

**WCAG Level:** A (Target: AA)
**Automated Issues:** 28

**Issues by Rule:**
- color-contrast: 5 (serious)
- button-name: 3 (critical)
- image-alt: 4 (serious)
- label: 8 (serious)
- link-name: 2 (serious)
- focus-visible: 6 (moderate)

**Critical Issues:**
1. IconButton components missing aria-label
2. Some images have decorative alt="" but are informative
3. Form inputs without associated labels

### 🔍 Implementation Verification

**Web Implementation:**
- Token Alignment: 87%
- Component Coverage: 92%
- Drift Issues: 8

**Drift Details:**
| Component | Design | Web | Issue |
|-----------|--------|-----|-------|
| Button | radius: 8px | radius: 4px | Visual |
| Card | shadow: md | shadow: sm | Visual |
| Input | height: 40px | height: 36px | Touch target |

**iOS Implementation:**
- Token Alignment: 78%
- Component Coverage: 85%
- Drift Issues: 12

**Android Implementation:**
- Token Alignment: 75%
- Component Coverage: 80%
- Drift Issues: 15

### 📚 Documentation Quality

- Storybook/Docs Site: ✅
- Usage Guidelines: ✅
- Code Examples: ✅
- Do/Don't Examples: ❌
- Accessibility Notes: ❌
- Changelog: ✅

**Documentation Gaps:**
- No accessibility usage guidelines
- Missing migration guides
- Component props not fully documented

## 📋 Recommendations

### Critical (Accessibility)

- **Add aria-label to all IconButton instances**
  - WCAG 4.1.2 violation
  - Effort: Low

- **Fix color contrast on secondary buttons**
  - WCAG 1.4.3 violation (3.2:1, needs 4.5:1)
  - Effort: Low

### High (Consistency)

- **Implement dark mode**
  - User expectation, competitive necessity
  - Effort: High

- **Resolve design-code drift**
  - 35 total drift issues across platforms
  - Effort: Medium

### Medium (Quality)

- **Add missing navigation components**
  - Breadcrumb, Stepper commonly needed
  - Effort: Medium

- **Improve test coverage to 80%**
  - Currently at 53%
  - Effort: Medium

### Low (Documentation)

- **Add Do/Don't examples**
  - Helps prevent misuse
  - Effort: Low

- **Document accessibility requirements**
  - Per-component a11y guidelines
  - Effort: Medium
```

## Cross-Platform Token Mapping

| Design Token | Web (CSS) | iOS (Swift) | Android (Compose) |
|--------------|-----------|-------------|-------------------|
| color.primary | --color-primary | Color.primary | Primary |
| spacing.md | --spacing-md | Spacing.md | Dimen.spacing_md |
| font.body | --font-body | Font.body | Typography.body |
