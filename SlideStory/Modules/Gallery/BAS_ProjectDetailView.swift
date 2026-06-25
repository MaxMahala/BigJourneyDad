import SwiftUI

struct BAS_ProjectDetailView: View {
    let project: BAS_SliderProject
    @EnvironmentObject var projectStore: BAS_ProjectStore
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet: Bool = false
    @State private var showDeleteConfirm: Bool = false

    var body: some View {
        ZStack {
            BAS_BackdropView()

            VStack(spacing: 20) {
                header

                BAS_CompareSliderView(
                    beforeImageName: project.beforeImageName,
                    afterImageName: project.afterImageName,
                    style: project.style
                )
                .padding(.horizontal, BAS_Metrics.screenPadding)
                .frame(maxHeight: 460)

                infoCard

                Spacer()

                actionRow
                    .padding(.horizontal, BAS_Metrics.screenPadding)
                    .padding(.bottom, 24)
            }
        }
        .confirmationDialog("Delete this slider?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                projectStore.remove(project)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.white.opacity(0.08)))
            }

            Spacer()

            Text(project.title)
                .font(BAS_Typography.title(17))
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()

            Button {
                projectStore.toggleFavorite(project)
            } label: {
                Image(systemName: project.isFavorite ? "star.fill" : "star")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(BAS_Palette.champagneGold)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(Color.white.opacity(0.08)))
            }
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
        .padding(.top, 8)
    }

    private var infoCard: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(project.category.displayName)
                    .font(BAS_Typography.caption(13))
                    .foregroundStyle(BAS_Palette.champagneGold)
                Text(project.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(BAS_Typography.body(12))
                    .foregroundStyle(BAS_Palette.smokeText)
            }

            Spacer()

            Image(systemName: project.style.direction.iconName)
                .foregroundStyle(BAS_Palette.smokeText)
        }
        .padding(16)
        .background(BAS_GlassCardBackground())
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }

    private var actionRow: some View {
        HStack(spacing: 14) {
            Button {
                showShareSheet = true
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .bas_goldButtonStyle()
            }

            Button {
                showDeleteConfirm = true
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(BAS_Palette.dangerRose)
                    .frame(width: 58, height: 58)
                    .background(
                        RoundedRectangle(cornerRadius: 29, style: .continuous)
                            .fill(Color.white.opacity(0.06))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 29, style: .continuous)
                            .strokeBorder(BAS_Palette.dangerRose.opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .sheet(isPresented: $showShareSheet) {
            BAS_ShareSliderSheet(project: project)
        }
    }
}

struct BAS_ShareSliderSheet: View {
    let project: BAS_SliderProject
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BAS_BackdropView()
            VStack(spacing: 24) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)

                Text("Share Your Slider")
                    .font(BAS_Typography.title(20))
                    .foregroundStyle(.white)

                BAS_CompareSliderView(
                    beforeImageName: project.beforeImageName,
                    afterImageName: project.afterImageName,
                    style: project.style,
                    isInteractive: false
                )
                .frame(height: 280)
                .padding(.horizontal, BAS_Metrics.screenPadding)

                VStack(spacing: 12) {
                    BAS_ShareOptionRow(icon: "square.and.arrow.up", title: "Share via System Sheet")
                    BAS_ShareOptionRow(icon: "square.and.arrow.down", title: "Save to Photo Library")
                    BAS_ShareOptionRow(icon: "link", title: "Copy Link")
                }
                .padding(.horizontal, BAS_Metrics.screenPadding)

                Spacer()
            }
        }
    }
}

struct BAS_ShareOptionRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(BAS_Gradient.goldSheen)
                .frame(width: 34)

            Text(title)
                .font(BAS_Typography.body(15))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(BAS_Palette.smokeText)
        }
        .padding(16)
        .background(BAS_GlassCardBackground(corner: BAS_Metrics.cornerSmall))
    }
}

#Preview {
    BAS_ProjectDetailView(project: BAS_MockDataFactory.makeMockProjects()[0])
        .environmentObject(BAS_ProjectStore())
}
