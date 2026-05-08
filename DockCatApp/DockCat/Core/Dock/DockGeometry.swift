import AppKit

enum DockGeometry {
    static func currentMainDisplaySpace(startPositionPercent: Double) -> ActivitySpace {
        let screen = primaryDisplayScreen()
        let frame = screen?.frame ?? CGRect(x: 0, y: 0, width: 1440, height: 900)
        let visibleFrame = screen?.visibleFrame ?? frame
        return ActivitySpace.make(
            screenFrame: frame,
            visibleFrame: visibleFrame,
            startPositionPercent: CGFloat(startPositionPercent)
        )
    }

    private static func primaryDisplayScreen() -> NSScreen? {
        NSScreen.screens.first { $0.frame.origin == .zero } ?? NSScreen.screens.first
    }
}
