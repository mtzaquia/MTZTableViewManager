//
// ActionCell.swift
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

class ActionCell: UITableViewCell, MTZModelDisplaying {
    
    var labelActionTitle: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        labelActionTitle = UILabel()
        labelActionTitle.translatesAutoresizingMaskIntoConstraints = false
        labelActionTitle.textColor = UIApplication.shared.keyWindow?.rootViewController?.view.tintColor
        labelActionTitle.textAlignment = .center
        labelActionTitle.numberOfLines = 0
        
        self.contentView.addSubview(labelActionTitle)
        
        let bottomConstraint = labelActionTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            labelActionTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            labelActionTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            labelActionTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            labelActionTitle.heightAnchor.constraint(equalToConstant: 44),
            bottomConstraint
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: MTZModel?) {
        let model = model as? ActionCellModel
        labelActionTitle.text = model?.actionTitle
    }
}
