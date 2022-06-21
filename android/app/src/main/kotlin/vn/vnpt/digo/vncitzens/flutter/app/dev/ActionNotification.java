package vn.vnpt.digo.vncitzens.flutter.app.dev;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import io.flutter.plugin.common.MethodChannel;

public class ActionNotification extends BroadcastReceiver {
    final String TAG = "App Client";

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "Thông báo cuộc gọi =====");
        String event = intent.getStringExtra("event_vcall");
        String message = intent.getStringExtra("message");
        Log.d(TAG, event);
        Log.d(TAG, message);
        //hướng xử lý tạo engine ở application -> dùng lại engine đó để gọi lên
    }
}