package com.example.RefApp

import android.text.SpannableString
import android.text.Spanned.SPAN_INCLUSIVE_EXCLUSIVE
import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.Distance
import androidx.car.app.model.DistanceSpan
import androidx.car.app.model.DurationSpan
import androidx.car.app.model.ItemList
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.RoutePreviewNavigationTemplate
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import io.flutter.embedding.engine.FlutterEngineCache

class RoutingScreen(carContext: CarContext) : Screen(carContext), DefaultLifecycleObserver,
    FlutterToCar.RoutingObserver {

    private var routeOptions: List<PgRouteOption>? = null
    private var selectedRouteOptionIndex: Int = 0

    private val carToFlutterApi: CarToFlutterApi?

    init {
        lifecycle.addObserver(this)
        FlutterToCar.instance.addObserver(this)

        carToFlutterApi = FlutterEngineCache.getInstance()
            .get(MainActivity.FLUTTER_ENGINE_ID)
            ?.dartExecutor
            ?.binaryMessenger
            ?.let { binaryMessenger ->
                CarToFlutterApi(binaryMessenger)
            }
    }

    override fun onDestroy(owner: LifecycleOwner) {
        FlutterToCar.instance.removeObserver(this)

        carToFlutterApi?.stopRouting { }
    }

    override fun onGetTemplate(): Template {
        val builder = RoutePreviewNavigationTemplate.Builder().setHeaderAction(Action.BACK)

        if (routeOptions == null) {
            builder.setLoading(true)
        } else {
            val itemListBuilder = ItemList.Builder()

            if (routeOptions!!.isEmpty()) {
                itemListBuilder.setNoItemsMessage("No routes found.")
            } else {
                itemListBuilder.setOnSelectedListener(this::onRouteSelected)

                for (routeOption in routeOptions!!) {
                    val rowBuilder =
                        Row.Builder().setTitle(createTitleSpan(routeOption))

                    itemListBuilder.addItem(rowBuilder.build())
                }

                itemListBuilder.setSelectedIndex(selectedRouteOptionIndex)
            }
            builder.setItemList(itemListBuilder.build())
        }

        val navigateAction = Action.Builder()
            .setTitle("Unimplemented")
            .build()
        builder.setNavigateAction(navigateAction)

        return builder.build()
    }

    private fun onRouteSelected(selectedIndex: Int) {
        carToFlutterApi?.updateSelectedRouteOption(selectedIndex.toLong()) {}
    }

    private fun createDistance(lengthInMeters: Long): Distance {
        return if (lengthInMeters < 1000) {
            Distance.create(lengthInMeters.toDouble(), Distance.UNIT_METERS)
        } else if (lengthInMeters < 10_000) {
            Distance.create(
                lengthInMeters.toDouble() / 1000.0,
                Distance.UNIT_KILOMETERS_P1
            )
        } else {
            Distance.create(
                lengthInMeters.toDouble() / 1000.0,
                Distance.UNIT_KILOMETERS
            )
        }
    }

    private fun createTitleSpan(routeOption: PgRouteOption): SpannableString {
        val distanceSpan =
            DistanceSpan.create(createDistance(routeOption.lengthInMeters))
        val durationSpan = DurationSpan.create(routeOption.durationInSeconds)

        val titleSpan = SpannableString("  \u00b7  ")
        titleSpan.setSpan(
            durationSpan,
            0,
            1,
            SPAN_INCLUSIVE_EXCLUSIVE
        )
        titleSpan.setSpan(
            distanceSpan,
            4,
            5,
            SPAN_INCLUSIVE_EXCLUSIVE
        )

        return titleSpan
    }

    /**
     * [FlutterToCar.RoutingObserver] methods
     */

    /** */
    override fun onRouteOptionsUpdated(message: PgRouteOptionsUpdatedMessage) {
        this.routeOptions = message.routeOptions.filterNotNull()
        selectedRouteOptionIndex = 0

        invalidate()
    }

    override fun onRouteOptionSelected(routeOptionId: Long) {
        selectedRouteOptionIndex = routeOptionId.toInt()

        invalidate()
    }

    override fun onStopRouting() {
        finish()
    }
}
