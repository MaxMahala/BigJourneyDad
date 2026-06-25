import SwiftUI

struct BAS_StatsView: View {
    @EnvironmentObject var projectStore: BAS_ProjectStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BAS_BackdropView()
            
            VStack(spacing: 24) {
                HStack {
                    Text("Analytics & Stats")
                        .font(BAS_Typography.title(22))
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(BAS_Palette.smokeText)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            statCard(title: "Total Creations", value: "\(projectStore.projects.count)", icon: "slider.horizontal.3")
                            statCard(title: "Favorites", value: "\(projectStore.projects.filter({$0.isFavorite}).count)", icon: "star.fill")
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories Breakdown")
                                .font(BAS_Typography.title(16))
                                .foregroundStyle(BAS_Palette.champagneGold)
                                .padding(.horizontal, 4)
                            
                            ForEach(BAS_ProjectCategory.allCases) { cat in
                                let count = projectStore.projects.filter({ $0.category == cat }).count
                                HStack {
                                    Label(cat.displayName, systemImage: cat.iconName)
                                        .font(BAS_Typography.body(14))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text("\(count) items")
                                        .font(BAS_Typography.caption(13))
                                        .foregroundStyle(BAS_Palette.smokeText)
                                }
                                .padding()
                                .background(BAS_GlassCardBackground(corner: BAS_Metrics.cornerMedium))
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(BAS_Palette.champagneGold)
                Spacer()
            }
            Text(value)
                .font(BAS_Typography.display(28))
                .foregroundStyle(.white)
            Text(title)
                .font(BAS_Typography.caption(12))
                .foregroundStyle(BAS_Palette.smokeText)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(BAS_GlassCardBackground(corner: BAS_Metrics.cornerMedium))
    }
}
