import SwiftUI

struct BAS_OnboardingContainerView: View {
    @EnvironmentObject var router: BAS_AppRouter
    @StateObject private var viewModel = BAS_OnboardingViewModel()

    var body: some View {
        ZStack {
            BAS_BackdropView()

            VStack(spacing: 0) {
                topSkipBar

                TabView(selection: $viewModel.currentIndex) {
                    ForEach(viewModel.pages) { page in
                        BAS_OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentIndex)

                pageIndicator
                    .padding(.top, 8)

                continueButton
                    .padding(.horizontal, BAS_Metrics.screenPadding)
                    .padding(.top, 22)
                    .padding(.bottom, 18)
            }
        }
    }

    private var topSkipBar: some View {
        HStack {
            Spacer()
            if !viewModel.isLastPage {
                Button {
                    viewModel.skipToEnd()
                } label: {
                    Text("Skip")
                        .font(BAS_Typography.body(15))
                        .foregroundStyle(BAS_Palette.smokeText)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(.top, 8)
        .padding(.trailing, 8)
        .frame(height: 44)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.pages) { page in
                Capsule()
                    .fill(page.id == viewModel.currentIndex ? BAS_Gradient.goldSheen : LinearGradient(colors: [Color.white.opacity(0.18)], startPoint: .top, endPoint: .bottom))
                    .frame(width: page.id == viewModel.currentIndex ? 26 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
            }
        }
    }

    private var continueButton: some View {
        Button {
            viewModel.advance {
                router.completeOnboarding()
            }
        } label: {
            HStack(spacing: 8) {
                Text(viewModel.isLastPage ? "Get Started" : "Continue")
                if !viewModel.isLastPage {
                    Image(systemName: "arrow.right")
                }
            }
            .bas_goldButtonStyle()
        }
    }
}

struct BAS_OnboardingPageView: View {
    let page: BAS_OnboardPage

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                Image(page.imageAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: BAS_Metrics.cornerLarge, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: BAS_Metrics.cornerLarge, style: .continuous)
                            .strokeBorder(
                                LinearGradient(colors: [BAS_Palette.champagneGold.opacity(0.6), Color.white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 1.4
                            )
                    )
                    .shadow(color: BAS_Palette.royalViolet.opacity(0.4), radius: 26, x: 0, y: 16)
            }
            .padding(.horizontal, BAS_Metrics.screenPadding)
            .frame(maxHeight: 420)

            VStack(spacing: 14) {
                Text(page.titleText)
                    .font(BAS_Typography.title(26))
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(page.subtitleText)
                    .font(BAS_Typography.body(15))
                    .foregroundStyle(BAS_Palette.smokeText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
            }
            .padding(.top, 28)
            .padding(.horizontal, BAS_Metrics.screenPadding)

            Spacer(minLength: 0)
        }
    }
}

#Preview {
    BAS_OnboardingContainerView()
        .environmentObject(BAS_AppRouter())
}
