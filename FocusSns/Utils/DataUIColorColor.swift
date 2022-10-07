//
//  DataUIColorColor.swift
//  FocusSns
//
//  Created by Taichi on 2022/02/21.
//

import Foundation
import SwiftUI

// MARK: Data
extension Data {
    static func convertToColor(data: Data) -> Color? {
        if let uiColor = Self.convertToUIColor(data: data) { return Color(uiColor) }
        return nil
    }
    
    func convertToColor() -> Color? {
        if let uiColor = self.convertToUIColor() { return Color(uiColor) }
        return nil
    }
    
    static func convertToUIColor(data :Data) -> UIColor? {
        var uiColor: UIColor?
        do { uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) }
        catch {}
        return uiColor
    }
    
    func convertToUIColor() -> UIColor? {
        var uiColor: UIColor?
        do { uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: self) }
        catch {}
        return uiColor
    }
}

// MARK: UIColor
extension UIColor {
    var color: Color {
        return Color(self)
    }
    
    func convertTodata() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: UIColor.supportsSecureCoding)
    }
}

// MARK: Color
extension Color {
    func convertToData() -> Data? {
        return UIColor(self).convertTodata()
    }
    
    static func convertToData(color: Color) -> Data? {
        return UIColor(color).convertTodata()
    }
}
