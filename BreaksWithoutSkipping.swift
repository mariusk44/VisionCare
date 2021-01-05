//
//  BreaksWithoutSkipping.swift
//  VisionCare
//
//  Created by Marius Kirsnauskas on 2020-05-05.
//  Copyright © 2020 Marius Kirsnauskas. All rights reserved.
//

import Foundation

class BreaksWithoutSkipping {
    private let defaults: UserDefaults
    private let defaultsKey = "BreaksWithoutSkipping"
    var count: Int {
        return defaults.integer(forKey: defaultsKey) - 1
    }
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    func reset() {
        defaults.set(0, forKey: defaultsKey)
    }
    func increase() {
        let value = defaults.integer(forKey: defaultsKey) + 1
        defaults.set(value, forKey: defaultsKey)
    }
}
