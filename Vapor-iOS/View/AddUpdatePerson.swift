//
//  AddUpdatePerson.swift
//  Vapor-App
//
//  Created by Ruitong Su on 12/31/22.
//

import SwiftUI

struct AddUpdatePerson: View {

    @ObservedObject var viewModel: AddUpdatePersonViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("name", text: $viewModel.personName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button {
                // add or Update
                viewModel.addUpdateAction {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text(viewModel.buttonTitle)
            }
        }
    }
}
