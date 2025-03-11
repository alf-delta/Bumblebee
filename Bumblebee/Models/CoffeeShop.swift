import Foundation
import CoreLocation

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

struct CoffeeShop: Identifiable, Codable {
    let id: String
    let name: String
    let address: String
    let description: String
    let rating: Double
    let reviewCount: Int
    let latitude: Double
    let longitude: Double
    let district: District
    let roastLevel: RoastLevel
    let brewingMethods: [BrewingMethod]
    let coffeeOrigins: [CoffeeOrigin]
    let openingHours: OpeningHours
    let imageURLs: [String]
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum District: String, Codable, CaseIterable {
        case downtown = "Downtown"
        case brooklyn = "Brooklyn"
        case queens = "Queens"
        case manhattan = "Manhattan"
    }
    
    enum RoastLevel: String, Codable, CaseIterable {
        case light = "Light"
        case medium = "Medium"
        case dark = "Dark"
    }
    
    enum BrewingMethod: String, Codable, CaseIterable {
        case espresso = "Espresso"
        case pourOver = "Pour Over"
        case frenchPress = "French Press"
        case aeropress = "AeroPress"
        case chemex = "Chemex"
        case coldBrew = "Cold Brew"
    }
    
    struct CoffeeOrigin: Codable {
        let country: String
        let region: String
        let farm: String?
        let altitude: String?
        let process: String?
        let variety: String?
    }
    
    struct OpeningHours: Codable {
        let monday: String
        let tuesday: String
        let wednesday: String
        let thursday: String
        let friday: String
        let saturday: String
        let sunday: String
    }
    
    static var previews: [CoffeeShop] = [
        CoffeeShop(
            id: "1",
            name: "Stumptown Coffee Roasters",
            address: "18 W 29th St, New York, NY",
            description: "A specialized coffee shop known for its freshly roasted coffee and minimalist design. We offer a wide selection of brewing methods and regularly update our menu.",
            rating: 4.8,
            reviewCount: 342,
            latitude: 40.7454,
            longitude: -73.9871,
            district: .manhattan,
            roastLevel: .medium,
            brewingMethods: [.espresso, .pourOver, .aeropress],
            coffeeOrigins: [
                CoffeeOrigin(
                    country: "Ethiopia",
                    region: "Yirgacheffe",
                    farm: "Idido",
                    altitude: "1800-2200m",
                    process: "Washed",
                    variety: "Heirloom"
                )
            ],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "2",
            name: "Blue Bottle Coffee",
            address: "76 N 4th St, Brooklyn, NY",
            description: "Trendy cafe chain offering upscale coffee drinks & pastries in an industrial-chic space.",
            rating: 4.6,
            reviewCount: 287,
            latitude: 40.7169,
            longitude: -73.9614,
            district: .brooklyn,
            roastLevel: .light,
            brewingMethods: [.pourOver, .coldBrew, .chemex],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "3",
            name: "Devoción",
            address: "25-29 Columbia St, Brooklyn, NY",
            description: "Colombian coffee roaster featuring farm-fresh beans & industrial-chic digs with greenhouse-style windows.",
            rating: 4.7,
            reviewCount: 456,
            latitude: 40.7125,
            longitude: -73.9567,
            district: .brooklyn,
            roastLevel: .medium,
            brewingMethods: [.espresso, .pourOver],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "4",
            name: "Coffee Project NY",
            address: "239 E 5th St, New York, NY",
            description: "Intimate coffee shop with a modern vibe, known for their deconstructed latte & coffee flight tastings.",
            rating: 4.9,
            reviewCount: 198,
            latitude: 40.7268,
            longitude: -73.9877,
            district: .manhattan,
            roastLevel: .light,
            brewingMethods: [.espresso, .pourOver, .aeropress, .chemex],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "5",
            name: "Sweetleaf Coffee Roasters",
            address: "4615 Center Blvd, Queens, NY",
            description: "Hip coffee shop & roastery offering house-roasted beans, plus baked goods in an industrial-chic space.",
            rating: 4.5,
            reviewCount: 234,
            latitude: 40.7471,
            longitude: -73.9567,
            district: .queens,
            roastLevel: .dark,
            brewingMethods: [.espresso, .pourOver, .coldBrew],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "6",
            name: "Third Rail Coffee",
            address: "240 Sullivan St, New York, NY",
            description: "Cozy spot serving carefully crafted coffee drinks & pastries in a rustic-modern setting.",
            rating: 4.6,
            reviewCount: 167,
            latitude: 40.7297,
            longitude: -73.9989,
            district: .manhattan,
            roastLevel: .medium,
            brewingMethods: [.espresso, .pourOver],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "7",
            name: "Variety Coffee Roasters",
            address: "146 Wyckoff Ave, Brooklyn, NY",
            description: "Local chain known for house-roasted coffee served in bright, minimalist surroundings.",
            rating: 4.7,
            reviewCount: 289,
            latitude: 40.7068,
            longitude: -73.9229,
            district: .brooklyn,
            roastLevel: .light,
            brewingMethods: [.espresso, .pourOver, .chemex],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "8",
            name: "Birch Coffee",
            address: "21-21 31st St, Queens, NY",
            description: "Local coffee shop chain known for its carefully sourced beans & laid-back atmosphere.",
            rating: 4.4,
            reviewCount: 178,
            latitude: 40.7762,
            longitude: -73.9311,
            district: .queens,
            roastLevel: .medium,
            brewingMethods: [.espresso, .frenchPress, .coldBrew],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "9",
            name: "Partners Coffee",
            address: "44-61 11th St, Long Island City, NY",
            description: "Specialty coffee roaster offering single-origin beans & creative drinks in an industrial space.",
            rating: 4.8,
            reviewCount: 312,
            latitude: 40.7475,
            longitude: -73.9507,
            district: .queens,
            roastLevel: .light,
            brewingMethods: [.espresso, .pourOver, .aeropress],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        ),
        CoffeeShop(
            id: "10",
            name: "Black Fox Coffee",
            address: "70 Pine St, New York, NY",
            description: "Upscale cafe serving specialty coffee & light fare in an elegant space with marble counters.",
            rating: 4.7,
            reviewCount: 245,
            latitude: 40.7075,
            longitude: -74.0071,
            district: .downtown,
            roastLevel: .medium,
            brewingMethods: [.espresso, .pourOver, .chemex],
            coffeeOrigins: [defaultOrigin],
            openingHours: defaultHours,
            imageURLs: defaultImages
        )
    ]
    
    private static let defaultHours = OpeningHours(
        monday: "7:00 AM - 8:00 PM",
        tuesday: "7:00 AM - 8:00 PM",
        wednesday: "7:00 AM - 8:00 PM",
        thursday: "7:00 AM - 8:00 PM",
        friday: "7:00 AM - 9:00 PM",
        saturday: "8:00 AM - 9:00 PM",
        sunday: "8:00 AM - 7:00 PM"
    )
    
    private static let defaultOrigin = CoffeeOrigin(
        country: "Ethiopia",
        region: "Yirgacheffe",
        farm: "Idido",
        altitude: "1800-2200m",
        process: "Washed",
        variety: "Heirloom"
    )
    
    private static let defaultImages = [
        "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb",
        "https://images.unsplash.com/photo-1554118811-1e0d58224f24"
    ]
}

struct MenuItem: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let category: Category
    
    enum Category: String, Codable, CaseIterable {
        case espresso = "Espresso"
        case filter = "Filter"
        case special = "Special"
        case pastry = "Pastry"
    }
} 