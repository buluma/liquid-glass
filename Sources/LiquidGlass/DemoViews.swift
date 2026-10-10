import SwiftUI

struct ScenicBackdrop: View {
    var vivid: Bool
    var shift: Double = 0

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: vivid ? [Color(red: 0.18, green: 0.36, blue: 0.57),
                                     Color(red: 0.55, green: 0.72, blue: 0.75),
                                     Color(red: 0.96, green: 0.73, blue: 0.52)] : [.gray, .gray.opacity(0.3)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                Circle()
                    .fill(Color(red: 1, green: 0.86, blue: 0.65))
                    .frame(width: 130, height: 130)
                    .blur(radius: 2)
                    .position(x: proxy.size.width * (0.76 - shift * 0.35), y: proxy.size.height * 0.27)
                ForEach(0..<4) { index in
                    Ellipse()
                        .fill(Color(red: 0.10 + Double(index) * 0.035,
                                    green: 0.28 + Double(index) * 0.04,
                                    blue: 0.33 + Double(index) * 0.04))
                        .frame(width: proxy.size.width * 1.6, height: proxy.size.height * 0.75)
                        .rotationEffect(.degrees(index.isMultiple(of: 2) ? -18 : 16))
                        .position(x: proxy.size.width * (index.isMultiple(of: 2) ? 0.15 : 0.9),
                                  y: proxy.size.height * (0.87 + Double(index) * 0.13))
                }
            }
        }
        .clipped()
        .accessibilityHidden(true)
    }
}

struct PageIntro: View {
    var eyebrow: String
    var title: String
    var subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow.uppercased())
                .font(.caption.weight(.semibold)).tracking(2).foregroundStyle(.secondary)
            Text(title).font(.system(size: 32, weight: .semibold, design: .rounded))
            Text(subtitle).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ShowcaseView: View {
    var model: AppModel
    @State private var expanded = false
    @State private var saved = false
    @Namespace private var glassNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                PageIntro(eyebrow: "Made of light", title: "Meet Liquid Glass.",
                          subtitle: "Translucent controls that catch the light, adapt to their surroundings, and move together.")
                ZStack(alignment: .bottom) {
                    ScenicBackdrop(vivid: model.vividBackdrop)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("THE QUIET HOURS").font(.caption.weight(.semibold)).tracking(3)
                        Text("Take a moment.").font(.system(size: 36, weight: .medium, design: .serif))
                        Text("A landscape beneath a living material.").font(.subheadline)
                    }
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 8, y: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(28)

                    GlassEffectContainer(spacing: 20) {
                        HStack(spacing: 12) {
                            Button {
                                withAnimation(reduceMotion ? nil : .spring(response: 0.45, dampingFraction: 0.8)) {
                                    expanded.toggle()
                                }
                            } label: {
                                Label(expanded ? "Less" : "Explore", systemImage: expanded ? "minus" : "plus")
                                    .padding(.horizontal, 8).padding(.vertical, 6)
                            }
                            .buttonStyle(.glass)
                            .glassEffectID("expand", in: glassNamespace)
                            if expanded {
                                Button { saved.toggle() } label: {
                                    Label(saved ? "Saved" : "Save", systemImage: saved ? "bookmark.fill" : "bookmark")
                                        .padding(.horizontal, 8).padding(.vertical, 6)
                                }
                                .buttonStyle(.glass)
                                .glassEffectID("save", in: glassNamespace)
                                .glassEffectTransition(.matchedGeometry)
                                Label("Slow down", systemImage: "leaf")
                                    .padding(14)
                                    .glassEffect(.regular.tint(model.accent.color), in: .capsule)
                                    .glassEffectID("leaf", in: glassNamespace)
                                    .glassEffectTransition(.matchedGeometry)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                    .padding(24)
                }
                .frame(height: 330)
                .clipShape(.rect(cornerRadius: 24))
                .accessibilityElement(children: .contain)

                HStack(alignment: .top, spacing: 24) {
                    FeatureNote(symbol: "circle.lefthalf.filled", title: "Real material",
                                text: "The system renders translucency, highlights, and the backdrop through native glass.")
                    FeatureNote(symbol: "cursorarrow.rays", title: "Responds to you",
                                text: "Hover and press the controls to see their native interactive response.")
                    FeatureNote(symbol: "arrow.triangle.merge", title: "Moves as one",
                                text: "Press Explore to reveal controls that merge and separate within a glass container.")
                }
                Text("Glass belongs on the control layer. The landscape and this text remain ordinary content.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .padding(32)
            .frame(maxWidth: 1000)
            .frame(maxWidth: .infinity)
        }
    }
}

struct FeatureNote: View {
    var symbol: String
    var title: String
    var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol).font(.title2).foregroundStyle(.secondary)
            Text(title).font(.headline)
            Text(text).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentSurface()
    }
}

