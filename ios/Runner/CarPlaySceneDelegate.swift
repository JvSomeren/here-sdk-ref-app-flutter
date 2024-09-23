import CarPlay

// `CarPlaySceneDelegate` manages the lifecycle events for the CarPlay scenes.
class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
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

        // CarPlay window has been connected. Set up the view controller for it and a map template.
        interfaceController.setRootTemplate(carPlayMapTemplate, animated: true)
        // CarPlayViewController is main view controller for the provided CPWindow.
        window.rootViewController = carPlayViewController
    }

    /// Conform to `CPTemplateApplicationSceneDelegate`, needed for CarPlay.
    /// Called when the CarPlay interface is disconnected.
    /// Use this method to clean up resources related to the CarPlay interface.
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnect interfaceController: CPInterfaceController,
                                  from window: CPWindow) {
        // Handle disconnection from CarPlay.
    }
}
