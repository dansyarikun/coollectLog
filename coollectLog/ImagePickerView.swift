//
//  ImagePickerView.swift
//  coollectLog
//
//  Created by 吉田健人 on 2026/02/01.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isShowCamera: Bool
    @Binding var captureImage: UIImage?
    
    // Coordinateorでコントローラのdelegateを管理
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        //撮影が終わった時によばれるdelegateメソッド
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            //撮影した写真をcaptureImageに保存
            if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originImage
            }
            
            //sheetを閉じる
            parent.isShowCamera.toggle()
        }
        
        //キャンセルボタンが選択された時に呼ばれるdelegateメソッド
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowCamera.toggle()
        }
    }
    
    // Coordinator生成
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Viewを生成するときに実行
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let myImagePickerController = UIImagePickerController()
        myImagePickerController.sourceType = .camera
        myImagePickerController.cameraDevice = .rear
        // delegate通知を依頼するクラスCoordinator
        myImagePickerController.delegate = context.coordinator
        return myImagePickerController
    }
    
    // View更新時に実行
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // 今回はなし
    }
}
