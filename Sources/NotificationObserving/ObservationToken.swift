import Foundation

/// Wrapper of an `NSObjectProtocol`, which usually is a token of an observation.
///
/// When this object deinitialize, the token gets removed from the notification center.
public final class ObservationToken {
    public let observer: NSObjectProtocol
    public weak var center: NotificationCenter?
    
    public init(observer: NSObjectProtocol, center: NotificationCenter) {
        self.observer = observer
        self.center = center
    }
    
    deinit {
        center?.removeObserver(observer)
    }
}

public extension NotificationCenter {
    func addObserver(
        forName name: Notification.Name,
        object: Any?,
        queue: OperationQueue?,
        using closure: @escaping (Notification) -> Void
    ) -> ObservationToken {
        ObservationToken(
            observer: addObserver(
                forName: name,
                object: object,
                queue: queue,
                using: closure
            ),
            center: self
        )
    }
}
