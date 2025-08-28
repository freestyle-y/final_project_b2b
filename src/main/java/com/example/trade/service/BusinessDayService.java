package com.example.trade.service;

import com.example.trade.dto.Holiday;
import org.springframework.stereotype.Service;

import java.time.*;
import java.time.DayOfWeek;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
public class BusinessDayService {

    private final HolidayApiClient holidayApiClient; // 이미 만드신 API 클라이언트
    private final Map<Integer, Set<LocalDate>> holidayCache = new ConcurrentHashMap<>();

    public BusinessDayService(HolidayApiClient holidayApiClient) {
        this.holidayApiClient = holidayApiClient;
    }

    /** 평일(주말+공휴일 제외) 기준으로 days 만큼 더한 날짜를 리턴 (start는 미포함, 다음날부터 카운트) */
    public LocalDate addBusinessDays(LocalDate start, int days) {
        // span 대충 넉넉히 프리패치 (연도 걸칠 수 있으므로)
        preloadHolidaysForSpan(start, start.plusDays(days * 3L));

        LocalDate d = start;
        int added = 0;
        while (added < days) {
            d = d.plusDays(1);
            if (isBusinessDay(d)) added++;
            // 연도 넘어가면 추가 프리패치
            if (added < days && !holidayCache.containsKey(d.getYear())) {
                preloadHolidaysForSpan(d, d.plusDays(366));
            }
        }
        return d;
    }

    /** 날짜가 주말/공휴일이면 다음 영업일로 민다 */
    public LocalDate moveToNextBusinessDay(LocalDate date) {
        preloadHolidaysForSpan(date, date.plusDays(60));
        LocalDate d = date;
        while (!isBusinessDay(d)) d = d.plusDays(1);
        return d;
    }

    public boolean isBusinessDay(LocalDate d) {
        DayOfWeek w = d.getDayOfWeek();
        if (w == DayOfWeek.SATURDAY || w == DayOfWeek.SUNDAY) return false;
        Set<LocalDate> holis = holidayCache.computeIfAbsent(d.getYear(), this::loadHolidaysForYear);
        return !holis.contains(d);
    }

    private void preloadHolidaysForSpan(LocalDate from, LocalDate to) {
        for (int y = from.getYear(); y <= to.getYear(); y++) {
            holidayCache.computeIfAbsent(y, this::loadHolidaysForYear);
        }
    }

    private Set<LocalDate> loadHolidaysForYear(int year) {
        try {
            // API 구조상 isHoliday=Y 인 날 + (원하시면 대체공휴일 플래그도 포함) -> 비영업일로 처리
            return holidayApiClient.fetch(year, null).stream()
                    .filter(h -> h.isHoliday() || h.isSubstitute())
                    .map(Holiday::date)
                    .collect(Collectors.toSet());
        } catch (Exception e) {
            // API 장애 시 공휴일 제외 못하지만, 주말 기준만이라도 동작하도록 빈 집합
            return Collections.emptySet();
        }
    }
}
