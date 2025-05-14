//
//  Extensions.swift
//  GitHubRepositories
//
//  Created by Filipe de Souza on 09/05/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public extension UIView {
    
    enum AnchorType {
        case top
        case bottom
        case leading
        case trailing
        case heigth
        case width
        case centerX
        case centerY
    }
    
    func addSubviews(_ subviews: [UIView], constraints: Bool) {
        
        for subview in subviews {
            
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = !constraints
        }
    }
    
    func addSubview(_ subview: UIView, constraints: Bool) {
        
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = !constraints
    }
    
    func anchors(equalTo view: UIView) {
        
        self.applyAnchors(ofType: [.top, .bottom, .leading, .trailing], to: view)
    }
    
    // MARK: - Anchors extensions

    func applyAnchors(ofType: [AnchorType], to referenceView: UIView) {
        
        if ofType.contains(.bottom) {
            self.bottomAnchor.constraint(equalTo: referenceView.bottomAnchor).isActive = true
        }
        
        if ofType.contains(.top) {
            self.topAnchor.constraint(equalTo: referenceView.topAnchor).isActive = true
        }
        
        if ofType.contains(.trailing) {
            self.trailingAnchor.constraint(equalTo: referenceView.trailingAnchor).isActive = true
        }
        
        if ofType.contains(.leading) {
            self.leadingAnchor.constraint(equalTo: referenceView.leadingAnchor).isActive = true
        }
        
        if ofType.contains(.heigth) {
            self.heightAnchor.constraint(equalTo: referenceView.heightAnchor).isActive = true
        }
        
        if ofType.contains(.width) {
            self.widthAnchor.constraint(equalTo: referenceView.widthAnchor).isActive = true
        }
        
        if ofType.contains(.centerX) {
            self.centerXAnchor.constraint(equalTo: referenceView.centerXAnchor).isActive = true
        }
        if ofType.contains(.centerY) {
            self.centerYAnchor.constraint(equalTo: referenceView.centerYAnchor).isActive = true
        }
    }
    
    @discardableResult func activateConstraints(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        return NSLayoutConstraint.activate(visualFormat, views: views, metrics: metrics)
    }
    
    func center(to view: UIView) {
        
        self.applyAnchors(ofType: [.centerX, .centerY], to: view)
    }
    
    @discardableResult
    func centerX(to: UIView, padding: CGFloat? = 0,
                 priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = centerXAnchor.constraint(equalTo: to.centerXAnchor,
                                              constant: padding ?? 0)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
}

public extension UIStackView {
    func addArrangedSubviews(views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}

fileprivate var ak_MyDisposeBag: UInt8 = 0

public extension UIViewController {
    
    // MARK: Public variables
    
    var myDisposeBag: DisposeBag {
        
        get {
            
            if let obj = objc_getAssociatedObject(self, &ak_MyDisposeBag) as? DisposeBag {
                return obj
            }
            let obj = DisposeBag()
            objc_setAssociatedObject(self, &ak_MyDisposeBag, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return obj
        }
        
        set(newValue) {
            
            objc_setAssociatedObject(self, &ak_MyDisposeBag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func layoutErrorView(errorView: ErrorView, buttonAction: ActionVoid? = nil) {
        guard !errorView.isDescendant(of: view) else { return }
        view.addSubview(errorView, constraints: true)
        errorView.button.isHidden = buttonAction == nil
        errorView.buttonAction = buttonAction
        errorView.center(to: view)
        errorView.alpha = 0
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UITableView {
    func updateTableHeaderViewHeight(completion: ((CGSize) -> Void)? = nil) {
        guard let headerView = tableHeaderView else { return }
        
        for view in headerView.subviews {
            guard let label = view as? UILabel, label.numberOfLines == 0 else { continue }
            label.preferredMaxLayoutWidth = label.frame.width
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableHeaderView = headerView
            completion?(size)
        }
    }
}

extension SharedSequence {
    public func unwrap<Result>() -> SharedSequence<SharingStrategy, Result> where Element == Result? {
        return self.filter { $0 != nil }.map { $0! }
    }
}

public extension NSLayoutConstraint {
    class func constraints(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        return visualFormat.split(separator: ";")
            .map {
                NSLayoutConstraint.constraints(withVisualFormat: String($0), options: [], metrics: metrics, views: views)
            }.flatMap{$0}
    }
    
    @discardableResult class func activate(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        let arr = visualFormat
            .split(separator: ";")
            .map { NSLayoutConstraint.constraints(String($0), views: views, metrics: metrics) }
            .flatMap{$0}
                
        NSLayoutConstraint.activate(arr)
        return arr
    }
}

public extension UIColor {
    func asImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }

    func hueColorWithBrightnessAmount(_ amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue,
                           saturation: saturation,
                           brightness: brightness * (1 + amount),
                           alpha: alpha)
        } else {
            return self
        }
    }
}

public extension Bool {
    var isFalse: Bool {
        return self == false
    }
}

protocol CEmptyable {
    var isNotEmpty: Bool { get }
}

extension String: CEmptyable {
    var isNotEmpty: Bool {
        isEmpty.isFalse
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var duplicates: Set<Iterator.Element> = []
        return filter { duplicates.insert($0).inserted }
    }
}

public extension String {
    func date(format: String) -> Date? {

        let df = DateFormatter()
        df.dateFormat = format

        if let date = df.date(from: self) {

            return date
        }
        df.calendar = Calendar(identifier: .iso8601)
        return df.date(from: self)
    }
}
