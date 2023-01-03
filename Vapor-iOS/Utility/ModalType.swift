//
//  ModalType.swift
//  Vapor-App
//
//  Created by Ruitong Su on 12/31/22.
//

import Foundation

enum ModalType: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }

    case add
    case update(Person)
}
