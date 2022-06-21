package vn.vnpt.digo.vncitzens.flutter.app.dev;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class ActionDenied extends BroadcastReceiver {
    final String TAG = "App Client";

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "Từ chối cuộc gọi =====");
        String event = intent.getStringExtra("event_vcall");
        String message = intent.getStringExtra("message");
        Log.d(TAG, event);
        Log.d(TAG, message);
    }
}
