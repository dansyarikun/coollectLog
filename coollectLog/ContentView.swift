//
//  ContentView.swift
//  coollectLog
//
//  Created by 吉田健人 on 2026/01/31.
//

import SwiftUI

struct ContentView: View {
  let INITTEXT = "Hello, coollectLog App!"
  let NOTFOUNDTEXT = "No items found."
  let defaultItem = Item(title: "スターバックスのモカ", category: "コーヒー", image: "image")
  @State var itemsArray: [Item] = []
  let titleLiteral = "Title"
  @State var captureImage: UIImage? = nil //撮影した写真を保持する状態変数
  @State var isShowSheet = false // 撮影画面(Sheet)の開閉状態を管理する状態変数
  @State var isShowAddSheet = false // item追加画面の表示を管理する状態変数
  var body: some View {
    NavigationStack {
      VStack {
        Spacer()
        Text(INITTEXT).font(.largeTitle)
        .padding()
          HStack {
              Image(.coffeeIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
              Image(.beerIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 80)
          }
        
        if !itemsArray.isEmpty {
          ForEach(Array(itemsArray.enumerated()), id: \.offset) { pair in
            let item = pair.element
            HStack {
              Text(item.title)
              Text(item.category)
              Text(item.image)
            }
            .font(Font.largeTitle.bold())
          }
        } else {
            Text(NOTFOUNDTEXT)
            .font(.largeTitle)
            .padding()
        }
        Button {
          print("Console: + new item pushed!!!!!!")
//          itemsArray.append(defaultItem)
          isShowAddSheet.toggle()
        } label: {
          Text("+ New Item")
        }
        .padding()
        .background(Color.blue)
        .foregroundStyle(.white)
        .cornerRadius(10)
        .padding()
        .font(Font.largeTitle.bold())
        .sheet(isPresented: $isShowAddSheet){
            AddItemView(itemsArray: $itemsArray,isShowAddSheet: $isShowAddSheet)
        }
        
        Button("DELETE ALL ITEMS") {
          itemsArray.removeAll(keepingCapacity: false)
        }
        .padding()
        .background(Color.red)
        .foregroundStyle(.white)
        .cornerRadius(10)
        .padding()
        .font(Font.largeTitle.bold())
        
        Spacer()
        
      }
    }
  }
}

#Preview {
    ContentView()
}
