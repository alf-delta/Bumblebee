import SwiftUI
import MapKit

struct MapContainerView: View {
    // MARK: - View Model
    @StateObject private var viewModel = MapViewModel()
    
    // MARK: - UI State
    @State private var showingFilters = false
    @State private var showingListView = false
    @State private var selectedShop: CoffeeShop?
    
    // MARK: - Map State
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))
    @State private var lastZoomLevel: Double = 0
    
    private var zoomLevel: Double {
        log2(360 / region.span.latitudeDelta)
    }
    
    private var proximityThreshold: CLLocationDistance {
        let currentZoom = zoomLevel
        
        switch currentZoom {
        case ...10: return 2000  // Очень далеко - большие кластеры
        case 10..<12: return 1000  // Далеко - средние кластеры
        case 12..<14: return 500   // Средний зум - маленькие кластеры
        default: return 200        // Близко - без кластеров
        }
    }
    
    private var clusters: [ShopCluster] {
        groupShopsByProximity(viewModel.filteredShops)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Map Layer
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    
                    ForEach(clusters) { cluster in
                        if cluster.shops.count == 1, let shop = cluster.shops.first {
                            // Одиночная метка
                            Annotation(shop.name, coordinate: shop.coordinates) {
                                CoffeeShopMarker(shop: shop) {
                                    selectedShop = shop
                                }
                            }
                        } else {
                            // Кластер
                            Annotation("\(cluster.shops.count) shops", coordinate: cluster.coordinate) {
                                ClusterMarker(count: cluster.shops.count) {
                                    handleClusterTap(cluster)
                                }
                            }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapCompass()
                    MapScaleView()
                    MapUserLocationButton()
                }
                .onMapCameraChange { context in
                    region = context.region
                    // Проверяем, изменился ли зум достаточно для обновления кластеров
                    let newZoomLevel = zoomLevel
                    if abs(newZoomLevel - lastZoomLevel) >= 1 {
                        lastZoomLevel = newZoomLevel
                        // Принудительно обновляем UI для пересчета кластеров
                        withAnimation {
                            viewModel.objectWillChange.send()
                        }
                    }
                }
                .ignoresSafeArea()
                
                // MARK: - Controls Layer
                VStack {
                    Spacer()
                        .frame(height: 100)
                    
                    // Zoom Controls
                    HStack {
                        MapZoomControls(
                            onZoomIn: zoomIn,
                            onZoomOut: zoomOut
                        )
                        .padding(.leading, 16)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Bottom Controls
                    HStack {
                        MapFilterButton(isActive: showingFilters) {
                            showingFilters.toggle()
                        }
                        Spacer()
                        MapListButton {
                            showingListView.toggle()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                
                // MARK: - Preview Card Layer
                if let shop = selectedShop {
                    VStack {
                        Spacer()
                        ShopPreviewCard(shop: shop) {
                            selectedShop = nil
                        }
                        .transition(.move(edge: .bottom))
                        .padding(.bottom, 80)
                    }
                    .padding(.horizontal)
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    selectedDistrict: $viewModel.selectedDistrict,
                    selectedRoastLevel: $viewModel.selectedRoastLevel,
                    selectedBrewingMethod: $viewModel.selectedBrewingMethod
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingListView) {
                CoffeeShopListView(shops: viewModel.filteredShops)
            }
            .navigationTitle("Bumblebee")
        }
    }
    
    // MARK: - Clustering
    private func groupShopsByProximity(_ shops: [CoffeeShop]) -> [ShopCluster] {
        var clusters: [ShopCluster] = []
        let threshold = proximityThreshold
        
        // Сортируем магазины по широте для более стабильной кластеризации
        let sortedShops = shops.sorted { $0.latitude > $1.latitude }
        
        for shop in sortedShops {
            let shopLocation = CLLocation(latitude: shop.latitude, longitude: shop.longitude)
            var foundCluster = false
            
            // Проверяем расстояние до существующих кластеров
            for (index, cluster) in clusters.enumerated() {
                let clusterLocation = CLLocation(
                    latitude: cluster.coordinate.latitude,
                    longitude: cluster.coordinate.longitude
                )
                
                let distance = shopLocation.distance(from: clusterLocation)
                print("Distance between \(shop.name) and cluster with \(cluster.shops.count) shops: \(distance)m")
                
                if distance <= threshold {
                    clusters[index].shops.append(shop)
                    clusters[index].updateCenter()
                    foundCluster = true
                    print("Added \(shop.name) to cluster with \(clusters[index].shops.count) shops")
                    break
                }
            }
            
            // Если не нашли подходящий кластер, создаем новый
            if !foundCluster {
                print("Creating new cluster for \(shop.name)")
                clusters.append(ShopCluster(coordinate: shop.coordinates, shops: [shop]))
            }
        }
        
        // Проверяем результат кластеризации
        for cluster in clusters {
            if cluster.shops.count > 1 {
                print("Cluster contains \(cluster.shops.count) shops:")
                for shop in cluster.shops {
                    print("- \(shop.name)")
                }
            }
        }
        
        return clusters
    }
    
    // MARK: - Map Control Functions
    private func zoomIn() {
        withAnimation {
            let currentRegion = region
            region = MKCoordinateRegion(
                center: currentRegion.center,
                span: MKCoordinateSpan(
                    latitudeDelta: currentRegion.span.latitudeDelta * 0.5,
                    longitudeDelta: currentRegion.span.longitudeDelta * 0.5
                )
            )
            cameraPosition = .region(region)
        }
    }
    
    private func zoomOut() {
        withAnimation {
            let currentRegion = region
            region = MKCoordinateRegion(
                center: currentRegion.center,
                span: MKCoordinateSpan(
                    latitudeDelta: currentRegion.span.latitudeDelta * 2,
                    longitudeDelta: currentRegion.span.longitudeDelta * 2
                )
            )
            cameraPosition = .region(region)
        }
    }
    
    private func handleClusterTap(_ cluster: ShopCluster) {
        withAnimation {
            // Для отладки выводим информацию о кластере
            print("Tapped cluster with \(cluster.shops.count) shops:")
            for shop in cluster.shops {
                print("- \(shop.name) at (\(shop.latitude), \(shop.longitude))")
            }
            
            if cluster.shops.count == 1 {
                selectedShop = cluster.shops.first
                return
            }
            
            // Рассчитываем новый регион для кластера
            let coordinates = cluster.shops.map { $0.coordinates }
            let minLat = coordinates.map { $0.latitude }.min() ?? 0
            let maxLat = coordinates.map { $0.latitude }.max() ?? 0
            let minLon = coordinates.map { $0.longitude }.min() ?? 0
            let maxLon = coordinates.map { $0.longitude }.max() ?? 0
            
            // Увеличиваем отступ для лучшего отображения
            let latPadding = (maxLat - minLat) * 0.5
            let lonPadding = (maxLon - minLon) * 0.5
            
            let newRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: (minLat + maxLat) / 2,
                    longitude: (minLon + maxLon) / 2
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: max(maxLat - minLat + latPadding, 0.005),
                    longitudeDelta: max(maxLon - minLon + lonPadding, 0.005)
                )
            )
            
            cameraPosition = .region(newRegion)
        }
    }
}

// MARK: - Shop Cluster
struct ShopCluster: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var shops: [CoffeeShop]
    
    mutating func updateCenter() {
        let centerLat = shops.map(\.latitude).reduce(0, +) / Double(shops.count)
        let centerLon = shops.map(\.longitude).reduce(0, +) / Double(shops.count)
        coordinate = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    }
}

