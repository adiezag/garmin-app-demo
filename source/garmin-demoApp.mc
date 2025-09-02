import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class garmin_demoApp extends Application.AppBase {

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
    function getInitialView() as [Views] or [Views, InputDelegates] {
        System.println("Hey, over here!");
        return [ new garmin_demoView(), new garmin_demoDelegate() ];
    }

}

function getApp() as garmin_demoApp {
    return Application.getApp() as garmin_demoApp;
}