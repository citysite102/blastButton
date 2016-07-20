//
//  blastButton.swift
//  blastButton_s
//
//  Created by YU CHONKAO on 2016/7/15.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

import UIKit

class blastButton: UIView {

    
    // Color
    private static let kButtonColor1: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private static let kButtonColor2: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private static let kButtonColor3: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private static let kButtonColor4: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    
    // UI Element
    private var thumbImageView: UIImageView!
    private var backgroundView: UIView!
    
    // Gesture
    private var longPressGesture: UILongPressGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    // Target & Selector
    private var target: AnyObject?;
    private var selector: Selector?;
    
    // State Check 
    private var selected : Bool = false;
    private var inRect : Bool = false;
    private var isLongPressSuccess : Bool = true;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Basic UI Element
        thumbImageView = UIImageView.init(image: UIImage(named: "icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate));
        thumbImageView.tintColor = UIColor.whiteColor();
        backgroundView = UIView.init();
        backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        backgroundView.backgroundColor = UIColor.redColor();
        backgroundView.layer.cornerRadius = self.frame.width / 2;
        self.addSubview(backgroundView);
        self.addSubview(thumbImageView);
        
        // Autolayout
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.addConstraint(thumbImageView.centerXAnchor.constraintEqualToAnchor(backgroundView.centerXAnchor));
        self.addConstraint(thumbImageView.centerYAnchor.constraintEqualToAnchor(backgroundView.centerYAnchor));
        
        // Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(blastButton.handleSelfOnTapped(_:)));
        self.addGestureRecognizer(tapGesture);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(target: AnyObject?, action: Selector) {
        self.target = target;
        self.selector = action;
    }
    
    func addBlastLine(number: Int) {
        
        for layer_s: CALayer in self.layer.sublayers! {
            if layer_s.isKindOfClass(CAShapeLayer) {
                layer_s.removeFromSuperlayer();
            }
        }
        
        for index in 1...number {
            let blastLine                         = CAShapeLayer();
            let linePath                          = UIBezierPath();
            linePath.moveToPoint(self.calculateStartPoint(index));
            linePath.addLineToPoint(self.calculateDestinationPoint(index));
            blastLine.path                        = linePath.CGPath;
            blastLine.lineWidth                   = 6.0;
            blastLine.lineCap                     = kCALineCapRound;
            blastLine.strokeColor                 = UIColor.redColor().CGColor;
            blastLine.fillColor                   = UIColor.clearColor().CGColor;
            blastLine.strokeEnd                   = 0.5;

            self.layer.addSublayer(blastLine);

            let animation                         = CABasicAnimation(keyPath: "strokeStart");
            animation.duration                    = 0.3;
            animation.fromValue                   = 0.0;
            animation.toValue                     = 1.0;
            animation.removedOnCompletion         = false;
            animation.fillMode                    = kCAFillModeForwards;
            animation.timingFunction              = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn);
            blastLine.addAnimation(animation, forKey: nil);

            let animation_end                     = CABasicAnimation(keyPath: "strokeEnd");
            animation_end.duration                = 0.3;
            animation_end.fromValue               = 0.5;
            animation_end.toValue                 = 1.0;
            animation_end.removedOnCompletion     = false;
            animation_end.fillMode                = kCAFillModeForwards;
            animation_end.timingFunction          = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn);
            blastLine.addAnimation(animation_end, forKey: nil);


            let blastDot                          = CAShapeLayer();
            blastDot.path                         = UIBezierPath.init(ovalInRect: CGRectMake(self.calculateDotStartPoint(index).x - 2, self.calculateDotStartPoint(index).y - 2, 4, 4)).CGPath;
            blastDot.fillColor                    = UIColor.redColor().CGColor;
            self.layer.addSublayer(blastDot);
            
            let animation_dot                     = CABasicAnimation(keyPath: "position");
            animation_dot.duration                = 0.3;
            animation_dot.fromValue               = NSValue(CGPoint: blastDot.position);
            animation_dot.toValue                 = NSValue(CGPoint: self.calculateDotDestinationPoint(index));
            print("StartPoint:" + NSStringFromCGPoint(blastDot.position) + " Destination:" + NSStringFromCGPoint(self.calculateDotDestinationPoint(index)));
            
            animation_dot.removedOnCompletion     = false;
            animation_dot.fillMode                = kCAFillModeForwards;
            animation_dot.timingFunction          = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn);

            let animation_dot_end                 = CABasicAnimation(keyPath: "opacity");
            animation_dot_end.beginTime           = 0.3;
            animation_dot_end.duration            = 0.3;
            animation_dot_end.fromValue           = 1.0;
            animation_dot_end.toValue             = 0.0;
            animation_dot_end.removedOnCompletion = false;
            animation_dot_end.fillMode            = kCAFillModeForwards;
            animation_dot_end.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn);
            
