import Foundation

struct CoffeeEvent: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let location: String
    let maxGuests: Int
    var currentGuests: Int
    let imageURL: URL?
    
    init(id: UUID = UUID(), 
         title: String, 
         description: String, 
         date: Date, 
         location: String, 
         maxGuests: Int, 
         currentGuests: Int = 0, 
         imageURL: URL? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        self.maxGuests = maxGuests
        self.currentGuests = currentGuests
        self.imageURL = imageURL
    }
} 