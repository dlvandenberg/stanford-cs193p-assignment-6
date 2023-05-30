//
//  ThemeEditor.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 25/05/2023.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: EmojiTheme
    @State var emojisToAdd = ""
    
    var body: some View {
        Form {
            nameSection
            emojisSection
            addEmojisSection
            cardCountSection()
            colorSection
        }
    }
    
    var nameSection: some View {
        Section("Theme name") {
            TextField("Name", text: $theme.name)
        }
    }
    
    var emojisSection: some View {
        Section(content: {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.emojiSize))]) {
                ForEach(theme.emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: Constants.emojiSize))
        }, header: {
            HStack {
                Text("Emojis")
                Spacer()
                Text("Tap to remove")
            }
        })
    }
    
    var addEmojisSection: some View {
        Section("Add emoji") {
            TextField("Emoji", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    withAnimation {
                        addEmojis(emojis)
                    }
                }
        }
    }
    
    private func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    @ViewBuilder
    func cardCountSection() -> some View {
        Section("Card count") {
            let validEmojiCount = theme.emojis.count >= Constants.minimumPairs
            let range = validEmojiCount ? Constants.minimumPairs...theme.emojis.count : Constants.minimumPairs...Constants.minimumPairs
            
            Stepper(value: $theme.pairs, in: range, step: 1) {
                Text("\(theme.pairs) Pairs")
                    .disabled(!validEmojiCount)
            }
        }
    }
    
    var colorSection: some View {
        Section("Color") {
            ColorPicker("Theme Color", selection: $theme.color)
        }
    }
}

fileprivate struct Constants {
    static let emojiSize: CGFloat = 30
    static let minimumPairs: Int = 2
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(EmojiTheme(id: 0, name: "Preview", color: Color(.sRGB, red: 0.8, green: 0, blue: 0.4), pairs: 10, emojis: "😀😃😄😁😇🥹😅😂🤣")))
    }
}
