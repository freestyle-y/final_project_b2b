package com.example.trade.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.trade.dto.Attachment;
import com.example.trade.dto.Contract;
import com.example.trade.dto.ContractSignForm;
import com.example.trade.dto.Quotation;
import com.example.trade.service.AttachmentService;
import com.example.trade.service.ContractService;
import com.example.trade.service.QuotationService;

@Controller
public class ContractController {
	private final ContractService contractService;
	private final AttachmentService attachmentService;
	private final QuotationService quotationService;
	public ContractController(ContractService contractService, AttachmentService attachmentService, QuotationService quotationService) {
		super();
		this.contractService = contractService;
		this.attachmentService = attachmentService;
		this.quotationService = quotationService;
	}

	// 클래스 내부 필드에 추가
	@Value("${app.upload.root}")
	private String UPLOAD_ROOT;

	@Value("${app.upload.url-prefix}")
	private String URL_PREFIX;
	
	
	// 기업 회원 계약서 목록 페이지
	@GetMapping("/biz/contractList")
	public String contractList(Principal principal, Model model) {
		String userId = principal.getName();
		List<Contract> contractList = contractService.getContractList(userId);
		model.addAttribute("contractList", contractList);
		return "biz/contractList";
	}
	
	// 기업 회원 계약서 상세 페이지
	@GetMapping("/biz/contractOne")
	public String contractOne(@RequestParam("contractNo") int contractNo,
	                          Principal principal,
	                          Model model) {
	    String userId = principal.getName();
	    List<Contract> contractOne = contractService.getContractOne(contractNo, userId);
	    List<Contract> contractUser = contractService.getContractUser(userId);
	    List<Contract> contractSupplier = contractService.getContractSupplier(contractNo);

	    // ✅ 총액 계산
	    int totalPrice = 0;
	    for (Contract c : contractOne) {
	        if (c.getPrice() != 0 && c.getProductQuantity() != 0) {
	            totalPrice += c.getPrice() * c.getProductQuantity();
	        }
	    }

	    model.addAttribute("contractUser", contractUser);
	    model.addAttribute("contractOne", contractOne);
	    model.addAttribute("contractSupplier", contractSupplier);
	    model.addAttribute("totalPrice", totalPrice); // JSP에서 출력 가능

	    return "biz/contractOne";
	}
	
	// 관리자 계약서 목록 페이지
	@GetMapping("/admin/contractList")
	public String contractList(Model model) {
		List<Contract> contractList = contractService.getAllContractList();
		model.addAttribute("contractList", contractList);
		return "admin/contractList";
	}
	
	// 관리자 계약서 상세 페이지
	@GetMapping("/admin/contractOne")
	public String contractOne(@RequestParam("contractNo") int contractNo, Model model) {
	    List<Contract> contractOne = contractService.getContractOneForAdmin(contractNo);
	    List<Contract> contractSupplier = contractService.getContractSupplier(contractNo);
	    List<Contract> contractUser = contractService.getContractUserByContractNo(contractNo);
	    System.out.println("contractNo: " + contractNo);
	    System.out.println("contractOne size: " + (contractOne != null ? contractOne.size() : "null"));
	    // ✅ 총액 계산
	    int totalPrice = 0;
	    for (Contract c : contractOne) {
	        if (c.getPrice() != 0 && c.getProductQuantity() != 0) {
	        	System.out.println("→ 계약번호: " + c.getContractNo() + ", 계약금: " + c.getDownPayment());
	            totalPrice += c.getPrice() * c.getProductQuantity();
	        }
	    }

	    List<Attachment> signs = attachmentService.findContractSigns(contractNo);
	    Attachment supplierSign = null;
	    Attachment buyerSign = null;
	    for (Attachment a : signs) {
	        if (a.getPriority() == 1 && supplierSign == null) supplierSign = a;
	        if (a.getPriority() == 2 && buyerSign == null) buyerSign = a;
	    }

	    model.addAttribute("supplierSign", supplierSign);
	    model.addAttribute("buyerSign", buyerSign);
	    model.addAttribute("contractOne", contractOne);
	    model.addAttribute("contractSupplier", contractSupplier);
	    model.addAttribute("contractUser", contractUser);
	    model.addAttribute("totalPrice", totalPrice); // JSP에서 출력 가능

	    return "admin/contractOne";
	}
	
	// 관리자 계약서 작성 페이지
	@GetMapping("/admin/writeContract")
	public String writeContract(@RequestParam("quotationNo") int quotationNo, Model model) {

	    // 견적서 기반 데이터 조회
	    Quotation quotation = quotationService.getQuotationOne(quotationNo);
	    model.addAttribute("quotation", quotation);

	    // 공급자 (견적 작성자)
	    List<Contract> contractSupplier = contractService.getContractSupplierByQuotation(quotationNo);
	    // 수요자 (상품요청 작성자)
	    List<Contract> contractUser = contractService.getContractUserByQuotation(quotationNo);

	    // ✅ 총액 = 각 상품별 price 합산
	    int totalPrice = 0;
	    if (quotation != null && quotation.getItems() != null) {
	        for (var item : quotation.getItems()) {
	            totalPrice += item.getPrice();   // 단가×수량이 아니라 이미 입력한 총액 그대로 합산
	        }
	    }
	    model.addAttribute("totalPrice", totalPrice);
	    model.addAttribute("quotationNo", quotationNo);
	    model.addAttribute("contractSupplier", contractSupplier);
	    model.addAttribute("contractUser", contractUser);

	    return "admin/writeContract";
	}

