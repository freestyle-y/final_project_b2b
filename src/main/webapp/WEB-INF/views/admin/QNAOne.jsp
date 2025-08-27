<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>문의 내역 상세</title>
<style>
    table {
        width: 50%;
        border-collapse: collapse;
        text-align: center;
        margin: auto;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
    }
    .delete-btn {
        border: none;
        background: none;
        padding: 0;
        margin: 0;
        color: blue;
        text-decoration: underline;
        cursor: pointer;
        font-size: 1em;
    }
    .delete-btn:hover {
        color: darkred;
    }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
	
	<h1>문의 내역 상세</h1>
	
   	<a href="/admin/FAQList">자주 묻는 질문</a> /
	<a href="/admin/QNAList">문의 내역</a> /
	<a href="/admin/noticeList">공지사항</a>
	
	<table>
		<c:forEach var="qna" items="${QNAOne}">
			<tr>
				<th>번호</th>
				<td>${qna.boardNo}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${qna.boardTitle}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${qna.boardContent}</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${qna.createUser}</td>
			</tr>
			<tr>
				<th>작성일시</th>
				<td>${qna.createDate}</td>
			</tr>
			<tr>
				<th>수정자</th>
				<td>${qna.updateUser}</td>
			</tr>
			<tr>
				<th>수정일시</th>
				<td>${qna.updateDate}</td>
			</tr>
			<tr>
				<th>사용 여부</th>
				<td>${qna.useStatus}</td>
			</tr>
			<tr>
				<th>조회수</th>
				<td>${qna.viewCount}</td>
			</tr>
		</c:forEach>
	</table>

	<a href="/admin/QNAList">목록</a>
	
	<h2>관리자 답변</h2>
	<form action="/admin/commentWrite" method="post">
		<input type="hidden" name="boardNo" value="${QNAOne[0].boardNo}">
		<textarea name="commentContent" rows="5" cols="60" placeholder="답변을 입력하세요"></textarea>
		<button type="submit">등록</button>
	</form>

	<h2>댓글</h2>

	<!-- 댓글 리스트 -->
	<div class="comments">
		<c:forEach var="comment" items="${commentList}">
			<div style="margin-left:${comment.depth * 20}px; border:1px solid #ddd; margin-bottom:5px; padding:5px;">
				<strong>
					<c:choose>
						<c:when test="${comment.createUser eq 'admin001'}">[관리자]</c:when>
						<c:otherwise>[작성자]</c:otherwise>
					</c:choose>
				</strong>
				${comment.commentContent}
				<div style="font-size: 0.8em; color: #555;">
					작성자: ${comment.createUser} / 작성일시: ${comment.createDate}
					<!-- 본인 댓글이 아닐 때만 '댓글쓰기' 노출 -->
					<c:if test="${comment.createUser ne username}">
        				/ <a href="#" onclick="showReplyForm(${comment.commentNo})">댓글쓰기</a>
					</c:if>
					<!-- 본인 댓글일 경우 '수정', '삭제' 노출 -->
					<c:if test="${comment.createUser eq username}">
						<!-- 수정 -->
						/ <a href="#" onclick="showEditForm(${comment.commentNo})">수정</a>
						<!-- 삭제 -->
						/ <form action="/admin/deleteComment" method="post" style="display: inline;">
							<input type="hidden" name="boardNo" value="${comment.boardNo}">
							<input type="hidden" name="commentNo" value="${comment.commentNo}">
							<button type="submit" class="delete-btn" onclick="return confirm('정말 댓글을 삭제하시겠습니까?');">삭제</button>
						</form>
					</c:if>
				</div>

				<!-- 대댓글 작성 폼 (숨김) -->
				<div id="replyForm-${comment.commentNo}" style="display: none; margin-top: 5px;">
					<form action="/admin/commentWrite" method="post">
						<!-- 원글 번호 -->
						<input type="hidden" name="boardNo" value="${comment.boardNo}">
						<!-- 부모 댓글 번호 -->
						<input type="hidden" name="parentCommentNo" value="${comment.commentNo}">
						<textarea name="commentContent" rows="5" cols="40" placeholder="댓글을 입력하세요"></textarea>
						<button type="submit">등록</button>
					</form>
				</div>

				<!-- 수정 폼 (숨김) -->
				<div id="editForm-${comment.commentNo}" style="display: none;">
					<form action="/admin/commentUpdate" method="post">
						<input type="hidden" name="boardNo" value="${comment.boardNo}">
						<input type="hidden" name="commentNo" value="${comment.commentNo}">
						<textarea name="commentContent" rows="5" cols="40">${comment.commentContent}</textarea>
						<button type="submit">수정</button>
					</form>
				</div>
			</div>
		</c:forEach>
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