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

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? BloodType else { return false }
        return self.optionDescription() == object.optionDescription()
    }

    var group: String!
    var rhFactor: Bool = false

    init(group: String, rhFactor: Bool) {
        super.init()
        self.group = group
        self.rhFactor = rhFactor
    }

    func optionDescription() -> String {
        return "\(self.group!)\(self.rhFactor ? "+" : "-")"
    }

    func optionViewReusing(_ reusableView: UIView?) -> UIView {
        if let reusableView = reusableView {
            let imageView = reusableView.viewWithTag(1) as! UIImageView
            let textLabel = reusableView.viewWithTag(2) as! UILabel
            imageView.image = UIImage(named: self.optionDescription())
            textLabel.text = self.optionDescription()
            return reusableView
        } else {
            let finalView = UIView()
            let imageView = UIImageView(image: UIImage(named: self.optionDescription()))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tag = 1
            finalView.addSubview(imageView)
            let textLabel = UILabel()
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.tag = 2
            textLabel.text = self.optionDescription()
            finalView.addSubview(textLabel)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: finalView.topAnchor, constant: 8),
                imageView.bottomAnchor.constraint(equalTo: finalView.bottomAnchor, constant: -8),
                imageView.heightAnchor.constraint(equalToConstant: 50),
                imageView.widthAnchor.constraint(equalToConstant: 50),
                imageView.centerYAnchor.constraint(equalTo: finalView.centerYAnchor),
                imageView.leadingAnchor.constraint(equalTo: finalView.leadingAnchor, constant: 16),
                textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
                textLabel.trailingAnchor.constraint(equalTo: finalView.trailingAnchor, constant: 16),
                textLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])

            return finalView
        }
    }

    override var description: String {
        return """
        \(super.description)
        group: \(String(describing: self.group))
        RH Factor: \(String(describing:self.rhFactor))
        """
    }
}
