//
//  TechQuoteDTO.swift
//  TechQuotes
//
//  Created by Sebastian Alzate on 21/08/24.
//

import Foundation

struct TechQuoteDTO: Codable, Identifiable, Hashable {
    let id: String
    let author: String
    let quote: String
    
    enum CodingKeys: String, CodingKey {
        case id, author
        case quote = "en"
    }
}

extension TechQuoteDTO {
    var mapToTechQuote: TechQuote {
        TechQuote(
            id: id,
            author: author,
            quote: quote
        )
    }
}
