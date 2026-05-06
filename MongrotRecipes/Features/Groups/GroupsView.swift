import SwiftUI

/// Groups tab — displays user-defined recipe groups.
/// TODO: Full implementation pending. Will show a list/grid of groups,
/// allow creating, reordering, and deleting groups, and drill into a
/// group's recipe list.
struct GroupsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 52, weight: .light))
                    .foregroundStyle(.white.opacity(0.12))

                Text("Groups")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))

                Text("Coming soon")
                    .font(.system(size: 15))
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    GroupsView()
        .preferredColorScheme(.dark)
}
