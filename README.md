# Liquid Glass

A small Swift 6 macOS app that demonstrates Apple's native Liquid Glass. No dependencies or simulated blur materials.

## Run

Requires macOS 26 or newer and Xcode 26 or newer (with its command-line tools selected).

```sh
./scripts/build-app.sh
open "dist/Liquid Glass.app"
```

For an optimized build: `./scripts/build-app.sh release`. Open `Package.swift` in Xcode to edit and run the executable scheme. The script creates an ad-hoc signed local app bundle; distribution would require Developer ID signing and notarization.

## Explore

- **Showcase**: native glass buttons over a landscape. Press Explore to animate controls emerging and merging with `GlassEffectContainer`, `glassEffectID`, and matched geometry transitions. Save toggles its state.
- **Playground**: regular/clear material, tint, interactive response, shape merging, and a movable backdrop. Hover and press the controls to compare responses. Shape separation below the container's spacing causes the glass shapes to merge.
- **Settings**: persisted system/light/dark appearance, accent, backdrop, and menu bar tray visibility. Accessible from the sidebar, toolbar, tray, or ⌘,.
- **Collapsible sidebar**: use the native toolbar sidebar button. ⌘1 and ⌘2 switch between the two sections.
- **Menu bar tray**: the drop icon opens a panel with the two sections, Settings, and Quit. Closing the main window leaves the tray available.

Glass is applied to controls, while content uses ordinary surfaces. SwiftUI handles the native material's accessibility behavior; the reveal animation also explicitly respects Reduce Motion.

## APIs

Uses [`glassEffect`](https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views), [`GlassEffectContainer`](https://developer.apple.com/documentation/swiftui/glasseffectcontainer), glass/glassProminent button styles, `NavigationSplitView`, `MenuBarExtra`, and the native `Settings` scene.
