//
//  BestScoresViewController.swift
//  Cities
//
//  Created by Влад Казмирчук on 2/18/20.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import UIKit

class BestScoresViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    deinit {
        print("Best scores deinited")
    }
    
    private var continueButton: UIButton!
    private var pageControl: UIPageControl!
    
    private let backgroundAnimationTime = 0.25
    private let constraintConfigurator = ConstraintConfiguratorBestScores()
    
    var gamesScores: [GameBestScoresVC] = []
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        self.view.backgroundColor = .clear
        
        if let firstGame = gamesScores.first {
            setViewControllers([firstGame], direction: .forward, animated: true, completion: nil)
        }
        
        continueButton = UIButton()
        self.view.addSubview(continueButton)
        
        pageControl = UIPageControl()
        self.view.addSubview(pageControl)
        
        pageControl.numberOfPages = gamesScores.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = Constants.colors.veryLightGray
        pageControl.currentPageIndicatorTintColor = Constants.colors.main
        
        continueButton.backgroundColor = Constants.colors.main
        continueButton.setTitle(translate("continue"), for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        continueButton.addTarget(self, action: #selector(continueClicked(sender:)), for: .touchUpInside)
        
        constraintConfigurator.setupContinueButton(button: continueButton, in: self.view)
        constraintConfigurator.setupPageControl(pageControl, in: self.view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: backgroundAnimationTime) {
            self.view.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 0.55)
        }
    }
    
    //MARK: - Logic
    
    @objc func continueClicked(sender: UIButton) {
        UIView.animate(withDuration: backgroundAnimationTime, animations: {
            self.view.backgroundColor = .clear
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let gameScores = viewController as? GameBestScoresVC else { return nil }
        guard let currentIndex = gamesScores.firstIndex(of: gameScores) else { return nil }
        if (currentIndex+1) < gamesScores.count {
            return gamesScores[currentIndex+1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let gameScores = viewController as? GameBestScoresVC else { return nil }
        guard let currentIndex = gamesScores.firstIndex(of: gameScores) else { return nil }
        if (currentIndex-1) >= 0 {
            return gamesScores[currentIndex-1]
        } else {
            return nil
        }
    }
    
    var pendingIndex = 0
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let game = pendingViewControllers.first as? GameBestScoresVC else { return }
        if let nextIndex = gamesScores.firstIndex(of: game) {
            pendingIndex = nextIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            pageControl.currentPage = pendingIndex
        }
    }

}
