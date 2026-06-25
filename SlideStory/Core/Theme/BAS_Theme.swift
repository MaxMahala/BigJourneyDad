import SwiftUI

enum BAS_Palette {
    static let voidBlack = Color(red: 0.04, green: 0.02, blue: 0.08)
    static let deepPlum = Color(red: 0.08, green: 0.03, blue: 0.20)
    static let royalViolet = Color(red: 0.36, green: 0.13, blue: 0.71)
    static let electricViolet = Color(red: 0.43, green: 0.18, blue: 0.85)
    static let orchidGlow = Color(red: 0.66, green: 0.33, blue: 0.97)
    static let champagneGold = Color(red: 1.0, green: 0.91, blue: 0.66)
    static let richGold = Color(red: 0.83, green: 0.69, blue: 0.22)
    static let deepGold = Color(red: 0.54, green: 0.39, blue: 0.04)
    static let bronzeGold = Color(red: 0.72, green: 0.49, blue: 0.13)
    static let mistLavender = Color(red: 0.90, green: 0.85, blue: 1.0)
    static let smokeText = Color(red: 0.78, green: 0.74, blue: 0.88)
    static let dangerRose = Color(red: 0.95, green: 0.36, blue: 0.46)
    static let successMint = Color(red: 0.40, green: 0.88, blue: 0.66)
}

enum BAS_Gradient {
    static let backdrop = LinearGradient(
        colors: [BAS_Palette.deepPlum, BAS_Palette.voidBlack],
        startPoint: .top,
        endPoint: .bottom
    )

    static let radialAura = RadialGradient(
        colors: [BAS_Palette.royalViolet.opacity(0.55), BAS_Palette.voidBlack.opacity(0)],
        center: .topLeading,
        startRadius: 10,
        endRadius: 480
    )

    static let goldSheen = LinearGradient(
        colors: [BAS_Palette.champagneGold, BAS_Palette.richGold, BAS_Palette.deepGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldSheenReversed = LinearGradient(
        colors: [BAS_Palette.deepGold, BAS_Palette.richGold, BAS_Palette.champagneGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let violetSheen = LinearGradient(
        colors: [BAS_Palette.orchidGlow, BAS_Palette.royalViolet, BAS_Palette.deepPlum],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGlass = LinearGradient(
        colors: [Color.white.opacity(0.10), Color.white.opacity(0.02)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let buttonPrimary = LinearGradient(
        colors: [BAS_Palette.champagneGold, BAS_Palette.bronzeGold],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let dividerGold = LinearGradient(
        colors: [BAS_Palette.champagneGold.opacity(0.2), BAS_Palette.champagneGold, BAS_Palette.bronzeGold.opacity(0.2)],
        startPoint: .top,
        endPoint: .bottom
    )
}

enum BAS_Typography {
    static func display(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }

    static func title(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }

    static func caption(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
}

enum BAS_Metrics {
    static let cornerLarge: CGFloat = 32
    static let cornerMedium: CGFloat = 22
    static let cornerSmall: CGFloat = 14
    static let screenPadding: CGFloat = 22
    static let cardSpacing: CGFloat = 18
}

struct BAS_GlassCardBackground: View {
    var corner: CGFloat = BAS_Metrics.cornerMedium

    var body: some View {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(BAS_Gradient.cardGlass)
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(BAS_Palette.deepPlum.opacity(0.55))
            )
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [BAS_Palette.champagneGold.opacity(0.55), Color.white.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
    }
}

struct BAS_GoldButtonLabelStyle: ViewModifier {
    var height: CGFloat = 58

    func body(content: Content) -> some View {
        content
            .font(BAS_Typography.title(17))
            .foregroundStyle(BAS_Palette.voidBlack)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(BAS_Gradient.buttonPrimary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.35), lineWidth: 0.8)
            )
            .shadow(color: BAS_Palette.richGold.opacity(0.45), radius: 18, x: 0, y: 10)
    }
}

extension View {
    func bas_goldButtonStyle(height: CGFloat = 58) -> some View {
        modifier(BAS_GoldButtonLabelStyle(height: height))
    }
}

struct BAS_BackdropView: View {
    var body: some View {
        ZStack {
            BAS_Gradient.backdrop
            BAS_Gradient.radialAura
            RadialGradient(
                colors: [BAS_Palette.richGold.opacity(0.16), Color.clear],
                center: .bottomTrailing,
                startRadius: 10,
                endRadius: 520
            )
        }
        .ignoresSafeArea()
    }
}