struct ClusterMarker: View {
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Внешний круг с градиентом
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.secondary.opacity(0.9),
                                AppColors.secondary
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                // Внутренний белый круг
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                
                // Количество
                Text("\(count)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.secondary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.white)
                    )
            }
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
        }
    }
}

extension CoffeeShop {
    var monogramColor: Color {
        let hash = abs(name.hashValue)
        let hue = Double(hash % 360) / 360.0
        return Color(hue: hue, saturation: 0.8, brightness: 0.9)
    }
    
    var monogram: String {
        let components = name.components(separatedBy: " ")
        if components.isEmpty {
            return "CF"
        }
        if components.count == 1 {
            let first = components[0]
            return String(first.prefix(2)).uppercased()
        }
        let first = components[0]
        let second = components[1]
        return (first.prefix(1) + second.prefix(1)).uppercased()
    }
}

struct CoffeeShopMarker: View {
    let shop: CoffeeShop
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Внешний круг с градиентом
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                shop.monogramColor.opacity(0.9),
                                shop.monogramColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                // Внутренний белый круг
                Circle()
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                
                // Монограмма
                Text(shop.monogram)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(shop.monogramColor)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.white)
                    )
            }
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
        }
    }
}

struct ShopPreviewCard: View {
    let shop: CoffeeShop
    let onDismiss: () -> Void
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(shop.name)
                    .font(.headline)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Text(shop.address)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                ForEach(shop.brewingMethods.prefix(3), id: \.self) { method in
                    Text(method.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.lightBrown)
                        .cornerRadius(8)
                }
            }
            
            Button("More Details") {
                showingDetail = true
            }
            .buttonStyle(.borderedProminent)
            .tint(AppColors.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                CoffeeShopDetailView(shop: shop)
            }
        }
    }
}

