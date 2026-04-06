import SwiftUI

extension Image {
    /// Initializes a SwiftUI Image from raw Data, cross-platform (iOS + macOS).
    init?(platformImageData data: Data) {
        #if canImport(UIKit)
        guard let image = UIKit.UIImage(data: data) else { return nil }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let image = AppKit.NSImage(data: data) else { return nil }
        self.init(nsImage: image)
        #else
        return nil
        #endif
    }
}
