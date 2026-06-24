import FabBar
import SwiftUI

enum AppTab: Hashable {
    case home
    case activity
}

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

struct GlassActionBarExample: View {
    @State private var selectedTab: AppTab = .home
    @State private var isShowingActions = false
    @State private var selectedAction: CreateAction?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var tabBarVisibility: Visibility {
        horizontalSizeClass == .compact ? .hidden : .visible
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                ExampleContentView(title: "Home", selectedAction: selectedAction)
                    .fabBarSafeAreaPadding()
                    .toolbarVisibility(tabBarVisibility, for: .tabBar)
            }

            Tab("Activity", systemImage: "chart.bar.fill", value: .activity) {
                ExampleContentView(title: "Activity", selectedAction: selectedAction)
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
                    handle(action)
                }
                .transition(.actionOverlay)
                .zIndex(2)
            }
        }
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

    private func handle(_ action: CreateAction) {
        selectedAction = action

        switch action {
        case .write:
            selectedTab = .home
            // Open a composer.
        case .scan:
            selectedTab = .home
            // Open a camera or scanner.
        case .upload:
            selectedTab = .activity
            // Open an import flow.
        }
    }
}

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

struct ExampleContentView: View {
    let title: String
    let selectedAction: CreateAction?

    var body: some View {
        NavigationStack {
            List {
                Section("Selected Action") {
                    Text(selectedAction?.rawValue ?? "None")
                }
            }
            .navigationTitle(title)
        }
    }
}

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
