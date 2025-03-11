import Foundation

struct Article: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let content: String
    let imageURL: String
    let author: String
    let coffeeShopId: String
    let publishedDate: Date
    let likes: Int
    let tags: [String]
    
    static var previews: [Article] = [
        Article(
            id: "1",
            title: "The Secrets of Perfect Coffee Roasting",
            subtitle: "How temperature and time affect your coffee taste",
            content: """
            Coffee roasting is both an art and a science. Each variety requires a special approach, 
            and even small changes in temperature or time can radically change the taste of the drink.
            
            Light roasting reveals fruity and floral notes while preserving the natural acidity of the beans. 
            Medium roasting brings out caramel and nutty undertones, while dark roasting produces chocolate 
            and spicy notes.
            
            At Blue Bottle Coffee, we use special roasting profiles for each variety 
            to highlight its unique characteristics.
            """,
            imageURL: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd",
            author: "James Freeman",
            coffeeShopId: "1",
            publishedDate: Date().addingTimeInterval(-7*24*60*60),
            likes: 156,
            tags: ["roasting", "coffee", "masterclass"]
        ),
        Article(
            id: "2",
            title: "Journey into the World of Filter Coffee",
            subtitle: "Understanding brewing methods",
            content: """
            Filter coffee is not just a brewing method, it's a whole philosophy. 
            Each method, whether V60, Chemex, or Kalita Wave, has its own characteristics 
            and reveals different aspects of coffee taste.
            
            Key factors for successful brewing:
            - Coffee grind
            - Water temperature
            - Extraction time
            - Brewing technique
            
            In our coffee shop, we prefer the V60 method for its versatility and ability 
            to highlight bright coffee notes.
            """,
            imageURL: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085",
            author: "Maria Peters",
            coffeeShopId: "2",
            publishedDate: Date().addingTimeInterval(-3*24*60*60),
            likes: 98,
            tags: ["filter-coffee", "V60", "brewing"]
        ),
        Article(
            id: "3",
            title: "Coffee and Health: Myths and Reality",
            subtitle: "A scientific look at your favorite drink",
            content: """
            For many years, there have been many myths about coffee's effects on health. 
            Let's look at what modern science says.
            
            Research shows that moderate coffee consumption:
            - Improves concentration
            - Boosts metabolism
            - Contains antioxidants
            - May reduce the risk of certain diseases
            
            It's important to remember individual caffeine sensitivity and choose 
            quality coffee from trusted producers.
            """,
            imageURL: "https://images.unsplash.com/photo-1442512595331-e89e73853f31",
            author: "Dr. Anna Smith",
            coffeeShopId: "3",
            publishedDate: Date().addingTimeInterval(-1*24*60*60),
            likes: 234,
            tags: ["health", "research", "caffeine"]
        )
    ]
} 