import Foundation
import CoreLocation
import Combine

class MapViewModel: ObservableObject {
    @Published var shops: [CoffeeShop] = []
    @Published var selectedDistrict: CoffeeShop.District?
    @Published var selectedRoastLevel: CoffeeShop.RoastLevel?
    @Published var selectedBrewingMethod: CoffeeShop.BrewingMethod?
    
    var filteredShops: [CoffeeShop] {
        var result = shops
        
        if let district = selectedDistrict {
            result = result.filter { $0.district == district }
        }
        
        if let roastLevel = selectedRoastLevel {
            result = result.filter { $0.roastLevel == roastLevel }
        }
        
        if let brewingMethod = selectedBrewingMethod {
            result = result.filter { $0.brewingMethods.contains(brewingMethod) }
        }
        
        return result
    }
    
    init() {
        loadShops()
    }
    
    private func loadShops() {
        // Test data
        shops = [
            // Manhattan - Flatiron District
            CoffeeShop(
                id: "1",
                name: "Stumptown Coffee Roasters",
                address: "18 W 29th St, New York, NY",
                description: "A specialized coffee shop known for its freshly roasted coffee and minimalist design.",
                rating: 4.8,
                reviewCount: 342,
                latitude: 40.7454,
                longitude: -73.9884,
                district: .manhattan,
                roastLevel: .medium,
                brewingMethods: [.espresso, .pourOver, .aeropress],
                coffeeOrigins: [
                    CoffeeShop.CoffeeOrigin(
                        country: "Ethiopia",
                        region: "Yirgacheffe",
                        farm: "Idido",
                        altitude: "1800-2200m",
                        process: "Washed",
                        variety: "Heirloom"
                    )
                ],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            ),
            // Manhattan - Chelsea
            CoffeeShop(
                id: "2",
                name: "Blue Bottle Coffee",
                address: "450 W 15th St, New York, NY",
                description: "Premium coffee chain offering sophisticated brews in an industrial-chic setting.",
                rating: 4.7,
                reviewCount: 289,
                latitude: 40.7422,
                longitude: -74.0059,
                district: .manhattan,
                roastLevel: .light,
                brewingMethods: [.pourOver, .espresso, .coldBrew],
                coffeeOrigins: [defaultOrigin],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            ),
            // Manhattan - Lower East Side
            CoffeeShop(
                id: "3",
                name: "Third Rail Coffee",
                address: "240 Sullivan St, New York, NY",
                description: "Cozy spot serving artisanal coffee and pastries.",
                rating: 4.6,
                reviewCount: 178,
                latitude: 40.7297,
                longitude: -73.9989,
                district: .manhattan,
                roastLevel: .medium,
                brewingMethods: [.espresso, .chemex],
                coffeeOrigins: [defaultOrigin],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            ),
            // Brooklyn - Williamsburg
            CoffeeShop(
                id: "4",
                name: "Toby's Estate Coffee",
                address: "25 N 6th St, Brooklyn, NY",
                description: "Australian-style coffee shop with in-house roasting.",
                rating: 4.9,
                reviewCount: 412,
                latitude: 40.7193,
                longitude: -73.9612,
                district: .brooklyn,
                roastLevel: .dark,
                brewingMethods: [.espresso, .pourOver, .aeropress, .chemex],
                coffeeOrigins: [defaultOrigin],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            ),
            // Brooklyn - DUMBO
            CoffeeShop(
                id: "5",
                name: "Brooklyn Roasting Company",
                address: "25 Jay St, Brooklyn, NY",
                description: "Spacious coffee shop with waterfront views.",
                rating: 4.7,
                reviewCount: 325,
                latitude: 40.7039,
                longitude: -73.9867,
                district: .brooklyn,
                roastLevel: .medium,
                brewingMethods: [.espresso, .frenchPress, .coldBrew],
                coffeeOrigins: [defaultOrigin],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            ),
            // Brooklyn - Greenpoint
            CoffeeShop(
                id: "6",
                name: "Partners Coffee",
                address: "125 N 6th St, Brooklyn, NY",
                description: "Modern coffee shop with extensive brew options.",
                rating: 4.8,
                reviewCount: 267,
                latitude: 40.7193,
                longitude: -73.9615,
                district: .brooklyn,
                roastLevel: .light,
                brewingMethods: [.espresso, .pourOver, .chemex],
                coffeeOrigins: [defaultOrigin],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            ),
            // Queens - Astoria
            CoffeeShop(
                id: "7",
                name: "Mighty Oak Roasters",
                address: "28-01 24th Ave, Astoria, NY",
                description: "Neighborhood favorite with house-roasted beans.",
                rating: 4.6,
                reviewCount: 189,
                latitude: 40.7733,
                longitude: -73.9154,
                district: .queens,
                roastLevel: .medium,
                brewingMethods: [.espresso, .pourOver],
                coffeeOrigins: [defaultOrigin],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            ),
            // Downtown
            CoffeeShop(
                id: "8",
                name: "La Colombe Coffee",
                address: "319 Church St, New York, NY",
                description: "Upscale coffee chain known for draft lattes.",
                rating: 4.7,
                reviewCount: 356,
                latitude: 40.7197,
                longitude: -74.0048,
                district: .downtown,
                roastLevel: .dark,
                brewingMethods: [.espresso, .pourOver, .coldBrew],
                coffeeOrigins: [defaultOrigin],
                openingHours: defaultOpeningHours,
                imageURLs: defaultImages
            )
        ]
    }
    
    private var defaultOpeningHours: CoffeeShop.OpeningHours {
        CoffeeShop.OpeningHours(
            monday: "7:00 AM - 8:00 PM",
            tuesday: "7:00 AM - 8:00 PM",
            wednesday: "7:00 AM - 8:00 PM",
            thursday: "7:00 AM - 8:00 PM",
            friday: "7:00 AM - 9:00 PM",
            saturday: "8:00 AM - 9:00 PM",
            sunday: "8:00 AM - 7:00 PM"
        )
    }
    
    private var defaultOrigin: CoffeeShop.CoffeeOrigin {
        CoffeeShop.CoffeeOrigin(
            country: "Colombia",
            region: "Huila",
            farm: "El Paraiso",
            altitude: "1700-2000m",
            process: "Washed",
            variety: "Caturra"
        )
    }
    
    private var defaultImages: [String] {
        [
            "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb",
            "https://images.unsplash.com/photo-1554118811-1e0d58224f24"
        ]
    }
} 