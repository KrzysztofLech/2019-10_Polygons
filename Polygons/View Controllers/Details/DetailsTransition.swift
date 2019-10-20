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
    private let totalTransitionDuration: Double = 10.0
    
    private var listViewController: ListViewController?
    private var detailsViewController: DetailsViewController?
    private var transitionContext: UIViewControllerContextTransitioning?
    
    private var personView: UIView?
    
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
    
    // MARK: - Present animation -
    
    private func showListViewControllerAnimations(completion: ( ()->() )? = nil) {
        guard
            let detailsViewController = detailsViewController,
            let detailsView = detailsViewController.view
            else { return }
        
        //let alphaValue: CGFloat = isPresenting ? 0.0 : 1.0
        
        transitionContext?.containerView.addSubview(detailsView)
        personView = createPersonView()
        detailsView.isHidden = true
        
        
        let scaleValue = getScaleValue(forSize: selectedCellFrame.size)
        personView?.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
        personView?.frame = selectedCellFrame
        
        
        UIView.animate(withDuration: totalTransitionDuration / 4, animations: {
            self.listViewControllerObjectsToHide.forEach { $0.alpha = 0.0 }
         }) {_ in
            
            self.listViewController?.view.addSubview(self.personView!)
            self.hideSelectedCell()
            
            let transformIdentity = CGAffineTransform.identity
            let transformTranslation = CGAffineTransform(translationX: 0, y: -200)
            
            UIView.animate(withDuration: self.totalTransitionDuration / 2, animations: {
                self.personView?.transform = transformIdentity.concatenating(transformTranslation)
            }) { _ in
                //completion?()
            }
            
//            if self.isPresenting {
//                detailsView.isHidden = false
//                self.transitionContext?.containerView.addSubview(detailsViewController.view)
//                detailsViewController.view.addSubview(self.createPersonView())
//            }

//            completion?()

            if !self.isPresenting { self.finishTransition() }
         }
    }
    
    
    private func showDetailsViewControllerAnimations(completion: ( ()->() )? = nil) {
        guard let listViewController = listViewController else { return }
          
        
        detailsViewController?.view.alpha = 0.0
        
        //let alphaValue: CGFloat = isPresenting ? 1.0 : 0.0
        
        //detailsViewController?.buttonsView.alpha = isPresenting ? 0.0 : 1.0
        //detailsViewController?.personView.alpha = isPresenting ? 0.0 : 1.0
        
        UIView.animate(withDuration: totalTransitionDuration / 2, animations: {
            //self.detailsViewController?.buttonsView.alpha = alphaValue
            //self.detailsViewController?.personView.alpha = alphaValue
            
            self.detailsViewController?.view.alpha = 1.0
            
         }) {_ in
            
            self.personView?.removeFromSuperview()
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
    
    
    // MARK: -
    
    private func createPersonView() -> UIView {
        guard
            let detailsViewController = detailsViewController,
            let personView = detailsViewController.personView.snapshotView(afterScreenUpdates: true)
            else { return UIView() }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = detailsViewController.data.path.cgPath
        personView.layer.mask = maskLayer
                
        return personView
    }
    
    private var selectedCellFrame: CGRect {
        guard
            let listViewController = listViewController,
            let detailsViewController = detailsViewController
            else { return .zero }

        let selectedCellIndex = detailsViewController.data.index
        let cell = listViewController.collectionView.cellForItem(at: IndexPath(item: selectedCellIndex, section: 0)) ?? UICollectionViewCell()
        let convertedFrame = listViewController.collectionView.convert(cell.frame, to: listViewController.view)
        
        return convertedFrame
    }
    
    private func getScaleValue(forSize size: CGSize) -> CGFloat {
        guard
            let personViewWidth = personView?.bounds.width,
            personViewWidth > 0
            else { return 0 }
        
        let selectedCellWidth = size.width
        let scaleValue = selectedCellWidth / personViewWidth
        
        return scaleValue
    }
    
    private var detailsPersonViewFrame: CGRect {
        guard let detailsViewController = detailsViewController else { return .zero }
        return detailsViewController.personView.frame
    }
    
    private var listViewControllerObjectsToHide: [UIView] {
        guard
            let listViewController = listViewController,
            let detailsViewController = detailsViewController
            else { return [] }
        
        var array: [UIView] = []
        array.append(listViewController.topView)
        
        let selectedCellIndex = detailsViewController.data.index
        let selectedCell = listViewController.collectionView.cellForItem(at: IndexPath(item: selectedCellIndex, section: 0))
        let visibleCells = listViewController.collectionView.visibleCells.filter { $0 != selectedCell }
        array.append(contentsOf: visibleCells)
        
        return array
    }
    
    private func hideSelectedCell() {
        guard
            let listViewController = listViewController,
            let detailsViewController = detailsViewController
            else { return }
                
        let selectedCellIndex = detailsViewController.data.index
        let selectedCell = listViewController.collectionView.cellForItem(at: IndexPath(item: selectedCellIndex, section: 0))
        selectedCell?.alpha = 0.0
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
