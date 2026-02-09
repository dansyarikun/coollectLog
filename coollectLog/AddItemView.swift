import SwiftUI
import PhotosUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var selectedCategory: Category = .coffee
    @State private var selectedImage: UIImage? = nil

    @State private var photosPickerItem: PhotosPickerItem? = nil
    @State private var isShowCamera: Bool = false
    @State private var isShowAlert: Bool = false

    enum Category: String, CaseIterable {
        case coffee
        case beer

        var displayName: String {
            switch self {
            case .coffee: return "コーヒー"
            case .beer: return "ビール"
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("タイトル") {
                    TextField("タイトルを入力", text: $title)
                }

                Section("カテゴリ") {
                    Picker("カテゴリ", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("画像") {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    PhotosPicker(
                        selection: $photosPickerItem,
                        matching: .images
                    ) {
                        Label("フォトライブラリから選択", systemImage: "photo.on.rectangle")
                    }

                    Button {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            isShowCamera = true
                        }
                    } label: {
                        Label("カメラで撮影", systemImage: "camera")
                    }

                    if selectedImage != nil {
                        Button(role: .destructive) {
                            selectedImage = nil
                            photosPickerItem = nil
                        } label: {
                            Label("画像を削除", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("アイテム追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveItem()
                    }
                }
            }
            .alert("入力エラー", isPresented: $isShowAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("タイトルを入力してください。")
            }
            .sheet(isPresented: $isShowCamera) {
                ImagePickerView(captureImage: $selectedImage)
            }
            .onChange(of: photosPickerItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }

    private func saveItem() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            isShowAlert = true
            return
        }

        var imagePath: String? = nil
        if let image = selectedImage {
            imagePath = ImageStore.save(image)
        }

        let newItem = Item(
            title: trimmedTitle,
            category: selectedCategory.displayName,
            imagePath: imagePath
        )
        modelContext.insert(newItem)

        dismiss()
    }
}
