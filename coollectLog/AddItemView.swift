//
//  AddItemView.swift
//  coollectLog
//
//  Created by 吉田健人 on 2026/01/31.
//

import SwiftUI

struct AddItemView: View {
    @Binding var itemsArray: [Item]
    @Binding var isShowAddSheet: Bool
    
    @State var isShowAddAlert: Bool = false
    
    @State var newItem: Item = Item(title:"",category:"",image:"")
    let CATEGORYLIST : [String] = ["コーヒー", "ビール"]
    let ERR_MSG_REQUIRE_TITLE: String = "タイトルを入力してください。"
    enum Categories: String, CaseIterable {
        case coffee
        case beer
        
        var name: String {
            switch self {
                case .coffee: return "コーヒー"
                case .beer: return "ビール"
            }
        }
    }
    
    let defaultcategory: String = "コーヒー"
    @State var selectedCategory = Categories.coffee
    @State var isShowCamera: Bool = false
    @State var captureImage: UIImage? = nil
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationStack {
            VStack{
                Form {
                    TextField("タイトル", text: $newItem.title)
                    Picker("カテゴリー", selection: $selectedCategory) {
                        ForEach(Categories.allCases, id: \.self) { category in
                            Text(category.name)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // カメラボタン
                Button {
                  // カメラ利用チェック
                  if UIImagePickerController.isSourceTypeAvailable(.camera) {
                      print("カメラ利用可能")
                      isShowCamera.toggle()
                    } else {
                      print("カメラ利用不可")
                  }
                } label: {
                  Text("カメラ起動")
                      .frame(maxWidth: .infinity)
                      .frame(height: 50)
                      .multilineTextAlignment(.center)
                      .background(Color.blue)
                      .cornerRadius(10)
                      .foregroundStyle(Color.white)
                }
                .padding()
                .sheet(isPresented: $isShowCamera) { // isPresentedで指定した状態変数がtrueの時実行
                    // UIImagePickerContorollerを表示
                    ImagePickerView(isShowCamera: $isShowCamera, captureImage: $captureImage)
                }
            }
            HStack {
                Button("back") {
                    isShowAddSheet.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .padding()
                .font(Font.largeTitle.bold())
                
                Button("enter") {
                    newItem.category = selectedCategory.name
                    if(newItem.title == "") {
                        isShowAddAlert = true
                    } else {
                      itemsArray.append(newItem)
                      isShowAddSheet.toggle()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .padding()
                .font(Font.largeTitle.bold())
                .alert("Validation Error", isPresented: $isShowAddAlert) {
                    Button("back", role: .cancel) {
                        
                    }
                } message: {
                    Text(ERR_MSG_REQUIRE_TITLE)
                        .font(.largeTitle)
                }
            }
        }
    }
}

//#Preview {
//    AddItemView()
//}
