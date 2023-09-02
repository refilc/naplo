package hu.refilc.naplo.widget_timetable;

import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import org.joda.time.DateTime;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import hu.refilc.naplo.database.DBManager;
import hu.refilc.naplo.R;

public class WidgetTimetableDataProvider implements RemoteViewsService.RemoteViewsFactory {

    private Context context;
    private int appWidgetId;

    private int rday = 0;

    private int theme;

    private Integer[] colorValues;

    List<Lesson> day_subjects = new ArrayList<>();
    List<Integer> lessonIndexes = new ArrayList<>();

    Item witem;

    /* Default values */

    static class Item {
        int Layout;

        int NumVisibility;
        int NameVisibility;
        int NameNodescVisibility;
        int DescVisibility;
        int RoomVisibility;
        int TimeVisibility;

        int NumColor;
        int NameColor;
        int NameNodescColor;
        int DescColor;

        Integer[] NameNodescPadding = {0, 0, 0, 0};

        public Item(int Layout, int NumVisibility,int NameVisibility,int NameNodescVisibility,int DescVisibility,int RoomVisibility,int TimeVisibility,int NumColor,int NameColor,int NameNodescColor,int DescColor) {
            this.Layout = Layout;
            this.NumVisibility = NumVisibility;
            this.NameVisibility = NameVisibility;
            this.NameNodescVisibility = NameNodescVisibility;
            this.DescVisibility = DescVisibility;
            this.RoomVisibility = RoomVisibility;
            this.TimeVisibility = TimeVisibility;

            this.NumColor = NumColor;
            this.NameColor = NameColor;
            this.NameNodescColor = NameNodescColor;
            this.DescColor = DescColor;
        }
    }

    static class Lesson {
        String status;
        String lessonIndex;
        String lessonName;
        String lessonTopic;
        String lessonRoom;
        long lessonStart;
        long lessonEnd;
        String substituteTeacher;

        public Lesson(String status, String lessonIndex,String lessonName,String lessonTopic, String lessonRoom,long lessonStart,long lessonEnd,String substituteTeacher) {
            this.status = status;
            this.lessonIndex = lessonIndex;
            this.lessonName = lessonName;
            this.lessonTopic = lessonTopic;
            this.lessonRoom = lessonRoom;
            this.lessonStart = lessonStart;
            this.lessonEnd = lessonEnd;
            this.substituteTeacher = substituteTeacher;
        }
    }

    Integer[] itemNameNodescPadding = {0, 0, 0, 0};

    public WidgetTimetableDataProvider(Context context, Intent intent) {
        this.context = context;
        this.appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID);

        this.theme = getThemeAccent(context);

