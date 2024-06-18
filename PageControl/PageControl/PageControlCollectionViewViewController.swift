//
//  PageControlCollectionViewViewController.swift
//  PageControl
//
//  Created by Oğuz Canbaz on 16.06.2024.
//

import UIKit

class PageControlCollectionViewViewController: UIViewController {
    
    // MARK: -- Components
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControlCollectionView:UIPageControl!
    
    // MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        
    }
    
    // MARK: -- Functions
    
    private func prepareCollectionView() {
        let FirstViewCell = UINib(nibName: "FirstViewCell", bundle: nil)
        collectionView.register(FirstViewCell, forCellWithReuseIdentifier: "FirstViewCell")
        
        let SecondViewCell = UINib(nibName: "SecondViewCell", bundle: nil)
        collectionView.register(SecondViewCell, forCellWithReuseIdentifier: "SecondViewCell")
        
        let ThirdViewCell = UINib(nibName: "ThirdViewCell", bundle: nil)
        collectionView.register(ThirdViewCell, forCellWithReuseIdentifier: "ThirdViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
}

// MARK: -- Extensions

extension PageControlCollectionViewViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstViewCell", for: indexPath) as! FirstViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondViewCell", for: indexPath) as! SecondViewCell
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirdViewCell", for: indexPath) as! ThirdViewCell
            return cell
        default:
            fatalError("Unexpected index path")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(collectionView.contentOffset.x / collectionView.frame.width)
        pageControlCollectionView.currentPage = Int(pageIndex)
    }
}



