package hu.refilc.naplo.widget_timetable

import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViewsService

class WidgetTimetableService: RemoteViewsService() {
  override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
    return WidgetTimetableDataProvider(getApplicationContext(), intent)
  }
}