struct MapFilterButton: View {
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.title)
                .foregroundColor(isActive ? AppColors.secondary : AppColors.primary)
                .padding(12)
                .background(AppColors.card)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        }
    }
}

struct MapListButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "list.bullet")
                .font(.title)
                .foregroundColor(AppColors.primary)
                .padding(12)
                .background(AppColors.card)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        }
    }
}

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDistrict: CoffeeShop.District?
    @Binding var selectedRoastLevel: CoffeeShop.RoastLevel?
    @Binding var selectedBrewingMethod: CoffeeShop.BrewingMethod?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // District Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("District")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(CoffeeShop.District.allCases, id: \.self) { district in
                                FilterChip(
                                    title: district.rawValue,
                                    icon: districtIcon(for: district),
                                    isSelected: selectedDistrict == district
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        if selectedDistrict == district {
                                            selectedDistrict = nil
                                        } else {
                                            selectedDistrict = district
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Roast Level Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Roast Level")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack(spacing: 0) {
                            ForEach(CoffeeShop.RoastLevel.allCases, id: \.self) { level in
                                RoastLevelButton(
                                    level: level,
                                    isSelected: selectedRoastLevel == level
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        if selectedRoastLevel == level {
                                            selectedRoastLevel = nil
                                        } else {
                                            selectedRoastLevel = level
                                        }
                                    }
                                }
                            }
                        }
                        .background(AppColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.05), radius: 10)
                    }
                    
                    // Brewing Methods Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Brewing Methods")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        FlowLayout(spacing: 12) {
                            ForEach(CoffeeShop.BrewingMethod.allCases, id: \.self) { method in
                                BrewingMethodCard(
                                    method: method,
                                    isSelected: selectedBrewingMethod == method
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        if selectedBrewingMethod == method {
                                            selectedBrewingMethod = nil
                                        } else {
                                            selectedBrewingMethod = method
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: resetFilters) {
                    Text("Reset")
                        .foregroundColor(AppColors.secondary)
                },
                trailing: Button("Done") {
                    dismiss()
                }
            )
        }
    }
    
    private func resetFilters() {
        withAnimation(.spring(response: 0.3)) {
            selectedDistrict = nil
            selectedRoastLevel = nil
            selectedBrewingMethod = nil
        }
    }
    
    private func districtIcon(for district: CoffeeShop.District) -> String {
        switch district {
        case .downtown: return "building.2"
        case .brooklyn: return "bridge"
        case .queens: return "crown"
        case .manhattan: return "building.columns"
        }
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.secondary : AppColors.card)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
            )
            .foregroundColor(isSelected ? .white : AppColors.textPrimary)
        }
    }
}

