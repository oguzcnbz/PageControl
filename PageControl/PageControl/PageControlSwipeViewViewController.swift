//
//  PageControlSwipeViewViewController.swift
//  PageControl
//
//  Created by Oğuz Canbaz on 16.06.2024.
//

import UIKit

class PageControlSwipeViewViewController: UIViewController {
    
    // MARK: -- Components
    
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var pageControlSwipeView: UIPageControl!
    
    // MARK: -- Properties
    
    var currentPage = 0
    let totalPageNumber = 3
    
    var currentView: UIView?
    var adjacentView: UIView?
    var isPanning = false
    
    // MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGestures()
        updateView(animated: false, direction: .none)
    }
    
    // MARK: -- Functions
    
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeView.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let direction: AnimationDirection = gesture.direction == .left ? .left : .right
        if gesture.direction == .left {
            if currentPage < pageControlSwipeView.numberOfPages - 1 {
                currentPage += 1
            }
        } else if gesture.direction == .right {
            if currentPage > 0 {
                currentPage -= 1
            }
        }
        updateView(animated: true, direction: direction)
    }
    
    func updateView(animated: Bool, direction: AnimationDirection) {
        
        let newView = createViewForPage(currentPage)
        newView.frame = swipeView.bounds
        
        if animated {
            let offset: CGFloat = direction == .left ? swipeView.frame.width : -swipeView.frame.width
            newView.transform = CGAffineTransform(translationX: offset, y: 0)
            swipeView.addSubview(newView)
            
            UIView.animate(withDuration: 0.5, animations: {
                
                newView.transform = .identity
                for subview in self.swipeView.subviews where subview != newView {
                    subview.transform = CGAffineTransform(translationX: -offset, y: 0)
                }
            }, completion: { _ in
                
                for subview in self.swipeView.subviews where subview != newView {
                    subview.removeFromSuperview()
                }
            })
        } else {
            swipeView.addSubview(newView)
        }
        pageControlSwipeView.currentPage = currentPage
    }
    
    func createViewForPage(_ page: Int) -> UIView {
        var view = UIView()
        switch page {
        case 0:
            view = Bundle.main.loadNibNamed("FirstPageView", owner: self, options: nil)?.first as! UIView
        case 1:
            view = Bundle.main.loadNibNamed("SecondPageView", owner: self, options: nil)?.first as! UIView
        case 2:
            view = Bundle.main.loadNibNamed("ThirdPageView", owner: self, options: nil)?.first as! UIView
        default:
            return view
        }
        return view
    }
}
