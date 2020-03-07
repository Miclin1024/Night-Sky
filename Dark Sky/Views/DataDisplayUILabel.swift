//
//  DataDisplayUILabel.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class DataDisplayUILabel: UILabel {
    
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
        self.font = getFont(size: 20, type: .Bold)
        self.textColor = .white
    }
    
    func getFont(size: CGFloat, type: fontType) -> UIFont {
        let fontName = fontNamePrefix + type.rawValue
        return UIFont(name: fontName, size: size)!
    }
    
    func setTextSize(to size: CGFloat) {
        self.font = self.font.withSize(size)
    }
    
    func setFont(toType type: fontType, toSize size: CGFloat) {
        self.font = getFont(size: size, type: type)
    }
}
