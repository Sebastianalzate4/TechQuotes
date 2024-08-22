//
//  TechQuoteView.swift
//  TechQuotes
//
//  Created by Sebastian Alzate on 21/08/24.
//

import SwiftUI

struct TechQuoteView: View {
    
    // Intentar que esta vista no necesite el viewmodel, sino que simplemente necesite de variables tipo String para inicializarse.
    
    @State var viewModel : TechQuoteViewModel
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            Text(viewModel.randomQuote?.quote ?? "")
                .italic()
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
         
            Text("~ \(viewModel.randomQuote?.author ?? "")")
                .font(.title3)
                .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: 500)
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
