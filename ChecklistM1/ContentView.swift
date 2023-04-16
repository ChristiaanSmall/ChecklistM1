//
//  ContentView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI
struct ContentView: View {
    @Binding var model: DataModel
    @State var myTitle = "MyList"
    
    var body: some View {
        NavigationView() {
            VStack {
                EditView(title: $myTitle)
                
                List {
                    ForEach(model.tasks.indices, id: \.self) { index in
                        NavigationLink(destination: ItemView(list: $model, count: index)) {
                            Text(model.tasks[index].list)
                        }
                    }
                    .onDelete { idx in
                        model.tasks.remove(atOffsets: idx)
                        model.save()
                    }
                    .onMove { source, destination in
                        model.tasks.move(fromOffsets: source, toOffset: destination)
                        model.save()
                    }
                }
                .navigationTitle(myTitle)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button("+"){
                        model.tasks.append(AppData(list: "New",listDet: [["Empty List", "circle"]]))
                        model.save()
                    }
                )
            }
        }
        .padding()
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

struct listView: View {
    var item:[String]
    var body: some View {
        HStack {
            Text(item[0])
            Spacer()
            Image(systemName: item[1])
            
        }
    }
}
