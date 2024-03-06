package hu.refilc.naplo.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class SQLiteHelper extends SQLiteOpenHelper {
    private static final String CREATE_TABLE_WIDGET = " create table widgets ( _id INTEGER NOT NULL, day_sel INTEGER NOT NULL);";
    private static final String DB_NAME = "app.db";
    private static final int DB_VERSION = 1;
    public static final String _ID = "_id";
    public static final String DAY_SEL = "day_sel";
    public static final String TIMETABLE = "timetable";
    public static final String LAST_ACCOUNT_ID = "last_account_id";
    public static final String THEME = "theme";
    public static final String PREMIUM_TOKEN = "premium_token";
    public static final String PREMIUM_SCOPES = "premium_scopes";
    public static final String LOCALE = "language";
    public static final String CUSTOM_ACCENT_COLOR = "custom_accent_color";
    public static final String CUSTOM_BACKGROUND_COLOR = "custom_background_color";
    public static final String CUSTOM_HIGHLIGHT_COLOR = "custom_highlight_color";
    public static final String TABLE_NAME_WIDGETS = "widgets";
    public static final String TABLE_NAME_USER_DATA = "user_data";
    public static final String TABLE_NAME_SETTINGS = "settings";

    public SQLiteHelper(Context context) {
        super(context, DB_NAME, null, 7);
    }

    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CREATE_TABLE_WIDGET);
    }

    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS widgets");
        onCreate(db);
    }
}
