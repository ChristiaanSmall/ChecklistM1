//
//  ContentView.swift
//  ChecklistM1
//
//  Created by Christiaan Small on 23/3/2023.
//

import SwiftUI
var tasks = [["Do workshop", "checkmark.circle.fill"], ["Workout Arms", "xmark.circle.fill"], ["Buy Food", "xmark.circle.fill"], ["Feed Dogs", "checkmark.circle.fill"]]
struct ContentView: View {
    var body: some View {
        NavigationView() {
            List {
                ForEach(tasks, id:\.self){
                    task in
                    listView(item: task)
                }
            }.navigationTitle("Work List:")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
