import SwiftUI

struct BAS_AdvancedDiscoveryView: View {
    @EnvironmentObject var projectStore: BAS_ProjectStore
    @EnvironmentObject var router: BAS_AppRouter
    
    @State private var searchText: String = ""
    @State private var selectedCategory: BAS_ProjectCategory? = nil
    @State private var showFavoritesOnly: Bool = false
    @State private var showMocksOnly: Bool = false
    
    enum SortOption: String, CaseIterable, Identifiable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        case alphabetical = "A-Z"
        
        var id: String { self.rawValue }
    }
    @State private var currentSort: SortOption = .newest
    
    @State private var isEditMode: Bool = false
    @State private var selectedProjectIDs: Set<UUID> = []
    
    private var processedProjects: [BAS_SliderProject] {
        var list = projectStore.projects
        
        if !searchText.isEmpty {
            list = list.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let category = selectedCategory {
            list = list.filter { $0.category == category }
        }
        
        if showFavoritesOnly {
            list = list.filter { $0.isFavorite }
        }
        
        if showMocksOnly {
            list = list.filter { $0.isMock }
        }
        
        switch currentSort {
        case .newest:
            list.sort { $0.createdAt > $1.createdAt }
        case .oldest:
            list.sort { $0.createdAt < $1.createdAt }
        case .alphabetical:
            list.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
        
        return list
    }
    
    var body: some View {
        ZStack {
            BAS_BackdropView()
            
            VStack(spacing: 0) {
                searchAndHeaderHeader
                
                ScrollView {
                    VStack(spacing: 20) {
                        quickStatsWidget
                        
                        filterControlPanel
                        
                        sortAndBulkActionHeader
                        
                        if processedProjects.isEmpty {
                            noResultsState
                        } else {
                            advancedProjectsGrid
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if isEditMode && !selectedProjectIDs.isEmpty {
                batchActionBar
            }
        }
    }
        
    private var searchAndHeaderHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Studio Hub")
                    .font(BAS_Typography.display(28))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    withAnimation(.spring()) {
                        isEditMode.toggle()
                        selectedProjectIDs.removeAll()
                    }
                } label: {
                    Text(isEditMode ? "Cancel" : "Select")
                        .font(BAS_Typography.body(14))
                        .foregroundStyle(isEditMode ? .red : BAS_Palette.champagneGold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.06))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, BAS_Metrics.screenPadding)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(BAS_Palette.smokeText)
                
                TextField("Search sliders by title...", text: $searchText)
                    .font(BAS_Typography.body(14))
                    .foregroundStyle(.white)
                    .tint(BAS_Palette.champagneGold)
                
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(BAS_Palette.smokeText)
                    }
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, BAS_Metrics.screenPadding)
        }
        .padding(.top, 10)
    }
    
    private var quickStatsWidget: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("MATCHED")
                    .font(BAS_Typography.caption(10))
                    .foregroundStyle(BAS_Palette.smokeText)
                Text("\(processedProjects.count)")
                    .font(BAS_Typography.title(18))
                    .foregroundStyle(BAS_Palette.champagneGold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(BAS_GlassCardBackground(corner: 12))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("TOTAL ITEMS")
                    .font(BAS_Typography.caption(10))
                    .foregroundStyle(BAS_Palette.smokeText)
                Text("\(projectStore.projects.count)")
                    .font(BAS_Typography.title(18))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(BAS_GlassCardBackground(corner: 12))
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
    
    private var filterControlPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Скрол категорій
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    BAS_FilterChip(title: "All Styles", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                    }
                    ForEach(BAS_ProjectCategory.allCases) { cat in
                        BAS_FilterChip(title: cat.displayName, isSelected: selectedCategory == cat) {
                            selectedCategory = cat
                        }
                    }
                }
                .padding(.horizontal, BAS_Metrics.screenPadding)
            }
            
            HStack(spacing: 16) {
                Toggle(isOn: $showFavoritesOnly) {
                    Label("Favorites", systemImage: "star.fill")
                        .font(BAS_Typography.body(12))
                        .foregroundStyle(.white)
                }
                .toggleStyle(BAS_CapsuleToggleStyle())
                
                Toggle(isOn: $showMocksOnly) {
                    Label("Demo Data", systemImage: "square.stack.3d.up.fill")
                        .font(BAS_Typography.body(12))
                        .foregroundStyle(.white)
                }
                .toggleStyle(BAS_CapsuleToggleStyle())
                
                Spacer()
            }
            .padding(.horizontal, BAS_Metrics.screenPadding)
        }
    }
    
    private var sortAndBulkActionHeader: some View {
        HStack {
            Text("Results")
                .font(BAS_Typography.title(16))
                .foregroundStyle(.white)
            
            Spacer()
            
            Menu {
                Picker("Sort by", selection: $currentSort) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.and.down.text.horizontal")
                    Text(currentSort.rawValue)
                }
                .font(BAS_Typography.caption(12))
                .foregroundStyle(BAS_Palette.champagneGold)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.05))
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
    
    private var advancedProjectsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            ForEach(processedProjects) { project in
                let isSelected = selectedProjectIDs.contains(project.id)
                
                ZStack(alignment: .topLeading) {
                    // Твоя стандартна картка
                    BAS_ProjectCardView(project: project)
                        .opacity(isEditMode && !isSelected ? 0.6 : 1.0)
                        .scaleEffect(isSelected ? 0.96 : 1.0)
                        .animation(.spring(response: 0.2), value: isSelected)
                        .onTapGesture {
                            if isEditMode {
                                if isSelected {
                                    selectedProjectIDs.remove(project.id)
                                } else {
                                    selectedProjectIDs.insert(project.id)
                                }
                            } else {
                                router.presentedSheet = .projectDetail(project)
                            }
                        }
                    
                    if isEditMode {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22))
                            .foregroundStyle(isSelected ? AnyShapeStyle(BAS_Gradient.goldSheen) : AnyShapeStyle(Color.white.opacity(0.6)))
                            .padding(14)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
        .padding(.horizontal, BAS_Metrics.screenPadding)
    }
    
    private var batchActionBar: some View {
        HStack(spacing: 20) {
            Text("Selected: \(selectedProjectIDs.count)")
                .font(BAS_Typography.body(14))
                .foregroundStyle(.white)
            
            Spacer()
            
            Button(action: batchToggleFavorite) {
                Image(systemName: "star.leadinghalf.filled")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(BAS_Palette.voidBlack)
                    .padding(12)
                    .background(Circle().fill(BAS_Gradient.goldSheen))
            }
            
            Button(action: batchDelete) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(Circle().fill(Color.red))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(BAS_Palette.voidBlack.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(BAS_Gradient.dividerGold.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var noResultsState: some View {
        VStack(spacing: 12) {
            Image(systemName: "slider.horizontal.2.square.on.square")
                .font(.system(size: 40))
                .foregroundStyle(BAS_Palette.smokeText)
                .padding(.top, 40)
            Text("No Matches Found")
                .font(BAS_Typography.title(16))
                .foregroundStyle(.white)
            Text("Try relaxing your filters or typing a different search query.")
                .font(BAS_Typography.body(13))
                .foregroundStyle(BAS_Palette.smokeText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
        
    private func batchToggleFavorite() {
        for id in selectedProjectIDs {
            if let project = projectStore.projects.first(where: { $0.id == id }) {
                projectStore.toggleFavorite(project)
            }
        }
        exitEditMode()
    }
    
    private func batchDelete() {
        for id in selectedProjectIDs {
            if let project = projectStore.projects.first(where: { $0.id == id }) {
                projectStore.remove(project)
            }
        }
        exitEditMode()
    }
    
    private func exitEditMode() {
        withAnimation {
            isEditMode = false
            selectedProjectIDs.removeAll()
        }
    }
}

struct BAS_CapsuleToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                configuration.isOn.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                configuration.label
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(configuration.isOn ? AnyShapeStyle(BAS_Gradient.goldSheen) : AnyShapeStyle(Color.white.opacity(0.05)))
            )
            .overlay(
                Capsule()
                    .stroke(configuration.isOn ? Color.clear : Color.white.opacity(0.1), lineWidth: 1)
            )
            .environment(\.colorScheme, configuration.isOn ? .light : .dark) // Швидкий інверт тексту
        }
    }
}