        this.colorValues = new Integer[]{R.color.filc,
                R.color.blue_shade300,
                R.color.green_shade300,
                R.color.lime_shade300,
                R.color.yellow_shade300,
                R.color.orange_shade300,
                R.color.red_shade300,
                R.color.pink_shade300,
                R.color.purple_shade300};

    }

    @Override
    public void onCreate() {
        initData();
    }

    @Override
    public void onDataSetChanged() {
        initData();
    }

    @Override
    public void onDestroy() {

    }

    @Override
    public int getCount() {

        return day_subjects.size();
    }

    public void setLayout(final RemoteViews view) {
        /* Visibilities */
        view.setViewVisibility(R.id.tt_item_num, witem.NumVisibility);
        view.setViewVisibility(R.id.tt_item_name, witem.NameVisibility);
        view.setViewVisibility(R.id.tt_item_name_nodesc, witem.NameNodescVisibility);
        view.setViewVisibility(R.id.tt_item_desc, witem.DescVisibility);
        view.setViewVisibility(R.id.tt_item_room, witem.RoomVisibility);
        view.setViewVisibility(R.id.tt_item_time, witem.TimeVisibility);

        /* backgroundResources */
        view.setInt(R.id.main_lay, "setBackgroundResource", witem.Layout);

        /* Paddings */
        view.setViewPadding(R.id.tt_item_name_nodesc, witem.NameNodescPadding[0], witem.NameNodescPadding[1], witem.NameNodescPadding[2], witem.NameNodescPadding[3]);

        /* Text Colors */
        view.setInt(R.id.tt_item_num, "setTextColor", getColor(context, witem.NumColor));
        view.setInt(R.id.tt_item_name, "setTextColor",  getColor(context, witem.NameColor));
        view.setInt(R.id.tt_item_name_nodesc, "setTextColor",  getColor(context, witem.NameNodescColor));
        view.setInt(R.id.tt_item_desc, "setTextColor",  getColor(context, witem.DescColor));
    }

    public int getColor(Context context, int color) {
        return context.getResources().getColor(color);
    }

    @Override
    public RemoteViews getViewAt(int position) {
        RemoteViews view = new RemoteViews(context.getPackageName(), R.layout.timetable_item);

        witem = defaultItem(theme);

        Lesson curr_subject = day_subjects.get(position);

        if (curr_subject.status.equals("empty")) {
            witem.NumColor = R.color.text_miss_num;

            witem.TimeVisibility = View.GONE;
            witem.RoomVisibility = View.GONE;

            witem.NameNodescColor = R.color.text_miss;
        }

        if (!curr_subject.substituteTeacher.equals("null")) {
            witem.NumColor = R.color.yellow;
            witem.Layout = R.drawable.card_layout_tile_helyetesitett;
        }

        if (curr_subject.status.equals("Elmaradt")) {
            witem.NumColor = R.color.red;
            witem.Layout = R.drawable.card_layout_tile_elmarad;
        } else if (curr_subject.status.equals("TanevRendjeEsemeny")) {
            witem.NumVisibility = View.GONE;
            witem.TimeVisibility = View.GONE;
            witem.RoomVisibility = View.GONE;

            witem.NameNodescPadding[0] = 50;
            witem.NameNodescPadding[2] = 50;

            witem.NameNodescColor = R.color.text_miss;
        }

        if (curr_subject.lessonTopic.equals("null")) {
            witem.DescVisibility = View.GONE;
            witem.NameVisibility = View.GONE;

            witem.NameNodescVisibility = View.VISIBLE;
        }

        setLayout(view);

        String lessonIndexTrailing = curr_subject.lessonIndex.equals("+") ? "" : ".";

        view.setTextViewText(R.id.tt_item_num, curr_subject.lessonIndex + lessonIndexTrailing);
        view.setTextViewText(R.id.tt_item_name, curr_subject.lessonName);
        view.setTextViewText(R.id.tt_item_name_nodesc, curr_subject.lessonName);
        view.setTextViewText(R.id.tt_item_desc, curr_subject.lessonTopic);
        view.setTextViewText(R.id.tt_item_room, curr_subject.lessonRoom);
        if(curr_subject.lessonStart != 0 && curr_subject.lessonEnd != 0)
            view.setTextViewText(R.id.tt_item_time, WidgetTimetable.zeroPad(new DateTime(curr_subject.lessonStart).getHourOfDay(), 2) + ":" + WidgetTimetable.zeroPad(new DateTime(curr_subject.lessonStart).getMinuteOfHour(), 2) +
                    "\n" + WidgetTimetable.zeroPad(new DateTime(curr_subject.lessonEnd).getHourOfDay(), 2) + ":" + WidgetTimetable.zeroPad(new DateTime(curr_subject.lessonEnd).getMinuteOfHour(),2));

        return view;
    }

    @Override
    public RemoteViews getLoadingView() {
        return null;
    }

    @Override
    public int getViewTypeCount() {
        return 1;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    private void initData() {

        theme = getThemeAccent(context);

        rday = WidgetTimetable.selectDay(context, appWidgetId, 0, false);

        day_subjects.clear();
        lessonIndexes.clear();

        try {
            List<JSONArray> arr = WidgetTimetable.genJsonDays(context);

            if(arr.isEmpty()) {
                return;
            }
            JSONArray arr_lessons = WidgetTimetable.genJsonDays(context).get(rday);

            for (int i = 0; i < arr_lessons.length(); i++) {
                JSONObject obj_lessons = arr_lessons.getJSONObject(i);

                day_subjects.add(jsonToLesson(obj_lessons));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        if(day_subjects.size() > 0) {
            Collections.sort(day_subjects, new Comparator<Lesson>() {
                public int compare(Lesson o1, Lesson o2) {
                    return new DateTime(o1.lessonStart).compareTo(new DateTime(o2.lessonStart));
                }
            });

            for (int i = 0; i < day_subjects.size(); i++) {
                if(!day_subjects.get(i).lessonIndex.equals("+")) {
                    lessonIndexes.add(Integer.valueOf(day_subjects.get(i).lessonIndex));
                }
            }

            if(lessonIndexes.size() > 0) {

                int lessonsChecked = Collections.min(lessonIndexes);
                int i = 0;

                while(lessonsChecked < Collections.max(lessonIndexes)) {
                    if(!lessonIndexes.contains(lessonsChecked)) {
                        day_subjects.add(i, emptyLesson(lessonsChecked));
                    }
                    lessonsChecked++;
                    i++;
                }
            }
        }
    }

    public static Integer getThemeAccent(Context context) {
        DBManager dbManager = new DBManager(context.getApplicationContext());

        try {
            dbManager.open();
            Cursor cursor = dbManager.fetchTheme();
            dbManager.close();

            return cursor.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public Item defaultItem(int theme) {
        return new Item(
                R.drawable.card_layout_tile,
                View.VISIBLE,
                View.VISIBLE,
                View.INVISIBLE,
                View.VISIBLE,
                View.VISIBLE,
                View.VISIBLE,
                colorValues[theme >= colorValues.length ? 0 : theme],
                R.color.text,
                R.color.text,
                R.color.text_desc
        );
    }

    public Lesson emptyLesson(int lessonIndex) {
        return new Lesson("empty", String.valueOf(lessonIndex), "Lyukasóra", "null", "null", 0, 0, "null");
    }

    public Lesson jsonToLesson(JSONObject json) {
        try {
            return new Lesson(
                    json.getJSONObject("Allapot").getString("Nev"),
                    !json.getString("Oraszam").equals("null") ? json.getString("Oraszam") : "+",
                    json.getString("Nev"),
                    json.getString("Tema"),
                    json.getString("TeremNeve"),
                    new DateTime(json.getString("KezdetIdopont")).getMillis(),
                    new DateTime(json.getString("VegIdopont")).getMillis(),
                    json.getString("HelyettesTanarNeve")
            );
        }catch (Exception e) {
            Log.d("Filc", "exception: " + e);
        };

        return null;
    }
}