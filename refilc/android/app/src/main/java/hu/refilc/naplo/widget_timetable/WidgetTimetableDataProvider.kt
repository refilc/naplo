package hu.refilc.naplo.widget_timetable

import android.app.UiModeManager
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.os.Build
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService

import org.joda.time.DateTime
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

import java.util.Collections
import java.util.Comparator

import hu.refilc.naplo.database.DBManager
import hu.refilc.naplo.R

class WidgetTimetableDataProvider(context: Context, intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    private val context: Context
    private val appWidgetId: Int
    private var rday = 0
    private var fullTheme: Array<Int>
    private val uiModeManager: UiModeManager
    private val nightMode: Int
    var day_subjects: MutableList<Lesson> = mutableListOf<Lesson>()
    var lessonIndexes: MutableList<Int> = mutableListOf<Int>()
    var witem: Item? = null

    /* Default values */
    class Item(
        var Layout: Int,
        var BackgroundColor: Int,
        var NumVisibility: Int,
        var NameVisibility: Int,
        var NameNodescVisibility: Int,
        var DescVisibility: Int,
        var RoomVisibility: Int,
        var TimeVisibility: Int,
        var NumColor: Int,
        var NameColor: Int,
        var NameNodescColor: Int,
        var DescColor: Int,
        var RoomColor: Int,
        var TimeColor: Int
    ) {
        var NameNodescPadding: Array<Int> = arrayOf(0, 0, 0, 0)
    }

    class Lesson(
        var status: String,
        var lessonIndex: String,
        var lessonName: String,
        var lessonTopic: String,
        var lessonRoom: String,
        var lessonStart: Long,
        var lessonEnd: Long,
        var substituteTeacher: String
    )

    var itemNameNodescPadding: Array<Int> = arrayOf(0, 0, 0, 0)

    init {
        this.context = context
        appWidgetId = intent.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        )
        fullTheme = getFullTheme(context)
        uiModeManager = context.getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
        nightMode = uiModeManager.getNightMode()
    }

    override fun onCreate() {
        initData()
    }

    override fun onDataSetChanged() {
        initData()
    }

    override fun onDestroy() {}

    override fun getCount(): Int {
      return day_subjects.size
    }

    fun setLayout(view: RemoteViews) {
        /* Visibilities */
        view.setViewVisibility(R.id.tt_item_num, witem!!.NumVisibility)
        view.setViewVisibility(R.id.tt_item_name, witem!!.NameVisibility)
        view.setViewVisibility(R.id.tt_item_name_nodesc, witem!!.NameNodescVisibility)
        view.setViewVisibility(R.id.tt_item_desc, witem!!.DescVisibility)
        view.setViewVisibility(R.id.tt_item_room, witem!!.RoomVisibility)
        view.setViewVisibility(R.id.tt_item_time, witem!!.TimeVisibility)

        /* backgroundResources */
        view.setInt(R.id.main_lay, "setBackgroundResource", witem!!.Layout)
        view.setInt(R.id.main_lay, "setBackgroundColor", witem!!.BackgroundColor)

        /* Paddings */
        view.setViewPadding(
            R.id.tt_item_name_nodesc,
            witem!!.NameNodescPadding[0],
            witem!!.NameNodescPadding[1],
            witem!!.NameNodescPadding[2],
            witem!!.NameNodescPadding[3]
        )

        /* Text Colors */
        view.setInt(R.id.tt_item_num, "setTextColor", witem!!.NumColor)
        view.setInt(R.id.tt_item_name, "setTextColor", getColor(context, witem!!.NameColor))
        view.setInt(R.id.tt_item_name_nodesc, "setTextColor", getColor(context, witem!!.NameNodescColor))
        view.setInt(R.id.tt_item_desc, "setTextColor", getColor(context, witem!!.DescColor))
        view.setInt(R.id.tt_item_room, "setTextColor", getColor(context, witem!!.RoomColor))
        view.setInt(R.id.tt_item_time, "setTextColor", getColor(context, witem!!.TimeColor))
    }

    fun getColor(context: Context, color: Int): Int {
        return context.getResources().getColor(color)
    }

    override fun getViewAt(position: Int): RemoteViews {
        val view = RemoteViews(context.getPackageName(), R.layout.timetable_item)
        witem = defaultItem(fullTheme, nightMode)
        val curr_subject = day_subjects[position]
        if (curr_subject.status.equals("empty")) {
            witem!!.NumColor = getColor(context, R.color.text_miss_num)
            witem!!.TimeVisibility = View.GONE
            witem!!.RoomVisibility = View.GONE
            witem!!.NameNodescColor = R.color.text_miss
        }
        if (!curr_subject.substituteTeacher.equals("null")) {
            witem!!.NumColor = getColor(context, R.color.yellow)
            witem!!.Layout = R.drawable.card_layout_tile_helyetesitett
        }
        if (curr_subject.status.equals("Elmaradt")) {
            witem!!.NumColor = getColor(context, R.color.red)
            witem!!.Layout = R.drawable.card_layout_tile_elmarad
        } else if (curr_subject.status.equals("TanevRendjeEsemeny")) {
            witem!!.NumVisibility = View.GONE
            witem!!.TimeVisibility = View.GONE
            witem!!.RoomVisibility = View.GONE
            witem!!.NameNodescPadding[0] = 50
            witem!!.NameNodescPadding[2] = 50
            witem!!.NameNodescColor = R.color.text_miss
        }
        if (curr_subject.lessonTopic.equals("null")) {
            witem!!.DescVisibility = View.GONE
            witem!!.NameVisibility = View.GONE
            witem!!.NameNodescVisibility = View.VISIBLE
        }
        setLayout(view)
        val lessonIndexTrailing = if (curr_subject.lessonIndex.equals("+")) "" else "."
        view.setTextViewText(R.id.tt_item_num, curr_subject.lessonIndex + lessonIndexTrailing)
        view.setTextViewText(R.id.tt_item_name, curr_subject.lessonName)
        view.setTextViewText(R.id.tt_item_name_nodesc, curr_subject.lessonName)
        view.setTextViewText(R.id.tt_item_desc, curr_subject.lessonTopic)
        view.setTextViewText(R.id.tt_item_room, curr_subject.lessonRoom)
        if (curr_subject.lessonStart != 0L && curr_subject.lessonEnd != 0L) view.setTextViewText(
            R.id.tt_item_time,
            ((WidgetTimetable.zeroPad(
                DateTime(curr_subject.lessonStart).getHourOfDay(),
                2
            ) + ":" + WidgetTimetable.zeroPad(
                DateTime(curr_subject.lessonStart).getMinuteOfHour(),
                2
            )).toString() +
                    "\n" + WidgetTimetable.zeroPad(
                DateTime(curr_subject.lessonEnd).getHourOfDay(),
                2
            )).toString() + ":" + WidgetTimetable.zeroPad(
                DateTime(curr_subject.lessonEnd).getMinuteOfHour(),
                2
            )
        )
        return view
    }

    override fun getLoadingView(): RemoteViews {
      val view = RemoteViews(context.getPackageName(), R.layout.timetable_item)
      return view
    }

    override fun getViewTypeCount(): Int {
      return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    private fun initData() {
        // refresh theme
        fullTheme = getFullTheme(context)
        rday = WidgetTimetable.selectDay(context, appWidgetId, 0, false)
        day_subjects.clear()
        lessonIndexes.clear()
        try {
            val arr: MutableList<JSONArray> = WidgetTimetable.genJsonDays(context) as MutableList<JSONArray>
            if (arr.isEmpty()) {
                return
            }
            val arr_lessons: JSONArray = WidgetTimetable.genJsonDays(context).get(rday)
            for (i in 0 until arr_lessons.length()) {
                val obj_lessons: JSONObject = arr_lessons.getJSONObject(i)
                day_subjects.add(jsonToLesson(obj_lessons))
            }
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        if (day_subjects.size > 0) {
            Collections.sort(day_subjects, object : Comparator<Lesson?> {
                override fun compare(o1: Lesson?, o2: Lesson?): Int {
                    return DateTime(o1?.lessonStart).compareTo(DateTime(o2?.lessonStart))
                }
            })
            for (i in 0 until day_subjects.size) {
                if (!day_subjects[i].lessonIndex.equals("+")) {
                    lessonIndexes.add(Integer.valueOf(day_subjects[i].lessonIndex))
                }
            }
            if (lessonIndexes.size > 0) {
                var lessonsChecked: Int = Collections.min(lessonIndexes)
                var i = 0
                while (lessonsChecked < Collections.max(lessonIndexes)) {
                    if (!lessonIndexes.contains(lessonsChecked)) {
                        day_subjects.add(i, emptyLesson(lessonsChecked))
                    }
                    lessonsChecked++
                    i++
                }
            }
        }
    }

    fun defaultItem(fullTheme: Array<Int>, nightMode: Int): Item {
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
        return Item(
            R.drawable.card_layout_tile,
            fullTheme[2],
            View.VISIBLE,
            View.VISIBLE,
            View.INVISIBLE,
            View.VISIBLE,
            View.VISIBLE,
            View.VISIBLE,
            fullTheme[1],
            textColor,
            textColor,
            textDescColor,
            textDescColor,
            textColor
        )
    }

    fun emptyLesson(lessonIndex: Int): Lesson {
        return Lesson(
            "empty",
            lessonIndex.toString(),
            "Lyukasóra",
            "null",
            "null",
            0,
            0,
            "null"
        )
    }

    fun jsonToLesson(json: JSONObject): Lesson {
        try {
            var name: String = json.getString("Nev")
            name = name.substring(0, 1).toUpperCase() + name.substring(1) // Capitalize name
            return Lesson(
                json.getJSONObject("Allapot").getString("Nev"),
                if (!json.getString("Oraszam").equals("null")) json.getString("Oraszam") else "+",
                name,
                json.getString("Tema"),
                json.getString("TeremNeve"),
                DateTime(json.getString("KezdetIdopont")).getMillis(),
                DateTime(json.getString("VegIdopont")).getMillis(),
                json.getString("HelyettesTanarNeve")
            )
        } catch (e: Exception) {
            Log.d("Filc", "exception: $e")
        }
        return Lesson("", "", "", "", "", 0, 0, "") 
    }

    companion object {
        fun getFullTheme(context: Context): Array<Int> {
            val dbManager = DBManager(context.getApplicationContext())
            try {
                dbManager.open()
                val cursor: Cursor = dbManager.fetchTheme()
                dbManager.close()
                val theme: Int = cursor.getInt(0)
                val customAccentColor: Int = cursor.getInt(1)
                val customBackgroundColor: Int = cursor.getInt(2)
                return arrayOf(theme, customAccentColor, customBackgroundColor)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return arrayOf(0, 0, 0)
        }
    }
}
