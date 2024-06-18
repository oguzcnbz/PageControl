//
//  PageControlScrollViewViewController.swift
//  PageControl
//
//  Created by Oğuz Canbaz on 16.06.2024.
//

import UIKit

class PageControlScrollViewViewController: UIViewController {
    
    // MARK: -- Components
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControlScrollView: UIPageControl!
    
    // MARK: -- Properties
    
    var pages: [UIView] = []
    
    // MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareScrollView()
    }
    
    // MARK: -- Functions
    
    private func prepareScrollView() {
        scrollView.delegate = self
        
        if let firstPageView = Bundle.main.loadNibNamed("FirstPageView", owner: self, options: nil)?.first as? FirstPageView {
            pages.append(firstPageView)
        }
        
        if let SecondPageView = Bundle.main.loadNibNamed("SecondPageView", owner: self, options: nil)?.first as? SecondPageView {
            pages.append(SecondPageView)
        }
        
        if let ThirdPageView = Bundle.main.loadNibNamed("ThirdPageView", owner: self, options: nil)?.first as? ThirdPageView {
            pages.append(ThirdPageView)
        }
        
        for (index, page) in pages.enumerated() {
            page.frame = CGRect(x: scrollView.frame.width * CGFloat(index),
                                y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            scrollView.addSubview(page)
            
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pages.count),
                                        height: scrollView.frame.height)
    }
    
    // MARK: -- Action Functions
    
    @IBAction func setupPageControl(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let offset = CGPoint(x: scrollView.frame.width * CGFloat(currentPage), y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}

// MARK: -- Extensions

extension PageControlScrollViewViewController:UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControlScrollView.currentPage = pageIndex
    }
}

