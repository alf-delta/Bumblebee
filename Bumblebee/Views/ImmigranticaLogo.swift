import SwiftUI

struct ImmigranticaLogoView: View {
    var foregroundColor: Color = .black
    var size: CGFloat = 200
    
    var body: some View {
        GeometryReader { geometry in
            ImmigranticaShape()
                .fill(foregroundColor)
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: size, height: size)
    }
}

private struct ImmigranticaShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Масштабируем SVG координаты (375x375) к размеру rect
        let width: CGFloat = 375
        let height: CGFloat = 375
        let scale = min(rect.width / width, rect.height / height)
        
        // Центрируем логотип
        let xOffset = (rect.width - width * scale) / 2
        let yOffset = (rect.height - height * scale) / 2
        
        // Трансформация для всех точек
        let transform = CGAffineTransform(scaleX: scale, y: scale)
            .translatedBy(x: xOffset / scale + width / 2, y: yOffset / scale + height / 2)
        
        // Буква I
        path.move(to: CGPoint(x: -150, y: -50).applying(transform))
        path.addLine(to: CGPoint(x: -130, y: -50).applying(transform))
        path.addLine(to: CGPoint(x: -130, y: 50).applying(transform))
        path.addLine(to: CGPoint(x: -150, y: 50).applying(transform))
        path.closeSubpath()
        
        // Точка над I
        let dotRadius: CGFloat = 10
        path.addEllipse(in: CGRect(
            x: -140 - dotRadius,
            y: -80 - dotRadius,
            width: dotRadius * 2,
            height: dotRadius * 2
        ).applying(transform))
        
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        ImmigranticaLogoView(foregroundColor: .black, size: 200)
        ImmigranticaLogoView(foregroundColor: .blue, size: 100)
        ImmigranticaLogoView(foregroundColor: .red, size: 50)
    }
    .padding()
    .preferredColorScheme(.light)
} 