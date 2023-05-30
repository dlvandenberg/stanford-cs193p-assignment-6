//
//  Assigment_6App.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 24/05/2023.
//

import SwiftUI

@main
struct Assigment_6App: App {
    @StateObject var themeStore = ThemeStore(named: "Default")
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
