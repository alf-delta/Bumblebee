import SwiftUI

struct CouponsView: View {
    @State private var coupons = Coupon.previews
    @State private var showingScanner = false
    @State private var showingHistory = false
    @State private var selectedTransaction: CouponTransaction?
    
    var availableCoupons: Int {
        coupons.filter { !$0.isUsed }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Купоны и баланс
                    VStack(spacing: 8) {
                        Text("\(availableCoupons)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.secondary)
                        
                        Text(availableCoupons == 1 ? "coupon available" : "coupons available")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Стопка купонов
                    ZStack {
                        ForEach(coupons.prefix(3).reversed()) { coupon in
                            CouponCard(coupon: coupon)
                                .offset(y: Double(coupons.firstIndex(where: { $0.id == coupon.id }) ?? 0) * 8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Кнопка активации
                    Button(action: {
                        showingScanner = true
                    }) {
                        Label("Redeem Coupon", systemImage: "qrcode.viewfinder")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(availableCoupons > 0 ? AppColors.secondary : Color.gray)
                            .cornerRadius(16)
                    }
                    .disabled(availableCoupons == 0)
                    .padding()
                }
            }
            .navigationTitle("My Coupons")
            .navigationBarItems(trailing: Button(action: {
                showingHistory = true
            }) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title2)
            })
            .sheet(isPresented: $showingScanner) {
                QRScannerView { result in
                    // Здесь будет логика обработки QR-кода и списания купонов
                    handleQRScan(result)
                    showingScanner = false
                }
            }
            .sheet(isPresented: $showingHistory) {
                TransactionHistoryView(transactions: Coupon.previewTransactions)
            }
        }
    }
    
    private func handleQRScan(_ result: String) {
        // Здесь будет логика обработки QR-кода
        // Например: проверка валидности кода, определение кофейни,
        // списание купонов в зависимости от типа напитка
    }
}

struct CouponCard: View {
    let coupon: Coupon
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(height: 220)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
            .overlay(
                VStack {
                    Image(systemName: "ticket.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.secondary)
                    
                    Text("Coffee Coupon")
                        .font(.title2)
                        .bold()
                    
                    Text("Valid at all partner coffee shops")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(coupon.purchaseDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
            )
    }
}

struct TransactionHistoryView: View {
    let transactions: [CouponTransaction]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(transactions) { transaction in
                VStack(alignment: .leading, spacing: 8) {
                    Text(transaction.drinkName)
                        .font(.headline)
                    
                    Text(transaction.coffeeShopName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Label("\(transaction.couponsSpent) coupon(s)", systemImage: "ticket.fill")
                        
                        if let additional = transaction.additionalPayment {
                            Label("+ $\(additional, specifier: "%.2f")", systemImage: "dollarsign.circle.fill")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(AppColors.secondary)
                    
                    Text(transaction.date.formatted())
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("History")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct QRScannerView: View {
    let onScan: (String) -> Void
    
    var body: some View {
        // Здесь будет реализация сканера QR-кодов
        Text("QR Scanner Placeholder")
    }
}

#Preview {
    CouponsView()
} 