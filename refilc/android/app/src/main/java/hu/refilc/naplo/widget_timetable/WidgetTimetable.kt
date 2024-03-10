package hu.refilc.naplo.widget_timetable

import android.app.PendingIntent
import android.app.UiModeManager
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import android.widget.Toast

import org.joda.time.DateTime
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

import java.time.DayOfWeek
import java.time.format.TextStyle
import java.util.Collections
import java.util.Comparator
import java.util.Locale
import java.util.HashMap
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Date

import hu.refilc.naplo.database.DBManager
import hu.refilc.naplo.MainActivity
import hu.refilc.naplo.R

import hu.refilc.naplo.utils.Week

import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import kotlin.collections.mutableMapOf

class WidgetTimetable : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val fullTheme: Array<Int> = getFullTheme(context)
        val textColors: Array<Int> = getTextColors(context, fullTheme)
        for (i in appWidgetIds.indices) {
            val views: RemoteViews = generateView(context, appWidgetIds[i])
            if (userLoggedIn(context)) {
                val rday = selectDay(context, appWidgetIds[i], 0, true)
                views.setTextViewText(R.id.nav_current, convertDayOfWeek(context, rday))
                views.setInt(R.id.nav_current, "setTextColor", getColor(context, textColors[0]))
            }
            pushUpdate(context, views, appWidgetIds[i])
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.hasExtra(AppWidgetManager.EXTRA_APPWIDGET_ID)) {
            val appId: Int = intent.getIntExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID
            )
            val views: RemoteViews = generateView(context, appId)
            try {
                if (userLoggedIn(context)) {
                    if (intent.getAction().equals(ACTION_WIDGET_CLICK_NAV_LEFT)) {
                        val rday = selectDay(context, appId, -1, false)
                        views.setTextViewText(R.id.nav_current, convertDayOfWeek(context, rday))
                        pushUpdate(context, views, appId)
                    } else if (intent.getAction().equals(ACTION_WIDGET_CLICK_NAV_RIGHT)) {
                        val rday = selectDay(context, appId, 1, false)
                        views.setTextViewText(R.id.nav_current, convertDayOfWeek(context, rday))
                        pushUpdate(context, views, appId)
                    } else if (intent.getAction().equals(ACTION_WIDGET_CLICK_NAV_TODAY)) {
                        val rday = getToday(context)
                        setSelectedDay(context, appId, rday)
                        views.setTextViewText(R.id.nav_current, convertDayOfWeek(context, rday))
                        pushUpdate(context, views, appId)
                    } else if (intent.getAction().equals(ACTION_WIDGET_CLICK_NAV_REFRESH)) {
                        val pendingIntent: PendingIntent =
                            HomeWidgetLaunchIntent.getActivity(
                                context,
                                MainActivity::class.java,
                                Uri.parse("timetable://refresh")
                            )
                        pendingIntent.send()
                    } else if (intent.getAction()
                            .equals("android.appwidget.action.APPWIDGET_DELETED")
                    ) {
                        val dbManager = DBManager(context.getApplicationContext())
                        try {
                            dbManager.open()
                            dbManager.deleteWidget(appId)
                            dbManager.close()
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                }
                if (intent.getAction().equals(ACTION_WIDGET_CLICK_BUY_PREMIUM)) {
                    val pendingIntent: PendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java,
                        Uri.parse("settings://premium")
                    )
                    pendingIntent.send()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun onEnabled(context: Context?) {
    }

    override fun onDisabled(context: Context?) {
    }

    companion object {
        private const val ACTION_WIDGET_CLICK_NAV_LEFT = "list_widget.ACTION_WIDGET_CLICK_NAV_LEFT"
        private const val ACTION_WIDGET_CLICK_NAV_RIGHT =
            "list_widget.ACTION_WIDGET_CLICK_NAV_RIGHT"
        private const val ACTION_WIDGET_CLICK_NAV_TODAY =
            "list_widget.ACTION_WIDGET_CLICK_NAV_TODAY"
        private const val ACTION_WIDGET_CLICK_NAV_REFRESH =
            "list_widget.ACTION_WIDGET_CLICK_NAV_REFRESH"
        private const val ACTION_WIDGET_CLICK_BUY_PREMIUM =
            "list_widget.ACTION_WIDGET_CLICK_BUY_PREMIUM"

        fun pushUpdate(context: Context?, remoteViews: RemoteViews?, appWidgetSingleId: Int) {
            val manager: AppWidgetManager = AppWidgetManager.getInstance(context)
            manager.updateAppWidget(appWidgetSingleId, remoteViews)
            manager.notifyAppWidgetViewDataChanged(appWidgetSingleId, R.id.widget_list)
        }

        fun getColor(context: Context, color: Int): Int {
            return context.getResources().getColor(color)
        }

        fun getTextColors(context: Context, fullTheme: Array<Int>): Array<Int> {
            val uiModeManager: UiModeManager =
                context.getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
            val nightMode: Int = uiModeManager.getNightMode()
            val textColor: Int
            val textDescColor: Int
            if (fullTheme[0] == 0 && nightMode == UiModeManager.MODE_NIGHT_NO) {
                textColor = R.color.text_light
                textDescColor = R.color.text_desc_light
            } else if (fullTheme[0] == 1) {
                textColor = R.color.text_light
                textDescColor = R.color.text_desc_light
            } else {
                textColor = R.color.text
                textDescColor = R.color.text_desc
            }
            return arrayOf(textColor, textDescColor)
        }

        fun getFullTheme(context: Context): Array<Int> {
            val dbManager = DBManager(context.getApplicationContext())
            try {
                dbManager.open()
                val cursor: Cursor = dbManager.fetchTheme()
                dbManager.close()
                val theme: Int = cursor.getInt(0)
                val customBackgroundColor: Int = cursor.getInt(2)
                return arrayOf(theme, customBackgroundColor)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return arrayOf(0, 0)
        }

        fun generateView(context: Context, appId: Int): RemoteViews {
            val fullTheme: Array<Int> = getFullTheme(context)
            val textColors: Array<Int> = getTextColors(context, fullTheme)
            val serviceIntent = Intent(context, WidgetTimetableService::class.java)
            serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appId)
            serviceIntent.setData(Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME)))
            val views = RemoteViews(context.getPackageName(), R.layout.widget_timetable)
            views.setViewVisibility(R.id.need_login, View.GONE)
            views.setViewVisibility(R.id.tt_grid_cont, View.GONE)
            views.setInt(R.id.nav_to_left, "setColorFilter", getColor(context, textColors[1]))
            views.setInt(R.id.nav_to_right, "setColorFilter", getColor(context, textColors[1]))
            views.setInt(R.id.nav_refresh, "setColorFilter", getColor(context, textColors[1]))
            views.setInt(R.id.empty_view, "setTextColor", getColor(context, textColors[0]))
            if (!userLoggedIn(context)) {
                views.setViewVisibility(R.id.need_login, View.VISIBLE)
                views.setOnClickPendingIntent(
                    R.id.open_login,
                    makePending(context, ACTION_WIDGET_CLICK_BUY_PREMIUM, appId)
                )
            } else {
                views.setViewVisibility(R.id.tt_grid_cont, View.VISIBLE)
                views.setInt(R.id.widget_list, "setBackgroundColor", fullTheme[1])
                views.setInt(R.id.bottom_nav, "setBackgroundColor", fullTheme[1])
                views.setOnClickPendingIntent(
                    R.id.nav_to_left,
                    makePending(context, ACTION_WIDGET_CLICK_NAV_LEFT, appId)
                )
                views.setOnClickPendingIntent(
                    R.id.nav_to_right,
                    makePending(context, ACTION_WIDGET_CLICK_NAV_RIGHT, appId)
                )
                views.setOnClickPendingIntent(
                    R.id.nav_current,
                    makePending(context, ACTION_WIDGET_CLICK_NAV_TODAY, appId)
                )
                views.setOnClickPendingIntent(
                    R.id.nav_refresh,
                    makePending(context, ACTION_WIDGET_CLICK_NAV_REFRESH, appId)
                )
                views.setRemoteAdapter(R.id.widget_list, serviceIntent)
                views.setEmptyView(R.id.widget_list, R.id.empty_view)
                views.setInt(R.id.empty_view, "setBackgroundColor", fullTheme[1])
            }
            return views
        }

        fun makePending(context: Context?, action: String?, appWidgetId: Int): PendingIntent {
            val activebtnnext = Intent(context, WidgetTimetable::class.java)
            activebtnnext.setAction(action)
            activebtnnext.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            return PendingIntent.getBroadcast(
                context,
                appWidgetId,
                activebtnnext,
                PendingIntent.FLAG_IMMUTABLE
            )
        }

        fun convertDayOfWeek(context: Context, rday: Int): String {

            /*if(rday == -1) return DayOfWeek.of(1).getDisplayName(TextStyle.FULL, new Locale("hu", "HU"))

        String dayOfWeek = DayOfWeek.of(rday + 1).getDisplayName(TextStyle.FULL, new Locale("hu", "HU"))*/
            var dayOfWeek = "Unknown"
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val loc: Locale = getLocale(context)
                if (rday == -1) return DayOfWeek.of(1).getDisplayName(TextStyle.FULL, loc)
                dayOfWeek = DayOfWeek.of(rday + 1).getDisplayName(TextStyle.FULL, loc)
            }
            return dayOfWeek.substring(0, 1).toUpperCase() + dayOfWeek.substring(1).toLowerCase()
        }

        fun setSelectedDay(context: Context, wid: Int, day: Int) {
            val dbManager = DBManager(context.getApplicationContext())
            try {
                dbManager.open()
                dbManager.update(wid, day)
                dbManager.close()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        fun getToday(context: Context): Int {
            var rday: Int = DateTime().getDayOfWeek() - 1
            val s: MutableList<JSONArray> = genJsonDays(context)
            try {
                if (checkIsAfter(s, rday)) rday += 1
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return retDay(rday, s.size)
        }

        fun selectDay(context: Context, wid: Int, add: Int, afterSubjects: Boolean): Int {
            val dbManager = DBManager(context.getApplicationContext())
            try {
                dbManager.open()
                val cursor: Cursor = dbManager.fetchWidget(wid)
                val s: MutableList<JSONArray> = genJsonDays(context)
                var retday: Int = DateTime().getDayOfWeek() - 1
                if (cursor.getCount() !== 0) retday = retDay(cursor.getInt(1) + add, s.size)
                if (afterSubjects) if (checkIsAfter(s, retday)) retday += 1
                retday = retDay(retday, s.size)
                if (cursor.getCount() === 0) dbManager.insertSelDay(
                    wid,
                    retday
                ) else dbManager.update(wid, retday)
                dbManager.close()

                // get the date of the first lesson
                val dt = DateTime(s[retday].getJSONObject(0).getString("Datum"))
                retday = dt.getDayOfWeek() - 1
                return retday
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return 0
        }

        fun checkIsAfter(s: MutableList<JSONArray>, retday: Int): Boolean {
            var retday = retday
            retday = retDay(retday, s.size)
            val vegIdopont: String =
                s[retday].getJSONObject(s[retday].length() - 1).getString("VegIdopont")
            return DateTime().isAfter(DateTime(vegIdopont))
        }

        fun retDay(retday: Int, size: Int): Int {
            var retday = retday
            if (retday < 0) retday = size - 1 else if (retday > size - 1) retday = 0
            return retday
        }

        fun genJsonDays(context: Context): MutableList<JSONArray> {
            val genDays: MutableList<JSONArray> = mutableListOf<JSONArray>()
            val dayMap: MutableMap<String, JSONArray> = mutableMapOf<String, JSONArray>()
            val dbManager = DBManager(context.getApplicationContext())
            try {
                dbManager.open()
                val ct: Cursor = dbManager.fetchTimetable()
                if (ct.getCount() === 0) {
                    return genDays
                }
                val fetchedTimetable = JSONObject(ct.getString(0))
                val currentWeek: String = Week.current().id().toString()
                val week: JSONArray = fetchedTimetable.getJSONArray(currentWeek)

                // Organize lessons into dates
                for (i in 0 until week.length()) {
                    try {
                        val entry: JSONObject = week.getJSONObject(i)
                        val date: String = entry.getString("Datum")
                        dayMap.computeIfAbsent(date) { k -> JSONArray() }.put(entry)
                    } catch (e: JSONException) {
                        e.printStackTrace()
                    }
                }
                genDays.addAll(dayMap.values)

                // Sort the 'genDays' list of JSON based on the start time of the first entry
                genDays.sortWith( { day1, day2 ->
                  // Extract the start time of the first entry in each day's JSON
                  val startTime1: String = day1.getJSONObject(0).getString("KezdetIdopont")
                  val startTime2: String = day2.getJSONObject(0).getString("KezdetIdopont")
                  // Compare the start times and return the result for sorting
                  startTime1.compareTo(startTime2)
                })
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                dbManager.close()
            }
            return genDays
        }

        fun zeroPad(value: Int, padding: Int): String {
            val b = StringBuilder()
            b.append(value)
            while (b.length < padding) {
                b.insert(0, "0")
            }
            return b.toString()
        }

        fun getLocale(context: Context): Locale {
            val dbManager = DBManager(context.getApplicationContext())
            try {
                dbManager.open()
                val loc: String = dbManager.fetchLocale().getString(0)
                dbManager.close()
                if (loc.equals("hu") || loc.equals("de")) {
                    return Locale(loc, loc.toUpperCase())
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return Locale("en", "GB")
        }

        fun userLoggedIn(context: Context): Boolean {
            return !lastUserId(context).equals("")
        }

        fun lastUserId(context: Context): String {
            val dbManager = DBManager(context.getApplicationContext())
            try {
                dbManager.open()
                val cursor: Cursor = dbManager.fetchLastUser()
                dbManager.close()
                if (cursor != null && !cursor.getString(0).equals("")) {
                    return cursor.getString(0)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return ""
        }
    }
}
