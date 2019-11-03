//
//  DetailsTransition.swift
//  Polygons
//
//  Created by Krzysztof Lech on 18/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class DetailsTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var isPresenting = false
    private let totalTransitionDuration: Double = 2.0
    
    private var listViewController: ListViewController?
    private var detailsViewController: DetailsViewController?
    private var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return totalTransitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else { return }

        self.transitionContext = transitionContext
        toViewController.view.frame = fromViewController.view.frame
        
        if isPresenting {
            
            listViewController = fromViewController as? ListViewController
            detailsViewController = toViewController as? DetailsViewController

            showListViewControllerAnimations { [weak self] in
                self?.showDetailsViewControllerAnimations()
            }
            
        } else {
            
            listViewController = toViewController as? ListViewController
            detailsViewController = fromViewController as? DetailsViewController
            
            showDetailsViewControllerAnimations { [weak self] in
                self?.showListViewControllerAnimations()
            }
        }
    }
    
    private func showListViewControllerAnimations(completion: ( ()->() )? = nil) {
        guard let detailsViewController = detailsViewController else { return }
        
        let alphaValue: CGFloat = isPresenting ? 0.0 : 1.0
        
        UIView.animate(withDuration: totalTransitionDuration / 2, animations: {
            self.listViewController?.topView.alpha = alphaValue
            self.listViewController?.collectionView.alpha = alphaValue
         }) {_ in
            if self.isPresenting {
                self.transitionContext?.containerView.addSubview(detailsViewController.view)
            }
            
            completion?()
            
            if !self.isPresenting { self.finishTransition() }
         }
    }
    
    private func showDetailsViewControllerAnimations(completion: ( ()->() )? = nil) {
        guard let listViewController = listViewController else { return }
            
        let alphaValue: CGFloat = isPresenting ? 1.0 : 0.0
        
        detailsViewController?.buttonsView.alpha = isPresenting ? 0.0 : 1.0
        detailsViewController?.personView.alpha = isPresenting ? 0.0 : 1.0
        
        UIView.animate(withDuration: totalTransitionDuration / 2, animations: {
            self.detailsViewController?.buttonsView.alpha = alphaValue
            self.detailsViewController?.personView.alpha = alphaValue
         }) {_ in
            if !self.isPresenting {
                self.transitionContext?.containerView.addSubview(listViewController.view)
            }

            completion?()
            if self.isPresenting {self.finishTransition() }
        }
    }
    
    private func finishTransition() {
        guard let listViewController = listViewController else { return }
        
        transitionContext?.completeTransition(true)
        if !isPresenting {
            UIApplication.shared.keyWindow?.addSubview(listViewController.view)
        }
    }
}

extension DetailsTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
