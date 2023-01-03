//
//  PersonListViewModel.swift
//  Vapor-App
//
//  Created by Ruitong Su on 12/31/22.
//

import SwiftUI

final class PersonListViewModel: ObservableObject {
    @Published var persons = [Person]()

    func fetchPersons() async throws {
        let urlString = Constants.baseURL + Endpoints.persons

        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let personResponse: [Person] = try await NetworkManager.shared.fetch(url: url)

        DispatchQueue.main.async {
            self.persons = personResponse
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            guard let id = persons[i].id,
                  let url = URL(string: Constants.baseURL + Endpoints.persons + "/\(id)") else {
                return
            }

            Task {
                do {
                    try await NetworkManager.shared.delete(at: id, url: url)
                } catch {
                    print("❌ Error: \(error)")
                }
            }
        }

        persons.remove(atOffsets: offsets)
    }
}
