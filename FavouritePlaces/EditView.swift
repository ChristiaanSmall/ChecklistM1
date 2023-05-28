//
//  EditView.swift
//  FavouritePlaces
//
//  Created by Christiaan Small on 31/3/2023.
//

import SwiftUI
/// EditView is a view that allows the user to edit the title of the list. It includes a TextField for the user to input the new title and a Cancel button to revert changes. When the user updates the title, the new value is saved to the DataModel.
struct EditView: View {
    /// Binding for the title property
    @Binding var title: String
    
    /// State property for the displayItem
    @State var displayItem: String = ""

    /// Environment property for the editMode
    @Environment(\.editMode) var editMode

    var body: some View {
        VStack {
            if(editMode?.wrappedValue == .active) {
                // Show the editable view only when editMode is active
                HStack {
                    Image(systemName: "square.and.pencil") // Pencil icon
                    TextField("Input:", text: $displayItem) // TextField for input
                    Button("Cancel") {
                        // Cancel button to revert changes
                        displayItem = title
                    }
                }
                .onAppear {
                    // Initialize displayItem with the current title when the view appears
                    displayItem = title
                }
                .onDisappear {
                    // Update the title with the edited displayItem when the view disappears
                    title = displayItem
                }
            }
        }
    }
}
