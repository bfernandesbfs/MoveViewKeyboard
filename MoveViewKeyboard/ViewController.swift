//
//  ViewController.swift
//  MoveViewKeyboard
//
//  Created by Bruno Fernandes on 20/09/16.
//  Copyright © 2016 BFS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var layoutBottonTextField: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    @IBAction func sendButtonPressed(sender: UIButton) {
        textField.resignFirstResponder()
    }
}


extension ViewController: Keyboardable {
    
    var layoutConstraintsForKeyboard: [NSLayoutConstraint] {
        return [layoutBottonTextField]
    }
    
    var addValueForKeyboard: CGFloat {
        return 0
    }
}
