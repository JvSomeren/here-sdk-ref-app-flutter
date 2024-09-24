package com.example.RefApp

class FlutterToCar private constructor() : FlutterToCarApi {
    companion object {
        val instance = FlutterToCar()
    }

    // generic observer

    private var genericObservers: Set<GenericObserver> = setOf()

    fun addObserver(observer: GenericObserver) {
        genericObservers = genericObservers.plus(observer)
    }

    fun removeObserver(observer: GenericObserver) {
        genericObservers = genericObservers.minus(observer)
    }

    // routing observer

    private var routingObservers: Set<RoutingObserver> =
        setOf()

    fun addObserver(observer: RoutingObserver) {
        routingObservers = routingObservers.plus(observer)
    }

    fun removeObserver(observer: RoutingObserver) {
        routingObservers = routingObservers.minus(observer)
    }

    interface GenericObserver {
        fun onStartRouting()
    }

    override fun onStartRouting() {
        for (observer in genericObservers) {
            observer.onStartRouting()
        }
    }

    interface RoutingObserver {
        fun onRouteOptionsUpdated(message: PgRouteOptionsUpdatedMessage) {}

        fun onRouteOptionSelected(routeOptionId: Long) {}

        fun onStopRouting() {}
    }

    override fun onRouteOptionsUpdated(message: PgRouteOptionsUpdatedMessage) {
        for (observer in routingObservers) {
            observer.onRouteOptionsUpdated(message)
        }
    }

    override fun onRouteOptionSelected(routeOptionIndex: Long) {
        for (observer in routingObservers) {
            observer.onRouteOptionSelected(routeOptionIndex)
        }
    }

    override fun onStopRouting() {
        for (observer in routingObservers) {
            observer.onStopRouting()
        }
    }
}
