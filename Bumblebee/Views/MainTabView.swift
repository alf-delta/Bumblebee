import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    private let profile = UserProfile.mockProfile()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapContainerView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(0)
            
            CoffeeClubView()
                .tabItem {
                    Label("Club", systemImage: "newspaper")
                }
                .tag(1)
            
            CouponsView()
                .tabItem {
                    Label("Coupons", systemImage: "ticket")
                }
                .tag(2)
            
            ProfileView(profile: profile)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .tint(AppColors.secondary)
    }
}

#Preview {
    MainTabView()
} 