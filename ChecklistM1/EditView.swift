//
//  EditView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 31/3/2023.
//

import SwiftUI

struct EditView: View {
    @Binding var title: String // Binding for the title property
    @State var displayItem: String = "" // State property for the displayItem

    @Environment(\.editMode) var editMode // Environment property for the editMode

    var body: some View {
        VStack {
            if(editMode?.wrappedValue == .active) { // Show the editable view only when editMode is active
                HStack {
                    Image(systemName: "square.and.pencil") // Pencil icon
                    TextField("Input:", text: $displayItem) // TextField for input
                    Button("Cancel") { // Cancel button to revert changes
                        displayItem = title
                    }
                }
                .onAppear {
                    displayItem = title // Initialize displayItem with the current title when the view appears
                }
                .onDisappear {
                    title = displayItem // Update the title with the edited displayItem when the view disappears
                }
            }
        }
    }
}
