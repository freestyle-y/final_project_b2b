package com.example.trade.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.trade.dto.Attachment;
import com.example.trade.mapper.AttachmentContractMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j // [수정] 로깅 추가
@Service
public class AttachmentContractService {

    private final AttachmentContractMapper attachmentContractMapper;

    public AttachmentContractService(AttachmentContractMapper attachmentContractMapper) {
        this.attachmentContractMapper = attachmentContractMapper;
    }

    /**
     * 첨부파일 저장
     * - filepath: 디렉터리(폴더) 경로만 저장
     * - filename: 실제 저장 파일명(savedName) 저장
     * - categoryCode: contractNo를 문자열로 저장(매퍼 조회 조건과 일치)
     */
    @Transactional(rollbackFor = Exception.class) // [수정] I/O 예외 롤백 보장
    public void saveFiles(List<MultipartFile> files,
                          String baseDir,
                          String attachmentCode,
                          String userId,
                          int contractNo) {

        log.info("=== 파일 저장 시작 ===");
        log.info("baseDir: {}, attachmentCode: {}, userId: {}, contractNo: {}, files: {}",
                baseDir, attachmentCode, userId, contractNo, (files == null ? 0 : files.size()));

        if (files == null || files.isEmpty()) {
            log.info("업로드할 파일이 없습니다.");
            return;
        }

        // 디렉터리 보장
        final Path dir = Paths.get(baseDir);
        try {
            Files.createDirectories(dir);
        } catch (IOException e) {
            throw new RuntimeException("업로드 디렉터리 생성 실패: " + e.getMessage(), e);
        }

        int nextPriority = attachmentContractMapper.selectNextPriority(attachmentCode, contractNo);
        log.info("다음 우선순위: {}", nextPriority);

        for (MultipartFile mf : files) {
            if (mf == null || mf.isEmpty()) continue;

            final String original = safeOriginalName(mf.getOriginalFilename());
            final String ext = extractExt(original);

            if (!isAllowedExt(ext)) {
                throw new IllegalArgumentException("허용되지 않은 확장자: " + ext);
            }

            final String savedName = UUID.randomUUID().toString().replace("-", "") + ext;
            final Path target = dir.resolve(savedName);

            try {
                // 덮어쓰기 금지 원하면 exists 체크 후 처리
                mf.transferTo(target.toFile());
                log.info("파일 저장됨: {}", target);
            } catch (IOException e) {
                throw new RuntimeException("파일 저장 실패: " + e.getMessage(), e);
            }

            Attachment at = new Attachment();
            at.setAttachmentCode(attachmentCode);
            // [수정] 문자열로 저장 (조회 조건과 일치)
            at.setCategoryCode(contractNo);
            at.setPriority(nextPriority++);
            // [수정] 디렉터리 경로만 저장 (다운로드 시 filepath + filename 결합)
            at.setFilepath(dir.toString().replace("\\", "/"));
            // [수정] 실제 저장 파일명 저장
            at.setFilename(savedName);
            at.setCreateUser(userId);
            at.setUseStatus("Y");

            int inserted = attachmentContractMapper.insertAttachment(at);
            log.info("DB 저장 완료: attachmentNo={}, 결과={}", at.getAttachmentNo(), inserted);
        }

        log.info("=== 파일 저장 완료 ===");
    }

    // 계약서별 첨부파일 목록 조회
    @Transactional(readOnly = true)
    public List<Attachment> getAttachmentsByContract(String attachmentCode, int contractNo) {
        log.info("=== 첨부파일 목록 조회 시작: code={}, contractNo={} ===", attachmentCode, contractNo);
        
        // 디버깅을 위한 추가 로그
        System.out.println("=== 첨부파일 목록 조회 디버깅 ===");
        System.out.println("attachmentCode: " + attachmentCode);
        System.out.println("contractNo: " + contractNo);
        System.out.println("contractNo 타입: " + Integer.class.getName());
        
        // [수정] 카테고리 문자열 매칭
        List<Attachment> list = attachmentContractMapper
                .selectAttachmentsByContract(attachmentCode, contractNo);
        
        System.out.println("MyBatis 쿼리 실행 완료");
        System.out.println("조회된 첨부파일 수: " + (list != null ? list.size() : 0));
        if (list != null && !list.isEmpty()) {
            System.out.println("첫 번째 첨부파일: " + list.get(0));
        }
        
        log.info("조회된 첨부파일 수: {}", (list == null ? 0 : list.size()));
        return list;
    }

    // 첨부파일 상세 조회
    @Transactional(readOnly = true)
    public Attachment getAttachmentByNo(int attachmentNo) {
        return attachmentContractMapper.selectAttachmentByNo(attachmentNo);
    }
    
    // 모든 첨부파일 조회 (디버깅용)
    @Transactional(readOnly = true)
    public List<Attachment> getAllAttachments() {
        log.info("=== 모든 첨부파일 조회 시작 ===");
        List<Attachment> list = attachmentContractMapper.selectAllAttachments();
        log.info("전체 첨부파일 수: {}", (list == null ? 0 : list.size()));
        return list;
    }

    // 첨부파일 삭제(물리 파일 삭제 + 논리 삭제)
    @Transactional(rollbackFor = Exception.class) // [수정] 롤백 보장
    public boolean deleteAttachment(int attachmentNo, String updateUser) {
        Attachment attachment = attachmentContractMapper.selectAttachmentByNo(attachmentNo);
        if (attachment == null) {
            return false;
        }

        // [수정] 실제 파일 경로 = 디렉터리 + 파일명
        Path filePath = Paths.get(
                nullToEmpty(attachment.getFilepath()),
                nullToEmpty(attachment.getFilename())
        );

        try {
            Files.deleteIfExists(filePath);
            log.info("물리 파일 삭제: {}", filePath);
        } catch (IOException e) {
            // 파일이 없거나 삭제 실패하더라도 DB 논리삭제는 진행
            log.warn("물리 파일 삭제 실패: {} - {}", filePath, e.getMessage());
        }

        int updated = attachmentContractMapper.deleteAttachment(attachmentNo, updateUser);
        return updated > 0;
    }

    // ====== 유틸 ======
    private static String safeOriginalName(String name) {
        if (name == null || name.isBlank()) return "file";
        // 경로 구분자 등 위험 문자 제거
        return name.replaceAll("[\\\\/\\r\\n\\t<>:\"|?*]", "_").trim();
    }

    private static String extractExt(String filename) {
        int idx = filename.lastIndexOf('.');
        return (idx >= 0 && idx < filename.length() - 1)
                ? filename.substring(idx).toLowerCase()
                : "";
    }

    private static boolean isAllowedExt(String ext) {
        // 대소문자 무시
        return ext.matches("\\.(?i)(png|jpg|jpeg|pdf|gif|webp|heic|txt|csv|docx|xlsx|pptx)");
    }

    private static String nullToEmpty(String s) {
        return (s == null ? "" : s);
    }
}
