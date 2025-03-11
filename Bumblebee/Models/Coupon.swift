import Foundation

struct CouponTransaction: Identifiable, Codable {
    let id: String
    let coffeeShopId: String
    let coffeeShopName: String
    let drinkName: String
    let couponsSpent: Int
    let additionalPayment: Double?
    let date: Date
}

struct Coupon: Identifiable, Codable {
    let id: String
    let purchaseDate: Date
    var isUsed: Bool
    
    static let standardDrinks = ["Espresso", "Americano"]
    static let premiumDrinks = ["Cappuccino", "Latte", "Flat White"]
    
    static func requiredCoupons(for drinkType: String) -> (coupons: Int, additionalPayment: Bool) {
        if standardDrinks.contains(drinkType) {
            return (1, false)
        } else if premiumDrinks.contains(drinkType) {
            return (2, false) // Опция с двумя купонами
            // Альтернативно: return (1, true) // Опция с одним купоном + доплата
        }
        return (0, false) // Неизвестный напиток
    }
    
    static var previewTransactions: [CouponTransaction] = [
        CouponTransaction(
            id: "1",
            coffeeShopId: "1",
            coffeeShopName: "Stumptown Coffee",
            drinkName: "Espresso",
            couponsSpent: 1,
            additionalPayment: nil,
            date: Date().addingTimeInterval(-2*24*60*60)
        ),
        CouponTransaction(
            id: "2",
            coffeeShopId: "2",
            coffeeShopName: "Blue Bottle",
            drinkName: "Cappuccino",
            couponsSpent: 1,
            additionalPayment: 2.50,
            date: Date().addingTimeInterval(-5*24*60*60)
        ),
        CouponTransaction(
            id: "3",
            coffeeShopId: "1",
            coffeeShopName: "Stumptown Coffee",
            drinkName: "Latte",
            couponsSpent: 2,
            additionalPayment: nil,
            date: Date().addingTimeInterval(-7*24*60*60)
        )
    ]
    
    static var previews: [Coupon] = (1...5).map { index in
        Coupon(
            id: "\(index)",
            purchaseDate: Date(),
            isUsed: false
        )
    }
} 