package hu.refilc.naplo.database

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase

import java.sql.SQLException

import hu.refilc.naplo.database.SQLiteHelper
import kotlin.arrayOf

class DBManager(private val context: Context) {
  private lateinit var database: SQLiteDatabase
  private lateinit var dbHelper: SQLiteHelper

  fun open(): DBManager {
    this.dbHelper = SQLiteHelper(this.context)
    this.database = this.dbHelper.getWritableDatabase()
    return this
  }
  
  fun close() {
    this.dbHelper.close()
  }

  fun fetchWidget(wid: Int): Cursor {
    val cursor: Cursor = this.database.query(SQLiteHelper.TABLE_NAME_WIDGETS, arrayOf(SQLiteHelper._ID, SQLiteHelper.DAY_SEL), "${SQLiteHelper._ID} = $wid", null, null, null, null)
    if (cursor != null) cursor.moveToFirst()
    return cursor
  }

  fun fetchTimetable(): Cursor {
    val cursor: Cursor = this.database.query(SQLiteHelper.TABLE_NAME_USER_DATA, arrayOf(SQLiteHelper.TIMETABLE), null, null, null, null, null)
    if (cursor != null) cursor.moveToFirst()
    return cursor
  }

  fun fetchLastUser(): Cursor {
    val cursor: Cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, arrayOf(SQLiteHelper.LAST_ACCOUNT_ID), null, null, null, null, null)
    if (cursor != null) cursor.moveToFirst()
    return cursor
  }

  fun fetchTheme(): Cursor {
    val cursor: Cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, arrayOf(SQLiteHelper.THEME, SQLiteHelper.CUSTOM_ACCENT_COLOR, SQLiteHelper.CUSTOM_BACKGROUND_COLOR), null, null, null, null, null)
    if (cursor != null) cursor.moveToFirst()
    return cursor
  }

  fun fetchLocale(): Cursor {
    val cursor: Cursor = this.database.query(SQLiteHelper.TABLE_NAME_SETTINGS, arrayOf(SQLiteHelper.LOCALE), null, null, null, null, null)
    if (cursor != null) cursor.moveToFirst()
    return cursor
  }

  fun deleteWidget(_id: Int) {
    this.database.delete(SQLiteHelper.TABLE_NAME_WIDGETS, "_id=$_id", null)
  }

  fun insertSelDay(_id: Int, day_sel: Int) {
    val con: ContentValues = ContentValues()
    con.put(SQLiteHelper._ID, _id)
    con.put(SQLiteHelper.DAY_SEL, day_sel)
    this.database.insert(SQLiteHelper.TABLE_NAME_WIDGETS, null, con)
  }

  fun update(_id: Int, day_sel: Int): Int {
    val con: ContentValues = ContentValues()
    con.put(SQLiteHelper.DAY_SEL, day_sel)
    return this.database.update(SQLiteHelper.TABLE_NAME_WIDGETS, con, "${SQLiteHelper._ID} = $_id", null)
  }
}
