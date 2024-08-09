//
//  Classes.swift
//  Seguridad Veintiseis
//
//  Created by Andres Moreno on 11/22/19.
//  Copyright © 2019 uc-web. All rights reserved.
//

import Foundation
import UIKit

public class CircleView: UIView {
    var id = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
        //clipsToBounds = true
        var shortestSide: CGFloat = 0.0
        if layer.frame.width < layer.frame.height {
            shortestSide = layer.frame.width
        }else{
            shortestSide = layer.frame.height
        }
        layer.cornerRadius =  shortestSide/2.0
    }
}


public class CircleButton: UIButton {
    var id = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
        var shortestSide: CGFloat = 0.0
        if layer.frame.width < layer.frame.height {
            shortestSide = layer.frame.width
        }else{
            shortestSide = layer.frame.height
        }
        layer.cornerRadius =  shortestSide/2.0
    }
}

public class AppButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
        layer.cornerRadius = 2.0
    }
}

public class CircleImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
        var shortestSide: CGFloat = 0.0
        if layer.frame.width < layer.frame.height {
            shortestSide = layer.frame.width
        }else{
            shortestSide = layer.frame.height
        }
        layer.cornerRadius =  shortestSide/2.0
    }
}

public class OvalView: UIView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutOvalMask()
    }

    private func layoutOvalMask() {
        let mask = self.shapeMaskLayer()
        let bounds = self.bounds
        if mask.frame != bounds {
            mask.frame = bounds
            mask.path = CGPath(ellipseIn: bounds, transform: nil)
        }
    }

    private func shapeMaskLayer() -> CAShapeLayer {
        if let layer = self.layer.mask as? CAShapeLayer {
            return layer
        }
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.black.cgColor
        self.layer.mask = layer
        return layer
    }

}


public class CardView: UIView {
    var id = 0
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
        clipsToBounds = true
        layer.cornerRadius =  8.0
        
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
    }
}
