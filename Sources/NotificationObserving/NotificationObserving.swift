import Foundation
import AssociatedValues

/// Types that subscribe to the notification center.
public protocol NotificationObserving: AnyObject {
    /// Which notification center you get notified the events from.
    var notificationCenter: NotificationCenter { get }
    /// Throw all the observation tokens into it, so that you don't have to
    /// remove them from the notification center.
    var disposables: [ObservationToken] { get set }
    
    /// Set up an observer.
    ///
    /// You don't have to remove the observer.
    func observe(
        forName name: Notification.Name,
        object: Any?,
        queue: OperationQueue?,
        using closure: @escaping (Notification) -> Void
    )
}

private var disposablesKey: Void?

public extension NotificationObserving {
    var notificationCenter: NotificationCenter {
        .default
    }
    
    var disposables: [ObservationToken] {
        get {
            if let disposables: [ObservationToken] = Runtime.get(from: self, by: &disposablesKey) {
                return disposables
            }
            return []
        }
        set {
            Runtime.set(newValue, to: self, by: &disposablesKey)
        }
    }
    
    func observe(
        forName name: Notification.Name,
        object: Any?,
        queue: OperationQueue?,
        using closure: @escaping (Notification) -> Void
    ) {
        disposables.append(
            ObservationToken(
                observer: notificationCenter.addObserver(
                    forName: name,
                    object: object,
                    queue: queue,
                    using: closure
                ),
                center: notificationCenter
            )
        )
    }
}
