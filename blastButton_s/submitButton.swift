//
//  submitButton.swift
//  blastButton_s
//
//  Created by YU CHONKAO on 2016/7/20.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

import UIKit

@objc public enum SubmitButtonState: Int {
    case normal = 0
    case loading = 1
    case success = 2
    case warning = 3
}

class submitButton: UIView {
    
    // Color
    private let shadowColor: UIColor            = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.5)
    private let tapColor: UIColor               = UIColor(red: 255/255, green: 248/255, blue: 247/255, alpha: 1.0)
    private let normalBackgrounColor: UIColor   = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private let submitIconColor: UIColor        = UIColor(red: 6/255, green: 164/255, blue: 191/255, alpha: 1.0)
    private let loadingBackgrounColor: UIColor  = UIColor(red: 255/255, green: 248/255, blue: 247/255, alpha: 1.0)
    private let loadingIconColor: UIColor       = UIColor(red: 6/255, green: 164/255, blue: 191/255, alpha: 1.0)
    private let successBackgroundColor: UIColor = UIColor(red: 65/255, green: 195/255, blue: 143/255, alpha: 1.0)
    private let successIconColor: UIColor       = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private let warningBackgroundColor: UIColor = UIColor(red: 1.0, green: 131/255, blue: 98/255, alpha: 1.0)
    private let warningIconColor: UIColor       = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    private let kLoadingRadius: CGFloat         = 12
    
    
    // UI Element
    private var submitImage: UIImageView!
    private var successImage: UIImageView!
    private var warningImage: UIImageView!
    private var backgroundView: UIView!
    private var tapAnimationView: UIView!
    private var loadingShapeLayer: CAShapeLayer!
    private var tapMaskLayer: CAShapeLayer!
    
    
    // Gesture
    private var tapGesture: UITapGestureRecognizer!
    
    // Target & Selector
    private var target: AnyObject?;
    private var selector: Selector?;
    
    // State Check
    private var buttonState: SubmitButtonState = .normal {
        didSet {
            switch buttonState {
                case .normal:
                    self.performBackgroundColorAnimation(normalBackgrounColor, completion: nil);
                    self.loadingShapeLayer.removeAllAnimations();
                case .loading:
                    self.performBackgroundColorAnimation(loadingBackgrounColor, completion: nil);
                    self.loadingShapeLayer.hidden = false;
                    self.performLoadingAnimation();
                case .success:
                    self.performBackgroundColorAnimation(successBackgroundColor, completion: nil);
                    self.loadingShapeLayer.removeAllAnimations();
                case .warning:
                    self.performBackgroundColorAnimation(warningBackgroundColor, completion: nil);
                    self.loadingShapeLayer.removeAllAnimations();
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Self Setting
        self.layer.shadowColor = shadowColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 2.0;
        
        
        // Basic UI Element
        submitImage = UIImageView.init(image: UIImage(named: "icon_submit")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate));
        submitImage.tintColor = submitIconColor;
        successImage = UIImageView.init(image: UIImage(named: "icon_success")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate));
        successImage.tintColor = successIconColor;
        warningImage = UIImageView.init(image: UIImage(named: "icon_warning")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate));
        warningImage.tintColor = warningIconColor;
        successImage.alpha = 0;
        warningImage.alpha = 0;
        
        backgroundView = UIView.init();
        backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        backgroundView.backgroundColor = UIColor.whiteColor();
        backgroundView.layer.cornerRadius = self.frame.height / 2;
        
        tapAnimationView = UIView.init();
        tapAnimationView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        tapAnimationView.backgroundColor = tapColor;
        tapAnimationView.userInteractionEnabled = false;
        tapAnimationView.hidden = true;
        tapAnimationView.layer.cornerRadius = self.frame.height / 2;
        
        self.addSubview(backgroundView);
        self.addSubview(tapAnimationView);
        self.addSubview(submitImage);
        self.addSubview(successImage);
        self.addSubview(warningImage);
        
        loadingShapeLayer = CAShapeLayer();
        loadingShapeLayer.strokeColor = loadingIconColor.CGColor;
        loadingShapeLayer.lineWidth   = 3.0;
        loadingShapeLayer.fillColor   = UIColor.clearColor().CGColor;
        loadingShapeLayer.lineCap     = kCALineCapRound;
        loadingShapeLayer.strokeEnd   = 0.8;
        loadingShapeLayer.hidden      = true;
        self.layer.addSublayer(loadingShapeLayer);
        
        // Autolayout
        setConstraintWithBackgroundView(submitImage);
        setConstraintWithBackgroundView(successImage);
        setConstraintWithBackgroundView(warningImage);
        
        // Original transform
        self.successImage.transform = CGAffineTransformIdentity;
        self.successImage.transform = CGAffineTransformRotate(self.successImage.transform, CGFloat(-M_PI_4/2));
        self.warningImage.transform = CGAffineTransformIdentity;
        self.warningImage.transform = CGAffineTransformRotate(self.warningImage.transform, CGFloat(-M_PI_4/2));
        
        
        // Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(blastButton.handleSelfOnTapped(_:)));
        self.backgroundView.addGestureRecognizer(tapGesture);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.loadingShapeLayer.path =
            UIBezierPath.init(ovalInRect: CGRectMake(CGRectGetWidth(self.frame)/2 - kLoadingRadius,
                                            CGRectGetHeight(self.frame)/2 - kLoadingRadius, 2 * kLoadingRadius, 2 * kLoadingRadius)).CGPath;
        self.loadingShapeLayer.frame = self.bounds;
    }
    
    private func setConstraintWithBackgroundView(constrainedImage: UIView) {
        constrainedImage.translatesAutoresizingMaskIntoConstraints = false;
        self.addConstraint(constrainedImage.centerXAnchor.constraintEqualToAnchor(backgroundView.centerXAnchor));
        self.addConstraint(constrainedImage.centerYAnchor.constraintEqualToAnchor(backgroundView.centerYAnchor));
    }
    
    // API
    
    func addTarget(target: AnyObject?, action: Selector) {
        self.target = target;
        self.selector = action;
    }
    
    // MARK: - Event
    
    func handleSelfOnTapped(gestureRecognizer: UITapGestureRecognizer) {
        if self.buttonState == .normal {
            self.performTapAnimation(gestureRecognizer.locationInView(self));
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.backgroundView.backgroundColor = self.tapColor;
                self.performSubmitHiddenAnimation();
                self.buttonState = .loading;
                if ((self.target?.respondsToSelector(self.selector!)) != nil) {
                    self.target?.performSelector(self.selector!, withObject: self);
                }
            }
        } else if self.buttonState == .loading {
            self.performAppearAnimation(self.successImage, completion: nil);
            self.loadingShapeLayer.hidden = true;
            self.buttonState = .success;
        } else if self.buttonState == .success {
            self.performHiddenAnimation(self.successImage, completion: nil);
            self.performAppearAnimation(self.warningImage, completion: { (result: Bool) in
                if result {
                    self.performShakeAnimation(self.backgroundView, completion: nil);
                    self.performShakeAnimation(self.warningImage, completion: nil);
                }
            });
            self.buttonState = .warning;
        } else {
            self.performHiddenAnimation(self.warningImage, completion: nil);
            self.performSubmitAppearAnimation();
            self.buttonState = .normal;
        }
    }
    
    // MARK: - Animation
    
    private func performLoadingAnimation() {
        let spinAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation");
        spinAnimation.fromValue             = 0;
        spinAnimation.toValue               = M_PI * 2;
        spinAnimation.duration              = 0.8;
        spinAnimation.repeatCount           = Float.infinity;
        self.loadingShapeLayer.addAnimation(spinAnimation, forKey: nil);
    }
    
    private func performTapAnimation(point: CGPoint) {
        
        // Remove Old Mask Layer
        if self.tapMaskLayer != nil {
            self.tapMaskLayer.removeFromSuperlayer();
            self.tapMaskLayer = nil;
        }
        
        // Set Up Mask Layer
        self.tapAnimationView.hidden = false;
        self.tapMaskLayer = CAShapeLayer();
        self.tapMaskLayer.opacity = 1.0;
        self.tapMaskLayer.fillColor   = UIColor.greenColor().CGColor;
        self.tapMaskLayer.path = UIBezierPath.init(ovalInRect: CGRectMake(point.x - 150, point.y - 150, 300, 300)).CGPath;
        self.tapMaskLayer.frame = self.bounds;
        layer.addSublayer(tapMaskLayer);
        tapAnimationView.layer.mask = tapMaskLayer;
        
        // Animation
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale");
        scaleAnimation.fromValue = 0;
        scaleAnimation.toValue = 1.0;
        scaleAnimation.duration = 0.2;
        scaleAnimation.delegate = self;
        scaleAnimation.removedOnCompletion = false;
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);
        self.tapMaskLayer.addAnimation(scaleAnimation, forKey: "tapAnimation");
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if anim == self.tapMaskLayer.animationForKey("tapAnimation") {
            self.tapMaskLayer.opacity = 0.0;
        }
    }
    
    private func performHiddenAnimation(hiddenImage: UIImageView, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(0.3,
                                   animations: { 
                                    hiddenImage.alpha = 0.0;
                                    hiddenImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4/2));
        }) { (result: Bool) in
            hiddenImage.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4/2));
            completion?(true);
        }
    }
    
    private func performAppearAnimation(hiddenImage: UIImageView, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    hiddenImage.alpha = 1.0;
                                    hiddenImage.transform = CGAffineTransformMakeRotation(0);
        }) { (result: Bool) in
            completion?(true);
        }
    }
    
    private func performShakeAnimation(hiddenImage: UIView, completion: ((Bool) -> Void)?) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = [-6, 6, -6, 6, -4, 4, -3, 3, 0]
        hiddenImage.layer.addAnimation(translation, forKey: "shakeIt");
    }
    
    private func performSubmitHiddenAnimation() {
        UIView.animateWithDuration(0.4,
                                   animations: {
                                    self.submitImage.alpha = 0.0;
                                    self.submitImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4/2));
                                    self.backgroundView.frame =
                                        CGRectMake((CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame))/2, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
                                    
        }) { (result: Bool) in
            self.submitImage.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4/2));
        }
    }
    
    private func performSubmitAppearAnimation() {
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.submitImage.alpha = 1.0;
                                    self.submitImage.transform = CGAffineTransformMakeRotation(0);
                                    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        });
    }
    
    private func performBackgroundColorAnimation(backgroundColor: UIColor, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(0.4,
                                   animations: { 
                                    self.backgroundView.backgroundColor = backgroundColor;
        });
    }
    
}
