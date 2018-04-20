//
//  CustomButton.swift
//  Twitch
//
//  Created by Vinicius Ricci on 20/04/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit


public class CustomButton: UIButton {
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        
        didSet {
            
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = (self.cornerRadius > 0)
        }
        
    }
}
