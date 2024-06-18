//
//  PageControlSwipeViewViewController.swift
//  PageControl
//
//  Created by Oğuz Canbaz on 16.06.2024.
//

// MARK: -- Enums
enum AnimationDirection {
    case left
    case right
    case none
}

import UIKit

class PageControlPanViewViewController: UIViewController {
    
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        swipeView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            isPanning = true
            break
        case .changed:
            guard isPanning else { return }
            
            let translation = gesture.translation(in: swipeView)
            let progress = translation.x / swipeView.bounds.width
            
            
            if translation.x < 0 {
                if adjacentView == nil {
                    adjacentView = createViewForPage(currentPage + 1)
                    adjacentView!.frame = swipeView.bounds
                    swipeView.addSubview(adjacentView!)
                }
            } else {
                if adjacentView == nil {
                    adjacentView = createViewForPage(currentPage - 1)
                    adjacentView!.frame = swipeView.bounds
                    swipeView.addSubview(adjacentView!)
                }
            }
            currentView!.transform = CGAffineTransform(translationX: translation.x, y: 0)
            adjacentView!.transform = CGAffineTransform(translationX: translation.x + (translation.x < 0 ? swipeView.bounds.width : -swipeView.bounds.width), y: 0)
            
        case .ended:
            guard isPanning else { return }
            isPanning = false
            
            let translation = gesture.translation(in: swipeView)
            
            if abs(translation.x) >= swipeView.bounds.width / 2 {
                if translation.x < 0 {
                    if currentPage < 2{
                        currentPage = min(currentPage + 1, totalPageNumber - 1)
                        updateView(animated: true, direction: .left)
                    }else{
                        UIView.animate(withDuration: 0.5, animations: {
                            self.currentView!.transform = .identity
                            self.adjacentView!.transform = CGAffineTransform(translationX: (translation.x < 0 ? self.swipeView.bounds.width : -self.swipeView.bounds.width), y: 0)
                        }, completion: { _ in
                            self.adjacentView!.removeFromSuperview()
                            self.adjacentView = nil
                        })
                    }
                } else {
                    if currentPage > 0 {
                        currentPage = max(currentPage - 1, 0)
                        updateView(animated: true, direction: .right)
                    }else{
                        UIView.animate(withDuration: 0.5, animations: {
                            self.currentView!.transform = .identity
                            self.adjacentView!.transform = CGAffineTransform(translationX: (translation.x < 0 ? self.swipeView.bounds.width : -self.swipeView.bounds.width), y: 0)
                        }, completion: { _ in
                            self.adjacentView!.removeFromSuperview()
                            self.adjacentView = nil
                        })
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.currentView!.transform = .identity
                    self.adjacentView!.transform = CGAffineTransform(translationX: (translation.x < 0 ? self.swipeView.bounds.width : -self.swipeView.bounds.width), y: 0)
                }, completion: { _ in
                    self.adjacentView!.removeFromSuperview()
                    self.adjacentView = nil
                })
            }
            
        default:
            break
        }
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
                self.currentView = newView
                self.adjacentView = nil
            })
        } else {
            swipeView.subviews.forEach { $0.removeFromSuperview() }
            swipeView.addSubview(newView)
            currentView = newView
            adjacentView = nil
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
