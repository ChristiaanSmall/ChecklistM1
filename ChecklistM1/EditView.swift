//
//  EditView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 31/3/2023.
//


import SwiftUI

struct EditView: View {
    @Binding var title: String
    @State var displayItem: String = ""
    @Environment(\.editMode) var editMode
    var body: some View {
        VStack {
            if(editMode?.wrappedValue == .active) {
                HStack {
                    Image(systemName: "square.and.pencil")
                    TextField("Input:", text: $displayItem)
                    Button("Cancel") {
                        displayItem = title
                    }
                }.onAppear {
                    displayItem = title
                }.onDisappear{
                    title = displayItem
                }
            }
        }
    }
}
