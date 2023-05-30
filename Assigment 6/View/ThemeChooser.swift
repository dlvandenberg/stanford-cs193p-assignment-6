//
//  ThemeChooser.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 25/05/2023.
//

import SwiftUI

struct ThemeChooser: View {
    typealias ThemeId = Int
    @EnvironmentObject var themeStore: ThemeStore
    @State private var editingTheme: EmojiTheme? = nil
    @State private var editMode: EditMode = .inactive
    @State private var themeGames = Dictionary<ThemeId, EmojiMemoryGame>()
    
    var body: some View {
        NavigationStack {
            List {
                themeList
            }
            .navigationTitle(Text("Memorize"))
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        themeStore.insertTheme(named: "New")
                        editingTheme = themeStore.theme(at: 0)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: themeStore.themes) { updatedThemes in
                updateGames(to: updatedThemes)
            }
        }
    }
    
    var themeList: some View {
        ForEach(themeStore.themes.filter { $0.emojis.count >= 2 }) { theme in
            if $editMode.wrappedValue.isEditing {
                listItem(for: theme)
                    .onTapGesture {
                        editingTheme = theme
                    }
            } else {
                NavigationLink(destination: MemorizeView(game: getGame(for: theme))) {
                    listItem(for: theme)
                }
            }
        }
        .onDelete { indexSet in
            themeStore.themes.remove(atOffsets: indexSet)
        }
        .onMove { indexSet, offset in
            themeStore.themes.move(fromOffsets: indexSet, toOffset: offset)
        }
        .sheet(item: $editingTheme) {
            print("Cleaning up invalid themes if any")
            themeStore.themes.removeAll(where: { $0.emojis.count < 2})
        } content: { item in
            let theme = $themeStore.themes[item]
            DismissibleSheet(dismissLabel: "Done", title: theme.name) {
                ThemeEditor(theme: theme)
            }
        }
    }
    
    private func getGame(for theme: EmojiTheme) -> EmojiMemoryGame {
        if let game = themeGames[theme.id] {
            game.theme = theme
            return game
        } else {
            let game = EmojiMemoryGame(with: theme)
            DispatchQueue.global(qos: .userInteractive).async {
                themeGames.updateValue(game, forKey: theme.id)
            }
            return game
        }
    }
    
    private func updateGames(to themes: [EmojiTheme]) {
        themeStore.themes.filter { $0.emojis.count >= 2 }.forEach { theme in
            if !themes.contains(theme) {
                themeStore.themes.remove(matching: theme)
            }
        }
    }
    
    func listItem(for theme: EmojiTheme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundColor(theme.color)
                .font(.title3)
            Text(themeDescription(pairs: theme.pairs, emojis: theme.emojis))
                .font(.caption)
        }
    }
    
    private func themeDescription(pairs: Int, emojis: String) -> String {
        pairs == emojis.count ? "All of \(emojis)" : "\(pairs) pairs from \(emojis)"
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser()
            .environmentObject(ThemeStore(named: "Preview"))
    }
}
