import heresdk
import UIKit

// This is the view controller shown on the car's head unit display with CarPlay.
class CarPlayViewController: UIViewController {

    var mapView : MapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize MapView without a storyboard.
        mapView = MapView(frame: view.bounds)
        view.addSubview(mapView)

        // Load the map scene using a map scheme to render the map with.
        mapView.mapScene.loadScene(mapScheme: MapScheme.normalDay, completion: onLoadScene)
    }

    // Completion handler when loading a map scene.
    private func onLoadScene(mapError: MapError?) {
        guard mapError == nil else {
            print("Error: Map scene not loaded, \(String(describing: mapError))")
            return
        }

        // Configure the map.
        let camera = mapView.camera
        let distanceInMeters = MapMeasure(kind: .distance, value: 1000 * 7)
        camera.lookAt(point: GeoCoordinates(latitude: 52.518043, longitude: 13.405991), zoom: distanceInMeters)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView.handleLowMemory()
    }
}
