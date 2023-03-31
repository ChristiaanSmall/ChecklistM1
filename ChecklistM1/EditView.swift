//
//  EditView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 31/3/2023.
//

import SwiftUI

struct EditView: View {
    @Binding var item: String
    @State var displayItem: String = ""
    @Environment(\.editMode) var editMode
    var body: some View {
        VStack {
            if(editMode?.wrappedValue == .active) {
                HStack {
                    Image(systemName: "creditcard.trianglebadge.exclamationmark")
                    TextField("Input:", text: $displayItem)
                    Button("Cancel") {
                        displayItem = item
                    }
                }.onAppear {
                    displayItem = item
                }.onDisappear{
                    item = displayItem
                }
            }
        }
    }
}
