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
import com.here.sdk.core.GeoCoordinates
import com.here.sdk.mapview.MapMeasure
import com.here.sdk.mapview.MapScheme
import com.here.sdk.mapview.MapSurface


class HelloMapScreen(carContext: CarContext) : Screen(carContext), SurfaceCallback {
    private val mapSurface: MapSurface

    init {
        carContext.getCarService(AppManager::class.java).setSurfaceCallback(this)
        // The MapSurface works the same as the HereMapController we know from Flutter. It uses
        // a surface in order to draw the map to the screen.
        mapSurface = MapSurface()
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

        mapSurface.mapScene.loadScene(MapScheme.NORMAL_DAY) { mapError ->
            if (mapError == null) {
                val distanceInMeters = 1000.0 * 10
                val mapMeasureZoom = MapMeasure(MapMeasure.Kind.DISTANCE, distanceInMeters)
                mapSurface.camera.lookAt(GeoCoordinates(52.530932, 13.384915), mapMeasureZoom)
            }
        }
    }

    override fun onSurfaceDestroyed(surfaceContainer: SurfaceContainer) {
        mapSurface.destroySurface()
    }

    private fun exit() {
        carContext.finishCarApp()
    }
}
