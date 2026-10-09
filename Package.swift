// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LiquidGlass",
    platforms: [.macOS("26.0")],
    products: [.executable(name: "LiquidGlass", targets: ["LiquidGlass"])],
    targets: [.executableTarget(name: "LiquidGlass")],
    swiftLanguageModes: [.v6]
)
