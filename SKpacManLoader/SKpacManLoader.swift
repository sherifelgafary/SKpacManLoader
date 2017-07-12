//
//  SKpacManLoader.swift
//  testLoader
//
//  Created by sherif_khaled on 6/15/16.
//  Copyright © 2016 brightCreations. All rights reserved.
//

import UIKit

class SKpacManLoader: UIView {
    @IBOutlet weak var dotsView: UIView!
    @IBOutlet weak var pacmanLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pacManView: UIView!
    @IBOutlet weak var loaderContainerView: UIView!
    
    
    @IBOutlet weak var reversedPacManView: UIView!
    @IBOutlet weak var reversedDotsView: UIView!
    @IBOutlet weak var reversedPacManTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ReversedLoaderContainerView: UIView!
    
    
    var pacmanSize:CGFloat = 25.0
    var pacmanColor:UIColor = UIColor(hexString: "#C41230ff")!
    var dotsColor:UIColor = UIColor(hexString: "#C41230ff")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ReversedLoaderContainerView.isHidden=true
        self.loaderContainerView.isHidden=false
        
        
        
    }
    
    func prepareLoader() {
        self.pacmanInLayer(self.pacManView.layer, size: CGSize(width: pacmanSize, height: pacmanSize), color: pacmanColor)
        self.pacmanInLayer(self.reversedPacManView.layer, size: CGSize(width: pacmanSize, height: pacmanSize), color: pacmanColor)
        self.reversedPacManView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
        
        for view in self.dotsView.subviews {
            view.backgroundColor = self.dotsColor
        }
        
        for view in self.reversedDotsView.subviews {
            view.backgroundColor = self.dotsColor
        }
        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SKpacManLoader.animatePacman), userInfo: nil, repeats: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func animatePacman()  {
        
        pacmanLeadingConstraint.constant=self.frame.width - pacmanSize*2
        
        UIView.animate(withDuration: 3, animations: {
            self.layoutIfNeeded()
        }, completion: { (finished:Bool) in
            self.ReversedLoaderContainerView.isHidden=false
            self.loaderContainerView.isHidden=true
            self.pacmanLeadingConstraint.constant=0
            
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SKpacManLoader.animateReversedPacman), userInfo: nil, repeats: false)
        }) 
        
    }
    
    func animateReversedPacman()  {
        
        reversedPacManTrailingConstraint.constant=self.frame.width - pacmanSize*2
        
        UIView.animate(withDuration: 3, animations: {
            self.layoutIfNeeded()
        }, completion: { (finished:Bool) in
            self.ReversedLoaderContainerView.isHidden=true
            self.loaderContainerView.isHidden=false
            self.reversedPacManTrailingConstraint.constant=0
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SKpacManLoader.animatePacman), userInfo: nil, repeats: false)
            
        }) 
    }
    
    func pacmanInLayer(_ layer: CALayer, size: CGSize, color: UIColor) {
        let pacmanSize =  size.width
        let pacmanDuration: CFTimeInterval = 0.5
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        // Stroke start animation
        let strokeStartAnimation = CAKeyframeAnimation(keyPath: "strokeStart")
        
        strokeStartAnimation.keyTimes = [0, 0.5, 1]
        strokeStartAnimation.timingFunctions = [timingFunction, timingFunction]
        strokeStartAnimation.values = [0.125, 0, 0.125]
        strokeStartAnimation.duration = pacmanDuration
        
        // Stroke end animation
        let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        
        strokeEndAnimation.keyTimes = [0, 0.5, 1]
        strokeEndAnimation.timingFunctions = [timingFunction, timingFunction]
        strokeEndAnimation.values = [0.875, 1, 0.875]
        strokeEndAnimation.duration = pacmanDuration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [strokeStartAnimation, strokeEndAnimation]
        animation.duration = pacmanDuration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw pacman
        let pacman = self.createLayerWith(size: CGSize(width: pacmanSize, height: pacmanSize), color: color)
        let frame = CGRect(
            x: (layer.bounds.origin.x),
            y: (layer.bounds.origin.y),
            width: pacmanSize,
            height: pacmanSize
        )
        
        pacman.frame = frame
        pacman.add(animation, forKey: "animation")
        layer.addSublayer(pacman)
    }
    
    func createLayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                              radius: size.width / 4,
                              startAngle: 0,
                              endAngle: CGFloat(2 * M_PI),
                              clockwise: true);
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = size.width / 2
        
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
    
    
}


var loader:SKpacManLoader?
var overlayView:UIView?


func startLoadingIn(_ ViewController:UIViewController, withBackGround:Bool = true ,withPacManColor:UIColor = UIColor(hexString: "#C41230ff")!, withDotsColor:UIColor = UIColor(hexString: "#C41230ff")! )
{
    if loader != nil {
        finishLoadingFrom(ViewController)
    }
    
    loader = UINib(nibName: "SKpacManLoader", bundle: nil).instantiate(withOwner: ViewController, options: nil)[0] as? SKpacManLoader
    loader?.pacmanColor = withPacManColor
    loader?.dotsColor = withDotsColor
    loader?.prepareLoader()
    
    overlayView = UIView(frame: ViewController.view.frame)
    if withBackGround {
        overlayView?.backgroundColor = UIColor(colorLiteralRed: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
    }else{
        overlayView?.backgroundColor = UIColor.clear
    }
    overlayView?.isUserInteractionEnabled=true
    // var currentWindow : UIWindow = UIApplication.sharedApplication().keyWindow!
    ViewController.view.addSubview(overlayView!)
    overlayView?.addSubview(loader!)
    loader?.center=(overlayView?.center)!
}

func finishLoadingFrom(_ ViewController:UIViewController)
{
    if overlayView != nil{
        overlayView?.removeFromSuperview()
        ViewController.view.isUserInteractionEnabled = true
    }
}


extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
