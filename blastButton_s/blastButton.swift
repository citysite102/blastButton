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
        
        self.addBlastLine(10);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(target: AnyObject?, action: Selector) {
        self.target = target;
        self.selector = action;
    }
    
    func addBlastLine(number: Int) {
        for index in 1...number {
//            let blastLine = CAShapeLayer();
            let linePath = UIBezierPath();
            linePath.moveToPoint(self.center);
            linePath.addLineToPoint(self.calculateDestinationPoint(index));
            print("Line \(index):" + NSStringFromCGPoint(CGPointMake(self.calculateDestinationPoint(index).x - self.center.x, self.calculateDestinationPoint(index).y - self.center.y)));
        }
    }
    
    func calculateDestinationPoint(index: Int) -> CGPoint {
        let angle: Double = (Double(index) - 1) * 36 / 180 * M_PI;
        let xCoordinate = self.center.x + CGFloat(sin(angle)) * 50;
        let yCoordinate = self.center.y + CGFloat(cos(angle)) * 50;
        return CGPointMake(xCoordinate, yCoordinate);
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
