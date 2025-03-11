import Foundation

enum ContentType: String, CaseIterable {
    case events = "Events"
    case news = "News"
    case articles = "Articles"
    
    var icon: String {
        switch self {
        case .events: return "calendar.badge.clock"
        case .news: return "newspaper"
        case .articles: return "book"
        }
    }
    
    var color: String {
        switch self {
        case .events: return "#FF6B6B"
        case .news: return "#4ECDC4"
        case .articles: return "#45B7D1"
        }
    }
}

struct ClubContent: Identifiable {
    let id: UUID
    let type: ContentType
    let title: String
    let description: String
    let date: Date
    let imageURL: URL?
    let author: String
    let tags: [String]
    
    // Event-specific properties
    let location: String?
    let maxGuests: Int?
    let currentGuests: Int?
    
    // News-specific properties
    let coffeeShopName: String?
    
    // Article-specific properties
    let readingTime: Int? // in minutes
    
    static func mockEvents() -> [ClubContent] {
        [
            ClubContent(
                id: UUID(),
                type: .events,
                title: "Latte Art Masterclass",
                description: "Learn to create beautiful latte art patterns under the guidance of our professional barista. Perfect for beginners!",
                date: Date().addingTimeInterval(86400),
                imageURL: URL(string: "https://example.com/latte-art"),
                author: "John Smith",
                tags: ["barista", "skills", "coffee"],
                location: "Bumblebee Downtown",
                maxGuests: 10,
                currentGuests: 3,
                coffeeShopName: nil,
                readingTime: nil
            ),
            ClubContent(
                id: UUID(),
                type: .events,
                title: "Coffee Cupping Session",
                description: "Join our specialty coffee tasting session. Experience different coffee origins and processing methods.",
                date: Date().addingTimeInterval(172800),
                imageURL: URL(string: "https://example.com/cupping"),
                author: "Maria Rodriguez",
                tags: ["tasting", "specialty", "origins"],
                location: "Bumblebee Lab",
                maxGuests: 15,
                currentGuests: 8,
                coffeeShopName: nil,
                readingTime: nil
            )
        ]
    }
    
    static func mockNews() -> [ClubContent] {
        [
            ClubContent(
                id: UUID(),
                type: .news,
                title: "New Single Origin from Ethiopia",
                description: "We're excited to introduce our latest Ethiopian Yirgacheffe. Featuring bright citrus notes with a jasmine finish.",
                date: Date().addingTimeInterval(-86400),
                imageURL: URL(string: "https://example.com/ethiopian"),
                author: "Bumblebee Coffee",
                tags: ["new", "ethiopia", "single-origin"],
                location: nil,
                maxGuests: nil,
                currentGuests: nil,
                coffeeShopName: "Bumblebee Downtown",
                readingTime: nil
            ),
            ClubContent(
                id: UUID(),
                type: .news,
                title: "Brooklyn Location Now Open",
                description: "Visit our new Brooklyn location! Featuring a custom Slayer espresso machine and locally baked pastries.",
                date: Date().addingTimeInterval(-172800),
                imageURL: URL(string: "https://example.com/brooklyn"),
                author: "Bumblebee Coffee",
                tags: ["new-location", "brooklyn"],
                location: nil,
                maxGuests: nil,
                currentGuests: nil,
                coffeeShopName: "Bumblebee Brooklyn",
                readingTime: nil
            )
        ]
    }
    
    static func mockArticles() -> [ClubContent] {
        [
            ClubContent(
                id: UUID(),
                type: .articles,
                title: "The Science of Coffee Extraction",
                description: "Understanding the chemistry behind coffee extraction can help you brew better coffee. Learn about the key variables affecting your cup.",
                date: Date().addingTimeInterval(-259200),
                imageURL: URL(string: "https://example.com/extraction"),
                author: "Dr. James Wilson",
                tags: ["science", "brewing", "education"],
                location: nil,
                maxGuests: nil,
                currentGuests: nil,
                coffeeShopName: nil,
                readingTime: 8
            ),
            ClubContent(
                id: UUID(),
                type: .articles,
                title: "Sustainable Coffee: From Farm to Cup",
                description: "Explore how sustainable farming practices affect coffee quality and farming communities. A deep dive into modern coffee production.",
                date: Date().addingTimeInterval(-345600),
                imageURL: URL(string: "https://example.com/sustainable"),
                author: "Emma Green",
                tags: ["sustainability", "farming", "education"],
                location: nil,
                maxGuests: nil,
                currentGuests: nil,
                coffeeShopName: nil,
                readingTime: 12
            )
        ]
    }
} 