import SwiftUI
import MapKit

struct CoffeeShopDetailView: View {
    let shop: CoffeeShop
    @State private var showingOrderSheet = false
    @State private var selectedDrink: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Coffee shop photos
                if let firstPhoto = shop.imageURLs.first {
                    AsyncImage(url: URL(string: firstPhoto)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(height: 250)
                    .clipped()
                }
                
                // Quick Actions Bar
                HStack(spacing: 20) {
                    Button(action: {
                        showingOrderSheet = true
                    }) {
                        Text("Order Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColors.secondary)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                
                VStack(alignment: .leading, spacing: 24) {
                    // Basic information
                    VStack(alignment: .leading, spacing: 8) {
                        Text(shop.name)
                            .font(.title)
                            .bold()
                        
                        Text(shop.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 16) {
                            Label(String(format: "%.1f", shop.rating), systemImage: "star.fill")
                                .foregroundColor(.yellow)
                            Text("•")
                                .foregroundColor(.gray)
                            Text("\(shop.reviewCount) reviews")
                                .foregroundColor(.gray)
                        }
                        .font(.subheadline)
                    }
                    
                    // Brewing methods
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Brewing Methods")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(shop.brewingMethods, id: \.self) { method in
                                    HStack {
                                        Image(systemName: brewingMethodIcon(for: method))
                                        Text(method.rawValue)
                                    }
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(AppColors.lightBrown)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Coffee information
                    if let origin = shop.coffeeOrigins.first {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Coffee Details")
                                .font(.headline)
                            
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    InfoCard(
                                        icon: "globe",
                                        title: "Origin",
                                        value: origin.country
                                    )
                                    InfoCard(
                                        icon: "map",
                                        title: "Region",
                                        value: origin.region
                                    )
                                }
                                
                                HStack(spacing: 12) {
                                    InfoCard(
                                        icon: "flame",
                                        title: "Roast",
                                        value: shop.roastLevel.rawValue
                                    )
                                    if let process = origin.process {
                                        InfoCard(
                                            icon: "gear",
                                            title: "Process",
                                            value: process
                                        )
                                    }
                                }
                                
                                if let farm = origin.farm {
                                    InfoCard(
                                        icon: "house",
                                        title: "Farm",
                                        value: farm
                                    )
                                }
                            }
                        }
                    }
                    
                    // Opening hours
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Opening Hours")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            OpeningHoursRow(day: "Monday", hours: shop.openingHours.monday)
                            OpeningHoursRow(day: "Tuesday", hours: shop.openingHours.tuesday)
                            OpeningHoursRow(day: "Wednesday", hours: shop.openingHours.wednesday)
                            OpeningHoursRow(day: "Thursday", hours: shop.openingHours.thursday)
                            OpeningHoursRow(day: "Friday", hours: shop.openingHours.friday)
                            OpeningHoursRow(day: "Saturday", hours: shop.openingHours.saturday)
                            OpeningHoursRow(day: "Sunday", hours: shop.openingHours.sunday)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 8)
                    }
                }
                .padding()
            }
        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingOrderSheet) {
            OrderSheet(shop: shop)
        }
    }
    
    private func brewingMethodIcon(for method: CoffeeShop.BrewingMethod) -> String {
        switch method {
        case .espresso: return "cup.and.saucer.fill"
        case .pourOver: return "drop.fill"
        case .frenchPress: return "cylinder.fill"
        case .aeropress: return "arrow.down.circle.fill"
        case .chemex: return "flask"
        case .coldBrew: return "snowflake"
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppColors.secondary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.subheadline)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
    }
}

struct InfoTag: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .bold()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.lightBrown)
        .cornerRadius(8)
    }
}

struct OpeningHoursRow: View {
    let day: String
    let hours: String
    
    var body: some View {
        HStack {
            Text(day)
                .foregroundColor(.gray)
            Spacer()
            Text(hours)
                .bold()
        }
        .font(.subheadline)
    }
}

struct OrderSheet: View {
    let shop: CoffeeShop
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDrink: String?
    @State private var quantity = 1
    @State private var useHybridPayment = false
    
    var standardDrinks: [String] {
        Coupon.standardDrinks
    }
    
    var premiumDrinks: [String] {
        Coupon.premiumDrinks
    }
    
    var totalCoupons: Int {
        guard let drink = selectedDrink else { return 0 }
        if premiumDrinks.contains(drink) && useHybridPayment {
            return quantity
        }
        let requirement = Coupon.requiredCoupons(for: drink)
        return requirement.coupons * quantity
    }
    
    var additionalPayment: Double? {
        guard let drink = selectedDrink, premiumDrinks.contains(drink), useHybridPayment else { return nil }
        return 2.50 * Double(quantity)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Standard Drinks (1 coupon)") {
                    ForEach(standardDrinks, id: \.self) { drink in
                        DrinkRow(
                            name: drink,
                            isSelected: selectedDrink == drink,
                            onTap: { 
                                selectedDrink = drink
                                useHybridPayment = false
                            }
                        )
                    }
                }
                
                Section("Premium Drinks") {
                    ForEach(premiumDrinks, id: \.self) { drink in
                        DrinkRow(
                            name: drink,
                            isSelected: selectedDrink == drink,
                            onTap: { 
                                selectedDrink = drink
                                useHybridPayment = false
                            }
                        )
                    }
                }
                
                if let drink = selectedDrink, premiumDrinks.contains(drink) {
                    Section("Payment Method") {
                        Toggle("Use 1 coupon + $2.50", isOn: $useHybridPayment)
                            .onChange(of: useHybridPayment) { newValue in
                                // Обработка изменения метода оплаты
                            }
                    }
                }
                
                if selectedDrink != nil {
                    Section {
                        Stepper("Quantity: \(quantity)", value: $quantity, in: 1...5)
                        HStack {
                            Text("Total coupons required:")
                            Spacer()
                            Text("\(totalCoupons)")
                                .bold()
                        }
                        if let additional = additionalPayment {
                            HStack {
                                Text("Additional payment:")
                                Spacer()
                                Text("$" + String(format: "%.2f", additional))
                                    .bold()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Order Coffee")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
            .safeAreaInset(edge: .bottom) {
                if let drink = selectedDrink {
                    Button(action: {
                        // TODO: Implement order processing
                        dismiss()
                    }) {
                        Text(buttonTitle)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.secondary)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
    }
    
    private var buttonTitle: String {
        if let additional = additionalPayment {
            return "Use \(totalCoupons) coupon\(totalCoupons == 1 ? "" : "s") + $" + String(format: "%.2f", additional)
        }
        return "Use \(totalCoupons) coupon\(totalCoupons == 1 ? "" : "s")"
    }
}

struct DrinkRow: View {
    let name: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(name)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(AppColors.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        CoffeeShopDetailView(shop: CoffeeShop.previews[0])
    }
} 