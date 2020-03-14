//
//  DataDisplayUILabel.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Spring

class DataDisplayUILabel: SpringLabel {
    
    let fontNamePrefix = "SFProText-"

    enum fontType: String {
        case Bold, Medium, Regular, Semibold, Thin, Light
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        labelSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelSetup()
    }
    
    func labelSetup() {
        font = getFont(size: 20, type: .Bold)
        textColor = .white
    }
    
    func setSpringAnimation(type: String, curve: String, duration: CGFloat) {
        animation = type
        self.curve = curve
        self.duration = duration
    }
    
    func setSpringOffset(x: CGFloat, y: CGFloat, scale: CGFloat) {
        self.x = x
        self.y = y
        self.scaleX = scale
        self.scaleY = scale
    }
    
    func springAnimate() {
        self.animate()
    }
    
    func getFont(size: CGFloat, type: fontType) -> UIFont {
        let fontName = fontNamePrefix + type.rawValue
        return UIFont(name: fontName, size: size)!
    }
    
    func setTextSize(to size: CGFloat) {
        font = font.withSize(size)
    }
    
    func setFont(toType type: fontType, toSize size: CGFloat) {
        font = getFont(size: size, type: type)
    }
}
