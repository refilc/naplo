package hu.refilc.naplo.database

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class SQLiteHelper(context: Context): SQLiteOpenHelper(context, DB_NAME, null, 7) {
  companion object {
    private final val CREATE_TABLE_WIDGET: String = " create table widgets ( _id INTEGER NOT NULL, day_sel INTEGER NOT NULL);"
    private final val DB_NAME: String = "app.db"
    private final val DB_VERSION: Int = 1
    final val _ID: String = "_id"
    final val DAY_SEL: String = "day_sel"
    final val TIMETABLE: String = "timetable"
    final val LAST_ACCOUNT_ID: String = "last_account_id"
    final val THEME: String = "theme"
    final val LOCALE: String = "language"
    final val CUSTOM_ACCENT_COLOR: String = "custom_accent_color"
    final val CUSTOM_BACKGROUND_COLOR: String = "custom_background_color"
    final val TABLE_NAME_WIDGETS: String = "widgets"
    final val TABLE_NAME_USER_DATA: String = "user_data"
    final val TABLE_NAME_SETTINGS: String = "settings"
  }

  override fun onCreate(db: SQLiteDatabase) {
    db.execSQL(CREATE_TABLE_WIDGET)
  }

  override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
    db.execSQL("DROP TABLE IF EXISTS widgets")
    onCreate(db)
  }
}
