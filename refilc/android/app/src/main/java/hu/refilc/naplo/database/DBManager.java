package hu.refilc.naplo.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.sql.SQLException;

import hu.refilc.naplo.database.SQLiteHelper;

public class DBManager {
    private Context context;
    private SQLiteDatabase database;
    private SQLiteHelper dbHelper;

    public DBManager(Context c) {
        this.context = c;
    }

    public DBManager open() throws SQLException {
        this.dbHelper = new SQLiteHelper(this.context);
        this.database = this.dbHelper.getWritableDatabase();
        return this;
    }

    public void close() {
        this.dbHelper.close();
    }

    public Cursor fetchWidget(int wid) {
        Cursor cursor = this.database.query(SQLiteHelper.TABLE_NAME_WIDGETS, new String[]{SQLiteHelper._ID, SQLiteHelper.DAY_SEL}, SQLiteHelper._ID + " = " + wid, null, null, null, null);
        if (cursor != null) {
            cursor.moveToFirst();
        }
        return cursor;
    }

    public Cursor fetchTimetable() {
        Cursor cursor = this.database.query(SQLiteHelper.TABLE_NAME_USER_DATA, new String[]{SQLiteHelper.TIMETABLE}, null, null, null, null, null);
        if (cursor != null) {
            cursor.moveToFirst();
        }
        return cursor;
    }

    public Cursor fetchLastUser() {
        Cursor cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, new String[]{SQLiteHelper.LAST_ACCOUNT_ID}, null, null, null, null, null);
        if (cursor != null) {
            cursor.moveToFirst();
        }
        return cursor;
    }

    public Cursor fetchTheme() {
        Cursor cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, new String[]{SQLiteHelper.THEME, SQLiteHelper.CUSTOM_ACCENT_COLOR, SQLiteHelper.CUSTOM_HIGHLIGHT_COLOR, SQLiteHelper.CUSTOM_BACKGROUND_COLOR}, null, null, null, null, null);
        if (cursor != null) {
            cursor.moveToFirst();
        }
        return cursor;
    }

    public Cursor fetchPremiumToken() {
        Cursor cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, new String[]{SQLiteHelper.PREMIUM_TOKEN}, null, null, null, null, null);
        if (cursor != null) {
            cursor.moveToFirst();
        }
        return cursor;
    }

    public Cursor fetchPremiumScopes() {
        Cursor cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, new String[]{SQLiteHelper.PREMIUM_SCOPES}, null, null, null, null, null);
        if (cursor != null) {
            cursor.moveToFirst();
        }
        return cursor;
    }

    public Cursor fetchLocale() {
        Cursor cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, new String[]{SQLiteHelper.LOCALE}, null, null, null, null, null);
        if (cursor != null) {
            cursor.moveToFirst();
        }
        return cursor;
    }

    public void deleteWidget(int _id) {
        this.database.delete(SQLiteHelper.TABLE_NAME_WIDGETS, "_id=" + _id, null);
    }

    /*public void changeSettings(int _id, Map<String, String> map) {
        ContentValues con = new ContentValues();
        for(Map.Entry<String, String> e: map.entrySet()){
            con.put(e.getKey(), e.getValue());
        }
        this.database.update(SQLiteHelper.TABLE_NAME_WIDGETS, con, "_id = " + _id, null);
    }
    public void insertSettings(int _id, Map<String, String> map) {
        ContentValues con = new ContentValues();
        for(Map.Entry<String, String> e: map.entrySet()){
            con.put(e.getKey(), e.getValue());
            //Log.d("Settings added", e.getKey() + " - " + e.getValue());
        }
        this.database.insert(SQLiteHelper.TABLE_NAME_WIDGETS, null, con);
    }*/

    public void insertSelDay(int _id, int day_sel) {
        ContentValues con = new ContentValues();
        con.put(SQLiteHelper._ID, _id);
        con.put(SQLiteHelper.DAY_SEL, day_sel);
        this.database.insert(SQLiteHelper.TABLE_NAME_WIDGETS, null, con);
    }

    public int update(int _id, int day_sel) {
        ContentValues con = new ContentValues();
        con.put(SQLiteHelper.DAY_SEL, day_sel);
        return this.database.update(SQLiteHelper.TABLE_NAME_WIDGETS, con, SQLiteHelper._ID + " = " + _id, null);
    }
}
