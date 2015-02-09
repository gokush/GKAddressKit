//
//  AddressEditCell.swift
//  bajibaji
//
//  Created by 童小波 on 15/2/4.
//  Copyright (c) 2015年 bajibaji. All rights reserved.
//

import UIKit

class AddressEditCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var valueLabel: UILabel!
    var delegate: AddressEditCellDelegate?
    var allowEdit: Bool = true{
        didSet{
            if allowEdit{
                valueTextField.hidden = false
                valueLabel.hidden = true
            }
            else{
                valueTextField.hidden = true
                valueLabel.hidden = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: "didTap:")
        valueLabel.addGestureRecognizer(tap)
        valueLabel.userInteractionEnabled = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func didTap(sender: UITapGestureRecognizer){
        self.delegate?.addressEditCellDidBeginEditing?(valueTextField, indexPath: indexPath())
    }
    
    func indexPath() -> NSIndexPath{
        let tableView = self.superview?.superview as UITableView
        return tableView.indexPathForCell(self)!
    }
    
    @IBAction func textFieldBeginEditing(sender: AnyObject) {
        self.delegate?.addressEditCellDidBeginEditing?(valueTextField, indexPath: indexPath())
    }
    
    @IBAction func textFieldEndEditing(sender: AnyObject) {
        self.delegate?.addressEditCellDidEndEditing?(valueTextField.text, indexPath: indexPath())
    }
   
}

@objc protocol AddressEditCellDelegate{
    optional func addressEditCellDidEndEditing(text: String, indexPath: NSIndexPath)
    optional func addressEditCellDidBeginEditing(textField: UITextField, indexPath: NSIndexPath)
}
