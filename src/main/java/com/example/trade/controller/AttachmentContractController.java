package com.example.trade.controller;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.trade.service.AttachmentContractService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AttachmentContractController {
    private final AttachmentContractService attachmentContractService;

    public AttachmentContractController(AttachmentContractService attachmentContractService) {
        this.attachmentContractService = attachmentContractService;
    }

    @Value("${file.upload-dir}")
    private String uploadDir;

    @PostMapping("/attachmentUpload")
    public ResponseEntity<String> attachmentUpload(@RequestParam("contractNo") int contractNo,
                                   @RequestParam("files") List<MultipartFile> files,
                                   @RequestParam(value = "attachmentCode", required = false, defaultValue = "CONTRACT") String attachmentCode,
                                   Principal principal) {
        try {
            String userId = (principal != null) ? principal.getName() : "system";
            log.info("파일 업로드 시작 - 계약번호: {}, 사용자: {}, 파일수: {}", contractNo, userId, files.size());

            Path dir = Paths.get(uploadDir, attachmentCode, String.valueOf(contractNo));
            log.info("업로드 디렉토리: {}", dir.toString());

            attachmentContractService.saveFiles(files, dir.toString(), attachmentCode, userId, contractNo);

            log.info("파일 업로드 완료 - 계약번호: {}", contractNo);
            return ResponseEntity.ok("첨부파일 업로드가 완료되었습니다.");
        } catch (Exception e) {
            log.error("파일 업로드 실패 - 계약번호: {}, 오류: {}", contractNo, e.getMessage(), e);
            return ResponseEntity.internalServerError().body("파일 업로드에 실패했습니다: " + e.getMessage());
        }
    }
}
