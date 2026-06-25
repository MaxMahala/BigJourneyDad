import SwiftUI

struct BAS_MainTabContainerView: View {
    @EnvironmentObject var router: BAS_AppRouter
    //
    var body: some View {
        ZStack(alignment: .bottom) {
            BAS_BackdropView()

            ZStack {
                BAS_GalleryView()
                    .opacity(router.selectedTab == .gallery ? 1 : 0)
                    .allowsHitTesting(router.selectedTab == .gallery)

                BAS_TemplatesView()
                    .opacity(router.selectedTab == .templates ? 1 : 0)
                    .allowsHitTesting(router.selectedTab == .templates)

                BAS_FavoritesView()
                    .opacity(router.selectedTab == .favorites ? 1 : 0)
                    .allowsHitTesting(router.selectedTab == .favorites)

                BAS_SettingsView()
                    .opacity(router.selectedTab == .settings ? 1 : 0)
                    .allowsHitTesting(router.selectedTab == .settings)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            BAS_CustomTabBar(selected: $router.selectedTab) {
                router.openCreationFlow()
                BAS_HapticManager.shared.triggerImpact(.light)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(item: $router.presentedSheet) { destination in
            switch destination {
            case .createSource:
                BAS_CreateProjectView()
            case .editor:
                if let project = router.activeProject {
                    BAS_ProjectDetailView(project: project)
                }
            case .projectDetail(let project):
                BAS_ProjectDetailView(project: project)
            case .generateRandom:
                BAS_GenerateRandomlyView()
            case .stats:
                BAS_StatsView()
            case .advancedDiscovery:
                BAS_AdvancedDiscoveryView()
            case .profile:
                BAS_ProfileView()
            }
        }
    }
}

struct BAS_CustomTabBar: View {
    @Binding var selected: BAS_MainTab
    let onCreateTap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.gallery)
            tabButton(.templates)
            createButton
            tabButton(.favorites)
            tabButton(.settings)
        }
        .padding(.horizontal, 10)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            BAS_Palette.voidBlack.opacity(0.92)
                .overlay(
                    Rectangle()
                        .fill(BAS_Gradient.dividerGold.opacity(0.5))
                        .frame(height: 1),
                    alignment: .top
                )
        )
    }

    private func tabButton(_ tab: BAS_MainTab) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selected = tab
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(selected == tab ? AnyShapeStyle(BAS_Gradient.goldSheen) : AnyShapeStyle(BAS_Palette.smokeText))

                Text(tab.title)
                    .font(BAS_Typography.caption(10))
                    .foregroundStyle(selected == tab ? BAS_Palette.champagneGold : BAS_Palette.smokeText)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var createButton: some View {
        Button(action: onCreateTap) {
            ZStack {
                Circle()
                    .fill(BAS_Gradient.goldSheen)
                    .frame(width: 52, height: 52)
                    .shadow(color: BAS_Palette.richGold.opacity(0.55), radius: 14, x: 0, y: 6)

                Image(systemName: "plus")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(BAS_Palette.voidBlack)
            }
            .offset(y: -14)
            .frame(maxWidth: .infinity)
        }
    }
}
