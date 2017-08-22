//
// ViewController.swift
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

@objcMembers class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableViewManager: MTZTableManager!
    dynamic var formObject: PersonFormObject!

    var dateRow: MTZTableFormDateRow! // required for KVO.
    var bloodRow: MTZTableFormRow!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInsetAdjustmentBehavior = .never

        formObject = PersonFormObject()

        let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
        let switchCellNib = UINib(nibName: "SwitchCell", bundle: nil)

        let nameModel = TextFieldCellModel()
        nameModel.placeholderText = "Name"
        let nameRow = MTZTableFormRow(nib: textFieldCellNib, formObject: formObject, keyPath: #keyPath(PersonFormObject.name), model: nameModel)
        nameRow.validators = [NameValidator(errorMessage: "Name must have between 4 and 20 characters.")]

        let cardNumberModel = TextFieldCellModel()
        cardNumberModel.placeholderText = "Card Number"
        cardNumberModel.keyboardType = .numberPad
        let cardNumberRow = MTZTableFormRow(nib: textFieldCellNib, formObject: formObject, keyPath: #keyPath(PersonFormObject.cardNumber), model: cardNumberModel)
        cardNumberRow.masker = CardNumberMasker()

        let expirationDateModel = TextFieldCellModel()
        expirationDateModel.placeholderText = "Expiration date"
        let expirationDateRow = MTZTableFormDateRow(nib: textFieldCellNib, formObject: formObject, keyPath: #keyPath(PersonFormObject.expirationDate), model: expirationDateModel)
        expirationDateRow.datePickerMode = .expirationDate

        let employedModel = SwitchCellModel()
        employedModel.descriptionText = "Employed"
        let employedRow = MTZTableFormRow(nib: switchCellNib, formObject: formObject, keyPath: #keyPath(PersonFormObject.employed), model: employedModel)

        let dateModel = TextFieldCellModel()
        dateModel.placeholderText = "Employment Date"
        dateRow = MTZTableFormDateRow(nib: textFieldCellNib, formObject: formObject, keyPath: #keyPath(PersonFormObject.date), model: dateModel)
        dateRow.minimumDate = Date()
        dateRow.maximumDate = Date().addingTimeInterval(60 * 60 * 24 * 30)
        dateRow.datePickerMode = .date
        dateRow.hidden = true

        let ageModel = TextFieldCellModel()
        ageModel.placeholderText = "Age"
        ageModel.keyboardType = .numberPad
        let ageRow = MTZTableFormRow(nib: textFieldCellNib, formObject: formObject, keyPath: #keyPath(PersonFormObject.age), model: ageModel)
        ageRow.converter = AgeConverter()

        let bloodModel = TextFieldCellModel()
        bloodModel.placeholderText = "Blood Type"
        bloodRow = MTZTableFormRow(nib: textFieldCellNib, formObject: formObject, keyPath: #keyPath(PersonFormObject.blood), model: bloodModel)
        bloodRow.validators = [NonNilValidator(errorMessage: "Blood type must be selected")]
        bloodRow.availableOptions = BloodType.allBloodTypes
        bloodRow.hidden = true

        let formSection = MTZTableSection(tableRows: [nameRow, cardNumberRow, expirationDateRow, employedRow, dateRow, ageRow, bloodRow])
        formSection.headerText = "Person form"
        formSection.footerText = "By filling this form you agree with the terms."
        
        let validateModel = ActionCellModel()
        validateModel.actionTitle = "Validate"
        let validateRow = MTZTableRow(clazz: ActionCell.self, model: validateModel) { [unowned self] (_, _) in
            self.validateForm(nil)
        }
        let resultsModel = ActionCellModel()
        resultsModel.actionTitle = "View Results"
        let resultsRow = MTZTableRow(clazz: ActionCell.self, model: resultsModel) { [unowned self] (_, _) in
            self.viewResult(nil)
        }
        
        let infoNib = UINib(nibName: "InformationCell", bundle: nil)
        let infoModel = InformationCellModel()
        infoModel.informationHeader = "What is this?"
        infoModel.informationBody = "This is a sample app to demonstrate the capabilities of MTZTableManager. It allows you to build table views descriptively and add powerful form capabilities such as the ones seen above. You can also dynamically add and remove rows (play with the 'Employed' toggle) and dynamically change cell height (like this row)."
        let infoRow = MTZTableRow(nib: infoNib, model: infoModel)
        infoRow.regularHeight = 44
        infoRow.expandedHeight = UITableViewAutomaticDimension
        let infoSection = MTZTableSection(tableRows: [infoRow])
        
        let actionsSection = MTZTableSection(tableRows: [validateRow, resultsRow])

        let tableData = MTZTableData(tableSections: [formSection, infoSection, actionsSection])

        tableViewManager = MTZTableManager(tableView: tableView, tableData: tableData, context: self)
        tableViewManager.register(AlertCommand(message: "This command was registered"))

        // After setting tableViewManager, as `.initial` trigger the hidden flag immediately.
        addObserver(self, forKeyPath: #keyPath(ViewController.formObject.employed), options: [.initial, .new], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(ViewController.formObject.employed) {
            dateRow.hidden = !((change?[.newKey] as? Bool) ?? false)
            bloodRow.hidden = dateRow.hidden
        }
    }

    @IBAction func validateForm(_ sender: UIButton?) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        do {
            try tableViewManager!.validate()
            feedbackGenerator.notificationOccurred(.success)
        } catch {
            let error = error as NSError
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                (error.userInfo[MTZFormFieldKey] as? (UIControl & MTZFormField))?.becomeFirstResponder()
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func viewResult(_ sender: UIBarButtonItem?) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Result", message: self.formObject.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

