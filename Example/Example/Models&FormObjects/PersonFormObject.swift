//
// PersonFormObject.swift
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

@objcMembers class PersonFormObject: NSObject, MTZFormObject {
    dynamic var name: String?
    dynamic var cardNumber: String?
    dynamic var expirationDate: Date?
    dynamic var age: Int = 0
    dynamic var employed: Bool = false
    dynamic var date: Date?
    dynamic var blood: BloodType?

    override var description: String {
        return """
        \(super.description)
        name: \(String(describing: self.name))
        card number: \(String(describing:self.cardNumber))
        expiration date: \(String(describing:self.expirationDate))
        employed: \(self.employed)
        date: \(String(describing: self.date))
        age: \(String(describing: self.age))
        blood: \(String(describing: self.blood))
        """
    }
}
