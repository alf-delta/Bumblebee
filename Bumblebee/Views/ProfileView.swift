import SwiftUI
import Charts

struct ProfileView: View {
    let profile: UserProfile
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile
                VStack(spacing: 16) {
                    // Avatar
                    if let avatarURL = profile.avatarURL {
                        AsyncImage(url: avatarURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(hex: "#4ECDC4"), lineWidth: 3))
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                    
                    // Name and username
                    VStack(spacing: 4) {
                        Text(profile.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("@\(profile.username)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Coffee Statistics
                HStack(alignment: .top, spacing: 16) {
                    // Chart
                    VStack {
                        Chart {
                            ForEach(profile.coffeeStats.types, id: \.name) { type in
                                SectorMark(
                                    angle: .value("Percentage", type.percentage),
                                    innerRadius: .ratio(0.618),
                                    angularInset: 1.5
                                )
                                .foregroundStyle(Color(hex: type.color))
                            }
                        }
                        .frame(width: 150, height: 150)
                        
                        Text("\(Int(profile.coffeeStats.totalVolume))ml")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#4ECDC4"))
                    }
                    
                    // Legend and volume
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(profile.coffeeStats.types, id: \.name) { type in
                            HStack {
                                Circle()
                                    .fill(Color(hex: type.color))
                                    .frame(width: 8, height: 8)
                                Text(type.name)
                                    .font(.subheadline)
                                Text("\(Int(type.percentage * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(profile.coffeeStats.funComparison)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                }
                .padding()
                .background(BumblebeeColors.card)
                .cornerRadius(16)
                
                // Favorite Places
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favorite Places")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ForEach(profile.favoriteLocations, id: \.self) { location in
                        HStack {
                            Image(systemName: "cup.and.saucer.fill")
                                .foregroundColor(Color(hex: "#4ECDC4"))
                            Text(location)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(BumblebeeColors.card)
                .cornerRadius(16)
                
                // Recommendations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Personal Recommendations")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        recommendationRow(
                            icon: "leaf.fill",
                            title: "Try Something New",
                            description: "Based on your taste, you might love our Flat White"
                        )
                        
                        recommendationRow(
                            icon: "clock.fill",
                            title: "Best Time to Visit",
                            description: "Your favorite barista works mornings 8am-2pm"
                        )
                    }
                }
                .padding()
                .background(BumblebeeColors.card)
                .cornerRadius(16)
                
                // Special Offers
                VStack(alignment: .leading, spacing: 16) {
                    Text("Special Offers")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ForEach(profile.specialOffers, id: \.title) { offer in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(offer.coffeeshopName)
                                    .font(.headline)
                                Spacer()
                                Text("until \(dateFormatter.string(from: offer.expiresAt))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(offer.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(offer.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if offer.isProgressive {
                                ProgressView(value: Double(offer.progress!), total: Double(offer.total!))
                                    .tint(Color(hex: "#4ECDC4"))
                                    .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(Color(hex: "#4ECDC4").opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(BumblebeeColors.card)
                .cornerRadius(16)
            }
            .padding()
        }
        .navigationTitle("Profile")
    }
    
    private func recommendationRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#4ECDC4"))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    NavigationView {
        ProfileView(profile: UserProfile.mockProfile())
    }
} 