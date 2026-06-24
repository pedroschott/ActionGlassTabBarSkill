# Create a Glass Action Bar SwiftUI

Use this guide to produce a complete article or implementation plan for a SwiftUI custom FAB tab bar with a glass action overlay.

## 1. Start With Native Tabs

Begin small. Show native tab navigation first:

```swift
import SwiftUI

enum AppTab: Hashable {
    case home
    case activity
}

struct RootView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView()
            }

            Tab("Activity", systemImage: "chart.bar.fill", value: .activity) {
                ActivityView()
            }
        }
    }
}
```

## 2. Install FabBar

Install the Swift package from:

```text
https://github.com/ryanashcraft/FabBar.git
```

With `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ryanashcraft/FabBar.git", from: "1.0.0")
]
```

With Xcode, use **File > Add Package Dependencies...**, paste the GitHub URL, and add the `FabBar` product to the app target.

Then import:

```swift
import FabBar
```

Mention that FabBar provides a SwiftUI API but uses UIKit internally to recreate the iOS 26-style Liquid Glass tab bar and FAB. It relies on UIKit view hierarchy behavior, so teams should re-check it after major iOS updates.

## 3. Add The FAB Tab Bar

Hide the native tab bar on compact width, keep it on regular width, and attach `.fabBar(...)` to the `TabView`:

```swift
import FabBar
import SwiftUI

enum AppTab: Hashable {
    case home
    case activity
}

struct RootView: View {
    @State private var selectedTab: AppTab = .home
    @State private var isShowingActions = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var tabBarVisibility: Visibility {
        horizontalSizeClass == .compact ? .hidden : .visible
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView()
                    .fabBarSafeAreaPadding()
                    .toolbarVisibility(tabBarVisibility, for: .tabBar)
            }

            Tab("Activity", systemImage: "chart.bar.fill", value: .activity) {
                ActivityView()
                    .fabBarSafeAreaPadding()
                    .toolbarVisibility(tabBarVisibility, for: .tabBar)
            }
        }
        .fabBar(
            selection: $selectedTab,
            tabs: [
                FabBarTab(value: .home, title: "Home", systemImage: "house.fill"),
                FabBarTab(value: .activity, title: "Activity", systemImage: "chart.bar.fill"),
            ],
            action: FabBarAction(
                systemImage: "plus",
                accessibilityLabel: "Create new item"
            ) {
                toggleActions()
            }
        )
    }

    private func toggleActions() {
        if isShowingActions {
            hideActions()
        } else {
            showActions()
        }
    }

    private func showActions() {
        withAnimation(.bouncy(duration: 0.41, extraBounce: 0.16)) {
            isShowingActions = true
        }
    }

    private func hideActions() {
        withAnimation(.bouncy(duration: 0.31, extraBounce: 0.08)) {
            isShowingActions = false
        }
    }
}
```

## 4. Add The Glass Action Overlay

Explain that the FAB only toggles the overlay. The overlay can contain any action: compose, scan, upload, record, search, or start a custom app flow.

Add the action model:

```swift
enum CreateAction: String, CaseIterable, Identifiable {
    case write = "Write"
    case scan = "Scan"
    case upload = "Upload"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .write:
            return "text.alignleft"
        case .scan:
            return "camera.fill"
        case .upload:
            return "tray.and.arrow.up.fill"
        }
    }
}
```

Attach the overlay to the root view:

```swift
.overlay {
    if isShowingActions {
        Color.black.opacity(0.001)
            .ignoresSafeArea()
            .onTapGesture {
                hideActions()
            }
            .transition(.opacity)
            .zIndex(1)
    }
}
.overlay(alignment: .bottom) {
    if isShowingActions {
        CreateActionOverlay { action in
            hideActions()

            switch action {
            case .write:
                break
            case .scan:
                break
            case .upload:
                break
            }
        }
        .transition(.actionOverlay)
        .zIndex(2)
    }
}
```

Use this overlay component:

```swift
struct CreateActionOverlay: View {
    let selectAction: (CreateAction) -> Void

    var body: some View {
        VStack(spacing: 10) {
            ForEach(CreateAction.allCases) { action in
                Button {
                    selectAction(action)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: action.systemImage)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 34, height: 34)
                            .background(.thinMaterial, in: Circle())

                        Text(action.rawValue)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 58)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .glassPanel(cornerRadius: 26)
        .padding(.horizontal, 18)
        .padding(.bottom, 65)
    }
}
```

Add the transition:

```swift
extension AnyTransition {
    static var actionOverlay: AnyTransition {
        .modifier(
            active: ActionOverlayTransition(isActive: true),
            identity: ActionOverlayTransition(isActive: false)
        )
    }
}

struct ActionOverlayTransition: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.2 : 1, anchor: .bottom)
            .opacity(isActive ? 0 : 1)
            .blur(radius: isActive ? 14 : 0)
    }
}
```

## 5. Apply Glass Modifiers

If the app does not already have glass helpers, add:

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

Use existing project glass modifiers instead when available.

## 6. Complete Example

Use `assets/GlassActionBarExample.swift` when the user asks for a complete file.
