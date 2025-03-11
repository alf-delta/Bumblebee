import SwiftUI

struct BumblebeeLogo: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Тело пчелы
                BeeShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.hex("FFD700"),  // Золотой
                                Color.hex("FFA500")   // Оранжевый
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                // Полоски
                BeeStripes()
                    .fill(Color.black)
                
                // Крылья
                BeeWings()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.9),
                                .white.opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blendMode(.screen)
            }
            .aspectRatio(contentMode: .fit)
        }
    }
}

private struct BeeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Тело пчелы (овал)
        path.addEllipse(in: CGRect(x: width * 0.2, y: height * 0.3,
                                 width: width * 0.6, height: height * 0.4))
        
        // Голова (круг)
        path.addEllipse(in: CGRect(x: width * 0.1, y: height * 0.35,
                                 width: width * 0.25, height: height * 0.3))
        
        return path
    }
}

private struct BeeStripes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Три полоски на теле
        for i in 0..<3 {
            let x = width * (0.35 + Double(i) * 0.15)
            path.move(to: CGPoint(x: x, y: height * 0.3))
            path.addLine(to: CGPoint(x: x, y: height * 0.7))
        }
        
        return path
    }
}

private struct BeeWings: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Верхнее крыло
        path.move(to: CGPoint(x: width * 0.4, y: height * 0.3))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.6, y: height * 0.3),
            control: CGPoint(x: width * 0.5, y: height * 0.1)
        )
        
        // Нижнее крыло
        path.move(to: CGPoint(x: width * 0.45, y: height * 0.4))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.65, y: height * 0.4),
            control: CGPoint(x: width * 0.55, y: height * 0.6)
        )
        
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        BumblebeeLogo()
            .frame(width: 200, height: 200)
        BumblebeeLogo()
            .frame(width: 100, height: 100)
    }
    .padding()
    .preferredColorScheme(.light)
} 