struct RoastLevelButton: View {
    let level: CoffeeShop.RoastLevel
    let isSelected: Bool
    let action: () -> Void
    
    var color: Color {
        switch level {
        case .light: return Color.hex("D4B595")
        case .medium: return Color.hex("A67B5B")
        case .dark: return Color.hex("582F0E")
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .strokeBorder(isSelected ? AppColors.secondary : .clear, lineWidth: 2)
                    )
                
                Text(level.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? AppColors.secondary : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? AppColors.lightBrown : .clear)
        }
    }
}

struct BrewingMethodCard: View {
    let method: CoffeeShop.BrewingMethod
    let isSelected: Bool
    let action: () -> Void
    
    var icon: String {
        switch method {
        case .espresso: return "cup.and.saucer.fill"
        case .pourOver: return "drop.fill"
        case .frenchPress: return "cylinder.fill"
        case .aeropress: return "arrow.down.circle.fill"
        case .chemex: return "flask"
        case .coldBrew: return "snowflake"
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : AppColors.secondary)
                
                Text(method.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            }
            .frame(width: 90, height: 90)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.secondary : AppColors.card)
                    .shadow(color: Color.black.opacity(0.05), radius: 8)
            )
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        return CGSize(
            width: proposal.width ?? .zero,
            height: rows.last?.maxY ?? .zero
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = arrangeSubviews(proposal: proposal, subviews: subviews)
        
        for row in rows {
            for element in row.elements {
                let point = CGPoint(x: element.x + bounds.minX, y: element.y + bounds.minY)
                element.subview.place(at: point, proposal: ProposedViewSize(element.size))
            }
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row(y: 0)
        var x: CGFloat = 0
        let maxWidth = proposal.width ?? .zero
        
        for subview in subviews {
            let size = subview.sizeThatFits(ProposedViewSize(width: maxWidth, height: nil))
            
            if x + size.width > maxWidth {
                rows.append(currentRow)
                currentRow = Row(y: currentRow.maxY + spacing)
                x = 0
            }
            
            currentRow.add(ElementInfo(subview: subview, size: size, x: x))
            x += size.width + spacing
        }
        
        if !currentRow.elements.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    struct Row {
        var elements: [ElementInfo] = []
        var y: CGFloat
        
        var maxY: CGFloat {
            y + (elements.map { $0.size.height }.max() ?? 0)
        }
        
        mutating func add(_ element: ElementInfo) {
            elements.append(element)
        }
    }
    
    struct ElementInfo {
        let subview: LayoutSubview
        let size: CGSize
        let x: CGFloat
        
        var y: CGFloat = 0
    }
}

struct CoffeeShopListView: View {
    let shops: [CoffeeShop]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedShop: CoffeeShop?
    
    var body: some View {
        NavigationView {
            List(shops) { shop in
                Button(action: {
                    selectedShop = shop
                }) {
                    HStack(spacing: 12) {
                        // Монограмма
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            shop.monogramColor.opacity(0.9),
                                            shop.monogramColor
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                            
                            Text(shop.monogram)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(shop.name)
                                .font(.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Text(shop.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            HStack {
                                ForEach(shop.brewingMethods.prefix(3), id: \.self) { method in
                                    Text(method.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(shop.monogramColor.opacity(0.1))
                                        .foregroundColor(shop.monogramColor)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Coffee Shops")
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
            .sheet(item: $selectedShop) { shop in
                NavigationView {
                    CoffeeShopDetailView(shop: shop)
                }
            }
        }
    }
}

struct MapZoomButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 28, height: 28)
                .background(.white)
                .clipShape(Circle())
        }
    }
}

struct MapZoomControls: View {
    let onZoomIn: () -> Void
    let onZoomOut: () -> Void
    
    var body: some View {
        VStack(spacing: 1) {
            MapZoomButton(icon: "plus") {
                withAnimation {
                    onZoomIn()
                }
            }
            
            Divider()
                .frame(width: 28)
                .background(.white)
            
            MapZoomButton(icon: "minus") {
                withAnimation {
                    onZoomOut()
                }
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    MapContainerView()
} 