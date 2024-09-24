import CarPlay

// `CarPlaySceneDelegate` manages the lifecycle events for the CarPlay scenes.
class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate,
                            CPMapTemplateDelegate, GenericDelegate, RoutingDelegate {
    var interfaceController: CPInterfaceController?
    var carPlayWindow: CPWindow?
    let carPlayMapTemplate = CPMapTemplate()
    let carPlayViewController = CarPlayViewController()

    /// Conform to `CPTemplateApplicationSceneDelegate`, needed for CarPlay.
    /// Called when the CarPlay interface controller connects and a new window for CarPlay is created.
    /// Initializes the view controller for CarPlay and sets up the root template with necessary UI elements.
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didConnect interfaceController: CPInterfaceController,
                                  to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carPlayWindow = window
        
        carPlayMapTemplate.mapDelegate = self

        // CarPlay window has been connected. Set up the view controller for it and a map template.
        interfaceController.setRootTemplate(carPlayMapTemplate, animated: true)
        // CarPlayViewController is main view controller for the provided CPWindow.
        window.rootViewController = carPlayViewController
        
        FlutterToCar.shared.addDelegate(delegate: self as GenericDelegate)
        FlutterToCar.shared.addDelegate(delegate: self as RoutingDelegate)
    }

    /// Conform to `CPTemplateApplicationSceneDelegate`, needed for CarPlay.
    /// Called when the CarPlay interface is disconnected.
    /// Use this method to clean up resources related to the CarPlay interface.
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnect interfaceController: CPInterfaceController,
                                  from window: CPWindow) {
        // Handle disconnection from CarPlay.
        
        carPlayMapTemplate.mapDelegate = nil
        
        FlutterToCar.shared.removeDelegate(delegate: self as GenericDelegate)
        FlutterToCar.shared.removeDelegate(delegate: self as RoutingDelegate)

        if let flutterEngine = iPhoneSceneDelegate.flutterEngine {
            CarToFlutterApi(binaryMessenger: flutterEngine.binaryMessenger).onDisconnect { _ in }
        }
    }
    
    // MARK: Helpers
        
    private func tripPreviewTextConfiguration() -> CPTripPreviewTextConfiguration {
        return CPTripPreviewTextConfiguration(
            startButtonTitle: "Unimplemented",
            additionalRoutesButtonTitle: nil,
            overviewButtonTitle: nil
        )
    }
    
    // MARK: CPMapTemplateDelegate
    
    func mapTemplate(
        _ mapTemplate: CPMapTemplate,
        selectedPreviewFor trip: CPTrip,
        using routeChoice: CPRouteChoice
    ) {
        let index = trip.routeChoices.firstIndex(of: routeChoice)
        
        if let flutterEngine = iPhoneSceneDelegate.flutterEngine {
            CarToFlutterApi(binaryMessenger: flutterEngine.binaryMessenger)
                .updateSelectedRouteOption(routeOptionIndex: Int64(index!)) { _ in }
        }
    }
    
    // MARK: GenericDelegate
    
    func onStartRouting() {
        if #available(iOS 14.0, *) {
            carPlayMapTemplate.backButton = CPBarButton(title: "Back") { [weak self] _ in
                if let flutterEngine = iPhoneSceneDelegate.flutterEngine {
                    CarToFlutterApi(binaryMessenger: flutterEngine.binaryMessenger).stopRouting { _ in }
                }
                
                self?.carPlayMapTemplate.hideTripPreviews()
                self?.carPlayMapTemplate.backButton = nil
            }
        } else {
            let button = CPBarButton(type: .text) { [weak self] _ in
                if let flutterEngine = iPhoneSceneDelegate.flutterEngine {
                    CarToFlutterApi(binaryMessenger: flutterEngine.binaryMessenger).stopRouting { _ in }
                }
                
                self?.carPlayMapTemplate.hideTripPreviews()
                self?.carPlayMapTemplate.backButton = nil
            }
            button.title = "Back"
            carPlayMapTemplate.backButton = button
        }
        
        carPlayMapTemplate.showTripPreviews([], textConfiguration: tripPreviewTextConfiguration())
    }
    
    // MARK: RoutingDelegate
    
    func onRouteOptionsUpdated(message: PgRouteOptionsUpdatedMessage) {
        let trip = CPTrip(
            origin: MKMapItem(from: message.origin),
            destination: MKMapItem(from: message.destination),
            routeChoices: message.routeOptions
                .filter { $0 != nil }
                .map({ routeOption in
                    let routeChoice = CPRouteChoice(
                        summaryVariants: [routeOption!.durationString],
                        additionalInformationVariants: [routeOption!.distanceString],
                        selectionSummaryVariants: []
                    )
                    
                    return routeChoice
                })
        )
        carPlayMapTemplate.showRouteChoicesPreview(
            for: trip,
            textConfiguration: tripPreviewTextConfiguration()
        )
    }
    
    func onRouteOptionSelected(routeOptionIndex: Int64) {
        // No API is provided to programmatically change the selected routeOption.
        // Implementing an alternative solution is out of the scope of this article.
    }
    
    func onStopRouting() {
        carPlayMapTemplate.hideTripPreviews()
        carPlayMapTemplate.backButton = nil
    }
}

extension MKMapItem {
    convenience init(from pgLatLng: PgLatLng) {
        self.init(
            placemark: MKPlacemark(
                coordinate: CLLocationCoordinate2D(
                    latitude: pgLatLng.latitude,
                    longitude: pgLatLng.longitude
                )
            )
        )
    }
}
