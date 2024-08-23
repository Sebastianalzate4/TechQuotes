//
//  ContentView.swift
//  TechQuotes
//
//  Created by Sebastian Alzate on 21/08/24.
//

import SwiftUI

struct ContentView: View {
    
    // Configurar la LaunchScreen para todos los dispositivos disponibles.
    
    @State private var viewModel = TechQuoteViewModel()
    @State private var renderedImage: Image?
    
    @State private var logoOpacity = 0.0
    @State private var logoScale: CGFloat = 0.5
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    private let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        
        let isLandscape = verticalSizeClass == .compact && (horizontalSizeClass == .compact || horizontalSizeClass == .regular)
        
        GeometryReader { geometry in
            
            VStack {
                
                Image(colorScheme == .light ? "TechQuotesLogoLight" : "TechQuotesLogoDark")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: isPad ? 300 : 200)
                    .padding(.top, isPhone && isLandscape ? geometry.size.height * 0.05 : geometry.safeAreaInsets.top)
                //  .padding(.top, geometry.safeAreaInsets.top)
                    .opacity(logoOpacity)
                    .scaleEffect(logoScale)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            logoOpacity = 1.0
                            logoScale = 1.0
                        }
                    }
                
                Spacer()
                
                TechQuoteView(viewModel: viewModel)
                    .onAppear {
                        Task {
                            try await viewModel.fetchQuotes()
                            await viewModel.random()
                        }
                    }
                    .onChange(of: viewModel.randomQuote) {
                        // Analizar lo que se debe modificar para no disminuir la calidad de la imagen al ser exportada.
                        // Revisar por qué la imagen se exporta en formato PNG?
                        let size = geometry.size // Obtener el tamaño de la vista en el simulador
                        let rendered = ImageRenderer(content: TechQuoteView(viewModel: viewModel)
                            .frame(width: size.width, height: size.height))
                        rendered.scale = UIScreen.main.scale // Escala de la pantalla del dispositivo
                        if let image = rendered.cgImage {
                            renderedImage = Image(decorative: image, scale: 1.0)
                        }
                    }
                
                Spacer()
                
                if let renderedImage {
                    ShareLink("Export", item: renderedImage, preview: SharePreview(Text("Shared image"), image: renderedImage))
                        .frame(maxWidth: isPad ? 300 : 200)
                        .frame(height: isPad ? 70 : 50)
                        .font(isPad ? .title : .headline)
                        .bold()
                        .foregroundColor(colorScheme == .light ? .white : .black)
                        .background(colorScheme == .light ? .black : .white)
                        .clipShape(Capsule())
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
    }
}



#Preview {
    ContentView()
}
