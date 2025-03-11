import SwiftUI

class CoffeeClubViewModel: ObservableObject {
    @Published var selectedType: ContentType?
    @Published var selectedDateFilter: DateFilter = .all
    @Published var content: [ClubContent] = []
    
    enum DateFilter: String, CaseIterable {
        case all = "All Time"
        case today = "Today"
        case thisWeek = "This Week"
        case thisMonth = "This Month"
        
        func isIncluded(_ date: Date) -> Bool {
            let calendar = Calendar.current
            let now = Date()
            
            switch self {
            case .all:
                return true
            case .today:
                return calendar.isDateInToday(date)
            case .thisWeek:
                return calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear)
            case .thisMonth:
                return calendar.isDate(date, equalTo: now, toGranularity: .month)
            }
        }
    }
    
    var filteredContent: [ClubContent] {
        content.filter { item in
            let typeMatch = selectedType == nil || item.type == selectedType
            let dateMatch = selectedDateFilter.isIncluded(item.date)
            return typeMatch && dateMatch
        }
    }
    
    func loadContent() {
        // Load mock data with test images
        content = [
            // Events
            ClubContent(
                id: UUID(),
                type: .events,
                title: "Latte Art Masterclass",
                description: "Learn to create beautiful latte art patterns under the guidance of our professional barista. Perfect for beginners!",
                date: Date().addingTimeInterval(86400),
                imageURL: URL(string: "https://images.unsplash.com/photo-1534778356534-d3d45b6df1da?w=800"),
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
                imageURL: URL(string: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800"),
                author: "Maria Rodriguez",
                tags: ["tasting", "specialty", "origins"],
                location: "Bumblebee Lab",
                maxGuests: 15,
                currentGuests: 8,
                coffeeShopName: nil,
                readingTime: nil
            ),
            
            // News
            ClubContent(
                id: UUID(),
                type: .news,
                title: "New Single Origin from Ethiopia",
                description: "We're excited to introduce our latest Ethiopian Yirgacheffe. Featuring bright citrus notes with a jasmine finish.",
                date: Date().addingTimeInterval(-86400),
                imageURL: URL(string: "https://images.unsplash.com/photo-1611854779393-1b2da9d400fe?w=800"),
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
                imageURL: URL(string: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800"),
                author: "Bumblebee Coffee",
                tags: ["new-location", "brooklyn"],
                location: nil,
                maxGuests: nil,
                currentGuests: nil,
                coffeeShopName: "Bumblebee Brooklyn",
                readingTime: nil
            ),
            
            // Articles
            ClubContent(
                id: UUID(),
                type: .articles,
                title: "The Science of Coffee Extraction",
                description: "Understanding the chemistry behind coffee extraction can help you brew better coffee. Learn about the key variables affecting your cup.",
                date: Date().addingTimeInterval(-259200),
                imageURL: URL(string: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800"),
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
                imageURL: URL(string: "https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?w=800"),
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

struct CoffeeClubView: View {
    @StateObject private var viewModel = CoffeeClubViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Content Type Filter
            HStack(spacing: 12) {
                FilterButton(
                    title: "All",
                    icon: "square.stack.3d.up",
                    isSelected: viewModel.selectedType == nil,
                    color: AppColors.primary
                ) {
                    viewModel.selectedType = nil
                }
                
                ForEach(ContentType.allCases, id: \.self) { type in
                    FilterButton(
                        title: type.rawValue,
                        icon: type.icon,
                        isSelected: viewModel.selectedType == type,
                        color: Color(hex: type.color)
                    ) {
                        viewModel.selectedType = type
                    }
                }
            }
            .padding()
            
            // Date Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(CoffeeClubViewModel.DateFilter.allCases, id: \.self) { filter in
                        DateFilterButton(
                            title: filter.rawValue,
                            isSelected: viewModel.selectedDateFilter == filter
                        ) {
                            viewModel.selectedDateFilter = filter
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Content List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredContent) { item in
                        ClubContentCard(content: item)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Coffee Club")
        .onAppear {
            viewModel.loadContent()
        }
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption)
            }
            .frame(width: 80)
            .padding(.vertical, 8)
            .foregroundColor(isSelected ? .white : color)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color : color.opacity(0.1))
            )
        }
    }
}

struct DateFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? AppColors.secondary : Color.gray.opacity(0.1))
                )
        }
    }
}

#Preview {
    NavigationView {
        CoffeeClubView()
    }
} 