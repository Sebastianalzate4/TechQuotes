//
//  TechQuote.swift
//  TechQuotes
//
//  Created by Sebastian Alzate on 21/08/24.
//

import Foundation

struct TechQuote: Identifiable, Equatable, Hashable {
    let id: String
    let author: String
    let quote: String
}
