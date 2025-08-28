package com.example.trade.service;

import com.example.trade.config.HolidayApiProperties;
import com.example.trade.dto.Holiday;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class HolidayApiClient {
    private final WebClient webClient;
    private final HolidayApiProperties props;
    private final ObjectMapper om = new ObjectMapper();
    private static final DateTimeFormatter BASIC = DateTimeFormatter.BASIC_ISO_DATE;

    public HolidayApiClient(WebClient holidayWebClient, HolidayApiProperties props) {
        this.webClient = holidayWebClient;
        this.props = props;
    }

    /**
     * @param year  필수 (예: 2025)
     * @param month 옵션 (1~12) 없으면 해당 연도 전체
     */
    public List<Holiday> fetch(int year, Integer month) {
        try {
            var encodedKey = URLEncoder.encode(props.getServiceKey(), StandardCharsets.UTF_8);
            var uriSpec = webClient.get().uri(builder -> {
                var b = builder
                        .path("/getRestDeInfo")
                        .queryParam("serviceKey", encodedKey)
                        .queryParam("solYear", year)
                        .queryParam("_type", "json")
                        // 연도 전체를 받을 때 기본 10개만 오니 넉넉히 올립니다.
                        .queryParam("numOfRows", 100);
                if (month != null) {
                    b.queryParam("solMonth", String.format("%02d", month));
                }
                return b.build();
            });

            String json = uriSpec.retrieve().bodyToMono(String.class).onErrorResume(ex -> {
                return Mono.just("{}");
            }).block();

            return parse(json);
        } catch (Exception e) {
            return List.of();
        }
    }

    private List<Holiday> parse(String json) throws Exception {
        List<Holiday> list = new ArrayList<>();
        JsonNode root = om.readTree(json);
        JsonNode items = root.path("response").path("body").path("items").path("item");
        if (items.isMissingNode() || items.isNull()) return list;

        if (items.isArray()) {
            for (JsonNode it : items) list.add(toHoliday(it));
        } else {
            list.add(toHoliday(items));
        }
        return list;
    }

    private Holiday toHoliday(JsonNode it) {
        // 데이터 구조: dateName(명칭), locdate(yyyymmdd), isHoliday(Y/N) 등이 제공됩니다.
        // (공식 데이터셋 설명 참고) :contentReference[oaicite:1]{index=1}
        String name = asText(it, "dateName");
        String loc = asText(it, "locdate");
        boolean holi = "Y".equalsIgnoreCase(asText(it, "isHoliday"));
        // 대체공휴일 여부는 별도 필드가 없을 수 있어 이름에 '대체공휴일' 포함시 표시
        boolean substitute = StringUtils.hasText(name) && name.contains("대체공휴일");

        LocalDate date = LocalDate.parse(loc, BASIC);
        return new Holiday(date, name, holi, substitute);
    }

    private String asText(JsonNode n, String f) {
        return n.has(f) && !n.get(f).isNull() ? n.get(f).asText() : "";
    }
}
