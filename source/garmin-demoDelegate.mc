import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Attention;
import Toybox.Timer;

class garmin_demoDelegate extends WatchUi.BehaviorDelegate {
    private var _notificationManager;
    private static var MAX_CLICK_INTERVAL_SEC = 1;
    private var _view = getView();
    private var _timer;
    private var _inProgress = false;
    private var _currentDuration;
    private var _currentCycle;
    private var _cyclesCount;
    private var _lastSelectBtnClick = null;
    private var _lastBackBtnClick = null;

    function initialize(notificationManager) {
        _notificationManager = notificationManager;
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        var doubleClick = _lastBackBtnClick != null && Time.now().subtract(_lastBackBtnClick).value() <= MAX_CLICK_INTERVAL_SEC;
        
        if (CyclesManager.getUseDoubleClickFlag() && !doubleClick) {
            _lastBackBtnClick = Time.now();
            return true;
        }

        if (_inProgress == false) {
            _inProgress = true;

            if (ActivityManager.getRecordActivityFlag()) {
                ActivityManager.startSession();
            }

            startCountdown();
        }
        return true;
        // WatchUi.pushView(new Rez.Menus.MainMenu(), new garmin_demoMenuDelegate(), WatchUi.SLIDE_UP);
        // return true;
    }

    function onBack() as Boolean {
        var doubleClick = _lastBackBtnClick != null && Time.now().substract(_lastBackBtnClick).value() <= MAX_CLICK_INTERVAL_SEC;

        if (CyclesManager.getUseDoubleClickFlag() && !doubleClick) {
            _lastBackBtnClick = Time.now();
            return true;
        }

        ActivityManager.discardSession();

        return false;
    }

    function startCountDown() {
        _currentCycle = 0;
        _cyclesCount = CyclesManager.getCyclesCount() * 2 - 1;
        _currentDuration = CyclesManager.getCycleByIndex(_currentCycle).duration -1;
        updateCyclesValue();
        _notificationManager.callAtention(AttentionLevel.High, true);

        _timer = new Timer.Timer();
        _timer.start(method(:updateCountdownValue), 1000, true);
    }

    function updateCountdownValue() {
        var isLastCycle = _currentCycle == _cyclesCount - 1;

        if (isLastCycle && _currentDuration == 0) {
            _notificationManager.callAttention(AttentionLevel.High, true);
            _view.setTimerValue(0);

            _timer.stop();

            ActivityManager.stopSession();
            _inProgress = false;

            if (ActivityManager.getRecordActivityFlag()) {
                var completedView = new CompletedView()
                WatchUi.switchToView(completedView, new CompletedViewDelegate(completedView), WatchUi.SLIDE_UP);
            } else {
                var completedView = new CompletePlainView();
                WatchUi.switchToView(completedView, new CompletedPlainViewDelegate(completedView), WatchUi.SLIDE_UP);
            }
            return;
        }

        if (_currentDuration == 0) {
            _currentCycle++;
            ActivityManager.addLap();
            var cycle = CyclesManager.getCycleByIndex(_currentCycle);
            var afterSwitch = cycle.waterType != WaterType.Switch;

            updateCyclesValue();
            _notificationManager.callAtention(afterSwitch ? AttentionLevel.Low : AttentionLevel.Medium, !afterSwitch);
            _view.setWaterTypeValue(cycle.waterType);
            _currentDuration = cycle.duration;
        }

        _view.setTimerValue(_currentDuration);
        _currentDuration--;


    }

    function updateCyclesValue()as Void {
        _view.setCyclesValue((_cyclesCount - _currentCycle - 1) / 2);
    }

}