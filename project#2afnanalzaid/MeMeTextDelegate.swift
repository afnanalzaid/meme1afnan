//
//  MeMeTextDelegate.swift
//  project#2afnanalzaid
//
//  Created by afnan abdullah on 10/03/1440 AH.
//  Copyright © 1440 afnan abdullah. All rights reserved.
//


import Foundation
import UIKit

class MeMeTextDelegate: NSObject, UITextFieldDelegate {
    
    var DefaultText: Bool = true
    
    
    func TextBeginEditing(Text: UITextField) {
        if DefaultText {
            Text.text = ""
            DefaultText = false
        }
    }
    
    func TextReturn(Text: UITextField) -> Bool {
        print("afnan")
        Text.resignFirstResponder()
        return true
    }
    
    func TextBeginEditing(Text: UITextField) -> Bool {
        return true
    }
    
  
    
}
