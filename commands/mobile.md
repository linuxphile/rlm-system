# Command: /rlm mobile

## Usage

```
/rlm mobile [path]
/rlm mobile ./ios
/rlm mobile ./android
/rlm mobile (analyzes both platforms if detected)
```

## Description

Deep analysis of mobile applications covering iOS, Android, React Native, Flutter, and cross-platform development.

## Agents Invoked

1. **mobile** (primary) - Platform analysis, performance, security
2. **design_ux** - Design system implementation, platform conventions
3. **security** - Mobile-specific security (storage, certificates, obfuscation)
4. **observability** - Crash reporting, analytics coverage

## Workflow

```python
def execute_mobile_audit(path="."):
    """
    Mobile-focused analysis workflow.
    """
    
    print("## 📱 Mobile Analysis\n")
    
    # Phase 1: Platform Detection
    platforms = detect_mobile_platforms(path)
    
    print("### Detected Platforms\n")
    for platform in platforms:
        print(f"- **{platform.name}**: {platform.language}")
        print(f"  - Min OS: {platform.min_version}")
        print(f"  - Architecture: {platform.architecture}")
    
    # Phase 2: Per-Platform Analysis
    for platform in platforms:
        print(f"\n### {platform.name} Analysis\n")
        
        # Performance
        print("#### ⚡ Performance\n")
        perf = analyze_mobile_performance(path, platform)
        print(f"- **Estimated App Size:** {perf.app_size}")
        print(f"- **Cold Start Risk:** {perf.startup_risk}")
        print(f"- **Memory Concerns:** {len(perf.memory_issues)}")
        
        # Security
        print("\n#### 🔒 Security\n")
        security = analyze_mobile_security(path, platform)
        print(f"- **Secure Storage:** {security.storage_method}")
        print(f"- **Certificate Pinning:** {'✅' if security.cert_pinning else '❌'}")
        print(f"- **Obfuscation:** {'✅' if security.obfuscation else '❌'}")
        
        # Platform Compliance
        print("\n#### 📋 Platform Compliance\n")
        compliance = check_platform_compliance(path, platform)
        for check, status in compliance.items():
            emoji = '✅' if status else '❌'
            print(f"- {check}: {emoji}")
    
    # Phase 3: Cross-Platform Analysis (if applicable)
    if len(platforms) > 1:
        print("\n### 🔄 Cross-Platform Consistency\n")
        consistency = analyze_cross_platform(path, platforms)
        print(f"- **Shared Code:** {consistency.shared_percentage}")
        print(f"- **Design Consistency:** {consistency.design_score}")
        print(f"- **Feature Parity:** {consistency.feature_parity}")
    
    # Phase 4: Design Implementation
    print("\n### 🎨 Design Implementation\n")
    design = analyze_mobile_design(path)
    print(f"- **Platform Conventions:** {design.conventions_followed}")
    print(f"- **Accessibility:** {design.a11y_score}")
    
    # Phase 5: Recommendations
    print("\n## 📋 Recommendations\n")
    recommendations = collect_mobile_recommendations()
    for rec in recommendations:
        print(f"- [{rec.priority}] {rec.issue}")
```

## Platform-Specific Checks

### iOS

| Check | Target | How |
|-------|--------|-----|
| App Size | < 50MB | Asset optimization, bitcode |
| Cold Start | < 1.5s | Lazy loading, async init |
| Memory | < 150MB | Instrument profiling |
| Privacy Manifest | Required | PrivacyInfo.xcprivacy |
| Keychain | Required | No UserDefaults for secrets |
| ATS | Enforced | No arbitrary loads |

### Android

| Check | Target | How |
|-------|--------|-----|
| App Size | < 30MB | App bundles, dynamic delivery |
| Cold Start | < 2s | Async init, splash optimization |
| Memory | < 200MB | Leak detection |
| Target SDK | ≥ 34 | Play Store requirement |
| ProGuard/R8 | Enabled | Code obfuscation |
| Encrypted Storage | Required | EncryptedSharedPreferences |

