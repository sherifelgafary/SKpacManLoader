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
        
        self.ReversedLoaderContainerView.hidden=true
        self.loaderContainerView.hidden=false
        
        
        
    }
    
    func prepareLoader() {
        self.pacmanInLayer(self.pacManView.layer, size: CGSizeMake(pacmanSize, pacmanSize), color: pacmanColor)
        self.pacmanInLayer(self.reversedPacManView.layer, size: CGSizeMake(pacmanSize, pacmanSize), color: pacmanColor)
        self.reversedPacManView.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
        
        for view in self.dotsView.subviews {
            view.backgroundColor = self.dotsColor
        }
        
        for view in self.reversedDotsView.subviews {
            view.backgroundColor = self.dotsColor
        }
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(SKpacManLoader.animatePacman), userInfo: nil, repeats: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func animatePacman()  {
        
        pacmanLeadingConstraint.constant=self.frame.width - pacmanSize*2
        
        UIView.animateWithDuration(3, animations: {
            self.layoutIfNeeded()
        }) { (finished:Bool) in
            self.ReversedLoaderContainerView.hidden=false
            self.loaderContainerView.hidden=true
            self.pacmanLeadingConstraint.constant=0
            
            _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(SKpacManLoader.animateReversedPacman), userInfo: nil, repeats: false)
        }
        
    }
    
    func animateReversedPacman()  {
        
        reversedPacManTrailingConstraint.constant=self.frame.width - pacmanSize*2
        
        UIView.animateWithDuration(3, animations: {
            self.layoutIfNeeded()
        }) { (finished:Bool) in
            self.ReversedLoaderContainerView.hidden=true
            self.loaderContainerView.hidden=false
            self.reversedPacManTrailingConstraint.constant=0
            _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(SKpacManLoader.animatePacman), userInfo: nil, repeats: false)
            
        }
    }
    
    func pacmanInLayer(layer: CALayer, size: CGSize, color: UIColor) {
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
        animation.removedOnCompletion = false
        
        // Draw pacman
        let pacman = self.createLayerWith(size: CGSize(width: pacmanSize, height: pacmanSize), color: color)
        let frame = CGRect(
            x: (layer.bounds.origin.x),
            y: (layer.bounds.origin.y),
            width: pacmanSize,
            height: pacmanSize
        )
        
        pacman.frame = frame
        pacman.addAnimation(animation, forKey: "animation")
        layer.addSublayer(pacman)
    }
    
    func createLayerWith(size size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        
        path.addArcWithCenter(CGPoint(x: size.width / 2, y: size.height / 2),
                              radius: size.width / 4,
                              startAngle: 0,
                              endAngle: CGFloat(2 * M_PI),
                              clockwise: true);
        layer.fillColor = nil
        layer.strokeColor = color.CGColor
        layer.lineWidth = size.width / 2
        
        layer.backgroundColor = nil
        layer.path = path.CGPath
        layer.frame = CGRectMake(0, 0, size.width, size.height)
        
        return layer
    }
    
    
}


var loader:SKpacManLoader?
var overlayView:UIView?


func startLoadingIn(ViewController:UIViewController, withBackGround:Bool = true ,withPacManColor:UIColor = UIColor(hexString: "#C41230ff")!, withDotsColor:UIColor = UIColor(hexString: "#C41230ff")! )
{
    if loader != nil {
        finishLoadingFrom(ViewController)
    }
    
    loader = UINib(nibName: "SKpacManLoader", bundle: nil).instantiateWithOwner(ViewController, options: nil)[0] as? SKpacManLoader
    loader?.pacmanColor = withPacManColor
    loader?.dotsColor = withDotsColor
    loader?.prepareLoader()
    
    overlayView = UIView(frame: ViewController.view.frame)
    if withBackGround {
        overlayView?.backgroundColor = UIColor(colorLiteralRed: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
    }else{
        overlayView?.backgroundColor = UIColor.clearColor()
    }
    overlayView?.userInteractionEnabled=true
    // var currentWindow : UIWindow = UIApplication.sharedApplication().keyWindow!
    ViewController.view.addSubview(overlayView!)
    overlayView?.addSubview(loader!)
    loader?.center=(overlayView?.center)!
}

func finishLoadingFrom(ViewController:UIViewController)
{
    if overlayView != nil{
        overlayView?.removeFromSuperview()
        ViewController.view.userInteractionEnabled = true
    }
}


extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substringFromIndex(start)
            
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber) {
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
