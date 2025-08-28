package com.example.trade.controller;

import com.example.trade.dto.Holiday;
import com.example.trade.service.HolidayApiClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class HolidayController {
    private final HolidayApiClient client;
    public HolidayController(HolidayApiClient client) { this.client = client; }

    @GetMapping("/api/holidays")
    public List<Holiday> getHolidays(@RequestParam int year,
                                     @RequestParam(required = false) Integer month) {
        return client.fetch(year, month);
    }
}
