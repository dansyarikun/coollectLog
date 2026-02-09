import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]
    @State private var isShowAddSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    isShowAddSheet = true
                } label: {
                    Text("ADD ITEM")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top)

                if items.isEmpty {
                    Spacer()
                    Text("アイテムがありません")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(items) { item in
                            ItemRowView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("coollectLog")
            .sheet(isPresented: $isShowAddSheet) {
                AddItemView()
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            if let imagePath = item.imagePath {
                ImageStore.delete(relativePath: imagePath)
            }
            modelContext.delete(item)
        }
    }
}

struct ItemRowView: View {
    let item: Item

    var body: some View {
        HStack(spacing: 12) {
            if let path = item.imagePath, let uiImage = ImageStore.load(relativePath: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                categoryIcon(for: item.category)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    private func categoryIcon(for category: String) -> Image {
        switch category {
        case "ビール": return Image(.beerIcon)
        case "コーヒー": return Image(.coffeeIcon)
        default: return Image(systemName: "questionmark.circle")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
