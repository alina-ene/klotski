//
//  String+Subscripts.swift
//  Klotski
//
//  Created by Alina Ene on 04/05/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import Foundation

extension String {
    
    subscript(idx: Int) -> String {
        guard let strIdx = index(startIndex, offsetBy: idx, limitedBy: endIndex)
            else { fatalError("String index out of bounds") }
        return "\(self[strIdx])"
    }
    
    func replaceString(at index: Int, with newChar: Character) -> String {
        var modifiedString = ""
        for (i, char) in self.enumerated() {
            modifiedString += String((i == index) ? newChar : char)
        }
        return modifiedString
    }
    
}
