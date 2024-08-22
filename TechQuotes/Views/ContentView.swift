//
//  ContentView.swift
//  TechQuotes
//
//  Created by Sebastian Alzate on 21/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = TechQuoteViewModel()
    @State private var renderedImage: Image?
    @Environment(\.colorScheme) private var colorScheme
    private var deviceType = UIDevice.current.userInterfaceIdiom
    // Acceder a las variables de entorno horizontal y vertical para cuando el celular esté en landscape poder modificar el tamaño del botón y de la quote para que no se recorte.
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {

                if colorScheme == .light {
                    Image("TechQuotesLogoLight")
                        .resizable()
                        .scaledToFit()
                        .background(Color.orange)
                        .frame(maxWidth: 200)
                        .padding(.top, geometry.safeAreaInsets.top)
                } else {
                    Image("TechQuotesLogoDark")
                        .resizable()
                        .scaledToFit()
                        .background(Color.orange)
                        .frame(maxWidth: 200)
                        .padding(.top, geometry.safeAreaInsets.top)
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
                        .frame(maxWidth: deviceType == .phone ? .infinity : 200)
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
