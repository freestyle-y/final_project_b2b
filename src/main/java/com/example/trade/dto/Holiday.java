package com.example.trade.dto;

import java.time.LocalDate;

public record Holiday(LocalDate date, String name, boolean isHoliday, boolean isSubstitute) {
}
