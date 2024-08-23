//
//  TechQuoteViewModel.swift
//  TechQuotes
//
//  Created by Sebastian Alzate on 21/08/24.
//

import Foundation

@Observable
final class TechQuoteViewModel {
    
    // Hacer una sola llamada a red cuando inicialice la app y no cada vez que se haga doble tap, así solo sería lanzar una quote aleatoria del array.
    
    var quotes: [TechQuote] = []
    var randomQuote: TechQuote? // Intentar usar var randomQuote: String = "" para no tener que lidiar con opcionales.
    
    
    func fetchQuotes() async throws  {
        
        let endpoint = "https://raw.githubusercontent.com/skolakoda/programming-quotes-api/master/Data/quotes.json"
        
        guard let url = URL(string: endpoint) else { return }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
        
        let quotes = try JSONDecoder().decode([TechQuoteDTO].self, from: data).map(\.mapToTechQuote)
        
        await MainActor.run {
            self.quotes = quotes
        }
        
    }
    
    func random() async {
        
        guard let randomQuote = quotes.randomElement() else { return }
        // Testear si con el nuevo patrón Observable ya no se necesita el uso de "MainActor.run"
        await MainActor.run {
            self.randomQuote = randomQuote
            
        }
    }
}

// Crear un enum para el control de errores. Pero antes, revisar cómo controlar la ausencia de conexión a internet para hacerlos de la mano.
