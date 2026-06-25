import SwiftUI

struct BAS_FavoritesView: View {
    @EnvironmentObject var projectStore: BAS_ProjectStore
    @EnvironmentObject var router: BAS_AppRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header

                if projectStore.favoriteProjects.isEmpty {
                    BAS_FavoritesEmptyState()
                        .padding(.top, 60)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(projectStore.favoriteProjects) { project in
                            BAS_ProjectCardView(project: project)
                                .onTapGesture {
                                    BAS_HapticManager.shared.triggerImpact(.light)
                                    router.presentedSheet = .projectDetail(project)
                                }
                        }
                    }
                    .padding(.horizontal, BAS_Metrics.screenPadding)
                }

                Spacer(minLength: 110)
            }
            .padding(.top, 8)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Favorites")
                .font(BAS_Typography.display(30))
                .foregroundStyle(.white)
            Text("Your starred transformations")
                .font(BAS_Typography.body(14))
                .foregroundStyle(BAS_Palette.smokeText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
}

struct BAS_FavoritesEmptyState: View {
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "star.circle")
                .font(.system(size: 44))
                .foregroundStyle(BAS_Gradient.goldSheen)

            Text("No Favorites Yet")
                .font(BAS_Typography.title(20))
                .foregroundStyle(.white)

            Text("Tap the star icon on any slider to keep it close at hand here.")
                .font(BAS_Typography.body(14))
                .foregroundStyle(BAS_Palette.smokeText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
        }
    }
}

#Preview {
    BAS_FavoritesView()
        .environmentObject(BAS_ProjectStore())
        .environmentObject(BAS_AppRouter())
}
