//
// BloodTypeConverter.swift
// MTZTableManager
//
// Copyright (c) 2017 Mauricio Tremea Zaquia (@mtzaquia)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit
import MTZTableViewManager

class BloodTypeConverter: MTZFormConverter {
    override func fromFieldValue(_ fieldValue: Any) -> Any? {
        let fieldValue = fieldValue as? String ?? ""
        if fieldValue.count < 2 {
            return nil
        }

        if (fieldValue.count == 3) {
            return BloodType(group: String(fieldValue.characters[fieldValue.startIndex])+String(fieldValue.characters[fieldValue.characters.index(fieldValue.characters.startIndex, offsetBy: 1)]), rhFactor: fieldValue.characters[fieldValue.characters.index(fieldValue.characters.startIndex, offsetBy: 2)] == "+" ? true : false)
        }

        return BloodType(group: String(fieldValue.characters[fieldValue.startIndex]), rhFactor: fieldValue.characters[fieldValue.characters.index(fieldValue.characters.startIndex, offsetBy: 1)] == "+" ? true : false)
    }

    override func toFieldValue(_ complexValue: Any) -> Any? {
        if let complexValue = complexValue as? BloodType {
            return "\(complexValue.group!)\(complexValue.rhFactor ? "+" : "-")"
        }

        return nil
    }
}
