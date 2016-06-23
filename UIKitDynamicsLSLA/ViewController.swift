//
//  ViewController.swift
//  UIKitDynamicsLSLA
//
//  Created by Garric Nahapetian on 6/22/16.
//  Copyright © 2016 Learn Swift LA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var greenView: UIView!

    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!
    var snapPoint: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
    }

    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        let touchPoint: CGPoint = sender.locationInView(view)

        switch sender.state {
        case .Began:
            snapPoint = greenView.center
            animator.removeAllBehaviors()

            let axis = CGVector(dx: 1, dy: 0)
            attachmentBehavior = UIAttachmentBehavior.slidingAttachmentWithItem(
                greenView,
                attachmentAnchor: touchPoint,
                axisOfTranslation: axis)
            animator.addBehavior(attachmentBehavior)
        case .Changed:
            attachmentBehavior.anchorPoint = touchPoint
        case .Ended:
            animator.removeBehavior(attachmentBehavior)

            let screenHeight = UIScreen.mainScreen().bounds.height
            let greenViewCenterY = greenView.center.y
            let withinYThreshold =
                greenViewCenterY > screenHeight * 0.25 &&
                greenViewCenterY < screenHeight * 0.75 ? true : false

            if withinYThreshold {
                let dynamicBehavior = UIDynamicItemBehavior(items: [greenView])
                dynamicBehavior.allowsRotation = false
                animator.addBehavior(dynamicBehavior)

                snapBehavior = UISnapBehavior(item: greenView, snapToPoint: snapPoint)
                snapBehavior.damping = 1.0
                animator.addBehavior(snapBehavior)
            } else {
                let pushBehavior = UIPushBehavior(items: [greenView], mode: .Instantaneous)
                pushBehavior.pushDirection = CGVector(dx: 0, dy: 1)
                let velocity = sender.velocityInView(view)
                pushBehavior.magnitude = sqrt((velocity.x * velocity.x) + (velocity.y + velocity.y))
                animator.addBehavior(pushBehavior)
            }
        default:
            break
        }
    }
}

