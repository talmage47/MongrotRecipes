import SwiftUI

/// A full-bleed horizontal scroll section with a bold header.
/// Used throughout the Collections tab (and future tabs).
struct HorizontalScrollSection<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var showSeeAll: Bool = false
    var onSeeAll: (() -> Void)? = nil
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(
                title: title,
                subtitle: subtitle,
                actionLabel: showSeeAll ? "See All" : nil,
                action: onSeeAll
            )

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    content()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 2) // allow shadow room
            }
        }
    }
}
