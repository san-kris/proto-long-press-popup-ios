//
//  ViewController.swift
//  proto-long-press-popup-ios
//
//  Created by Santosh Krishnamurthy on 3/8/23.
//

import UIKit

class ViewController: UIViewController {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg-image"))
        return imageView
    }()
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        // adding subviews inside the view
        let redView = UIView()
        redView.backgroundColor = .red
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        // all the UIViews in an array
        let arrangedViews = [redView, blueView]
        
        // Add the array of Subviews to stack-view
        let stackView = UIStackView(arrangedSubviews: arrangedViews)
        // specify the distribution to Fill equally
        stackView.distribution = .fillEqually
        
        // add the stackview as a subview
        containerView.addSubview(stackView)
        
        // set the padding between subview in stack view and around the view
        // setting a constant to 8 pxl
        let Padding: CGFloat = 8
        stackView.spacing = Padding
        stackView.layoutMargins = UIEdgeInsets(top: Padding, left: Padding, bottom: Padding, right: Padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // view is not displayed by default until the frame is set
        // the default X,Y of new view is 0,0 and width,height is 0,0
        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        // specify the frame of the stackview
        stackView.frame = containerView.frame
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .systemGray
        imageView.frame = view.frame
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        
        setupLongPressGesture()
    }

    func setupLongPressGesture() -> Void {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer){
        
        if (gesture.state == .began){
            print("Long press began: \(Date())")
            handleGestureBegan(gesture: gesture)
        } else if (gesture.state == .ended){
            print("Long press ended: \(Date())")
            iconsContainerView.removeFromSuperview()
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) -> Void {
        view.addSubview(iconsContainerView)
        // print("view frame: \(iconsContainerVie.frame)")
        // print("view bounds: \(iconsContainerVie.bounds)")
        
        // get the location of the click on screen
        let pressedLocation = gesture.location(in: view)
        print("Location of press: \(pressedLocation)")
        
        
        // calculate the x,y coordinates for the red box so that it appears at the center of the screen
        let newXCoordinate = (view.frame.width - iconsContainerView.frame.width ) / 2
        let newYCoordinate = pressedLocation.y - iconsContainerView.frame.height
        
        // apply transformation to box to move it to new lcation
        // Affine Transform helps capture the scale, rotate and translate changes to a view
        // only need to create Affine Transform if we are going to reuse later
        // For one oof use, we can use scaleBy, translateBy and rootateBy functions
        // NOTE:- its important to remember, after transformation / animation. the X,Y coordinates of a view will not reset of original values
        iconsContainerView.transform = CGAffineTransform(translationX: newXCoordinate, y: pressedLocation.y)
        
        // animating fade in effect
        iconsContainerView.alpha = 0
        
        // statuc function to animate movement of ui element on screen
        // specify end state of the ui in the closure and core graphics will take care of the rest
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: newXCoordinate, y: newYCoordinate)
        } completion: { done in
            print("Alpha animation completed")
        }
    }

}