	@PostMapping("/admin/contract/write")
	public String writeContractAdmin(
	        @ModelAttribute ContractSignForm form,
	        Principal principal,
	        RedirectAttributes ra
	) throws IOException {  // ✅ IOException 위임

	    String quotationNoStr = form.getQuotationNo();
	    String downPaymentStr = form.getDownPayment();
	    String finalPaymentStr = form.getFinalPayment();

	    int quotationNo = Integer.parseInt(quotationNoStr);
	    int downPayment = Integer.parseInt(downPaymentStr.replaceAll(",", ""));
	    int finalPayment = Integer.parseInt(finalPaymentStr.replaceAll(",", ""));

	    String userId = (principal != null) ? principal.getName() : "admin";

	    Contract contract = new Contract();
	    contract.setQuotationNo(quotationNo);
	    contract.setDownPayment(downPayment);
	    contract.setFinalPayment(finalPayment);
	    contract.setCreateUser(userId);
	    contract.setUseStatus("Y");

	    contractService.insertContract(contract);
	    int newContractNo = contract.getContractNo();

	    // ✅ 서명 저장
	    List<Attachment> toSave = new ArrayList<>();

	    if (StringUtils.hasText(form.getSupplierSignature())) {
	        Attachment a = saveSignatureDataUrl(form.getSupplierSignature(), newContractNo, 1, "supplier", userId);
	        if (a != null) toSave.add(a);
	    }

	    if (StringUtils.hasText(form.getBuyerSignature())) {
	        Attachment a = saveSignatureDataUrl(form.getBuyerSignature(), newContractNo, 2, "buyer", userId);
	        if (a != null) toSave.add(a);
	    }

	    if (!toSave.isEmpty()) {
	        attachmentService.saveAll(toSave);
	    }

	    ra.addFlashAttribute("msg", "계약서와 서명이 저장되었습니다.");
	    return "redirect:/admin/contractOne?contractNo=" + newContractNo;
	}




	
	
	@PostMapping("/biz/contract/write")
    public String writeContract(
            @ModelAttribute ContractSignForm form,
            Principal principal,
            RedirectAttributes ra
    ) throws IOException {

        // 1) 계약서 번호 확보(이미 존재한다고 가정)
        if (!StringUtils.hasText(form.getContractNo())) {
            ra.addFlashAttribute("error", "contractNo가 필요합니다.");
            return "redirect:/admin/contractList";
        }
        int contractNo = Integer.parseInt(form.getContractNo());
        String userId = principal != null ? principal.getName() : "system";

        // 2) DataURL → 파일 저장 후 Attachment 빌드
        List<Attachment> toSave = new ArrayList<>();

        if (StringUtils.hasText(form.getSupplierSignature())) {
            Attachment a = saveSignatureDataUrl(form.getSupplierSignature(), contractNo, 1, "supplier", userId);
            if (a != null) toSave.add(a);
        }
        if (StringUtils.hasText(form.getBuyerSignature())) {
            Attachment a = saveSignatureDataUrl(form.getBuyerSignature(), contractNo, 2, "buyer", userId);
            if (a != null) toSave.add(a);
        }

        // 3) DB insert
        if (!toSave.isEmpty()) {
            attachmentService.saveAll(toSave);
        }

        ra.addFlashAttribute("msg", "계약서 서명이 저장되었습니다.");
        return "redirect:/admin/contractOne?contractNo=" + contractNo;
    }

    /**
     * DataURL(예: data:image/png;base64,AAAA...)을 디코드하여 파일로 저장하고,
     * attachment 레코드를 만들어 반환.
     */
    private Attachment saveSignatureDataUrl(String dataUrl, int contractNo, int priority, String role, String userId) throws IOException {
        // dataURL 파싱
        if (!dataUrl.startsWith("data:")) return null;
        String[] parts = dataUrl.split(",");
        if (parts.length != 2) return null;

        String meta = parts[0]; // data:image/png;base64
        String base64 = parts[1];

        // 확장자 추출 (png/jpg/svg 등)
        String ext = "png";
        if (meta.contains("image/jpeg")) ext = "jpg";
        else if (meta.contains("image/svg+xml")) ext = "svg";
        else if (meta.contains("image/png")) ext = "png";

        // 파일명/경로 구성 (연-월 폴더)
        LocalDate now = LocalDate.now();
        String ym = now.format(DateTimeFormatter.ofPattern("yyyy/MM"));
        String relDir = "/signatures/" + ym;        // URL 기준 상대 디렉토리
        String filename = "contract_" + contractNo + "_" + role + "." + ext;

        // 실제 저장 디렉토리
        File dir = new File(UPLOAD_ROOT + relDir);
        if (!dir.exists()) dir.mkdirs();

        // 파일 저장
        byte[] data = Base64.getDecoder().decode(base64);
        File out = new File(dir, filename);
        Files.write(out.toPath(), data);

        // Attachment 레코드 생성
        Attachment att = new Attachment();
        att.setAttachmentCode("CONTRACT_SIGN");
        att.setCategoryCode(contractNo);
        att.setPriority(priority);
        att.setFilepath(URL_PREFIX + relDir);   // ex) /uploads/signatures/2025/08
        att.setFilename(filename);
        att.setCreateUser(userId);
        att.setUseStatus("Y");
        return att;
    }
}
