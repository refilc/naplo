package hu.refilc.naplo.utils

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkInfo

import java.util.Calendar
import java.util.Date

class Utils {
  companion object {
    @JvmStatic
    fun hasNetwork(context: Context): Boolean {
      val cm: ConnectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
      val netInfo: NetworkInfo = cm.getActiveNetworkInfo() as NetworkInfo
      if (netInfo != null && netInfo.isConnectedOrConnecting()) {
        return true
      }
      return false
    }

    @JvmStatic
    fun getWeekStartDate(): Date {
      var calendar: Calendar = Calendar.getInstance()
      while (calendar.get(Calendar.DAY_OF_WEEK) != Calendar.MONDAY) {
        calendar.add(Calendar.DATE, -1)
      }
      return calendar.getTime()
    }

    @JvmStatic
    fun getWeekEndDate(): Date {
      var calendar: Calendar = Calendar.getInstance()
      while (calendar.get(Calendar.DAY_OF_WEEK) != Calendar.MONDAY) {
        calendar.add(Calendar.DATE, 1)
      }
      calendar.add(Calendar.DATE, -1)
      return calendar.getTime()
    }
  }
}