### React Native

| Check | Target | How |
|-------|--------|-----|
| Bundle Size | < 5MB | Metro optimization |
| Bridge Calls | Minimize | Batch operations |
| Native Modules | Audit | Performance impact |
| Hermes | Enabled | JS engine optimization |

### Flutter

| Check | Target | How |
|-------|--------|-----|
| App Size | < 15MB | Tree shaking, deferred components |
| Frame Rate | 60 FPS | DevTools profiling |
| Plugin Audit | Regular | Security, maintenance |

## Output Template

```markdown
## 📱 Mobile Analysis

### Detected Platforms

- **iOS (Swift)**: SwiftUI + UIKit
  - Min OS: iOS 15.0
  - Architecture: MVVM with Coordinators

- **Android (Kotlin)**: Jetpack Compose
  - Min OS: Android 8.0 (API 26)
  - Architecture: MVVM with Clean Architecture

### iOS Analysis

#### ⚡ Performance

- **Estimated App Size:** 42MB ✅
- **Cold Start Risk:** Medium ⚠️
  - Heavy work in AppDelegate.didFinishLaunching
  - 12 synchronous network calls on startup
- **Memory Concerns:** 2 issues
  - Potential retain cycle in HomeViewModel
  - Large image not downsampled

#### 🔒 Security

- **Secure Storage:** Keychain ✅
- **Certificate Pinning:** ❌ Missing
- **Obfuscation:** N/A (Swift)
- **Issues:**
  - API key hardcoded in Config.swift:23
  - No jailbreak detection

#### 📋 Platform Compliance

- Privacy Manifest: ❌ Missing (App Store risk)
- ATT Implementation: ✅
- Info.plist Complete: ✅
- Required Capabilities: ✅

### Android Analysis

#### ⚡ Performance

- **Estimated App Size:** 28MB ✅
- **Cold Start Risk:** Low ✅
- **Memory Concerns:** 1 issue
  - Fragment not clearing reference in onDestroyView

#### 🔒 Security

- **Secure Storage:** EncryptedSharedPreferences ✅
- **Certificate Pinning:** ✅ (OkHttp)
- **Obfuscation:** ✅ R8 enabled
- **Issues:**
  - Debug certificate in release config
  - Backup allowed (android:allowBackup="true")

#### 📋 Platform Compliance

- Target SDK: 34 ✅
- ProGuard/R8: ✅
- Data Safety Accuracy: ⚠️ Review needed
- Permissions Declared: ✅

### 🔄 Cross-Platform Consistency

- **Shared Code:** 0% (native apps)
- **Design Consistency:** 85%
  - Button styles differ
  - Navigation patterns differ (expected)
- **Feature Parity:** 95%
  - iOS missing: widgets
  - Android missing: Apple Pay

### 🎨 Design Implementation

- **Platform Conventions:** Mostly followed
  - iOS: Using SF Symbols ✅
  - Android: Material 3 components ✅
  - Issue: Custom bottom sheet differs from platform standard
- **Accessibility:**
  - iOS: VoiceOver support partial
  - Android: TalkBack support good

## 📋 Recommendations

### Critical

- **[iOS] Add Privacy Manifest**
  - Required for App Store submission
  - Effort: Low

- **[iOS] Implement certificate pinning**
  - MITM attack vulnerability
  - Effort: Medium

### High

- **[iOS] Remove hardcoded API key**
  - Use secure configuration
  - Effort: Low

- **[Android] Disable backup for sensitive data**
  - Set android:allowBackup="false"
  - Effort: Low

### Medium

- **[iOS] Optimize startup performance**
  - Defer non-critical initialization
  - Effort: Medium

- **[Both] Improve VoiceOver/TalkBack coverage**
  - Add content descriptions
  - Effort: Medium
```

## Integration with Other Commands

- `/rlm design` - Cross-reference design implementation
- `/rlm security` - Deep security analysis
- `/rlm review` - Part of full-stack review
