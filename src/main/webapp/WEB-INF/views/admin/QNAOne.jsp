<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>문의 내역 상세</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
	
	<!-- Page Title -->
	<div class="page-title light-background">
		<div class="container d-lg-flex justify-content-between align-items-center">
			<h1 class="mb-2 mb-lg-0">문의 내역 상세</h1>
			<nav class="breadcrumbs">
				<ol>
					<li><%@include file="/WEB-INF/common/home.jsp"%></li>
					<li class="current">문의 내역</li>
				</ol>
			</nav>
		</div>
	</div>
	<!-- End Page Title -->
	
	<div class="container my-4">
		<c:forEach var="qna" items="${QNAOne}">
		<div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
			<!-- 제목 -->
			<h3 class="mb-0">${qna.boardTitle}</h3>
			<ul class="list-inline mb-0 text-muted small">
				<!-- 작성일시 -->
				<li class="list-inline-item">${qna.createDate}</li>
			</ul>
		</div>
		
		<!-- 본문 -->
		<div class="border-bottom pb-2 mb-3">
			<p>${qna.boardContent}</p>
		</div>
		</c:forEach>
		
		<div class="text-start">
			<a href="/admin/QNAList" class="btn btn-primary">목록</a>
		</div>
	</div>

	<!-- 댓글 영역 -->
	<div class="container my-5">
		<h4 class="mb-3">답변</h4>

		<c:if test="${empty commentList}">
			<p class="text-muted">등록된 답변이 없습니다.</p>
		</c:if>

		<c:forEach var="comment" items="${commentList}">
			<div class="card mb-3" style="margin-left:${comment.depth * 20}px;">
				<div class="card-body p-3">
					<div class="d-flex justify-content-between align-items-center">
						<div>
							<strong>
								<c:choose>
									<c:when test="${fn:startsWith(comment.createUser, 'admin')}">[관리자]</c:when>
									<c:otherwise>[작성자]</c:otherwise>
								</c:choose>
							</strong>
							<small class="text-muted ms-2">${comment.createDate}</small>
						</div>
						<div>
							<!-- 본인 댓글이 아닐 때만 '댓글쓰기' 노출 -->
							<c:if test="${comment.createUser ne username}">
								<a href="#" onclick="showReplyForm(${comment.commentNo}); return false;" class="btn btn-sm btn-outline-primary">댓글쓰기</a>
							</c:if>
							<!-- 본인 댓글일 경우 '수정', '삭제' 노출 -->
							<c:if test="${comment.createUser eq username}">
								<a href="#" onclick="showEditForm(${comment.commentNo}); return false;" class="btn btn-sm btn-outline-success">수정</a>
								<form action="/admin/deleteComment" method="post" class="d-inline">
									<input type="hidden" name="boardNo" value="${comment.boardNo}">
									<input type="hidden" name="commentNo" value="${comment.commentNo}">
									<button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('정말 댓글을 삭제하시겠습니까?');">삭제</button>
								</form>
							</c:if>
						</div>
					</div>
					<p class="mt-2 mb-0">${comment.commentContent}</p>

					<!-- 대댓글 작성 폼 (숨김) -->
					<div id="replyForm-${comment.commentNo}" class="mt-3" style="display: none;">
						<form action="/admin/commentWrite" method="post">
							<!-- 원글 번호 -->
							<input type="hidden" name="boardNo" value="${comment.boardNo}">
							<!-- 부모 댓글 번호 -->
							<input type="hidden" name="parentCommentNo" value="${comment.commentNo}">
							<textarea name="commentContent" rows="3" class="form-control mb-2" placeholder="댓글을 입력하세요"></textarea>
							<button type="submit" class="btn btn-sm btn-primary">등록</button>
						</form>
					</div>

					<!-- 수정 폼 (숨김) -->
					<div id="editForm-${comment.commentNo}" class="mt-3" style="display: none;">
						<form action="/admin/commentUpdate" method="post">
							<input type="hidden" name="boardNo" value="${comment.boardNo}">
							<input type="hidden" name="commentNo" value="${comment.commentNo}">
							<textarea name="commentContent" rows="3" class="form-control mb-2">${comment.commentContent}</textarea>
							<button type="submit" class="btn btn-sm btn-success">수정</button>
						</form>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
	
	<!-- 관리자 답변 -->
	<div class="container my-5">
		<h4 class="mb-3">관리자 답변</h4>
		<form action="/admin/commentWrite" method="post" class="mb-4">
			<input type="hidden" name="boardNo" value="${QNAOne[0].boardNo}">
			<div class="mb-3">
				<textarea class="form-control" name="commentContent" rows="4" placeholder="답변을 입력하세요"></textarea>
			</div>
			<div class="text-start">
				<button type="submit" class="btn btn-success">등록</button>
			</div>
		</form>
	</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
	// 댓글쓰기 클릭 시 댓글 입력 폼 토글
	function showReplyForm(commentNo) {
	    $("#replyForm-" + commentNo).toggle(); 
	}
	
	// 수정 클릭 시 댓글 수정 폼 토글
	function showEditForm(commentNo) {
	    $("#editForm-" + commentNo).toggle();
	}
</script>

</body>
</html>