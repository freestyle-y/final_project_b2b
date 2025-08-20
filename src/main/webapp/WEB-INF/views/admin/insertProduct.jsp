<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<style>
    body {
        font-family: Arial, sans-serif;
        padding: 20px;
    }
    .form-group {
        margin-bottom: 15px;
    }
    label {
        display: inline-block;
        width: 150px;
    }
    select, input[type="text"], input[type="number"], input[type="file"], button {
        padding: 5px;
        width: 250px;
    }
    .sub-section {
        margin-left: 160px;
        margin-top: 5px;
    }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

	const optionList = [
	    <c:forEach var="opt" items="${optionList}" varStatus="status">
	        {
	            optionNo: ${opt.optionNo},
	            optionName: '${opt.optionName}',
	            optionNameValue: '${opt.optionNameValue}'
	        }<c:if test="${!status.last}">,</c:if>
	    </c:forEach>
	];
	
	// 옵션 그룹화
	const optionMap = {};
	optionList.forEach(opt => {
	    if (!optionMap[opt.optionName]) {
	        optionMap[opt.optionName] = [];
	    }
	    optionMap[opt.optionName].push({
	        value: opt.optionNameValue,
	        optionNo: opt.optionNo
	    });
	});

	// 옵션 종류 채우기
	$(document).ready(function() {
	    const $nameSelect = $('#optionNameSelect');
	    const $newOptionName = $('#newOptionName'); // 자동 입력할 input
	    
	    Object.keys(optionMap).forEach(name => {
	        $nameSelect.append(
	            $('<option>', { value: name, text: name })
	        );
	    });
	    
	 	// 옵션 종류 선택 시 옵션명 자동 입력
	    $nameSelect.on('change', function() {
	        const selectedOption = $(this).val();
	        $newOptionName.val(selectedOption); // 입력창에 자동 채움
	    });
	});

	// 옵션 값 채우기
	function onOptionNameChange() {
	    const selectedName = $('#optionNameSelect').val();
	    const $valueSelect = $('#optionValueSelect');
	    $valueSelect.html('<option value="">-- 값 선택 --</option>');

	    if (selectedName && optionMap[selectedName]) {
	        optionMap[selectedName].forEach(item => {
	            $valueSelect.append(
	                $('<option>', {
	                    value: item.optionNo, // 서버로 넘길 번호
	                    text: item.value      // 사용자 표시
	                })
	            );
	        });
	    }
	}

	function addOption() {
	    const name = $('#newOptionName').val().trim();
	    const value = $('#newOptionValue').val().trim();
	    const createUser = '${loginUserName}';

	    if (!name || !value) {
	        alert("옵션명과 옵션값을 모두 입력하세요.");
	        return;
	    }

	    $.ajax({
	        url: '/addOption',
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify({
	            optionName: name,
	            optionNameValue: value,
	            createUser: createUser
	        }),
	        success: function(newOption) {
	            alert("옵션이 추가되었습니다.");
	            $('#newOptionName').val('');
	            $('#newOptionValue').val('');

	            // 내부 optionMap 갱신
	            if (!optionMap[name]) {
	                optionMap[name] = [];
	                $('#optionNameSelect').append(
	                    $('<option>', { value: name, text: name })
	                );
	            }
	            optionMap[name].push({
	                value: value,
	                optionNo: newOption.optionNo
	            });

	            // 드롭다운 새로고침
	            if ($('#optionNameSelect').val() === name) {
	                onOptionNameChange(); // 현재 선택 중인 옵션이면 하위 값도 갱신
	            }
	        },
	        error: function() {
	            alert("옵션 추가에 실패했습니다.");
	        }
	    });
	}

	
    function addCategory(level) {
    	const nameInput = document.getElementById("new" + level + "Category");
        const name = nameInput.value.trim();
        
        if (!name) {
            alert(`${level} 카테고리 이름을 입력하세요.`);
            return;
        }

        let parentId;
        if (level === 'Middle') {
            parentId = document.getElementById("majorCategory").value;
            if (!parentId) {
                alert("먼저 대분류를 선택하세요.");
                return;
            }
        } else if (level === 'Minor') {
            parentId = document.getElementById("middleCategory").value;
            if (!parentId) {
                alert("먼저 중분류를 선택하세요.");
                return;
            }
        }

        const loginUser = "${loginUserName}";

        $.ajax({
            url: '/addCategories',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                categoryName: name,
                parentCategory: (level === 'Major') ? '0' : parentId,
                createUser: loginUser
            }),
            success: function(newCategory) {
                if(level === 'Major') {
                    const $majorSelect = $('#majorCategory');
                    $majorSelect.append($('<option>', {
                        value: newCategory.categoryId,
                        text: newCategory.categoryName
                    }));
                    nameInput.value = ''; // 입력창 초기화
                    alert('대분류가 추가되었습니다.');
                } else if (level === 'Middle') {
                    const $middleSelect = $('#middleCategory');
                    $middleSelect.append($('<option>', {
                        value: newCategory.categoryId,
                        text: newCategory.categoryName
                    }));
                    nameInput.value = '';
                    alert('중분류가 추가되었습니다.');
                } else if (level === 'Minor') {
                    const $minorSelect = $('#minorCategory');
                    $minorSelect.append($('<option>', {
                        value: newCategory.categoryId,
                        text: newCategory.categoryName
                    }));
                    nameInput.value = '';
                    alert('소분류가 추가되었습니다.');
                }
            },
            error: function() {
                alert(`${level} 추가 실패`);
            }
        });
    }

    function onMajorCategoryChange() {
        const $middleSelect = $("#middleCategory");
        $middleSelect.html('<option value="">-- 중분류 선택 --</option>');

        const $minorSelect = $("#minorCategory");
        $minorSelect.html('<option value="">-- 소분류 선택 --</option>');

        const majorId = $("#majorCategory").val();
        if (!majorId) return;

        $.ajax({
            url: "/categories/" + majorId + "/children",
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                $.each(data, function(index, category) {
                    $middleSelect.append(
                        $('<option>', {
                            value: category.categoryId,
                            text: category.categoryName
                        })
                    );
                });
            },
            error: function() {
                alert("중분류 로딩 실패");
            }
        });
    }

    function onMiddleCategoryChange() {
        const $minorSelect = $("#minorCategory");
        $minorSelect.html('<option value="">-- 소분류 선택 --</option>');

        const middleId = $("#middleCategory").val();
        if (!middleId) return;

        $.ajax({
            url: "/categories/" + middleId + "/children",
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                $.each(data, function(index, category) {
                    $minorSelect.append(
                        $('<option>', {
                            value: category.categoryId,
                            text: category.categoryName
                        })
                    );
                });
            },
            error: function() {
                alert("소분류 로딩 실패");
            }
        });
    }

    // 상품 등록 전 카테고리 우선순위로 categoryId 세팅
    function setCategoryIdBeforeSubmit() {
        const minorVal = $("#minorCategory").val();
        const middleVal = $("#middleCategory").val();
        const majorVal = $("#majorCategory").val();

        let selectedCategoryId = "";

        if (minorVal) {
            selectedCategoryId = minorVal;
        } else if (middleVal) {
            selectedCategoryId = middleVal;
        } else if (majorVal) {
            selectedCategoryId = majorVal;
        }

        if (!selectedCategoryId) {
            alert("카테고리를 최소 하나 선택하세요.");
            return false;
        }

        $("#categoryId").val(selectedCategoryId);
        return true;
    }
