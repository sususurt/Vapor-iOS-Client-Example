//
//  PersonList.swift
//  Vapor-App
//
//  Created by Ruitong Su on 12/31/22.
//

import SwiftUI

struct PersonList: View {

    @StateObject var viewModel = PersonListViewModel()

    @State var modal: ModalType? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.persons) { person in
                    Button {
                        modal = .update(person)
                    } label: {
                        Text(person.name)
                            .font(.title)
                            .foregroundColor(Color(.label))
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("📖 Roster")
            .toolbar {
                Button {
                    modal = .add
                } label: {
                    Label("Add Person", systemImage: "plus.circle")
                }
            }
            .sheet(item: $modal, onDismiss: {
                Task {
                    do {
                        try await viewModel.fetchPersons()
                    } catch {
                        print("❌ Error: \(error)")
                    }
                }
            }) { modal in
                switch modal {
                case .add:
                    AddUpdatePerson(viewModel: AddUpdatePersonViewModel())
                case .update(let person):
                    AddUpdatePerson(viewModel:
                                        AddUpdatePersonViewModel(currentPerson: person))
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchPersons()
                    } catch {
                        print("❌ Error: \(error)")
                    }
                }
            }
        }
    }
}

struct PersonList_Previews: PreviewProvider {
    static var previews: some View {
        PersonList()
    }
}
