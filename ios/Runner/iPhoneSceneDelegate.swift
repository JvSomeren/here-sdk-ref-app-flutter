// `iPhoneSceneDelegate` manages the lifecycle events of a UI scene for the application.
class iPhoneSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static private(set) var flutterEngine: FlutterEngine? = nil

    var window: UIWindow?

    /// Called when a new scene session is being created and associated with the app.
    /// This method sets up the initial content and configuration for the scene using Storyboards.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        
        // Manually create a FlutterEngine and FlutterViewController.
        let flutterEngine = FlutterEngine(name: "SceneDelegateEngine")
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        let controller = FlutterViewController.init(engine: flutterEngine, nibName: nil, bundle: nil)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        iPhoneSceneDelegate.flutterEngine = flutterEngine
        
        FlutterToCarApiSetup.setUp(
            binaryMessenger: flutterEngine.binaryMessenger,
            api: FlutterToCar.shared
        )
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        if let flutterEngine = iPhoneSceneDelegate.flutterEngine {
            FlutterToCarApiSetup.setUp(
                binaryMessenger: flutterEngine.binaryMessenger,
                api: nil
            )
            
            flutterEngine.destroyContext()
            iPhoneSceneDelegate.flutterEngine = nil
        }
    }
}