            let animation_dot_group               = CAAnimationGroup();
            animation_dot_group.duration = 0.6;
            animation_dot_group.animations = [animation_dot, animation_dot_end]
            blastDot.addAnimation(animation_dot_group, forKey: nil);
            
            
        }
        self.bringSubviewToFront(self.backgroundView);
        self.bringSubviewToFront(self.thumbImageView);
    }
    
    func calculateStartPoint(index: Int) -> CGPoint {
        let angle: Double = (Double(index) - 1) * 36 / 180 * M_PI;
        let xCoordinate = CGRectGetWidth(self.frame)/2 + CGFloat(sin(angle)) * 25;
        let yCoordinate = CGRectGetHeight(self.frame)/2 + CGFloat(cos(angle)) * 25;
        return CGPoint(x: xCoordinate, y: yCoordinate);
    }
    
    func calculateDestinationPoint(index: Int) -> CGPoint {
        let angle: Double = (Double(index) - 1) * 36 / 180 * M_PI;
        let xCoordinate = CGRectGetWidth(self.frame)/2 + CGFloat(sin(angle)) * 45;
        let yCoordinate = CGRectGetHeight(self.frame)/2 + CGFloat(cos(angle)) * 45;
        return CGPoint(x: xCoordinate, y: yCoordinate);
    }
    
    func calculateDotStartPoint(index: Int) -> CGPoint {
        let xCoordinate = CGRectGetWidth(self.frame)/2;
        let yCoordinate = CGRectGetHeight(self.frame)/2;
        return CGPoint(x: xCoordinate, y: yCoordinate);
    }
    
    func calculateDotDestinationPoint(index: Int) -> CGPoint {
        let angle: Double = 18 + (Double(index) - 1) * 36 / 180 * M_PI;
        let xCoordinate = CGFloat(sin(angle)) * 45;
        let yCoordinate = CGFloat(cos(angle)) * 45;
        return CGPoint(x: xCoordinate, y: -yCoordinate);
    }
    
    func handleSelfOnTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.backgroundView.transform = CGAffineTransformIdentity;
        self.thumbImageView.transform = CGAffineTransformIdentity;
        self.thumbImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.backgroundView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        
        UIView.animateWithDuration(0.3, delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0,
                                   options: .CurveEaseOut,
                                   animations: {
                                    
                                    let scaleTransform: CGAffineTransform = CGAffineTransformMakeScale(0.1, 0.1);
                                    let groupTransform: CGAffineTransform = CGAffineTransformRotate(scaleTransform, CGFloat(-M_PI_4/2));
                                    
                                    self.backgroundView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                                    self.thumbImageView.transform = groupTransform;
            }, completion: { (result: Bool) in
                
                if (self.selected) {
                    self.addBlastLine(10);
                }
                
                self.backgroundView.backgroundColor = self.selected ? UIColor.redColor() : UIColor.greenColor();
                UIView.animateWithDuration(0.3, delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 0,
                    options: .CurveEaseOut,
                    animations: {
                        
                        let scaleTransform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 1.0);
                        let groupTransform: CGAffineTransform = CGAffineTransformRotate(scaleTransform, 0);
                        
                        self.backgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        self.thumbImageView.transform = groupTransform
                        
                    }, completion: { (_result: Bool) in
                        self.selected = self.isLongPressSuccess ? !self.selected : self.selected;
                })
        })
    }
    
    
    // Old version
    /*
    func handleSelfOnLongPressing(gestureRecognizer: UILongPressGestureRecognizer) {
        self.isLongPressSuccess = true;
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            self.inRect = true;
            self.backgroundView.transform = CGAffineTransformIdentity;
            self.thumbImageView.transform = CGAffineTransformIdentity;
            self.thumbImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.backgroundView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            
            UIView.animateWithDuration(2.0, delay: 0,
                                       usingSpringWithDamping: 1,
                                       initialSpringVelocity: 0,
                                       options: [.CurveEaseOut, .BeginFromCurrentState],
                                       animations: {
                                        
                                        let scaleTransform: CGAffineTransform = CGAffineTransformMakeScale(0.1, 0.1);
                                        let groupTransform: CGAffineTransform = CGAffineTransformRotate(scaleTransform, CGFloat(-M_PI_4/2));
                                        
                                        self.backgroundView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                                        self.thumbImageView.transform = groupTransform;
                }, completion: { (result: Bool) in
                    if self.isLongPressSuccess {
                        print("Set to %@", self.selected ? "red color" : "green color");
                        self.backgroundView.backgroundColor = self.selected ? UIColor.redColor() : UIColor.greenColor();
                    }
                    UIView.animateWithDuration(1.0, delay: 0,
                        usingSpringWithDamping: 1,
                        initialSpringVelocity: 0,
                        options: [.CurveEaseOut, .BeginFromCurrentState],
                        animations: {
                            
                            let scaleTransform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 1.0);
                            let groupTransform: CGAffineTransform = CGAffineTransformRotate(scaleTransform, 0);
                            
                            self.backgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                            self.thumbImageView.transform = groupTransform
                        }, completion: { (_result: Bool) in
                            self.selected = self.isLongPressSuccess ? !self.selected : self.selected;
                    })
            })
            
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Changed) {
            
            let touchPoint = gestureRecognizer.locationInView(self);
            let availableRect = CGRectInset(self.bounds, -20, -20);

            if (!CGRectContainsPoint(availableRect, touchPoint)) {
                if self.inRect {
                    self.isLongPressSuccess = false;
                    print("False + \(self.isLongPressSuccess)");
                    if !self.selected {
                        UIView.animateWithDuration(1.0, delay: 0,
                                                   usingSpringWithDamping: 1,
                                                   initialSpringVelocity: 0,
                                                   options: [.CurveEaseOut, .BeginFromCurrentState],
                                                   animations: {
                                                    self.backgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                    
                                                    let scaleTransform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 1.0);
                                                    let groupTransform: CGAffineTransform = CGAffineTransformRotate(scaleTransform, 0);
                                                    self.thumbImageView.transform = groupTransform
                                                    
                            }, completion: { (result: Bool) in
                                print("Change to red color");
                                self.backgroundView.backgroundColor = UIColor.redColor();
                        })
                    } else {
                        UIView.animateWithDuration(1.0, delay: 0,
                                                   usingSpringWithDamping: 1,
                                                   initialSpringVelocity: 0,
                                                   options: [.CurveEaseOut, .BeginFromCurrentState],
                                                   animations: {
                                                    self.backgroundView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                    
                                                    let scaleTransform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 1.0);
                                                    let groupTransform: CGAffineTransform = CGAffineTransformRotate(scaleTransform, 0);
                                                    self.thumbImageView.transform = groupTransform
                                                    
                            }, completion: { (result: Bool) in
                                print("Change to green color");
                                self.backgroundView.backgroundColor = UIColor.greenColor();
                        })
                    }
                    self.inRect = false;
                }
            } else {
                print("True");
                isLongPressSuccess = true;
                self.inRect = true;
            }
        } else if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            print("End");
        } else {
            print("Other");
        }
    }*/
    
}
