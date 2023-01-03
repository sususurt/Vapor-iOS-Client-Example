//
//  Person.swift
//  Vapor-App
//
//  Created by Ruitong Su on 12/31/22.
//

import Foundation

struct Person: Identifiable, Codable {
    let id: UUID?
    var name: String
}
