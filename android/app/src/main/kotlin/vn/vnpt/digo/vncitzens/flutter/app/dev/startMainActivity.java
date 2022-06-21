package vn.vnpt.digo.vncitzens.flutter.app.dev;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.vnptit2.vnpt_vcall.ConnectionBroadcast;

import java.util.HashMap;

import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;

public class startMainActivity extends BroadcastReceiver {
    String TAG = "startMainActivity";

    @Override
    public void onReceive(Context context, Intent intent) {
//        String dataOptions = {"avatarUrl":"https:\/\/phunugioi.com\/wp-content\/uploads\/2020\/10\/hinh-anh-avatar-de-thuong-cute.jpg"};
        String topic = intent.getStringExtra("topic");
        String type = intent.getStringExtra("type");
        String answer = intent.getStringExtra("answer");
        String callerName = intent.getStringExtra("callerName");
        String caller = intent.getStringExtra("caller");
        String lockScreen = intent.getStringExtra("lockScreen");
        String callID = intent.getStringExtra("callID");
        String dest = intent.getStringExtra("dest");
        String missedCall = intent.getStringExtra("missedCall");
        String callSip = intent.getStringExtra("callSip");
        String event = intent.getStringExtra("event");
        HashMap<Object, Object> dataOptions = (HashMap<Object, Object>) intent.getSerializableExtra("dataOptions");
        boolean fromCallCenter = intent.getBooleanExtra("fromCallCenter", false);
        boolean soundVibration = intent.getBooleanExtra("soundVibration", false);

        int idNotification = intent.getIntExtra("idNotification", -1);

        Log.d(TAG, "Data get from startMainAcitivity ====="
                + "\ncallSip: " + callSip
                + "\ntopic: " + topic
                + "\ntype: " + type
                + "\nanswer: " + answer
                + "\ncallerName: " + callerName
                + "\ncaller: " + caller
                + "\nlockScreen: " + lockScreen
                + "\ncallID: " + callID
                + "\ndataOptions: " + dataOptions
                + "\nsoundVibration: " + soundVibration
                + "\nevent: " + event
                + "\nfromCallCenter: " + fromCallCenter
                + "\nmissedCall: " + missedCall);

        Intent intentSDKVideoCall = new Intent(context, MainActivity.class);
        intentSDKVideoCall.putExtra("callSip", callSip);
        intentSDKVideoCall.putExtra("type", type);
        intentSDKVideoCall.putExtra("dest", dest);
        intentSDKVideoCall.putExtra("callerName", callerName);
        intentSDKVideoCall.putExtra("caller", caller);
        intentSDKVideoCall.putExtra("lockScreen", lockScreen);
        intentSDKVideoCall.putExtra("callID", callID);
        intentSDKVideoCall.putExtra("dataOptions", dataOptions);
        intentSDKVideoCall.putExtra("soundVibration", soundVibration);
        intentSDKVideoCall.putExtra("missedCall", missedCall);
        intentSDKVideoCall.putExtra("event", event);
        intentSDKVideoCall.putExtra("fromCallCenter", fromCallCenter);
        if (answer != null && answer.equals("auto")) {
            intentSDKVideoCall.putExtra("answer", "auto");
        }
        if (idNotification != -1) {
            intentSDKVideoCall.putExtra("idNotification", idNotification);
        }

        intentSDKVideoCall.setFlags(FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_NO_USER_ACTION | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//        | Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP
//        | Intent.FLAG_ACTIVITY_NO_HISTORY
        context.startActivity(intentSDKVideoCall);
        
    }
}