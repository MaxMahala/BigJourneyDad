import SwiftUI

struct BAS_CreateProjectView: View {
    @EnvironmentObject var router: BAS_AppRouter
    @EnvironmentObject var projectStore: BAS_ProjectStore
    @EnvironmentObject var permissionManager: BAS_PermissionManager
    @StateObject private var viewModel = BAS_CreateProjectViewModel()
    @State private var slotPendingSourceChoice: BAS_PhotoSlot?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BAS_BackdropView()

            ScrollView {
                VStack(spacing: 26) {
                    header

                    VStack(spacing: 18) {
                        BAS_PhotoSlotCard(
                            slotTitle: "Before Photo",
                            image: viewModel.beforeImage,
                            accentIcon: "1.circle.fill"
                        ) {
                            slotPendingSourceChoice = .before
                        }

                        BAS_PhotoSlotCard(
                            slotTitle: "After Photo",
                            image: viewModel.afterImage,
                            accentIcon: "2.circle.fill"
                        ) {
                            slotPendingSourceChoice = .after
                        }
                    }
                    .padding(.horizontal, BAS_Metrics.screenPadding)

                    if viewModel.bothImagesReady {
                        previewSection
                        detailsSection
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
            }

            VStack {
                Spacer()
                bottomActionBar
            }
        }
        .confirmationDialog(
            "Choose Photo Source",
            isPresented: Binding(
                get: { slotPendingSourceChoice != nil },
                set: { if !$0 { slotPendingSourceChoice = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Take Photo") {
                if let slot = slotPendingSourceChoice {
                    viewModel.requestSource(for: slot, useCamera: true, permissionManager: permissionManager)
                }
                slotPendingSourceChoice = nil
            }
            Button("Choose from Gallery") {
                if let slot = slotPendingSourceChoice {
                    viewModel.requestSource(for: slot, useCamera: false, permissionManager: permissionManager)
                }
                slotPendingSourceChoice = nil
            }
            Button("Cancel", role: .cancel) {
                slotPendingSourceChoice = nil
            }
        }
        .sheet(item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .camera(let slot):
                BAS_ImagePickerRepresentable(
                    source: .camera,
                    onImagePicked: { image in viewModel.assignPicked(image: image, slot: slot) },
                    onCancel: { viewModel.activeSheet = nil }
                )
                .ignoresSafeArea()
            case .gallery(let slot):
                BAS_ImagePickerRepresentable(
                    source: .photoLibrary,
                    onImagePicked: { image in viewModel.assignPicked(image: image, slot: slot) },
                    onCancel: { viewModel.activeSheet = nil }
                )
                .ignoresSafeArea()
            }
        }
        .alert("Permission Needed", isPresented: $viewModel.showPermissionAlert) {
            Button("Open Settings") { permissionManager.openSystemSettings() }
            Button("Not Now", role: .cancel) {}
        } message: {
            Text(viewModel.permissionAlertMessage)
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

            Text("New Slider")
                .font(BAS_Typography.title(18))
                .foregroundStyle(.white)

            Spacer()

            Color.clear.frame(width: 34, height: 34)
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live Preview")
                .font(BAS_Typography.caption(13))
                .foregroundStyle(BAS_Palette.smokeText)
                .padding(.horizontal, BAS_Metrics.screenPadding)

            BAS_LivePreviewSlider(before: viewModel.beforeImage, after: viewModel.afterImage, style: viewModel.styleConfig)
                .frame(height: 320)
                .padding(.horizontal, BAS_Metrics.screenPadding)
        }
    }

    private var detailsSection: some View {
        VStack(spacing: 18) {
            BAS_TitledTextField(title: "Project Name", text: $viewModel.projectTitle, placeholder: "Golden Hour Glow")

            BAS_CategoryPickerRow(selected: $viewModel.selectedCategory)

            BAS_StyleConfiguratorView(config: $viewModel.styleConfig)
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }

    private var bottomActionBar: some View {
        VStack {
            if viewModel.bothImagesReady {
                Button {
                    if let project = viewModel.buildProject() {
                        projectStore.add(project)
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Slider")
                    }
                    .bas_goldButtonStyle()
                }
                .padding(.horizontal, BAS_Metrics.screenPadding)
                .padding(.bottom, 16)
                .padding(.top, 10)
                .background(
                    LinearGradient(colors: [Color.clear, BAS_Palette.voidBlack.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                )
            }
        }
    }
}

struct BAS_PhotoSlotCard: View {
    let slotTitle: String
    let image: UIImage?
    let accentIcon: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                BAS_GlassCardBackground()

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: BAS_Metrics.cornerMedium, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: BAS_Metrics.cornerMedium, style: .continuous)
                                .strokeBorder(BAS_Palette.champagneGold.opacity(0.5), lineWidth: 1.2)
                        )
                } else {
                    HStack(spacing: 14) {
                        Image(systemName: accentIcon)
                            .font(.system(size: 22))
                            .foregroundStyle(BAS_Gradient.goldSheen)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(slotTitle)
                                .font(BAS_Typography.title(16))
                                .foregroundStyle(.white)
                            Text("Tap to add a photo")
                                .font(BAS_Typography.body(13))
                                .foregroundStyle(BAS_Palette.smokeText)
                        }

                        Spacer()

                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(BAS_Gradient.goldSheen)
                    }
                    .padding(.horizontal, 18)
                    .frame(height: 84)
                }
            }
            .frame(height: image == nil ? 84 : 140)
        }
        .buttonStyle(.plain)
    }
}

struct BAS_LivePreviewSlider: View {
    let before: UIImage?
    let after: UIImage?
    let style: BAS_ProjectStyleConfig

    var body: some View {
        if let before, let after {
            BAS_CompareSliderUIImageView(before: before, after: after, style: style)
        } else {
            RoundedRectangle(cornerRadius: BAS_Metrics.cornerLarge)
                .fill(Color.white.opacity(0.05))
        }
    }
}

struct BAS_TitledTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(BAS_Typography.caption(13))
                .foregroundStyle(BAS_Palette.smokeText)

            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(BAS_Palette.smokeText.opacity(0.5)))
                .font(BAS_Typography.body(16))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: BAS_Metrics.cornerSmall, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: BAS_Metrics.cornerSmall, style: .continuous)
                        .strokeBorder(BAS_Palette.champagneGold.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct BAS_CategoryPickerRow: View {
    @Binding var selected: BAS_ProjectCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category")
                .font(BAS_Typography.caption(13))
                .foregroundStyle(BAS_Palette.smokeText)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(BAS_ProjectCategory.allCases) { category in
                        Button {
                            selected = category
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: category.iconName)
                                Text(category.displayName)
                            }
                            .font(BAS_Typography.caption(13))
                            .foregroundStyle(selected == category ? BAS_Palette.voidBlack : .white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(
                                Capsule().fill(selected == category ? AnyShapeStyle(BAS_Gradient.goldSheen) : AnyShapeStyle(Color.white.opacity(0.08)))
                            )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BAS_CreateProjectView()
        .environmentObject(BAS_AppRouter())
        .environmentObject(BAS_ProjectStore())
        .environmentObject(BAS_PermissionManager())
}
