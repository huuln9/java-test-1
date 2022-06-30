package vn.vnpt.digo.vncitzens.flutter.app.dev

import android.R
import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import com.vnpt.vnptmedia.soft.vnptpaysdkfull.uiv3.fragment.FragmentHomeUIV3

class VnptPayFragmentActivity : FragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null) {
            val fragmentHomeUIV3 = FragmentHomeUIV3.newInstance(false, false)
            supportFragmentManager.beginTransaction()
                .add(R.id.content, fragmentHomeUIV3).commit()
        }
    }
}