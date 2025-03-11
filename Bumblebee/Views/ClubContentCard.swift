import SwiftUI

struct ClubContentCard: View {
    let content: ClubContent
    @State private var showingInviteSheet = false
    @State private var showingDetail = false
    @State private var selectedGuestCount = 1
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with type indicator
                HStack {
                    Label(content.type.rawValue, systemImage: content.type.icon)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: content.type.color).opacity(0.2))
                        .foregroundColor(Color(hex: content.type.color))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: content.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Image
                if let imageURL = content.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(height: 200)
                    .clipped()
                } else {
                    // Placeholder image based on content type
                    Image(systemName: content.type.icon)
                        .font(.system(size: 40))
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: content.type.color).opacity(0.1))
                        .foregroundColor(Color(hex: content.type.color))
                }
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(content.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(content.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: content.type.color))
                            }
                        }
                    }
                    
                    // Type-specific content
                    switch content.type {
                    case .events:
                        eventContent
                    case .news:
                        newsContent
                    case .articles:
                        articleContent
                    }
                }
                .padding()
            }
            .background(AppColors.card)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingInviteSheet) {
            if let maxGuests = content.maxGuests,
               let currentGuests = content.currentGuests {
                InviteView(
                    title: content.title,
                    maxGuests: maxGuests,
                    currentGuests: currentGuests,
                    guestCount: $selectedGuestCount,
                    onConfirm: { count in
                        // TODO: Implement join event logic
                        print("Joined event with \(count) guests")
                    }
                )
            }
        }
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                ContentDetailView(content: content)
            }
        }
    }
    
    @ViewBuilder
    private var eventContent: some View {
        if let maxGuests = content.maxGuests,
           let currentGuests = content.currentGuests {
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Label(dateFormatter.string(from: content.date), systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Label("\(maxGuests - currentGuests) spots left", systemImage: "person.2")
                            .font(.caption)
                            .foregroundColor(currentGuests < maxGuests ? .secondary : .red)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private var newsContent: some View {
        if let coffeeShopName = content.coffeeShopName {
            HStack {
                Label(coffeeShopName, systemImage: "cup.and.saucer.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var articleContent: some View {
        HStack {
            Label(content.author, systemImage: "person.circle")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if let readingTime = content.readingTime {
                Label("\(readingTime) min read", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ClubContentCard(content: ClubContent.mockEvents()[0])
} 