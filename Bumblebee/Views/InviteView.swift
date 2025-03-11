import SwiftUI

struct InviteView: View {
    let title: String
    let maxGuests: Int
    let currentGuests: Int
    @Binding var guestCount: Int
    let onConfirm: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("How many guests would you like to bring?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Stepper(value: $guestCount, in: 1...max(1, maxGuests - currentGuests)) {
                    Text("\(guestCount) \(guestCount == 1 ? "guest" : "guests")")
                        .font(.title3)
                }
                .padding()
                
                Button(action: {
                    onConfirm(guestCount)
                    dismiss()
                }) {
                    Text("Confirm")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.secondary)
                        .cornerRadius(12)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
} 