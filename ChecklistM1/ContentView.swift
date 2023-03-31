//
//  ContentView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI
var tasks = [["Do workshop", "checkmark.circle.fill"], ["Workout Arms", "xmark.circle.fill"], ["Buy Food", "xmark.circle.fill"], ["Feed Dogs", "checkmark.circle.fill"]]
struct ContentView: View {
    @Binding var model: DataModel
    var body: some View {

        NavigationView() {
            
            List {
                ForEach(model.tasks, id: \.self) {
                    task in
                    HStack{
                        Text(task.item)
                        Spacer()
                        Image(systemName: task.status)
                    }
                }
                //                ForEach(tasks, id:\.self){
                //                    task in
                //                    listView(item: task)
                //                }
                
            }.navigationTitle("Work List:")
                .navigationBarItems(leading: EditButton(),
                                    trailing: Button("+"){
                    model.tasks.append(AppData(item:"New Task", status: "checkmark.circle.fill"))
                })
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
