import SwiftUI

struct ContentDetailView: View {
    let content: ClubContent
    @Environment(\.dismiss) private var dismiss
    @State private var showingInviteSheet = false
    @State private var selectedGuestCount = 1
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header Image
                if let imageURL = content.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(height: 250)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    // Title and metadata
                    Text(content.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if content.type == .events {
                        eventDetailContent
                    } else {
                        HStack {
                            Label(content.author, systemImage: "person.circle")
                            Spacer()
                            Label(dateFormatter.string(from: content.date), systemImage: "calendar")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    if let readingTime = content.readingTime {
                        Label("\(readingTime) min read", systemImage: "clock")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let coffeeShopName = content.coffeeShopName {
                        Label(coffeeShopName, systemImage: "cup.and.saucer.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Content
                    Text(content.description)
                        .font(.body)
                        .lineSpacing(8)
                    
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(content.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(hex: content.type.color).opacity(0.1))
                                    .foregroundColor(Color(hex: content.type.color))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
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
    }
    
    @ViewBuilder
    private var eventDetailContent: some View {
        if let location = content.location,
           let maxGuests = content.maxGuests,
           let currentGuests = content.currentGuests {
            VStack(alignment: .leading, spacing: 12) {
                // Event metadata
                VStack(alignment: .leading, spacing: 8) {
                    Label(dateFormatter.string(from: content.date), systemImage: "calendar")
                    Label(location, systemImage: "mappin.circle")
                    Label("\(currentGuests)/\(maxGuests) guests registered", systemImage: "person.2")
                    Label("Host: \(content.author)", systemImage: "person.circle")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                // Join button
                if currentGuests < maxGuests {
                    Button(action: {
                        showingInviteSheet = true
                    }) {
                        Text("Join Event")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: content.type.color))
                            .cornerRadius(12)
                    }
                } else {
                    Text("Event is full")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.gray)
                        .cornerRadius(12)
                }
            }
        }
    }
} 