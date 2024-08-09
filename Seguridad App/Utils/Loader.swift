//
//  Loader.swift
//
//  Created by Andrés Moreno on 17/09/18.
//  Copyright © 2018 uc-web. All rights reserved.
//

import Foundation
import UIKit

public class Loader {
    
    // Ojo: Si existe una barra superior (top bar) sin transparencia, el espacio podria estar reservado y separado del View principal
    
    static var currentOverlay : UIView?
    static var imageView = UIImageView(image: UIImage(named: "ic_loader")) // Imagen central
    
    static var text = ""
    
    
    static func start(_ overlayTarget : UIView, image: UIImage? = nil){
        
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubviewToFront(overlay)
        
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFit
        imageView.center = overlayTarget.center
        
        if let image = image {
            imageView.image = image
        }
        
        
        overlayTarget.addSubview(imageView)
        overlayTarget.bringSubviewToFront(imageView)
        currentOverlay = overlay
        UIView.animate(withDuration: 0.15, animations: {
            currentOverlay?.alpha = 0.8
            imageView.alpha = 0.9
        }, completion: { (finished: Bool) in
            rotate180()
        })
    }
    
    static func rotate180(){
        if currentOverlay != nil {
            UIView.animate(withDuration: 0.35, delay: 0 , animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(180 * .pi / 180.0))
            }, completion: { (finished: Bool) in
                rotate360()
            })
        }
    }
    
    static func rotate360(){
        if currentOverlay != nil {
            UIView.animate(withDuration: 0.35, delay: 0, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(360 * .pi / 180.0))
            }, completion: { (finished: Bool) in
                rotate180()
            })
        }
    }
    
    static func stop() {
        if currentOverlay != nil {
            UIView.animate(withDuration: 0, delay: 0, animations: {
                imageView.alpha = 0
                currentOverlay?.alpha = 0
            }, completion: { (finished: Bool) in
                currentOverlay?.removeFromSuperview()
                currentOverlay =  nil
                imageView.removeFromSuperview()
            })
        }
    }
}
