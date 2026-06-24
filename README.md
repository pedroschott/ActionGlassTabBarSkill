# Create a Glass Action Bar SwiftUI

A Codex skill for building or documenting a SwiftUI glass action bar: native `TabView` foundation, `ryanashcraft/FabBar` installation, floating action button setup, bottom action overlay, and reusable glass modifiers.

## What It Includes

- Native SwiftUI `TabView` starter pattern
- FabBar installation from `https://github.com/ryanashcraft/FabBar.git`
- FAB tab bar integration with `.fabBar(...)`
- Glass action overlay with enum-backed actions
- Fallback SwiftUI glass modifiers
- Complete sample file: `assets/GlassActionBarExample.swift`

## Install

Copy or clone this repository into your Codex skills directory:

```bash
git clone https://github.com/pedroschott/ActionGlassTabBarSkill.git \
  ~/.codex/skills/create-glass-action-bar-swiftui
```

Then invoke it in Codex:

```text
$create-glass-action-bar-swiftui
```

## Files

- `SKILL.md` - skill trigger metadata and workflow instructions
- `references/guide.md` - complete implementation/article guide
- `assets/GlassActionBarExample.swift` - drop-in SwiftUI example
- `agents/openai.yaml` - Codex UI metadata

## FabBar Dependency

The generated guide uses FabBar:

```swift
.package(url: "https://github.com/ryanashcraft/FabBar.git", from: "1.0.0")
```

FabBar recreates a native-looking iOS 26 Liquid Glass tab bar with a real floating action button. Because it uses UIKit internals, review it after major iOS updates.
