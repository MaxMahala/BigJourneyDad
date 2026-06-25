import SwiftUI

struct BAS_CompareSliderUIImageView: View {
    let before: UIImage
    let after: UIImage
    var style: BAS_ProjectStyleConfig

    @State private var dragPosition: CGFloat = 0.5

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack(alignment: .topLeading) {
                Image(uiImage: after)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()

                Image(uiImage: before)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .mask(maskShape(for: size))

                dividerAndHandle(for: size)
                labelsOverlay
            }
            .clipShape(RoundedRectangle(cornerRadius: BAS_Metrics.cornerLarge, style: .continuous))
            .contentShape(Rectangle())
            .gesture(
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
            )
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

    @ViewBuilder
    private func dividerAndHandle(for size: CGSize) -> some View {
        let position: CGPoint = {
            switch style.direction {
            case .horizontal: return CGPoint(x: size.width * dragPosition, y: size.height / 2)
            case .vertical: return CGPoint(x: size.width / 2, y: size.height * dragPosition)
            case .diagonal: return CGPoint(x: size.width * dragPosition, y: size.height * dragPosition)
            }
        }()

        if style.direction != .diagonal {
            Group {
                if style.direction == .horizontal {
                    Rectangle().fill(BAS_Gradient.dividerGold).frame(width: 3)
                } else {
                    Rectangle().fill(BAS_Gradient.dividerGold).frame(height: 3)
                }
            }
            .shadow(color: BAS_Palette.champagneGold.opacity(0.7), radius: 6)
            .position(position)
            .frame(width: size.width, height: size.height)
            .allowsHitTesting(false)
        }

        BAS_HandleKnobView(shape: style.handleShape)
            .position(position)
    }

    @ViewBuilder
    private var labelsOverlay: some View {
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

struct BAS_StyleConfiguratorView: View {
    @Binding var config: BAS_ProjectStyleConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            optionRow(title: "Handle Shape", options: BAS_HandleShape.allCases, selected: config.handleShape) { config.handleShape = $0 }
            optionRow(title: "Label Style", options: BAS_LabelStyle.allCases, selected: config.labelStyle) { config.labelStyle = $0 }
            optionRow(title: "Direction", options: BAS_SliderDirection.allCases, selected: config.direction) { config.direction = $0 }

            VStack(alignment: .leading, spacing: 10) {
                Text("Labels")
                    .font(BAS_Typography.caption(13))
                    .foregroundStyle(BAS_Palette.smokeText)

                HStack(spacing: 12) {
                    BAS_InlineLabelField(text: $config.beforeText)
                    BAS_InlineLabelField(text: $config.afterText)
                }
            }
        }
    }

    @ViewBuilder
    private func optionRow<T: Identifiable & Hashable>(
        title: String,
        options: [T],
        selected: T,
        onSelect: @escaping (T) -> Void
    ) -> some View where T: BAS_DisplayNameProviding {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(BAS_Typography.caption(13))
                .foregroundStyle(BAS_Palette.smokeText)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(options) { option in
                        Button {
                            onSelect(option)
                        } label: {
                            Text(option.displayName)
                                .font(BAS_Typography.caption(13))
                                .foregroundStyle(option == selected ? BAS_Palette.voidBlack : .white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 9)
                                .background(
                                    Capsule().fill(option == selected ? AnyShapeStyle(BAS_Gradient.goldSheen) : AnyShapeStyle(Color.white.opacity(0.08)))
                                )
                        }
                    }
                }
            }
        }
    }
}

protocol BAS_DisplayNameProviding {
    var displayName: String { get }
}

extension BAS_HandleShape: BAS_DisplayNameProviding {}
extension BAS_LabelStyle: BAS_DisplayNameProviding {}
extension BAS_SliderDirection: BAS_DisplayNameProviding {}

struct BAS_InlineLabelField: View {
    @Binding var text: String

    var body: some View {
        TextField("", text: $text)
            .font(BAS_Typography.caption(13))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(BAS_Palette.champagneGold.opacity(0.3), lineWidth: 1))
            .multilineTextAlignment(.center)
    }
}
