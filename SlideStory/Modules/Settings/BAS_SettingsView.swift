import SwiftUI

struct BAS_SettingsView: View {
    @EnvironmentObject var permissionManager: BAS_PermissionManager
    @EnvironmentObject var router: BAS_AppRouter
    @AppStorage("bas_haptics_enabled") private var hapticsEnabled: Bool = true
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                
                BAS_SettingsSection(title: "Account") {
                    Button {
                        BAS_HapticManager.shared.triggerImpact(.light)
                        withAnimation(.spring()) {
                            router.presentedSheet = .profile
                        }
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(BAS_Palette.orchidGlow.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(BAS_Gradient.goldSheen)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Me")
                                    .font(BAS_Typography.title(15))
                                    .foregroundStyle(.white)
                                Text("View 3D Athlete Profile")
                                    .font(BAS_Typography.body(12))
                                    .foregroundStyle(BAS_Palette.smokeText)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(BAS_Palette.smokeText)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.02))
                    }
                    .buttonStyle(.plain)
                }

                BAS_SettingsSection(title: "Permissions") {
                    BAS_PermissionRow(
                        icon: "camera.fill",
                        title: "Camera Access",
                        state: permissionManager.cameraState
                    ) {
                        BAS_HapticManager.shared.triggerImpact(.light)
                        permissionManager.openSystemSettings()
                    }
                    BAS_PermissionRow(
                        icon: "photo.on.rectangle",
                        title: "Photo Library Access",
                        state: permissionManager.galleryState
                    ) {
                        BAS_HapticManager.shared.triggerImpact(.light)
                        permissionManager.openSystemSettings()
                    }
                }

                BAS_SettingsSection(title: "Preferences") {
                    BAS_ToggleRow(icon: "waveform", title: "Haptic Feedback", isOn: $hapticsEnabled)
                }

                BAS_SettingsSection(title: "Support") {
                    BAS_NavigationRow(icon: "star.bubble.fill", title: "Rate the App") {
                        BAS_HapticManager.shared.triggerNotification(.success)
                        
                        BAS_ReviewManager.shared.requestAppReview()
                    }
                    
                    BAS_NavigationRow(icon: "hand.raised.fill", title: "Privacy Policy") {
                        BAS_HapticManager.shared.triggerImpact(.light)
                        if let url = URL(string: COnfigmMText.privacyOPFIFk3j2345) {
                            openURL(url)
                        }
                    }
                }

                Text("\(COnfigmMText.MNamnameStreApp) v1.0.0")
                    .font(BAS_Typography.body(12))
                    .foregroundStyle(BAS_Palette.smokeText.opacity(0.6))
                    .padding(.top, 8)

                Spacer(minLength: 110)
            }
            .padding(.top, 8)
        }
        .onAppear {
            permissionManager.refreshStates()
        }
    }

    private var header: some View {
        Text("Settings")
            .font(BAS_Typography.display(30))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, BAS_Metrics.screenPadding)
    }
}

struct BAS_SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(BAS_Typography.caption(13))
                .foregroundStyle(BAS_Palette.smokeText)
                .padding(.horizontal, BAS_Metrics.screenPadding)

            VStack(spacing: 1) {
                content
            }
            .background(BAS_GlassCardBackground())
            .padding(.horizontal, BAS_Metrics.screenPadding)
        }
    }
}

struct BAS_PermissionRow: View {
    let icon: String
    let title: String
    let state: BAS_PermissionState
    let onFix: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(BAS_Gradient.goldSheen)
                .frame(width: 26)

            Text(title)
                .font(BAS_Typography.body(15))
                .foregroundStyle(.white)

            Spacer()

            statusBadge
        }
        .padding(16)
        .contentShape(Rectangle())
        .onTapGesture {
            if state != .granted { onFix() }
        }
    }

    private var statusBadge: some View {
        Group {
            switch state {
            case .granted:
                Label("Allowed", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(BAS_Palette.successMint)
            case .denied, .restricted:
                Label("Denied", systemImage: "xmark.circle.fill")
                    .foregroundStyle(BAS_Palette.dangerRose)
            case .notDetermined:
                Label("Not Set", systemImage: "questionmark.circle.fill")
                    .foregroundStyle(BAS_Palette.smokeText)
            }
        }
        .font(BAS_Typography.caption(12))
        .labelStyle(.titleAndIcon)
    }
}

struct BAS_ToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(BAS_Gradient.goldSheen)
                .frame(width: 26)

            Text(title)
                .font(BAS_Typography.body(15))
                .foregroundStyle(.white)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(BAS_Palette.richGold)
        }
        .padding(16)
    }
}

struct BAS_NavigationRow: View {
    let icon: String
    let title: String
    var cdsfaction: () -> Void

    var body: some View {
        Button {
            cdsfaction()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(BAS_Gradient.goldSheen)
                    .frame(width: 26)
                
                Text(title)
                    .font(BAS_Typography.body(15))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(BAS_Palette.smokeText)
            }
            .padding(16)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    BAS_SettingsView()
        .environmentObject(BAS_PermissionManager())
        .environmentObject(BAS_AppRouter())
}
