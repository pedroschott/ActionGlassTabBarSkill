---
name: create-glass-action-bar-swiftui
description: Build or document a SwiftUI iOS 26-style glass tab bar with a floating action button using ryanashcraft/FabBar, including native TabView setup, Swift Package installation, FabBar integration, bottom action overlays, reusable glass modifiers, and complete sample SwiftUI files. Use when the user asks for a custom tab bar, FAB tab bar, glass action bar, Liquid Glass action overlay, or a guide/code snippets for installing and using FabBar in SwiftUI.
---

# Create a Glass Action Bar SwiftUI

## Workflow

When adding or documenting a glass action bar, do these in order:

1. Start with a small native SwiftUI `TabView` example so the selection model is clear.
2. Install FabBar from `https://github.com/ryanashcraft/FabBar.git` using Swift Package Manager.
3. Add `import FabBar`, hide the native tab bar on compact width, apply `.fabBarSafeAreaPadding()` inside each tab, and attach `.fabBar(...)` to the `TabView`.
4. Wire the FAB to toggle an action overlay instead of performing app work directly.
5. Add a glass bottom action overlay with an enum-backed `ForEach`, icon circles, full-width rows, tap-to-dismiss scrim, and a bottom transition.
6. Add local glass modifiers when the target app does not already provide them.

Read [references/guide.md](references/guide.md) when writing the full guide or implementing the pattern. Use [assets/GlassActionBarExample.swift](assets/GlassActionBarExample.swift) as the bundled SwiftUI example file to copy or adapt.

## Implementation Rules

- Keep examples generic: avoid project-specific names, colors, stores, subscription gates, onboarding state, or feature models unless the user asks to adapt an existing app.
- Preserve native tab behavior by keeping `TabView(selection:)` as the source of tab navigation.
- Treat the FAB as an action launcher, not a fake tab.
- Keep the native tab bar visible on regular horizontal size classes unless the user explicitly wants custom behavior everywhere.
- Use `FabBarAction(systemImage:accessibilityLabel:)` with a real accessibility label such as `"Create new item"`.
- Place `.fabBarSafeAreaPadding()` on each tab root that scrolls or can be obscured by the bottom bar.
- Include the warning that FabBar recreates a native-looking tab bar with UIKit internals and may need review after OS updates.

## GitHub And Install

Use this package URL:

```text
https://github.com/ryanashcraft/FabBar.git
```

For `Package.swift` users:

```swift
.package(url: "https://github.com/ryanashcraft/FabBar.git", from: "1.0.0")
```

For Xcode users: add the package from the same GitHub URL in **File > Add Package Dependencies...** and link the `FabBar` product to the iOS app target.

## Glass Modifier Fallback

If the app already has its own glass design-system modifiers, use those. Otherwise, add a local fallback like this:

```swift
extension View {
    func glassPanel(cornerRadius: CGFloat = 26) -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.18), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.18), radius: 24, x: 0, y: 14)
    }
}
```

Prefer this fallback for snippets and articles. In production code, place it near the app's design-system modifiers.
