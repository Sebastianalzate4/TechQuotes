//
//  TechQuoteView.swift
//  TechQuotes
//
//  Created by Sebastian Alzate on 21/08/24.
//

import SwiftUI

struct TechQuoteView: View {
    
    // Seguir configurando según el dispositivo y su orientación, el tamaño de los elementos en la vista como ya lo he logrado con el modificador ".font"
    
    // Intentar que esta vista no necesite el viewmodel, sino que simplemente necesite de variables tipo String para inicializarse.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    private let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    private let isPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State var viewModel : TechQuoteViewModel
    
    var body: some View {
        
//        let isPortrait = verticalSizeClass == .regular && horizontalSizeClass == .compact
        let isLandscape = verticalSizeClass == .compact && (horizontalSizeClass == .compact || horizontalSizeClass == .regular)
        
        VStack(alignment: .trailing) {
            Text(viewModel.randomQuote?.quote ?? "")
                .italic()
//                .font(isPhone && isLandscape ? .title3 : .title2)
                .font(isPad ? .title : (isPhone && isLandscape ? .headline : .title2))
                .multilineTextAlignment(.center)
                .padding()
         
            Text("~ \(viewModel.randomQuote?.author ?? "")")
//                .font(isPhone && isLandscape ? .headline : .title3)
                .font(isPad ? .title2 : (isPhone && isLandscape ? .subheadline : .title3))
                .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .frame(maxWidth: .infinity, maxHeight: 500)
//        .background(Color.red)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            Task {
                await viewModel.random()
            }
        }
    }
}

// Presentar una Preview.
#Preview {
    TechQuoteView(viewModel: TechQuoteViewModel())
}
