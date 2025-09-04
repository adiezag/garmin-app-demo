import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class garmin_demoApp extends Application.AppBase {
    private var _view;


    function initialize() {
        System.println("First!");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("App has started");

    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        System.println("App stopped");
    }

    // Return the initial view of your application here
    // function getInitialView() as [Views] or [Views, InputDelegates] {
    function getInitialView() as Array<Views or InputDelegates>? {
        System.println("Hey, over here!");
        
        var notificationManager = new NotificationManager();
        _view = new garmin_demoView(notificationManager);

        // return [ new garmin_demoView(), new garmin_demoDelegate() ];
        return [_view, new garmin_demoDelegate(notificationManager)] as Array <Views or InputDelegates>;
    }
    
    // Returns main view instance
    function getView() as Void {
        return _view;
    }

}
// Returns app instance
function getApp() as garmin_demoApp {
    return Application.getApp() as garmin_demoApp;
}

// Returns main view instance
function getView() as garmin_demoView{
    return Application.getApp().getView();
}