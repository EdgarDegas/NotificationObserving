import XCTest
import Quick
import Nimble
import Foundation
@testable import NotificationObserving

let testCenter = TestNotificationCenter()

class Tests: QuickSpec {
  var notificationObservingExample: NotificationObservingExample!
  var updatedByClosure = false
  var observer: NSObjectProtocol?
  
  override func spec() {
    describe("Set up observer") { [self] in
      context("on TestName") {
        it("the name should be in the text center") {
          observe()
          expect(testCenter.observedName?.rawValue).to(equal("TestName"))
          expect(testCenter.observedQueue).to(be(OperationQueue.main))
          expect(testCenter.observedObject as? String).to(equal("Demo Object"))
          testCenter.observedClosure?(.init(name: .init(rawValue: "")))
          expect(updatedByClosure).to(be(true))
        }
        
        it("the observers should be in disposables") {
          observe()
          expect(notificationObservingExample.disposables.count).to(equal(1))
        }
      }
      
      context("then deinit") { [self] in
        it("the observer should've been removed") {
          observe()
          self.observer = notificationObservingExample.disposables.first!.observer
          weak var exampleWeakRef = notificationObservingExample
          notificationObservingExample = nil
          expect(exampleWeakRef).to(beNil())
          expect(testCenter.removedObserver).to(be(observer))
        }
      }
    }
  }
  
  func observe() {
    notificationObservingExample = .init()
    notificationObservingExample.observe(
      forName: .init("TestName"),
      object: "Demo Object",
      queue: .main
    ) { _ in
      self.updatedByClosure = true
    }
  }
}

class NotificationObservingExample: NotificationObserving {
    var disposables: [ObservationToken] = []
    var notificationCenter: NotificationCenter {
        testCenter
    }
}

class TestNotificationCenter: NotificationCenter {
    var observedName: Notification.Name?
    var observedObject: Any?
    var observedQueue: OperationQueue?
    var observedClosure: ((Notification) -> Void)?
    
    override func addObserver(
        forName name: Notification.Name?,
        object: Any?,
        queue: OperationQueue?,
        using closure: @escaping (Notification) -> Void
    ) -> NSObjectProtocol {
        self.observedName = name
        self.observedQueue = queue
        self.observedObject = object
        self.observedClosure = closure
        return super.addObserver(forName: name, object: object, queue: queue, using: closure)
    }
    
    var removedObserver: Any?
    override func removeObserver(_ observer: Any) {
        super.removeObserver(observer)
        self.removedObserver = observer
    }
}
