import SwiftUI

struct BAS_TemplatesView: View {
    @EnvironmentObject var router: BAS_AppRouter
    private let templates = BAS_MockDataFactory.makeTemplatePresets()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(templates) { template in
                        BAS_TemplateCardView(template: template) {
                            BAS_HapticManager.shared.triggerImpact(.light)
                            router.openCreationFlow()
                        }
                    }
                }
                .padding(.horizontal, BAS_Metrics.screenPadding)

                Spacer(minLength: 110)
            }
            .padding(.top, 8)
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Templates")
                    .font(BAS_Typography.display(30))
                    .foregroundStyle(.white)
                Text("Curated styles for every story")
                    .font(BAS_Typography.body(14))
                    .foregroundStyle(BAS_Palette.smokeText)
            }
            
            Spacer()
            
            Button {
                BAS_HapticManager.shared.triggerImpact(.light)
                withAnimation(.spring()) {
                    router.presentedSheet = .advancedDiscovery
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 14, weight: .bold))
                    Text("Studio")
                        .font(BAS_Typography.caption(13))
                }
                .foregroundStyle(BAS_Palette.voidBlack)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(BAS_Gradient.goldSheen)
                )
                .shadow(color: BAS_Palette.richGold.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
}

struct BAS_TemplateCardView: View {
    let template: BAS_TemplatePreset
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 130)
                    .overlay(
                        Image(systemName: template.category.iconName)
                            .font(.system(size: 30))
                            .foregroundStyle(.white.opacity(0.85))
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: BAS_Metrics.cornerMedium, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name)
                        .font(BAS_Typography.title(14))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text(template.category.displayName)
                        .font(BAS_Typography.body(11))
                        .foregroundStyle(BAS_Palette.smokeText)
                }
                .padding(.top, 10)
                .padding(.horizontal, 4)
            }
            .padding(10)
            .background(BAS_GlassCardBackground(corner: BAS_Metrics.cornerMedium))
        }
        .buttonStyle(.plain)
    }

    private var gradientColors: [Color] {
        switch template.category {
        case .portrait: return [BAS_Palette.orchidGlow, BAS_Palette.royalViolet]
        case .fitness: return [BAS_Palette.richGold, BAS_Palette.bronzeGold]
        case .interior: return [BAS_Palette.electricViolet, BAS_Palette.deepPlum]
        case .nature: return [BAS_Palette.champagneGold, BAS_Palette.royalViolet]
        case .renovation: return [BAS_Palette.bronzeGold, BAS_Palette.deepPlum]
        case .art: return [BAS_Palette.orchidGlow, BAS_Palette.richGold]
        case .other: return [BAS_Palette.royalViolet, BAS_Palette.voidBlack]
        }
    }
}

#Preview {
    BAS_TemplatesView()
        .environmentObject(BAS_AppRouter())
}
