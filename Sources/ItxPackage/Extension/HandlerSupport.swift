import Foundation
import UIKit


private class Handler<T: AnyObject> {
    private let callback: (T) -> Void
    private weak var object: T?
    
    public init(object: T, callback: @escaping (T) -> Void) {
        self.object = object
        self.callback = callback
    }
    
    public lazy var selector: Selector = {
        #selector(handler)
    }()
    
    @objc private func handler() {
        guard let object = object else { return }
        callback(object)
    }
}

fileprivate enum AssociatedKeys {
    public static var handlers = "__handlers__"
}

public protocol HandlerSupport: AnyObject {}

extension HandlerSupport where Self: UIControl {
    fileprivate var handlers: Array<Handler<Self>> {
        set(config) {
            objc_setAssociatedObject(self, &AssociatedKeys.handlers, config, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.handlers) as? [Handler<Self>] ?? []
        }
    }
    
    @discardableResult
    public func on(event: UIControl.Event, do callback: @escaping (Self) -> Void) -> Self {
        let handler = Handler<Self>(object: self, callback: callback)
        addTarget(handler, action: handler.selector, for: event)
        handlers.append(handler)
        return self
    }
}

extension HandlerSupport where Self: UIButton {
    @discardableResult
    public func onTap(do callback: @escaping (Self) -> Void) -> Self {
        let handler = Handler<Self>(object: self, callback: callback)
        addTarget(handler, action: handler.selector, for: .touchUpInside)
        handlers.append(handler)
        return self
    }
}

extension HandlerSupport where Self: UISlider {
    @discardableResult
    public func onTap(do callback: @escaping (Self) -> Void) -> Self {
        let handler = Handler<Self>(object: self, callback: callback)
        addTarget(handler, action: handler.selector, for: .valueChanged)
        handlers.append(handler)
        return self
    }
}

extension HandlerSupport where Self: UIView {
    @discardableResult
    public func onTap(do callback: @escaping () -> Void) -> Self {
        addGestureRecognizer(UITapGestureRecognizer().onChange(do: { _ in
            callback()
        }))
        return self
    }
}

extension HandlerSupport where Self: UIGestureRecognizer {
    fileprivate var handlers: Array<Handler<Self>> {
        set(config) {
            objc_setAssociatedObject(self, &AssociatedKeys.handlers, config, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.handlers) as? [Handler<Self>] ?? []
        }
    }
    
    @discardableResult
    func onChange(do callback: @escaping (Self) -> Void) -> Self {
        let handler = Handler<Self>(object: self, callback: callback)
        addTarget(handler, action: handler.selector)
        handlers.append(handler)
        return self
    }
}

extension HandlerSupport where Self: UIBarButtonItem {
    fileprivate var handlers: Array<Handler<Self>> {
        set(config) {
            objc_setAssociatedObject(self, &AssociatedKeys.handlers, config, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.handlers) as? [Handler<Self>] ?? []
        }
    }
    
    static func closeButton(callback: @escaping (Self) -> Void) -> Self {
        let btn = Self(image: UIImage(named: "Close_Icon"), style: .plain, target: nil, action: nil)
        let handler = Handler<Self>(object: btn, callback: callback)
        btn.handlers.append(handler)
        btn.target = handler
        btn.action = handler.selector
        return btn
    }
}

extension UIControl: HandlerSupport {}
extension UIBarButtonItem: HandlerSupport {}
extension UIGestureRecognizer: HandlerSupport {}
