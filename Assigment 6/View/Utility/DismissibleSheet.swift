//
//  DismissableSheet.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 26/05/2023.
//

import SwiftUI

struct DismissibleSheet<Content>: View where Content: View{
    @Environment(\.dismiss) private var dismiss
    var content: () -> Content
    var dismissLabel: String
    var sheetTitle: Binding<String>?
    
    init(dismissLabel: String, title: Binding<String>? = nil, _ content: @escaping () -> Content) {
        self.dismissLabel = dismissLabel
        self.sheetTitle = title
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                content()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text(dismissLabel)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(sheetTitle ?? .constant(""))
        }
    }
}