struct PlaygroundView: View {
    var model: AppModel
    @State private var tinted = true
    @State private var interactive = true
    @State private var clear = false
    @State private var separation = 12.0
    @State private var backdropPosition = 0.0
    @State private var liked = false

    private var material: Glass {
        let glass: Glass = clear ? .clear : .regular
        return glass.tint(tinted ? model.accent.color : nil).interactive(interactive)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                PageIntro(eyebrow: "A material study", title: "Make it your own.",
                          subtitle: "Change the glass, move the backdrop, and bring the shapes together.")
                ZStack {
                    ScenicBackdrop(vivid: model.vividBackdrop, shift: backdropPosition)
                    GlassEffectContainer(spacing: 30) {
                        HStack(spacing: separation) {
                            Image(systemName: "sun.max")
                                .font(.system(size: 28))
                                .frame(width: 82, height: 82)
                                .glassEffect(material, in: .circle)
                            Image(systemName: "water.waves")
                                .font(.system(size: 28))
                                .frame(width: 82, height: 82)
                                .glassEffect(material, in: .circle)
                            Image(systemName: "moon")
                                .font(.system(size: 28))
                                .frame(width: 82, height: 82)
                                .glassEffect(material, in: .circle)
                        }
                    }
                    VStack {
                        Spacer()
                        Button { liked.toggle() } label: {
                            Label(liked ? "Favourited" : "Favourite this view", systemImage: liked ? "heart.fill" : "heart")
                                .padding(8)
                        }
                        .buttonStyle(.glassProminent)
                    }
                    .padding(24)
                }
                .frame(height: 290)
                .clipShape(.rect(cornerRadius: 24))
                Form {
                    Section("Material") {
                        Toggle("Tinted glass", isOn: $tinted)
                        Toggle("Interactive response", isOn: $interactive)
                        Toggle("Clear variant", isOn: $clear)
                        Text("Clear glass is best over rich backgrounds. Regular glass provides stronger separation.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Section("Composition") {
                        Slider(value: $separation, in: 0...60) { Text("Shape separation") }
                        Slider(value: $backdropPosition, in: 0...1) { Text("Backdrop position") }
                    }
                }
                .formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .frame(height: 330)
            }
            .padding(32)
            .frame(maxWidth: 1000)
            .frame(maxWidth: .infinity)
        }
    }
}

struct PreferencesView: View {
    @Bindable var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PageIntro(eyebrow: "Just the essentials", title: "Settings",
                      subtitle: "A few small choices. Saved automatically.")
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $model.appearance) {
                        ForEach(["System", "Light", "Dark"], id: \.self) { Text($0).tag($0) }
                    }
                    Picker("Accent", selection: $model.accent) {
                        ForEach(Accent.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Toggle("Colourful backdrop", isOn: $model.vividBackdrop)
                }
                Section("Menu bar") {
                    Toggle("Show menu bar tray", isOn: $model.showTray)
                    Text("Use the drop icon in the macOS menu bar to open either section or Settings.")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            .frame(height: 290)
            Label("Respects macOS Reduce Motion and Reduce Transparency settings.", systemImage: "accessibility")
                .font(.caption).foregroundStyle(.secondary)
            Text("Swift 6 · SwiftUI · Native Liquid Glass")
                .font(.caption2).foregroundStyle(.tertiary)
        }
    }
}
