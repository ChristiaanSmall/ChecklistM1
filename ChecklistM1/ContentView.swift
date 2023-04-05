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
    var abc = 0
    var body: some View {

            NavigationView() {
                VStack {
                    EditView(title: $myTitle)
                List {
                    ForEach(model.tasks.enumerated().map { $0 }, id: \.element) { (index, task) in
                        NavigationLink(destination: ItemView(list: $model, count: index)) {
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
                    .navigationBarItems(trailing: Button("+"){
                        model.tasks.append(AppData(list: "New",listDet: [["Empty List", "circle"]]))
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
