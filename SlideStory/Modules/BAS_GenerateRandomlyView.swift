import SwiftUI

struct BAS_GenerateRandomlyView: View {
    @EnvironmentObject var projectStore: BAS_ProjectStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var generatedTitle: String = "Magic Flash"
    @State private var randomCategory: BAS_ProjectCategory = .portrait
    @State private var randomStyle: BAS_ProjectStyleConfig = .standard
    @State private var isSpinning = false
    
    private let titlesPool = ["Midnight Glow", "Neon Dream", "Retro Shift", "Urban Canvas", "Vivid Edge", "Nordic Crisp", "Cyber Pulse"]

    var body: some View {
        ZStack {
            BAS_BackdropView()
            
            VStack(spacing: 24) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Idea Generator")
                            .font(BAS_Typography.title(24))
                            .foregroundStyle(.white)
                        Text("Generate random presets combinations")
                            .font(BAS_Typography.body(12))
                            .foregroundStyle(BAS_Palette.smokeText)
                    }
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
                
                Spacer()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(BAS_Gradient.goldSheen, lineWidth: 2)
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(isSpinning ? 360 : 0))
                        
                        Image(systemName: randomCategory.iconName)
                            .font(.system(size: 40))
                            .foregroundStyle(BAS_Palette.champagneGold)
                            .scaleEffect(isSpinning ? 0.7 : 1.0)
                    }
                    
                    VStack(spacing: 8) {
                        Text(generatedTitle)
                            .font(BAS_Typography.display(22))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(randomCategory.displayName.uppercased())
                            .font(BAS_Typography.caption(12))
                            .foregroundStyle(BAS_Palette.voidBlack)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(BAS_Gradient.goldSheen))
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Direction:")
                                .foregroundStyle(BAS_Palette.smokeText)
                            Spacer()
                            Text("\(String(describing: randomStyle.direction).uppercased())")
                                .foregroundStyle(.white)
                        }
                        HStack {
                            Text("Labels:")
                                .foregroundStyle(BAS_Palette.smokeText)
                            Spacer()
                            Text("\(randomStyle.beforeText) / \(randomStyle.afterText)")
                                .foregroundStyle(.white)
                        }
                    }
                    .font(BAS_Typography.body(13))
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: BAS_Metrics.cornerMedium))
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: rollDice) {
                        HStack {
                            Image(systemName: "dice")
                            Text("Roll Random Mix")
                        }
                        .font(BAS_Typography.title(16))
                        .foregroundStyle(BAS_Palette.voidBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Capsule().fill(BAS_Gradient.goldSheen))
                    }
                    
                    Button(action: saveGeneratedProject) {
                        Text("Save as Draft Project")
                            .font(BAS_Typography.body(14))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            rollDice()
        }
    }
    
    private func rollDice() {
        withAnimation(.linear(duration: 0.4)) {
            isSpinning = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let templates = BAS_MockDataFactory.makeTemplatePresets()
            if let randomTemplate = templates.randomElement() {
                self.randomCategory = randomTemplate.category
                self.randomStyle = randomTemplate.style
            }
            
            self.generatedTitle = titlesPool.randomElement() ?? "Custom Slide"
            
            withAnimation(.bouncy) {
                isSpinning = false
            }
        }
    }
    
    private func saveGeneratedProject() {
        let newProject = BAS_SliderProject(
            title: generatedTitle,
            beforeImageName: "golden-hour-glow-stockcake",
            afterImageName: "golden-hour-glow-stockcake-filtered",
            createdAt: Date(),
            category: randomCategory,
            style: randomStyle,
            isFavorite: false,
            isMock: false
        )
        projectStore.add(newProject)
        dismiss()
    }
}
