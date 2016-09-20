//
//  Keyboardable.swift
//  MoveViewKeyboard
//
//  Created by Bruno Fernandes on 20/09/16.
//  Copyright © 2016 BFS. All rights reserved.
//

import UIKit

public typealias KeyboardHeightDuration = (height: CGFloat, duration: Double)

public protocol Keyboardable {
    var layoutConstraintsForKeyboard: [NSLayoutConstraint] { get }
    var addValueForKeyboard: CGFloat { get }
    func addKeyboardObservers()
    func removeKeyboardObservers()
    
}

extension Keyboardable where Self: UIViewController {
    
    public func addKeyboardObservers() {
        NSNotificationCenter
            .defaultCenter()
            .addObserverForName(UIKeyboardWillShowNotification,
                                object: nil,
                                queue: nil) { [weak self] notification in
                                    
                                    self?.keyboardWillShow(notification)
        }
        
        NSNotificationCenter
            .defaultCenter()
            .addObserverForName(UIKeyboardWillHideNotification,
                                object: nil,
                                queue: nil) { [weak self] notification in
                                    
                                    self?.keyboardWillHide(notification)
        }
    }
    
    public func removeKeyboardObservers() {
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self,
                            name: UIKeyboardWillShowNotification,
                            object: nil)
        
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self,
                            name: UIKeyboardWillHideNotification,
                            object: nil)
    }
    
    private func keyboardWillShow(notification: NSNotification) {
        guard var info = getKeyboardInfo(notification) else { return }
        
        if let tabBarHeight = tabBarController?.tabBar.frame.height {
            info.height -= tabBarHeight
        }
        
        animateConstraints(info.height + addValueForKeyboard, duration: info.duration)
    }
    
    private func keyboardWillHide(notification: NSNotification) {
        guard let info = getKeyboardInfo(notification) else { return }
        
        animateConstraints(0, duration: info.duration)
    }
    
    private func getKeyboardInfo(notification: NSNotification) -> KeyboardHeightDuration? {
        guard let userInfo = notification.userInfo else { return nil }
        guard let rect = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() else { return nil }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return nil }
        
        return (rect.height, duration)
    }
    
    private func animateConstraints(constant: CGFloat, duration: Double) {
        layoutConstraintsForKeyboard.forEach { c in
            c.constant = constant
        }
        
        UIView.animateWithDuration(duration) {
            self.view.layoutIfNeeded()
        }
    }
}
