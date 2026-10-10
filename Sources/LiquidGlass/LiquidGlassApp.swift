import AppKit
import SwiftUI

enum Page: String, CaseIterable, Identifiable {
    case showcase = "Showcase", playground = "Playground", settings = "Settings"
    var id: Self { self }
    var symbol: String {
        switch self {
        case .showcase: "sparkles"
        case .playground: "slider.horizontal.3"
        case .settings: "gearshape"
        }
    }
}

enum Accent: String, CaseIterable, Identifiable {
    case blue = "Ocean", purple = "Iris", orange = "Sunset"
    var id: Self { self }
    var color: Color {
        switch self {
        case .blue: .blue
        case .purple: .purple
        case .orange: .orange
        }
    }
}

@MainActor @Observable
final class AppModel {
    var page: Page = .showcase
    var accent: Accent {
        didSet { UserDefaults.standard.set(accent.rawValue, forKey: "accent") }
    }
    var appearance: String {
        didSet { UserDefaults.standard.set(appearance, forKey: "appearance") }
    }
    var vividBackdrop: Bool {
        didSet { UserDefaults.standard.set(vividBackdrop, forKey: "vividBackdrop") }
    }
    var showTray: Bool {
        didSet { UserDefaults.standard.set(showTray, forKey: "showTray") }
    }
    var colorScheme: ColorScheme? {
        appearance == "Light" ? .light : appearance == "Dark" ? .dark : nil
    }
    init() {
        let defaults = UserDefaults.standard
        accent = Accent(rawValue: defaults.string(forKey: "accent") ?? "") ?? .blue
        appearance = defaults.string(forKey: "appearance") ?? "System"
        vividBackdrop = defaults.object(forKey: "vividBackdrop") as? Bool ?? true
        showTray = defaults.object(forKey: "showTray") as? Bool ?? true
    }
}

@main
struct LiquidGlassApp: App {
    @State private var model = AppModel()

    var body: some Scene {
        Window("Liquid Glass", id: "main") {
            ContentView(model: model)
                .modifier(FrostedWindowBackground())
                .tint(model.accent.color)
                .preferredColorScheme(model.colorScheme)
        }
        .defaultSize(width: 1040, height: 740)
        .windowResizability(.contentMinSize)
        .commands {
            CommandMenu("Explore") {
                Button("Showcase") { model.page = .showcase }
                    .keyboardShortcut("1")
                Button("Playground") { model.page = .playground }
                    .keyboardShortcut("2")
            }
        }

        Settings {
            PreferencesView(model: model)
                .padding(28)
                .frame(width: 480)
                .modifier(FrostedWindowBackground())
                .tint(model.accent.color)
                .preferredColorScheme(model.colorScheme)
        }

        MenuBarExtra("Liquid Glass", systemImage: "drop.halffull", isInserted: $model.showTray) {
            TrayView(model: model)
                .tint(model.accent.color)
                .preferredColorScheme(model.colorScheme)
        }
        .menuBarExtraStyle(.window)
    }
}

struct ContentView: View {
    @Bindable var model: AppModel
    @State private var visibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $model.page) {
                Section("Explore") {
                    ForEach([Page.showcase, .playground]) { page in
                        Label(page.rawValue, systemImage: page.symbol).tag(page)
                    }
                }
                Section {
                    Label("Settings", systemImage: "gearshape").tag(Page.settings)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationSplitViewColumnWidth(min: 180, ideal: 210, max: 260)
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 8) {
                    Image(systemName: "drop.halffull").foregroundStyle(model.accent.color)
                    Text("Liquid Glass").font(.caption.weight(.medium))
                    Spacer()
                    Text("Swift 6").font(.caption2).foregroundStyle(.secondary)
                }
                .padding(16)
            }
        } detail: {
            Group {
                switch model.page {
                case .showcase: ShowcaseView(model: model)
                case .playground: PlaygroundView(model: model)
                case .settings:
                    ScrollView {
                        PreferencesView(model: model)
                            .padding(36)
                            .frame(maxWidth: 620)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle(model.page.rawValue)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    SettingsLink { Label("Settings", systemImage: "gearshape") }
                        .help("Open Settings (⌘,)")
                }
            }
        }
        .frame(minWidth: 740, minHeight: 640)
    }
}

struct TrayView: View {
    @Bindable var model: AppModel
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Liquid Glass", systemImage: "drop.halffull")
                .font(.title3.weight(.semibold))
            Text("A little clarity in your menu bar.")
                .font(.caption).foregroundStyle(.secondary)
            ForEach([Page.showcase, .playground]) { page in
                Button {
                    model.page = page
                    openWindow(id: "main")
                    NSApp.activate()
                } label: {
                    Label(page.rawValue, systemImage: page.symbol)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.glass)
            }
            Divider()
            HStack {
                Button("Settings…") {
                    openSettings()
                    NSApp.activate()
                }
                Spacer()
                Button("Quit") { NSApp.terminate(nil) }
            }
            .buttonStyle(.borderless)
        }
        .padding(22)
        .frame(width: 290)
    }
}
