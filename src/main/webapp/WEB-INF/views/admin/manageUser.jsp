<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        h1 { margin-bottom: 20px; }
        .filter-box {
            background: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        select, button {
            padding: 6px 10px;
            margin-right: 10px;
        }
        table {
            width: 100%;
            max-width: 960px;
            margin: 0 auto;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #f0f0f0;
        }
        .btn-approve {
            background: #007bff;
            color: #fff;
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-approve:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
    <jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

    <h1>회원 관리</h1>

    <!-- 필터 -->
    <div class="filter-box">
        <label>회원 구분:
            <select id="filterType">
                <option value="">전체</option>
                <option value="CC001">관리자</option>
                <option value="CC002">기업회원</option>
                <option value="CC003">개인회원</option>
            </select>
        </label>
        <label>상태:
            <select id="filterStatus">
                <option value="">전체</option>
                <option value="CS001">활성화</option>
                <option value="CS002">휴면</option>
                <option value="CS003">탈퇴</option>
                <option value="CS004">가입대기</option>
            </select>
        </label>
        <button id="btnSearch">조회</button>
    </div>

    <!-- 회원 테이블 -->
    <table id="userTable">
        <thead>
            <tr>
                <th>아이디</th>
                <th>이름</th>
                <th>회원 구분</th>
                <th>이메일</th>
                <th>전화번호</th>
                <th>상태</th>
                <th>가입일</th>
                <th>승인</th>
            </tr>
        </thead>
        <tbody>
            <!-- 데이터 Ajax 로드 -->
        </tbody>
    </table>

    <jsp:include page="/WEB-INF/common/footer/footer.jsp" />

    <script>
        // 한글 변환 매핑
        const typeMap = {
            "CC001": "관리자",
            "CC002": "기업회원",
            "CC003": "개인회원"
        };
        const statusMap = {
            "CS001": "활성화",
            "CS002": "휴면",
            "CS003": "탈퇴",
            "CS004": "가입대기"
        };

        function loadUsers() {
            let type = $("#filterType").val();
            let status = $("#filterStatus").val();

            $.ajax({
                url: "/public",
                type: "GET",
                data: { type: type, status: status },
                success: function(users) {
					console.log(users);
                    let tbody = $("#userTable tbody");
                    tbody.empty();

                    if (users.length === 0) {
                        tbody.append("<tr><td colspan='8'>조회된 회원이 없습니다.</td></tr>");
                        return;
                    }

                    users.forEach(u => {
                        let approveBtn = "-";
                        if (u.customerCategory === "CC002" && u.customerStatus === "CS004") {
                            approveBtn = `<button class="btn-approve" onclick="approveUser('${u.id}')">승인</button>`;
                        }
                        // console.log(u.email);
                        // console.log(u.id);
                        console.log(users[0]);
                        let row = `
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.name}</td>
                                <td>${typeMap[u.customerCategory] || u.customerCategory}</td>
                                <td>${u.email || ''}</td>
                                <td>${u.phone || ''}</td>
                                <td>${statusMap[u.customerStatus] || u.customerStatus}</td>
                                <td>${u.createDate || ''}</td>
                                <td>${approveBtn}</td>
                            </tr>
                        `;
                        tbody.append(row);
                    });
                }
            });
        }

        function approveUser(id) {
            if (!confirm("해당 회원을 승인하시겠습니까?")) return;

            $.ajax({
                url: "/public/" + id + "/approve",
                type: "PUT",
                success: function() {
                    alert("승인 완료되었습니다.");
                    loadUsers();
                },
                error: function() {
                    alert("승인 처리 중 오류가 발생했습니다.");
                }
            });
        }

        $("#btnSearch").click(function() {
            loadUsers();
        });

        // 페이지 로드 시 전체 조회
        $(document).ready(function() {
            loadUsers();
        });
    </script>
</body>
</html>
