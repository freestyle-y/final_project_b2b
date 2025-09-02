<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>카테고리 관리</title>
  <link rel="stylesheet" href="https://uicdn.toast.com/tui-tree/latest/tui-tree.css" />
</head>
<body>

<h2 style="text-align: center;">카테고리 트리</h2>
<div id="tree" class="tui-tree-wrap"></div>

<script src="https://uicdn.toast.com/tui-tree/latest/tui-tree.js"></script>

<script>
  // JSTL에서 넘긴 categoryList를 JS 배열로 변환 (숫자는 null 처리)
  const rawCategoryList = [
    <c:forEach var="cat" items="${categoryList}" varStatus="status">
      {
        categoryIdLv1: ${cat.categoryIdLv1 != null ? cat.categoryIdLv1 : 'null'},
        categoryNameLv1: "${cat.categoryNameLv1}",
        categoryIdLv2: ${cat.categoryIdLv2 != null ? cat.categoryIdLv2 : 'null'},
        categoryNameLv2: "${cat.categoryNameLv2}",
        categoryIdLv3: ${cat.categoryIdLv3 != null ? cat.categoryIdLv3 : 'null'},
        categoryNameLv3: "${cat.categoryNameLv3}"
      }<c:if test="${!status.last}">,</c:if>
    </c:forEach>
  ];

  // 트리 데이터 변환 함수
  function transformToTreeData(categoryList) {
    const map = {};
    const result = [];

    categoryList.forEach(cat => {
      const { categoryIdLv1, categoryNameLv1, categoryIdLv2, categoryNameLv2, categoryIdLv3, categoryNameLv3 } = cat;

      if (categoryIdLv1 && !map[categoryIdLv1]) {
        const node = {
          text: categoryNameLv1,
          data: { categoryId: categoryIdLv1 },
          children: []
        };
        map[categoryIdLv1] = node;
        result.push(node);
      }

      if (categoryIdLv2 && !map[categoryIdLv2]) {
        const midNode = {
          text: categoryNameLv2,
          data: { categoryId: categoryIdLv2 },
          children: []
        };
        map[categoryIdLv2] = midNode;
        if (map[categoryIdLv1]) {
          map[categoryIdLv1].children.push(midNode);
        }
      }

      if (categoryIdLv3 && !map[categoryIdLv3]) {
        const subNode = {
          text: categoryNameLv3,
          data: { categoryId: categoryIdLv3 }
        };
        map[categoryIdLv3] = subNode;
        if (map[categoryIdLv2]) {
          map[categoryIdLv2].children.push(subNode);
        }
      }
    });

    return result;
  }

  const treeData = transformToTreeData(rawCategoryList);

  // 트리 생성
  const tree = new tui.Tree('#tree', {
    data: treeData,
    nodeDefaultState: 'opened',
    template: {
      internalNode:
        '<div class="tui-tree-content-wrapper" style="padding-left: {{indent}}px">' +
          '<button type="button" class="tui-tree-toggle-btn tui-js-tree-toggle-btn">' +
            '<span class="tui-ico-tree"></span>' +
            '{{stateLabel}}' +
          '</button>' +
          '<span class="tui-tree-text tui-js-tree-text">' +
            '<span class="tui-tree-ico tui-ico-folder"></span>' +
            '{{text}}' +
          '</span>' +
        '</div>' +
        '<ul class="tui-tree-subtree tui-js-tree-subtree">' +
          '{{children}}' +
        '</ul>',
      leafNode:
        '<div class="tui-tree-content-wrapper" style="padding-left: {{indent}}px">' +
          '<span class="tui-tree-text {{textClass}}">' +
            '<span class="tui-tree-ico tui-ico-file"></span>' +
            '{{text}}' +
          '</span>' +
        '</div>'
    }
  });

  // 트리 기능 활성화
  tree.enableFeature('Selectable')
      .enableFeature('Editable', {
        dataKey: 'text'
      })
      .enableFeature('Ajax', {
        command: {
          update: {
            url: '/admin/updateCategoryName',
            method: 'POST',
            contentType: 'application/json',
            params: function(treeData) {
              const nodeData = tree.getNodeData(treeData.nodeId);
              const categoryId = nodeData?.data?.categoryId;
              const newName = treeData?.data?.text;

              console.log("Sending update:", { categoryId, newName });

              return { categoryId, newName };
            }
          }
        },
        parseData: function(command, responseData) {
          if (command === 'update') {
            return responseData.success !== false;
          }
          return true;
        }
      });

  // 수정 전 사용자 확인
  tree.on('beforeEditNode', function(event) {
    return confirm('이 카테고리 이름을 수정하시겠습니까?');
  });
</script>

</body>
</html>