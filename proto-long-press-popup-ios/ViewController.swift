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
                
        // set the padding between subview in stack view and around the view
        // setting a constant to 8 pxl
        let padding: CGFloat = 6
        // set height of each icon
        let iconHeight: CGFloat = 38
        
        /*
        // Using map function to generate views
        let arrangedViews = [UIColor.red, .green, .blue].map { (color) -> UIView in
            let newView = UIView()
            newView.backgroundColor = color
            newView.layer.cornerRadius = iconHeight / 2
            return newView
        }
         */

        
        let iconImages = [UIImage(named: "icons8-american-football-96"),
                          UIImage(named: "icons8-heart-suit-96"),
                          UIImage(named: "icons8-jack-o-lantern-96"),
                          UIImage(named: "icons8-party-popper-96"),
                          UIImage(named: "icons8-skunk-96"),
                          UIImage(named: "icons8-sunflower-96")
        ]
        
        // Using map function to generate views
        let arrangedViews = iconImages.map { (image) -> UIImageView in
            let newImageView = UIImageView(image: image)
            newImageView.backgroundColor = .gray
            newImageView.layer.cornerRadius = iconHeight / 2
            // Need to enable iteraction too perfrm hit testing
            newImageView.isUserInteractionEnabled = true
            return newImageView
        }
         
        // Add the array of Subviews to stack-view
        let stackView = UIStackView(arrangedSubviews: arrangedViews)
        // specify the distribution to Fill equally
        stackView.distribution = .fillEqually
        
        // add the stackview as a subview
        containerView.addSubview(stackView)
        
    
        
        // Adds space between subviews
        stackView.spacing = padding
        // creates a margin aroound subviews
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // capture number of subviews in the stack
        let numOfIcons = CGFloat(arrangedViews.count)
        let widthWithPadding = (numOfIcons * iconHeight) + ((numOfIcons + 1) * padding)
        
        // view is not displayed by default until the frame is set
        // the default X,Y of new view is 0,0 and width,height is 0,0
        containerView.frame = CGRect(x: 0, y: 0, width: widthWithPadding, height: iconHeight + (2 * padding))
        // make rounded corner edges on the container view
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        // Add shadow to container view
        // set the shadoow color
        containerView.layer.shadowColor = CGColor(gray: 0.5, alpha: 0.5)
        // set shadow opacity. default value is 0, i.e. invisible
        containerView.layer.shadowOpacity = 1
        // set offset to show shadow below button. Default is shadow on top (0,-3)
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        // set shadow radiouos, default value is 3
        containerView.layer.shadowRadius = 3.0
        
        
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
//        view.addSubview(imageView)
        
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
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                // bring back the icons back inside stack view
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (view) in
                    view.transform = .identity
                })
                // show icon trey dropping down
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: self.iconsContainerView.frame.height)
                self.iconsContainerView.alpha = 0
                
            } completion: { done in
                self.iconsContainerView.removeFromSuperview()
                print("icon animation reset complete")
            }
            
        } else if (gesture.state == .changed){
            handleGestureChange(gesture: gesture)
        }
            
    }
    
    func handleGestureChange(gesture: UILongPressGestureRecognizer) -> Void {
        // get the X,Y oof the touch relative to the container view specified
        let hoverLocation = gesture.location(in: self.iconsContainerView)
        print("Location of press: \(hoverLocation)")
        
        // If you want to hover outside
        let fixedLocation = CGPoint(x: hoverLocation.x, y: self.iconsContainerView.frame.height / 2)
        
        // perform hit test on the point
        if let hitTestView = iconsContainerView.hitTest(fixedLocation, with: nil){
            // check if hittest view is a uiimage view
            if hitTestView is UIImageView{
                // animate the views
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                    // bring back the icons back inside stack view
                    let stackView = self.iconsContainerView.subviews.first
                    stackView?.subviews.forEach({ (view) in
                        view.transform = .identity
                    })
                    // change the Y value of the icon image
                    hitTestView.transform = CGAffineTransform(translationX: 0, y: -50)
                } completion: { done in
                    print("icon animation complete")
                }

            }
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

