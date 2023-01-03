//
//  AddUpdatePersonViewModel.swift
//  Vapor-App
//
//  Created by Ruitong Su on 12/31/22.
//

import SwiftUI

final class AddUpdatePersonViewModel: ObservableObject {
    @Published var personName = ""

    var personID: UUID?

    var isUpdating: Bool {
        personID != nil
    }

    var buttonTitle: String {
        personID != nil ? "Update Person" : "Add Person"
    }

    // Constructor for add
    init() { }

    // Constructor for update
    init(currentPerson: Person) {
        self.personID = currentPerson.id
        self.personName = currentPerson.name
    }

    func addPerson() async throws {
        let urlString = Constants.baseURL + Endpoints.persons
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let person = Person(id: nil, name: personName)

        try await NetworkManager.shared.send(to: url,
                                             object: person,
                                             httpMethod: HttpMethods.POST.rawValue)
    }

    func updatePerson() async throws {
        let urlString = Constants.baseURL + Endpoints.persons
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let personToUpdate = Person(id: personID, name: personName)
        try await NetworkManager.shared.send(to: url, object: personToUpdate, httpMethod: HttpMethods.PUT.rawValue)
    }

    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do {
                if isUpdating {
                    try await updatePerson()
                } else {
                    try await addPerson()
                }
            } catch {
                print("❌ Error: \(error)")
            }
            completion()
        }
    }
}
