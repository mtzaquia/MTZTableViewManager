//
// BloodType.swift
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

@objcMembers class BloodType: NSObject, MTZFormOption {

    class var allBloodTypes: [BloodType] {
        return [
            BloodType(group: "O", rhFactor: true),
            BloodType(group: "O", rhFactor: false),
            BloodType(group: "A", rhFactor: true),
            BloodType(group: "A", rhFactor: false),
            BloodType(group: "B", rhFactor: true),
            BloodType(group: "B", rhFactor: false),
            BloodType(group: "AB", rhFactor: true),
            BloodType(group: "AB", rhFactor: false)
        ]
    }

    var group: String!
    var rhFactor: Bool = false

    init(group: String, rhFactor: Bool) {
        super.init()
        self.group = group
        self.rhFactor = rhFactor
    }

    func optionDescription() -> String {
        return BloodTypeConverter().toFieldValue(self) as! String
    }

    override var description: String {
        return """
        \(super.description)
        group: \(String(describing: self.group))
        RH Factor: \(String(describing:self.rhFactor))
        """
    }
}
