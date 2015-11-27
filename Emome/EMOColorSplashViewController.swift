//
//  EMOColorSplashViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/26/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import QuartzCore

class EMOColorSplashViewController: UIViewController {
    
    @IBOutlet weak var panelView: UIView!
    var pusher: UIPushBehavior!
    var animator: UIDynamicAnimator!
    
    var touchStartTime: NSTimeInterval?
    
    var newLayer: CAShapeLayer?
    
    var isPanelSetUp = false
    
    var eraserButton: UIButton!
    
    var currentColor: UIColor?
    
    var colorLayers: [CAShapeLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        // Do any additional setup after loading the view.
//        let circleView = UIView(frame: CGRect(x: 100.0, y: 200.0, width: 40.0, height: 40.0))
//        circleView.backgroundColor = UIColor.emomeThemeColor()
//        circleView.layer.cornerRadius = 20.0
//        self.view.addSubview(circleView)
//        
//        self.animator = UIDynamicAnimator.init(referenceView: self.view)
//        
//        self.pusher = UIPushBehavior.init(items: [circleView], mode: .Instantaneous)
//        self.pusher.pushDirection = CGVector(dx: 0.1, dy: 0.1)
//        self.pusher.active = true
//        
//        self.animator.addBehavior(self.pusher)
//        
//        let collision = UICollisionBehavior.init(items: [circleView])
//        collision.translatesReferenceBoundsIntoBoundary = true
//        self.animator.addBehavior(collision)
        
    }
    
    override func viewDidLayoutSubviews() {
        if !self.isPanelSetUp {
            setUpPanel()
            self.isPanelSetUp = true
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func backToHome(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func setUpPanel() {
        let maskPath = UIBezierPath.init(roundedRect: self.panelView.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        self.panelView.layer.mask = maskLayer
        
        let height = self.panelView.bounds.size.height
        let width = self.panelView.bounds.size.width / CGFloat(EMOEmotion.allValues.count + 1)
        
        // Add Button
        var x: CGFloat = 0.0
        var tag: Int = 0
        for emotion in EMOEmotion.allValues {
            let button = UIButton.init(frame: CGRect(x: x, y: 0, width: width, height: height))
            button.setTitle("\(emotion)", forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 60.0, left: 0.0, bottom: 0.0, right: 0.0)
            button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
            button.tag = tag
            button.addTarget(self, action: "toolDidSelect:", forControlEvents: .TouchUpInside)
            self.panelView.addSubview(button)
            
            x += width
            tag += 1
        }
        
        self.eraserButton = UIButton.init(frame: CGRect(x: x, y: 0, width: width, height: height))
        eraserButton.setImage(UIImage(named: "btn-eraser"), forState: .Normal)
        eraserButton.imageEdgeInsets = UIEdgeInsets(top: 18.0, left: 0.0, bottom: 0.0, right: 0.0)
        eraserButton.addTarget(self, action: "toolDidSelect:", forControlEvents: .TouchUpInside)
        self.panelView.addSubview(eraserButton)
    }
    
    func toolDidSelect(sender: UIButton) {
        if sender == self.eraserButton {
            self.currentColor = nil
            self.newLayer = nil
            
        } else {
            print("\(EMOEmotion.allValues[sender.tag]) selected")
            self.currentColor = UIColor.colorForEmotion(EMOEmotion.allValues[sender.tag])
        }
    }
    
    func setUpEmitter() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.origin.y)
        emitterLayer.emitterZPosition = 10
        emitterLayer.emitterSize = CGSize(width: self.view.bounds.size.width, height: 0.0)
        emitterLayer.emitterShape = kCAEmitterLayerSphere
        
        let emitterCell = CAEmitterCell()
        emitterCell.scale = 0.1
        emitterCell.scaleRange = 0.2
        emitterCell.emissionRange = CGFloat(M_PI_2)
        emitterCell.lifetime = 5.0
        emitterCell.birthRate = 10
        emitterCell.velocity = 200
        emitterCell.velocityRange = 50
        emitterCell.yAcceleration = 250
        
        emitterCell.contents = UIImage(imageLiteral: "ic-cross").CGImage
        
        emitterLayer.emitterCells = [emitterCell]
        
        self.view.layer.addSublayer(emitterLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            print("\(touch.locationInView(self.view))")
            self.touchStartTime = event?.timestamp
            
            if let color = self.currentColor {
                
                self.newLayer = CAShapeLayer()
                self.newLayer!.bounds = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
                self.newLayer!.position = touch.locationInView(self.view)
                self.newLayer!.backgroundColor = color.CGColor
                self.newLayer!.cornerRadius = 20.0
                self.newLayer!.opacity = 0.6
                self.view.layer.addSublayer(self.newLayer!)
                
                let scaleAnimation = CABasicAnimation.init(keyPath: "transform")
                scaleAnimation.fromValue = NSValue.init(CATransform3D: CATransform3DIdentity)
                scaleAnimation.toValue = NSValue.init(CATransform3D: CATransform3DMakeScale(6.0, 6.0, 1.0))
                
                scaleAnimation.duration = 4.0
                scaleAnimation.fillMode = kCAFillModeBoth
                scaleAnimation.removedOnCompletion = false
                
                self.newLayer!.addAnimation(scaleAnimation, forKey: "zoom")
                
            } else {
                
                let touchedLayer = self.view.layer.presentationLayer()?.hitTest(touch.locationInView(self.view))
                let actualLayer = touchedLayer!.modelLayer() as! CALayer
                
                if actualLayer == self.view.layer {
                    print("self")
                } else {
                    for i in 0..<self.colorLayers.count {
                        if actualLayer == self.colorLayers[i] {
                            actualLayer.removeFromSuperlayer()
                            self.colorLayers.removeAtIndex(i)
                            break
                        }
                    }
                }
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            if let layer = self.newLayer {
                CATransaction.begin()
                layer.position = touch.locationInView(self.view)
                CATransaction.commit()
            }
            
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            print("\(touch.locationInView(self.view))")
            
            if let layer = self.newLayer {
                if let frame = layer.presentationLayer()?.frame {
                
//                    CATransaction.begin()
                    layer.bounds = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
                    layer.cornerRadius = frame  .size.width / 2
                    layer.removeAnimationForKey("zoom")
//                    CATransaction.commit()
                }
                
                self.colorLayers.append(layer)
            }
        }
    }
//
//    func radiusForTouchDuraiton(touchDuration: NSTimeInterval) -> CGFloat {
//        
//        let ratio: CGFloat = CGFloat(touchDuration / 1.5)
//        print("ratio \(ratio) duration \(touchDuration)")
//        return CGFloat(20.0 + ratio * 40.0)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
