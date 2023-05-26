package hu.filc.naplo.utils;

import java.time.DayOfWeek;
import java.time.Duration;
import java.time.LocalDate;

public class Week {
    private final LocalDate start;
    private final LocalDate end;

    private Week(LocalDate start, LocalDate end) {
        this.start = start;
        this.end = end;
    }

    public static Week current() {
        return fromDate(LocalDate.now());
    }

    public static Week fromId(int id) {
        LocalDate _now = getYearStart().plusDays(id * 7L);
        return new Week(_now.minusDays(_now.getDayOfWeek().getValue() - 1), _now.plusDays(7 - _now.getDayOfWeek().getValue()));
    }

    public static Week fromDate(LocalDate date) {

        return new Week(date.minusDays(date.getDayOfWeek().getValue() - 1), date.plusDays(7 - date.getDayOfWeek().getValue()));
    }

    public Week next() {
        return Week.fromDate(start.plusDays(8));
    }

    public int id() {
        return (int) Math.ceil(Duration.between(getYearStart().atStartOfDay(), start.atStartOfDay()).toDays() / 7f);
    }

    private static LocalDate getYearStart() {
        LocalDate now = LocalDate.now();
        LocalDate start = getYearStart(now.getYear());
        return start.isBefore(now) ? start : getYearStart(now.getYear() -1);
    }

    private static LocalDate getYearStart(int year) {
        LocalDate time = LocalDate.of(year, 9, 1);
        if (time.getDayOfWeek() == DayOfWeek.SATURDAY)
            return time.plusDays(2);
        else if (time.getDayOfWeek() == DayOfWeek.SUNDAY)
            return time.plusDays(1);
        return time;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Week week = (Week) o;
        return this.id() == week.id();
    }

    @Override
    public int hashCode() {
        return id();
    }
}