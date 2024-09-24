protocol GenericDelegate: AnyObject {
    func onStartRouting()
}

protocol RoutingDelegate: AnyObject {
    func onRouteOptionsUpdated(message: PgRouteOptionsUpdatedMessage)
    func onRouteOptionSelected(routeOptionIndex: Int64)
    func onStopRouting()
}

private struct WeakGenericDelegate {
    weak var value: GenericDelegate?
    
    init(_ value: GenericDelegate) {
        self.value = value
    }
}

private struct WeakRoutingDelegate {
    weak var value: RoutingDelegate?
    
    init(_ value: RoutingDelegate) {
        self.value = value
    }
}

class FlutterToCar: FlutterToCarApi {
    private init() {}
    
    static let shared = FlutterToCar()
    
    // MARK: delegate methods
    
    private var genericDelegates: Array<WeakGenericDelegate> = Array()
    
    func addDelegate(delegate: GenericDelegate) {
        genericDelegates.append(WeakGenericDelegate(delegate))
        
        // reap disposed delegates
        genericDelegates.removeAll { $0.value == nil }
    }
    
    func removeDelegate(delegate: GenericDelegate) {
        if let index = genericDelegates.firstIndex(where: { $0.value === delegate}) {
            genericDelegates.remove(at: index)
        }
    }
    
    private var routingDelegates: Array<WeakRoutingDelegate> = Array()
    
    func addDelegate(delegate: RoutingDelegate) {
        routingDelegates.append(WeakRoutingDelegate(delegate))
        
        // reap disposed delegates
        routingDelegates.removeAll { $0.value == nil }
    }
    
    func removeDelegate(delegate: RoutingDelegate) {
        if let index = routingDelegates.firstIndex(where: { $0.value === delegate}) {
            routingDelegates.remove(at: index)
        }
    }
    
    // MARK: FlutterToCarApi methods
    
    func onStartRouting() throws {
        for delegate in genericDelegates {
            delegate.value?.onStartRouting()
        }
    }
    
    func onRouteOptionsUpdated(message: PgRouteOptionsUpdatedMessage) throws {
        for delegate in routingDelegates {
            delegate.value?.onRouteOptionsUpdated(message: message)
        }
    }
    
    func onRouteOptionSelected(routeOptionIndex: Int64) throws {
        for delegate in routingDelegates {
            delegate.value?.onRouteOptionSelected(routeOptionIndex: routeOptionIndex)
        }
    }
    
    func onStopRouting() throws {
        for delegate in routingDelegates {
            delegate.value?.onStopRouting()
        }
    }
}
