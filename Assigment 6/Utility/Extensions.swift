//
//  Extensions.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 24/05/2023.
//

import Foundation

extension Array where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
    
    var oneAndOnly: Element? {
        count == 1 ? first : nil
    }
}

extension Array where Iterator.Element: Identifiable {
    mutating func remove(matching element: Element) {
        if let index = index(matching: element) {
            remove(at: index)
        }
    }
}

// MARK: Collection.index(matching:)
extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Index? {
        firstIndex(where: { $0.id == element.id })
    }
    
    
}

// MARK: RangeReplaceableCollection subscript
extension RangeReplaceableCollection where Element: Identifiable {
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(matching: element) {
                return self[index]
            } else {
                return element
            }
        }
        set {
            if let index = index(matching: element) {
                replaceSubrange(index...index, with: [newValue])
            }
        }
    }
}

// MARK: String.removingDuplicateCharacters
extension String {
    var removingDuplicateCharacters: String {
        reduce(into: "") { seen, character in
            if !seen.contains(character) {
                seen.append(character)
            }
        }
    }
}

extension String.Element {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}
