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
    @Environment(\.colorScheme) private var colorScheme
//    private var deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                Image(colorScheme == .light ? "TechQuotesLogoLight" : "TechQuotesLogoDark")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .padding(.top, geometry.safeAreaInsets.top)
                
                
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
                        .frame(maxWidth: 200)
                        .frame(height: 50)
                        .font(.headline)
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