</script>
</head>
<jsp:include page="/WEB-INF/common/header/adminHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<h1>상품 등록</h1>

<form method="post" action="/admin/insertProduct" enctype="multipart/form-data" onsubmit="return setCategoryIdBeforeSubmit();">

	<input type="hidden" id="creatUser" name="createUser" value="${loginUserName}">
    <div class="form-group">
        <label>상품명:</label>
        <input type="text" name="productName" required>
    </div>

    <div class="form-group">
        <label>이미지 등록:</label>
        <input type="file" name="productImage">
    </div>

    <!-- 대분류 선택 및 추가 -->
    <div class="form-group">
        <label>대분류:</label>
        <select id="majorCategory" onchange="onMajorCategoryChange()">
            <option value="">-- 대분류 선택 --</option>
            <c:forEach var="item" items="${majorCategoryList}">
                <option value="${item.categoryId}">${item.categoryName}</option>
            </c:forEach>
        </select>
        <div class="sub-section">
            <input type="text" id="newMajorCategory" placeholder="새 대분류 입력">
            <button type="button" onclick="addCategory('Major')">대분류 추가</button>
        </div>
    </div>

    <!-- 중분류 선택 및 추가 -->
    <div class="form-group">
        <label>중분류:</label>
        <select id="middleCategory" onchange="onMiddleCategoryChange()">
            <option value="">-- 중분류 선택 --</option>
        </select>
        <div class="sub-section">
            <input type="text" id="newMiddleCategory" placeholder="새 중분류 입력">
            <button type="button" onclick="addCategory('Middle')">중분류 추가</button>
        </div>
    </div>

    <!-- 소분류 선택 및 추가 -->
    <div class="form-group">
        <label>소분류:</label>
        <select id="minorCategory">
            <option value="">-- 소분류 선택 --</option>
        </select>
        <div class="sub-section">
            <input type="text" id="newMinorCategory" placeholder="새 소분류 입력">
            <button type="button" onclick="addCategory('Minor')">소분류 추가</button>
        </div>
    </div>

    <!-- 숨겨진 카테고리 ID 전달용 -->
    <input type="hidden" id="categoryId" name="categoryId" />

    <!-- 옵션 선택 (2단 드롭다운) -->
	<div class="form-group">
	    <label>옵션 종류:</label>
	    <select id="optionNameSelect" onchange="onOptionNameChange()" required>
	        <option value="">-- 옵션 선택 --</option>
	    </select>
	</div>
	
	<div class="form-group">
	    <label>옵션 값:</label>
	    <select id="optionValueSelect" name="optionNo" required>
	        <option value="">-- 값 선택 --</option>
	    </select>
	</div>
	
	<!-- 옵션 추가 영역 -->
	<div class="form-group">
	    <label>옵션명 추가:</label>
	    <input type="text" id="newOptionName" placeholder="예: 사이즈">
	</div>
	
	<div class="form-group">
	    <label>옵션값 추가:</label>
	    <input type="text" id="newOptionValue" placeholder="예: XXL">
	</div>
	
	<div class="form-group">
	    <label></label>
	    <button type="button" onclick="addOption()">옵션 추가</button>
	</div>

    <div class="form-group">
        <label>금액:</label>
        <input type="number" name="price" required>
    </div>

    <div class="form-group">
        <label></label>
        <button type="submit">상품 등록</button>
    </div>

</form>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
