<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>상품 등록</title>
<style>
    /* Google Fonts */
    @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');

    body {
        background-color: #f4f7f6;
        font-family: 'Noto Sans KR', sans-serif;
        color: #333;
        line-height: 1.6;
        margin: 0;
        padding: 0;
    }

    .container {
        max-width: 900px;
        margin: 40px auto;
        padding: 40px;
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
    }

    h1 {
        text-align: center;
        color: #2c3e50;
        margin-bottom: 40px;
        font-weight: 700;
    }

    form {
        display: flex;
        flex-direction: column;
        gap: 25px;
    }
    
    .form-group {
        display: flex;
        align-items: center;
    }

    .form-group label {
        flex: 0 0 150px;
        font-weight: 500;
        color: #555;
    }

    select,
    input[type="text"],
    input[type="number"],
    input[type="file"] {
        flex: 1;
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        transition: border-color 0.3s, box-shadow 0.3s;
        max-width: 300px;
    }
    
    select:focus,
    input[type="text"]:focus,
    input[type="number"]:focus {
        outline: none;
        border-color: #3498db;
        box-shadow: 0 0 8px rgba(52, 152, 219, 0.2);
    }

    .sub-section {
        margin-left: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .sub-section input[type="text"] {
        max-width: 200px;
    }

</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 기존 스크립트 코드는 변경하지 않았습니다.
    const optionList = [
        <c:forEach var="opt" items="${optionList}" varStatus="status">
            {
                optionNo: ${opt.optionNo},
                optionName: '${opt.optionName}',
                optionNameValue: '${opt.optionNameValue}'
            }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
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

    $(document).ready(function() {
        const $nameSelect = $('#optionNameSelect');
        const $newOptionName = $('#newOptionName');
        
        Object.keys(optionMap).forEach(name => {
            $nameSelect.append(
                $('<option>', { value: name, text: name })
            );
        });
        
        $nameSelect.on('change', function() {
            const selectedOption = $(this).val();
            $newOptionName.val(selectedOption);
        });
        
        $('#productForm').on('submit', function(e) {
            e.preventDefault();

            if (!setCategoryIdBeforeSubmit()) {
                return;
            }

            const productName = $('input[name="productName"]').val().trim();
            const optionNo = $('#optionValueSelect').val();

            if (!productName) {
                alert('상품명을 입력하세요.');
                return;
            }
            if (!optionNo) {
                alert('옵션 값을 선택하세요.');
                return;
            }

            $.ajax({
                url: '/checkProductOptionDuplication',
                type: 'POST',
                data: {
                    productName: productName,
                    optionNo: Number(optionNo)
                },
                success: function(res) {
                    if (res.exists) {
                        alert('같은 상품명과 옵션 조합이 이미 존재합니다.');
                    } else {
                        e.currentTarget.submit();
                    }
                },
                error: function() {
                    alert('중복 체크 중 오류가 발생했습니다.');
                }
            });
        });
    });

    function onOptionNameChange() {
        const selectedName = $('#optionNameSelect').val();
        const $valueSelect = $('#optionValueSelect');
        $valueSelect.html('<option value="">-- 값 선택 --</option>');

        if (selectedName && optionMap[selectedName]) {
            optionMap[selectedName].forEach(item => {
                $valueSelect.append(
                    $('<option>', {
                        value: item.optionNo,
                        text: item.value
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

                if ($('#optionNameSelect').val() === name) {
                    onOptionNameChange();
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
                    nameInput.value = '';
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
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container">
    <h1>상품 등록</h1>

    <form id="productForm" method="post" action="/admin/insertProduct" enctype="multipart/form-data">
    
        <input type="hidden" id="creatUser" name="createUser" value="${loginUserName}">
        <div class="form-group">
            <label>상품명:</label>
            <input type="text" name="productName" required>
        </div>

        <div class="form-group">
            <label>이미지 등록:</label>
            <input type="file" name="productImage" accept="image/*" multiple>
        </div>

		<div class="form-group">
		    <label>상세 이미지 등록:</label>
		    <input type="file" name="detailImages" accept="image/*" multiple>
		</div>
		
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
                <section class="register py-1">
				   <div class="text-center">
				      <button type="button" class="btn btn-register btn-xs" onclick="addCategory('Major')"
				      	style="font-size: 14px; padding: 10px 20px; height: 45px; line-height: 1.1;">
				      대분류 추가</button>
				   </div>
				</section>
            </div>
        </div>

        <div class="form-group">
            <label>중분류:</label>
            <select id="middleCategory" onchange="onMiddleCategoryChange()">
                <option value="">-- 중분류 선택 --</option>
            </select>
            <div class="sub-section">
                <input type="text" id="newMiddleCategory" placeholder="새 중분류 입력">
                <section class="register py-1">
				   <div class="text-center">
				      <button type="button" class="btn btn-register btn-xs" onclick="addCategory('Middle')"
				      	style="font-size: 14px; padding: 10px 20px; height: 45px; line-height: 1.1;">
				      중분류 추가</button>
				   </div>
				</section>
            </div>
        </div>

        <div class="form-group">
            <label>소분류:</label>
            <select id="minorCategory">
                <option value="">-- 소분류 선택 --</option>
            </select>
            <div class="sub-section">
                <input type="text" id="newMinorCategory" placeholder="새 소분류 입력">
                <section class="register py-1">
				   <div class="text-center">
				      <button type="button" class="btn btn-register btn-xs" onclick="addCategory('Minor')"
				      	style="font-size: 14px; padding: 10px 20px; height: 45px; line-height: 1.1;">
				      소분류 추가</button>
				   </div>
				</section>
            </div>
        </div>

        <input type="hidden" id="categoryId" name="categoryId" />

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
        
        <div class="form-group">
            <label>옵션명 추가:</label>
            <input type="text" id="newOptionName" placeholder="예: 사이즈">
        </div>
        
        <div class="form-group">
            <label>옵션값 추가:</label>
            <input type="text" id="newOptionValue" placeholder="예: XXL">
        </div>
        
        <section class="register py-1">
		   <div class="text-end">
		      <button type="button" class="btn btn-register btn-xs" onclick="addOption()"
		      	style="font-size: 14px; padding: 10px 20px; height: 45px; line-height: 1.1;">
		      옵션 추가</button>
		   </div>
		</section>
				
        <div class="form-group">
            <label>금액:</label>
            <input type="number" name="price" required>
        </div>

		<section class="register py-1">
		   <div class="text-end">
		      <button type="submit" class="btn btn-register"
		      	style="font-size: 14px; padding: 10px 20px; height: 45px; line-height: 1.1;">
		      상품 등록</button>
		   </div>
		</section>
    </form>
</div>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>