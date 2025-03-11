import SwiftUI

struct CoffeeClubView: View {
    let articles = Article.previews
    @State private var selectedArticle: Article?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(articles) { article in
                        ArticleCard(article: article)
                            .onTapGesture {
                                selectedArticle = article
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Coffee Club")
            .sheet(item: $selectedArticle) { article in
                ArticleDetailView(article: article)
            }
        }
    }
}

struct ArticleCard: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: article.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.title2)
                    .bold()
                
                Text(article.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    ForEach(article.tags.prefix(3), id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .foregroundColor(AppColors.secondary)
                    }
                }
                
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                    Text(article.author)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("\(article.likes)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: article.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(height: 250)
                    .clipShape(Rectangle())
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(article.title)
                            .font(.title)
                            .bold()
                        
                        Text(article.subtitle)
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.gray)
                            Text(article.author)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                        
                        Text(article.content)
                            .font(.body)
                            .lineSpacing(6)
                        
                        HStack {
                            ForEach(article.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .foregroundColor(AppColors.secondary)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
}

#Preview {
    CoffeeClubView()
} 