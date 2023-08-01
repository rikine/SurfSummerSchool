//
//  Array.swift
//  SurfSummerSchool
//
//  Created by Никита Шестаков on 01.08.2023.
//

import Foundation

extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func remove(item: Element) -> Element? {
        guard let index = firstIndex(of: item) else { return nil }
        return remove(at: index)
    }
}
