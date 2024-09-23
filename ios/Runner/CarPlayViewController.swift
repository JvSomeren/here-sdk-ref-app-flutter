import heresdk
import here_sdk
import UIKit

// This is the view controller shown on the car's head unit display with CarPlay.
class CarPlayViewController: UIViewController {

    var mapView : MapView!
    var mapViewHost : MapViewHost!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize MapView without a storyboard.
        mapView = MapView(frame: view.bounds)
        view.addSubview(mapView)

        if let flutterEngine = iPhoneSceneDelegate.flutterEngine {
            mapViewHost = MapViewHost(
                viewIdentifier: 123,
                binaryMessenger: flutterEngine.binaryMessenger,
                mapView: mapView
            )
            
            CarToFlutterApi(binaryMessenger: flutterEngine.binaryMessenger).setupMapView { _ in }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView.handleLowMemory()
    }
}
