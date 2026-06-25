import SwiftUI

struct BAS_GalleryView: View {
    @EnvironmentObject var projectStore: BAS_ProjectStore
    @EnvironmentObject var router: BAS_AppRouter
    @State private var selectedCategoryFilter: BAS_ProjectCategory?

    private var filteredProjects: [BAS_SliderProject] {
        guard let filter = selectedCategoryFilter else { return projectStore.projects }
        return projectStore.projects(in: filter)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection

                if !projectStore.projects.isEmpty {
                    categoryFilterRow
                }

                if filteredProjects.isEmpty {
                    BAS_EmptyStateView()
                        .padding(.top, 60)
                } else {
                    projectsGrid
                }

                Spacer(minLength: 110)
            }
            .padding(.top, 8)
        }
    }

    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Sliders")
                    .font(BAS_Typography.display(30))
                    .foregroundStyle(.white)
                
                Text("\(projectStore.projects.count) creations")
                    .font(BAS_Typography.body(14))
                    .foregroundStyle(BAS_Palette.smokeText)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    BAS_HapticManager.shared.triggerImpact(.light)
                    router.presentedSheet = .generateRandom
                } label: {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(BAS_Palette.voidBlack)
                        .padding(10)
                        .background(Circle().fill(BAS_Gradient.goldSheen))
                }
                
                Button {
                    BAS_HapticManager.shared.triggerImpact(.light)
                    router.presentedSheet = .stats
                } label: {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
            }
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }

    private var categoryFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                BAS_FilterChip(title: "All", isSelected: selectedCategoryFilter == nil) {
                    selectedCategoryFilter = nil
                }
                ForEach(BAS_ProjectCategory.allCases) { category in
                    BAS_FilterChip(title: category.displayName, isSelected: selectedCategoryFilter == category) {
                        BAS_HapticManager.shared.triggerImpact(.light)
                        selectedCategoryFilter = category
                    }
                }
            }
            .padding(.horizontal, BAS_Metrics.screenPadding)
        }
    }

    private var projectsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            ForEach(filteredProjects) { project in
                BAS_ProjectCardView(project: project)
                    .onTapGesture {
                        BAS_HapticManager.shared.triggerImpact(.light)
                        router.presentedSheet = .projectDetail(project)
                    }
            }
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
}

struct BAS_FilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(BAS_Typography.caption(13))
                .foregroundStyle(isSelected ? BAS_Palette.voidBlack : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(
                    Capsule().fill(isSelected ? AnyShapeStyle(BAS_Gradient.goldSheen) : AnyShapeStyle(Color.white.opacity(0.08)))
                )
        }
    }
}

struct BAS_ProjectCardView: View {
    let project: BAS_SliderProject

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                BAS_ResolvedImage(name: project.afterImageName)
                    .frame(height: 160)
                    .clipped()

                if project.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(BAS_Palette.champagneGold)
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.5)))
                        .padding(8)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: BAS_Metrics.cornerMedium, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(project.title)
                    .font(BAS_Typography.title(14))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: project.category.iconName)
                        .font(.system(size: 10))
                    Text(project.category.displayName)
                        .font(BAS_Typography.body(11))
                }
                .foregroundStyle(BAS_Palette.smokeText)
            }
            .padding(.top, 10)
            .padding(.horizontal, 4)
        }
        .padding(10)
        .background(BAS_GlassCardBackground(corner: BAS_Metrics.cornerMedium))
    }
}

struct BAS_EmptyStateView: View {
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 44))
                .foregroundStyle(BAS_Gradient.goldSheen)

            Text("No Sliders Yet")
                .font(BAS_Typography.title(20))
                .foregroundStyle(.white)

            Text("Tap the gold plus button below to create your first before / after masterpiece.")
                .font(BAS_Typography.body(14))
                .foregroundStyle(BAS_Palette.smokeText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
        }
    }
}

#Preview {
    BAS_GalleryView()
        .environmentObject(BAS_ProjectStore())
        .environmentObject(BAS_AppRouter())
}
