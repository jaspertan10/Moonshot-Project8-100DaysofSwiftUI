//
//  Astronaut.swift
//  Moonshot
//
//  Created by Jasper Tan on 12/1/24.
//

import Foundation

struct Astronaut: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
}
