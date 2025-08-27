package com.example.trade.restController;

import java.nio.charset.StandardCharsets;                 // ✅ 수정: 다운로드 파일명 인코딩용
import java.nio.file.Files;                               // ✅ 수정: 콘텐츠 타입 추정
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.sql.DataSource;                              // ✅ 수정: 디버그용 DB 정보 노출

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.ContentDisposition;         // ✅ 수정: 안전한 Content-Disposition
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;          // ✅ 수정: 디버그용 DB 정보 노출
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.dto.Attachment;
import com.example.trade.service.AttachmentContractService;
import com.zaxxer.hikari.HikariDataSource;                 // ✅ 수정: JDBC URL 추출용 (Hikari일 때)

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/attachments")
public class AttachmentContractRestController {

    private final AttachmentContractService attachmentContractService;

    // ✅ 수정: 디버그용 DB 정보 노출에 필요한 빈 주입(생성자 주입)
    private final DataSource dataSource;
    private final JdbcTemplate jdbcTemplate;

    public AttachmentContractRestController(AttachmentContractService attachmentContractService,
                                            DataSource dataSource,                  // ✅
                                            JdbcTemplate jdbcTemplate) {            // ✅
        this.attachmentContractService = attachmentContractService;
        this.dataSource = dataSource;           // ✅
        this.jdbcTemplate = jdbcTemplate;       // ✅
    }

    @Value("${file.upload-dir}")
    private String uploadDir;

    /** 첨부파일 목록 조회 (AJAX) */
    @GetMapping("/{contractNo}")
    public ResponseEntity<List<Attachment>> getAttachments(
            @PathVariable int contractNo,
            @RequestParam(value = "attachmentCode", defaultValue = "CONTRACT") String attachmentCode) {
        try {
            log.info("첨부파일 목록 조회 - 계약번호: {}, 첨부파일코드: {}", contractNo, attachmentCode);

            List<Attachment> attachments =
                    attachmentContractService.getAttachmentsByContract(attachmentCode, contractNo);

            log.info("조회된 첨부파일 수: {}", (attachments == null ? 0 : attachments.size()));
            return ResponseEntity.ok(attachments);
        } catch (Exception e) {
            log.error("첨부파일 목록 조회 실패 - 계약번호: {}, 오류: {}", contractNo, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /** 파일 다운로드 */
    @GetMapping("/download/{attachmentNo}")
    public ResponseEntity<Resource> downloadFile(@PathVariable int attachmentNo, Principal principal) {
        try {
            Attachment attachment = attachmentContractService.getAttachmentByNo(attachmentNo);
            if (attachment == null) {
                return ResponseEntity.notFound().build();
            }

            Path filePath = Paths.get(attachment.getFilepath()).resolve(attachment.getFilename()).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                log.warn("파일을 찾을 수 없거나 읽을 수 없습니다. path={}", filePath);
                return ResponseEntity.notFound().build();
            }

            // ✅ 수정: 실제 콘텐츠 타입 추정 (없으면 이진)
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;

            // ✅ 수정: 안전한 Content-Disposition 헤더(한글/공백 대응)
            String downloadName = attachment.getFilename();
            String cd = ContentDisposition.attachment()
                    .filename(downloadName, StandardCharsets.UTF_8)
                    .build()
                    .toString();

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))  // ✅
                    .header(HttpHeaders.CONTENT_DISPOSITION, cd)         // ✅
                    .body(resource);

        } catch (Exception e) {
            log.error("파일 다운로드 실패 - 첨부파일번호: {}, 오류: {}", attachmentNo, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /** 첨부파일 삭제 (논리 삭제 + 물리 파일 삭제 시도는 Service에서) */
    @PostMapping("/delete")
    public ResponseEntity<String> deleteAttachment(@RequestParam("attachmentNo") int attachmentNo,
                                                   Principal principal) {
        try {
            String userId = (principal != null) ? principal.getName() : "system";
            boolean deleted = attachmentContractService.deleteAttachment(attachmentNo, userId);
            if (deleted) {
                return ResponseEntity.ok("첨부파일이 삭제되었습니다.");
            } else {
                return ResponseEntity.badRequest().body("첨부파일 삭제에 실패했습니다.");
            }
        } catch (Exception e) {
            log.error("첨부파일 삭제 실패 - 첨부파일번호: {}, 오류: {}", attachmentNo, e.getMessage(), e);
            return ResponseEntity.internalServerError().body("첨부파일 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /** 디버깅: 모든 첨부파일 조회 */
    @GetMapping("/debug/all")
    public ResponseEntity<List<Attachment>> getAllAttachments() {
        try {
            log.info("모든 첨부파일 조회 시작");
            List<Attachment> allAttachments = attachmentContractService.getAllAttachments();
            log.info("전체 첨부파일 수: {}", (allAttachments == null ? 0 : allAttachments.size()));
            return ResponseEntity.ok(allAttachments);
        } catch (Exception e) {
            log.error("모든 첨부파일 조회 실패: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /** 디버깅: 특정 계약번호의 첨부파일 상세 조회 */
    @GetMapping("/debug/contract/{contractNo}")
    public ResponseEntity<Map<String, Object>> debugContractAttachments(@PathVariable int contractNo) {
        try {
            log.info("계약번호 {} 첨부파일 디버깅 조회", contractNo);

            Map<String, Object> debugInfo = new HashMap<>();
            debugInfo.put("contractNo", contractNo);
            debugInfo.put("attachmentCode", "CONTRACT");

            // CONTRACT 코드로 바로 조회
            List<Attachment> contractAttachments =
                    attachmentContractService.getAttachmentsByContract("CONTRACT", contractNo);
            debugInfo.put("contractAttachments", contractAttachments);
            debugInfo.put("contractAttachmentsCount", contractAttachments.size());

            // 모든 첨부에서 동일 contractNo 필터
            List<Attachment> allAttachments = attachmentContractService.getAllAttachments();
            List<Attachment> matchingAttachments = allAttachments.stream()
                    .filter(att -> att.getCategoryCode() == contractNo)   // ✅ 수정: int 비교
                    .collect(Collectors.toList());
            debugInfo.put("matchingByCategoryCode", matchingAttachments);
            debugInfo.put("matchingByCategoryCodeCount", matchingAttachments.size());

            // 전체 개수/샘플
            debugInfo.put("totalAttachments", allAttachments.size());
            debugInfo.put("allAttachmentsSample", allAttachments.stream().limit(5).collect(Collectors.toList()));

            return ResponseEntity.ok(debugInfo);
        } catch (Exception e) {
            log.error("계약번호 {} 첨부파일 디버깅 조회 실패: {}", contractNo, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /** 디버깅: 서버가 바라보는 DB 정보를 확인 */
    @GetMapping("/debug/db")
    public ResponseEntity<Map<String, Object>> debugDb() {
        Map<String, Object> m = new HashMap<>();
        try {
            // ✅ 수정: 현재 연결된 DB/URL, CONTRACT 전체 행 수
            String database = jdbcTemplate.queryForObject("SELECT DATABASE()", String.class);
            Long cnt = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM attachment WHERE attachment_code='CONTRACT'", Long.class);

            String url = null;
            if (dataSource instanceof HikariDataSource ds) {
                url = ds.getJdbcUrl();
            }

            m.put("database", database);
            m.put("url", url);
            m.put("contract_rows", cnt);
            return ResponseEntity.ok(m);
        } catch (Exception e) {
            log.error("debugDb 호출 실패: {}", e.getMessage(), e);
            m.put("error", e.getMessage());
            return ResponseEntity.internalServerError().body(m);
        }
    }
}
