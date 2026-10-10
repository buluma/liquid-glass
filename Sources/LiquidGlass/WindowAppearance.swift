import SwiftUI

/// One continuous native backdrop lets desktop colours show through the window.
/// Card fills add contrast without placing another blur over each panel.
struct FrostedWindowBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        content
            .background(reduceTransparency ? AnyShapeStyle(.background) : AnyShapeStyle(
                colorScheme == .dark ? Color.black.opacity(0.25) : Color.white.opacity(0.12)
            ))
            .containerBackground(
                reduceTransparency ? AnyShapeStyle(.background) : AnyShapeStyle(Material.thin),
                for: .window
            )
    }
}

private struct ContentSurface: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorScheme) private var colorScheme

    private var fill: AnyShapeStyle {
        if reduceTransparency { return AnyShapeStyle(.background.secondary) }
        return AnyShapeStyle(colorScheme == .dark ? Color.white.opacity(0.07) : Color.white.opacity(0.50))
    }

    func body(content: Content) -> some View {
        content.background(fill, in: .rect(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(.primary.opacity(0.08), lineWidth: 1))
    }
}

extension View {
    func contentSurface(cornerRadius: CGFloat = 18) -> some View {
        modifier(ContentSurface(cornerRadius: cornerRadius))
    }
}
