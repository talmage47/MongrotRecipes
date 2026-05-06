import SwiftUI

struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab
    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .glassEffect(in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    }

    @ViewBuilder
    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = selectedTab == tab

        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.icon + ".fill" : tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .symbolEffect(.bounce, value: isSelected)

                Text(tab.label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
            }
            .foregroundStyle(isSelected ? accentColor : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FloatingTabBar(selectedTab: .constant(.collections))
    }
    .preferredColorScheme(.dark)
}
