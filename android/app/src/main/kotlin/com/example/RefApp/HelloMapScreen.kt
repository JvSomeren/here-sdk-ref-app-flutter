package com.example.RefApp

import androidx.car.app.AppManager
import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.SurfaceCallback
import androidx.car.app.SurfaceContainer
import androidx.car.app.model.Action
import androidx.car.app.model.ActionStrip
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.NavigationTemplate
import com.here.sdk.mapview.MapSurface
import com.here.sdk.mapview.MapSurfaceHost
import io.flutter.embedding.engine.FlutterEngineCache


class HelloMapScreen(carContext: CarContext) : Screen(carContext), SurfaceCallback {
    private val mapSurface: MapSurface
    private val mapSurfaceHost: MapSurfaceHost?
    private val carToFlutterApi: CarToFlutterApi?

    init {
        carContext.getCarService(AppManager::class.java).setSurfaceCallback(this)
        // The MapSurface works the same as the HereMapController we know from Flutter. It uses
        // a surface in order to draw the map to the screen.
        mapSurface = MapSurface()

        val binaryMessenger = FlutterEngineCache.getInstance()
            .get(MainActivity.FLUTTER_ENGINE_ID)
            ?.dartExecutor
            ?.binaryMessenger

        mapSurfaceHost = binaryMessenger?.let { MapSurfaceHost(123, it, mapSurface) }
        carToFlutterApi = binaryMessenger?.let { CarToFlutterApi(it) }
    }

    override fun onGetTemplate(): Template {
        // Add a button to exit the app.
        val actionStripBuilder = ActionStrip.Builder()
        actionStripBuilder.addAction(
            Action.Builder()
                .setTitle("Exit")
                .setOnClickListener(this::exit)
                .build()
        )

        val builder = NavigationTemplate.Builder()
        builder.setActionStrip(actionStripBuilder.build())

        return builder.build()
    }

    override fun onSurfaceAvailable(surfaceContainer: SurfaceContainer) {
        mapSurface.setSurface(
            carContext,
            surfaceContainer.surface,
            surfaceContainer.width,
            surfaceContainer.height
        )

        carToFlutterApi?.setupMapView { }
    }

    override fun onSurfaceDestroyed(surfaceContainer: SurfaceContainer) {
        mapSurface.destroySurface()
    }

    private fun exit() {
        carContext.finishCarApp()
    }
}
