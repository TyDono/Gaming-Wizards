import SwiftUI

struct ContentView: View {
    @State private var items = ["Jim", "Jam", "Boom"]
    @State private var selectedItems: [String] = []
    @State private var filter = Filterer()
    @State private var navigationIsTrue: Bool = false

    var body: some View {
        VStack {
            Text("tap to navigate")
                .background(Color.blue)
                .onTapGesture {
                    navigationIsTrue.toggle()
                }
            timvar
            ForEach(items, id: \.self) { item in
                ItemView(item: item, isSelected: self.isSelected(item))
                    .onTapGesture {
                        self.toggleSelection(for: item)
                    }
            }
        }
        .navigationDestination(isPresented: $navigationIsTrue) {
            ManageListOfGamesView()
        }
    }
    
    private var timvar: some View {
        ScrollView{
            FlowLayout(mode: .scrollable,
                       binding: $filter.searchText,
                       items: filter.gamesFilter) { gameItem in
                Text(gameItem.textName)
                    .padding()
                    .onTapGesture {
                        self.toggleSelection(for: gameItem.textName)
                    }
            }
        }
    }
    
    private func isSelected(_ item: String) -> Bool {
        return selectedItems.contains(item)
    }
    
    private func toggleSelection(for item: String) {
        if isSelected(item) {
            selectedItems.removeAll { $0 == item }
        } else {
            selectedItems.append(item)
        }
    }
}

struct ItemView: View {
    let item: String
    let isSelected: Bool

    var body: some View {
        Text(item)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue : Color.gray)
            )
    }
}
