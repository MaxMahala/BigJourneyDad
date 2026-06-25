import SwiftUI
import SceneKit

struct BAS_ProfileView: View {
    @EnvironmentObject var router: BAS_AppRouter
    @State private var selectedMetricTimeframe: Int = 0
    
    var body: some View {
        ZStack {
            BAS_BackdropView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    profileHeader
                    
                    athlete3DViewerSection
                    
                    quickMetricsRings
                    
                    achievementsMilestonesSection
                    
                    Spacer(minLength: 120)
                }
                .padding(.top, 12)
            }
        }
    }
        
    private var profileHeader: some View {
        VStack(spacing: 4) {
            Text("PRO ATHLETE")
                .font(BAS_Typography.caption(11))
                .foregroundStyle(BAS_Gradient.goldSheen)
                .tracking(3)
            
            Text("John Devidson")
                .font(BAS_Typography.display(28))
                .foregroundStyle(.white)
            
            Text("Member since August 2025")
                .font(BAS_Typography.body(12))
                .foregroundStyle(BAS_Palette.smokeText)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
    
    private var athlete3DViewerSection: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Circle()
                    .fill(BAS_Palette.orchidGlow.opacity(0.15))
                    .frame(width: 240, height: 240)
                    .blur(radius: 40)
                    .offset(y: 20)
                
                BAS_SceneKitView(modelName: "Shirtless_Athlete_in_Black_Shorts.usdz")
                    .frame(height: 340)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                
                HStack(spacing: 6) {
                    Image(systemName: "arkit")
                    Text("3D Interactive Model • Swipe to Rotate")
                }
                .font(BAS_Typography.caption(10))
                .foregroundStyle(BAS_Palette.smokeText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())
                .padding(.bottom, 10)
            }
        }
    }
    
    private var quickMetricsRings: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Performance Stats")
                .font(BAS_Typography.title(16))
                .foregroundStyle(.white)
                .padding(.horizontal, BAS_Metrics.screenPadding)
            
            HStack(spacing: 16) {
                metricRingWidget(title: "Performance", value: "94%", color: BAS_Palette.orchidGlow)
                metricRingWidget(title: "Endurance", value: "89%", color: BAS_Palette.champagneGold)
                metricRingWidget(title: "Strength", value: "97%", color: BAS_Palette.electricViolet)
            }
            .padding(.horizontal, BAS_Metrics.screenPadding)
        }
    }
    
    private var achievementsMilestonesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Achievement Milestones")
                .font(BAS_Typography.title(16))
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                milestoneRow(
                    title: "12 Week Transformation",
                    subtitle: "Drag a gleaming gold divider and look back at your progress.",
                    icon: "trophy.fill",
                    iconColor: BAS_Palette.richGold
                )
                
                milestoneRow(
                    title: "New Bench Mark",
                    subtitle: "Hit maximum depth and high engagement limits.",
                    icon: "medal.fill",
                    iconColor: BAS_Palette.champagneGold
                )
            }
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
        
    private func metricRingWidget(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.06), lineWidth: 6)
                
                Circle()
                    .trim(from: 0.0, to: 0.85) // приклад заповнення прогресу
                    .stroke(
                        AngularGradient(colors: [color, color.opacity(0.4)], center: .center),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text(value)
                    .font(BAS_Typography.title(15))
                    .foregroundStyle(.white)
            }
            .frame(width: 70, height: 70)
            
            Text(title.uppercased())
                .font(BAS_Typography.caption(10))
                .foregroundStyle(BAS_Palette.smokeText)
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(BAS_GlassCardBackground(corner: 16))
    }
    
    private func milestoneRow(title: String, subtitle: String, icon: String, iconColor: Color) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BAS_Typography.title(14))
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(BAS_Typography.body(12))
                    .foregroundStyle(BAS_Palette.smokeText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(BAS_Palette.smokeText)
        }
        .padding(14)
        .background(BAS_GlassCardBackground(corner: 14))
    }
}

struct BAS_SceneKitView: UIViewRepresentable {
    let modelName: String
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = .clear
        
        let scene = SCNScene()
        
        let modelContainerNode = SCNNode()
        
        if let modelUrl = Bundle.main.url(forResource: modelName.replacingOccurrences(of: ".usdz", with: ""), withExtension: "usdz"),
           let referenceNode = SCNReferenceNode(url: modelUrl) {
            referenceNode.load()
            modelContainerNode.addChildNode(referenceNode)
        } else {
            let backupCapsule = SCNCapsule(capRadius: 0.3, height: 1.6)
            backupCapsule.firstMaterial?.diffuse.contents = UIColor(red: 0.85, green: 0.65, blue: 0.4, alpha: 1.0)
            let backupNode = SCNNode(geometry: backupCapsule)
            modelContainerNode.addChildNode(backupNode)
        }
        
        scene.rootNode.addChildNode(modelContainerNode)
        
        let (minVec, maxVec) = modelContainerNode.boundingBox
        let powerOfModel = SCNVector3(
            x: maxVec.x - minVec.x,
            y: maxVec.y - minVec.y,
            z: maxVec.z - minVec.z
        )
        
        let midX = minVec.x + powerOfModel.x / 2
        let midY = minVec.y + powerOfModel.y / 2
        let midZ = minVec.z + powerOfModel.z / 2
        modelContainerNode.position = SCNVector3(-midX, -midY, -midZ)
        
        let baseNode = SCNNode()
        baseNode.addChildNode(modelContainerNode)
        scene.rootNode.addChildNode(baseNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()

        let maxDimension = max(powerOfModel.x, max(powerOfModel.y, powerOfModel.z))
        let distance = maxDimension * 2.2

        cameraNode.position = SCNVector3(x: 0, y: 0, z: distance)

        cameraNode.camera?.zNear = 0.1
        cameraNode.camera?.zFar = Double(distance * 4)
        
        scene.rootNode.addChildNode(cameraNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor(white: 0.6, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.color = UIColor(white: 0.4, alpha: 1.0)
        let directionalNode = SCNNode()
        directionalNode.light = directionalLight
        directionalNode.position = SCNVector3(x: 2, y: 4, z: 3)
        scene.rootNode.addChildNode(directionalNode)
        
        scnView.scene = scene
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
}
