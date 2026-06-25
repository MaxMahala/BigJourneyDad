import SwiftUI

struct BAS_CompareSliderView: View {
    let beforeImageName: String
    let afterImageName: String
    var style: BAS_ProjectStyleConfig
    var isInteractive: Bool = true

    @State private var dragPosition: CGFloat = 0.5

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack(alignment: .topLeading) {
                BAS_ResolvedImage(name: afterImageName)
                    .frame(width: size.width, height: size.height)
                    .clipped()

                BAS_ResolvedImage(name: beforeImageName)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .mask(maskShape(for: size))

                handleOverlay(for: size)
                labelsOverlay(for: size)
            }
            .clipShape(RoundedRectangle(cornerRadius: BAS_Metrics.cornerLarge, style: .continuous))
            .contentShape(Rectangle())
            .gesture(isInteractive ? dragGesture(in: size) : nil)
        }
    }

    @ViewBuilder
    private func maskShape(for size: CGSize) -> some View {
        switch style.direction {
        case .horizontal:
            HStack(spacing: 0) {
                Rectangle().frame(width: size.width * dragPosition)
                Spacer(minLength: 0)
            }
        case .vertical:
            VStack(spacing: 0) {
                Rectangle().frame(height: size.height * dragPosition)
                Spacer(minLength: 0)
            }
        case .diagonal:
            BAS_DiagonalMaskShape(progress: dragPosition)
        }
    }

    private func dragGesture(in size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0).onChanged { value in
            switch style.direction {
            case .horizontal:
                dragPosition = min(max(value.location.x / size.width, 0), 1)
            case .vertical:
                dragPosition = min(max(value.location.y / size.height, 0), 1)
            case .diagonal:
                let combined = (value.location.x / size.width + value.location.y / size.height) / 2
                dragPosition = min(max(combined, 0), 1)
            }
        }
    }

    @ViewBuilder
    private func handleOverlay(for size: CGSize) -> some View {
        let position: CGPoint = {
            switch style.direction {
            case .horizontal: return CGPoint(x: size.width * dragPosition, y: size.height / 2)
            case .vertical: return CGPoint(x: size.width / 2, y: size.height * dragPosition)
            case .diagonal: return CGPoint(x: size.width * dragPosition, y: size.height * dragPosition)
            }
        }()

        ZStack {
            handleLine(for: size)
            BAS_HandleKnobView(shape: style.handleShape)
                .position(position)
        }
    }

    @ViewBuilder
    private func handleLine(for size: CGSize) -> some View {
        switch style.direction {
        case .horizontal:
            Rectangle()
                .fill(BAS_Gradient.dividerGold)
                .frame(width: 3)
                .shadow(color: BAS_Palette.champagneGold.opacity(0.7), radius: 6)
                .position(x: size.width * dragPosition, y: size.height / 2)
                .frame(width: size.width, height: size.height)
                .allowsHitTesting(false)
        case .vertical:
            Rectangle()
                .fill(BAS_Gradient.dividerGold)
                .frame(height: 3)
                .shadow(color: BAS_Palette.champagneGold.opacity(0.7), radius: 6)
                .position(x: size.width / 2, y: size.height * dragPosition)
                .frame(width: size.width, height: size.height)
                .allowsHitTesting(false)
        case .diagonal:
            EmptyView()
        }
    }

    @ViewBuilder
    private func labelsOverlay(for size: CGSize) -> some View {
        if style.labelStyle != .none {
            VStack {
                HStack {
                    BAS_SliderLabelView(text: style.beforeText, style: style.labelStyle)
                    Spacer()
                    BAS_SliderLabelView(text: style.afterText, style: style.labelStyle)
                }
                .padding(14)
                Spacer()
            }
        }
    }
}

struct BAS_DiagonalMaskShape: Shape {
    var progress: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let shift = (w + h) * progress - h
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: shift + h, y: 0))
        path.addLine(to: CGPoint(x: shift, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()
        return path
    }
}

struct BAS_HandleKnobView: View {
    let shape: BAS_HandleShape

    var body: some View {
        switch shape {
        case .circleArrows:
            Circle()
                .fill(BAS_Gradient.goldSheen)
                .frame(width: 46, height: 46)
                .overlay(
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.left")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(BAS_Palette.voidBlack)
                )
                .overlay(Circle().strokeBorder(Color.white.opacity(0.4), lineWidth: 1))
                .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 4)
        case .thinLine:
            Circle()
                .fill(BAS_Palette.champagneGold)
                .frame(width: 16, height: 16)
                .shadow(color: .black.opacity(0.3), radius: 4)
        case .diamond:
            Image(systemName: "diamond.fill")
                .font(.system(size: 30))
                .foregroundStyle(BAS_Gradient.goldSheen)
                .shadow(color: .black.opacity(0.3), radius: 6)
        case .dropShadowBar:
            RoundedRectangle(cornerRadius: 8)
                .fill(BAS_Gradient.goldSheen)
                .frame(width: 34, height: 60)
                .overlay(
                    VStack(spacing: 4) {
                        ForEach(0..<3) { _ in
                            Capsule().fill(BAS_Palette.voidBlack.opacity(0.55)).frame(width: 14, height: 2.4)
                        }
                    }
                )
                .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 4)
        }
    }
}

struct BAS_SliderLabelView: View {
    let text: String
    let style: BAS_LabelStyle

    var body: some View {
        switch style {
        case .pillTags:
            Text(text)
                .font(BAS_Typography.caption(12))
                .foregroundStyle(BAS_Palette.champagneGold)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(Capsule().fill(Color.black.opacity(0.45)))
                .overlay(Capsule().strokeBorder(BAS_Palette.champagneGold.opacity(0.6), lineWidth: 1))
        case .minimalText:
            Text(text)
                .font(BAS_Typography.caption(12))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.6), radius: 4)
        case .ribbon:
            Text(text)
                .font(BAS_Typography.caption(11))
                .foregroundStyle(BAS_Palette.voidBlack)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(BAS_Gradient.goldSheen)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        case .none:
            EmptyView()
        }
    }
}

struct BAS_ResolvedImage: View {
    let name: String

    var body: some View {
        if let uiImage = BAS_ImageStorage.shared.loadImage(named: name) {
            Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fill)
        } else {
            Image(name).resizable().aspectRatio(contentMode: .fill)
        }
    }
}
