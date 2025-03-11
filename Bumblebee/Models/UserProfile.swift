import Foundation

struct UserProfile {
    var name: String = "John Smith"
    var username: String = "coffee_lover"
    var avatarURL: URL? = URL(string: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d")
    var photo: String = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d"
    var coffeeStats = CoffeeStats(
        types: [
            CoffeeType(name: "Latte", percentage: 0.45, color: "#4ECDC4"),
            CoffeeType(name: "Cappuccino", percentage: 0.3, color: "#FF6B6B"),
            CoffeeType(name: "Espresso", percentage: 0.25, color: "#95A5A6")
        ],
        totalVolume: 2500,
        funComparison: "That's like 2.5 large water bottles! Nice start! ☺️"
    )
    
    var favoriteLocations: [String] = [
        "Bumblebee Jersey City",
        "Bumblebee Manhattan",
        "Bumblebee Brooklyn"
    ]
    
    var specialOffers: [SpecialOffer] = [
        SpecialOffer(
            coffeeshopName: "Bumblebee Jersey City",
            title: "4th Flat White Free",
            description: "Buy 3 Flat Whites, get the 4th one on us",
            expiresAt: Date().addingTimeInterval(7*24*60*60),
            isProgressive: true,
            progress: 2,
            total: 4
        ),
        SpecialOffer(
            coffeeshopName: "Bumblebee Manhattan",
            title: "Happy Hour",
            description: "20% off all drinks between 2-4 PM",
            expiresAt: Date().addingTimeInterval(14*24*60*60),
            isProgressive: false
        )
    ]
    
    static func mockProfile() -> UserProfile {
        UserProfile()
    }
}

struct CoffeeStats {
    var types: [CoffeeType]
    var totalVolume: Double
    var funComparison: String
}

struct CoffeeType {
    var name: String
    var percentage: Double
    var color: String
}

struct SpecialOffer {
    var coffeeshopName: String
    var title: String
    var description: String
    var expiresAt: Date
    var isProgressive: Bool
    var progress: Int? = nil
    var total: Int? = nil
} 