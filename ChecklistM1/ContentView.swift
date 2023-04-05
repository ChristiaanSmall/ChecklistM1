//
//  ContentView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI
struct ContentView: View {
    @Binding var model: DataModel
    @State var myTitle = "My List"
    var body: some View {

            NavigationView() {
                VStack {
                EditView(title: $myTitle )
                List {
                    ForEach($model.tasks, id: \.self) {
                        $task in

                        NavigationLink(destination: ItemView(list: $task)) {
                            Text(task.list)
                        }
                        
                        //Text(task.list)

                       // Spacer()
                        
                    }.onDelete { idx in
                        model.tasks.remove(atOffsets: idx)
                        model.save()
                    }.onMove { idx, i in
                        model.tasks.move(fromOffsets: idx, toOffset: i)
                        model.save()
                    }
                    //                ForEach(tasks, id:\.self){
                    //                    task in
                    //                    listView(item: task)
                    //                }
                    
                }.navigationTitle(myTitle)
                    .navigationBarItems(leading: EditButton(),
                                        trailing: Button("+"){
                        model.tasks.append(AppData(list: "New",listDet: [["Empty List", "checkmark.circle.fill"]]))
                        model.save()
                    })
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
