package hu.refilc.naplo.utils

import java.time.DayOfWeek
import java.time.Duration
import java.time.LocalDate
import kotlin.math.ceil

class Week private constructor(private final val start: LocalDate, private final val end: LocalDate) {
  companion object {
    fun current(): Week {
      return fromDate(LocalDate.now())
    }

    fun fromId(id: Int): Week {
      val _now: LocalDate = getYearStart().plusDays(id * 7L)
      return Week(_now.minusDays(_now.getDayOfWeek().getValue() - 1L), _now.plusDays(7L - _now.getDayOfWeek().getValue()))
    }

    fun fromDate(date: LocalDate): Week {
      return Week(date.minusDays(date.getDayOfWeek().getValue() - 1L), date.plusDays(7L - date.getDayOfWeek().getValue()))
    }

    private fun getYearStart(): LocalDate {
      val now: LocalDate = LocalDate.now()
      val start: LocalDate = getYearStart(now.getYear())
      return if (start.isBefore(now)) start else getYearStart(now.getYear() - 1)
    }

    private fun getYearStart(year: Int): LocalDate {
      val time: LocalDate = LocalDate.of(year, 9, 1)
      if (time.getDayOfWeek() == DayOfWeek.SATURDAY)
        return time.plusDays(2)
      else if (time.getDayOfWeek() == DayOfWeek.SUNDAY)
        return time.plusDays(1)
      return time
    }
  }

  fun next(): Week {
    return Week.fromDate(start.plusDays(8))
  }

  fun id(): Int {
    return Math.ceil(Duration.between(getYearStart().atStartOfDay(), start.atStartOfDay()).toDays() / 7.0).toInt()
  }

  override fun equals(o: Any?): Boolean {
    if (this == o as Week) return true
    if (o == null || Week::class != o::class) return false
    val week: Week = o as Week
    return this.id() == week.id()
  }

  override fun hashCode(): Int {
    return id()
  }
}
