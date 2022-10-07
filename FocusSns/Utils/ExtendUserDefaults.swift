//
//  ExtendUserDefaults.swift
//  FocusSns
//
//  Created by Taichi on 2022/02/21.
//

import Foundation

extension UserDefaults {
    func setEnum<T: RawRepresentable>(_ value: T?, forKey key: String) where T.RawValue == String {
        if let value = value {
            set(value.rawValue, forKey: key)
        } else {
            removeObject(forKey: key)
        }
    }

    func getEnum<T: RawRepresentable>(forKey key: String) -> T? where T.RawValue == String {
        if let string = string(forKey: key) {
            return T(rawValue: string)
        }
        return nil
    }
}
