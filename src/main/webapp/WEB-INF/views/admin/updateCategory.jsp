<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>카테고리 관리</title>
  <link rel="stylesheet" href="https://uicdn.toast.com/tui-tree/latest/tui-tree.css" />
  <link rel="stylesheet" href="https://uicdn.toast.com/tui.context-menu/latest/tui-context-menu.css"/>
  <%@ include file="/WEB-INF/common/head.jsp"%>
  <style>
  	.tui-tree-input{
  		width: 150px;
  		padding: 14px 0;
  		font-size:13px;
  	}
  </style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

	<!-- Page Title -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">카테고리 수정</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="/personal/mainPage">Home</a></li>
            <li class="current">Category</li>
          </ol>
        </nav>
      </div>
	</div><!-- End Page Title -->

<div id="tree" class="tui-tree-wrap"></div>

<script src="https://uicdn.toast.com/tui.context-menu/latest/tui-context-menu.js"></script>
<script src="https://uicdn.toast.com/tui-tree/latest/tui-tree.js"></script>

<script>
  // JSTL에서 넘어온 categoryList를 JS 배열로 변환
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

  // 카테고리 데이터를 트리 형식으로 변환
  function transformToTreeData(categoryList) {
    const map = {};
    const result = [];

    categoryList.forEach(cat => {
      const { categoryIdLv1, categoryNameLv1, categoryIdLv2, categoryNameLv2, categoryIdLv3, categoryNameLv3 } = cat;

      if (categoryIdLv1 && !map[categoryIdLv1]) {
        const node = { text: categoryNameLv1, data: { categoryId: categoryIdLv1 }, children: [] };
        map[categoryIdLv1] = node;
        result.push(node);
      }

      if (categoryIdLv2 && !map[categoryIdLv2]) {
        const midNode = { text: categoryNameLv2, data: { categoryId: categoryIdLv2 }, children: [] };
        map[categoryIdLv2] = midNode;
        if (map[categoryIdLv1]) map[categoryIdLv1].children.push(midNode);
      }

      if (categoryIdLv3 && !map[categoryIdLv3]) {
        const subNode = { text: categoryNameLv3, data: { categoryId: categoryIdLv3 } };
        map[categoryIdLv3] = subNode;
        if (map[categoryIdLv2]) map[categoryIdLv2].children.push(subNode);
      }
    });

    return result;
  }

  const treeData = transformToTreeData(rawCategoryList);

  //Create Tree component
  const tree = new tui.Tree('#tree', {
    data: treeData,
    nodeDefaultState: 'opened',
    template: {
      internalNode:
        '<div class="tui-tree-content-wrapper" style="padding-left: {{indent}}px">' +
          '<button type="button" class="tui-tree-toggle-btn tui-js-tree-toggle-btn">' +
            '<span class="tui-ico-tree"></span>{{stateLabel}}' +
          '</button>' +
          '<span class="tui-tree-text tui-js-tree-text">' +
            '<span class="tui-tree-ico tui-ico-folder"></span>{{text}}' +
          '</span>' +
        '</div>' +
        '<ul class="tui-tree-subtree tui-js-tree-subtree">{{children}}</ul>',
      leafNode:
        '<div class="tui-tree-content-wrapper" style="padding-left: {{indent}}px">' +
          '<span class="tui-tree-text {{textClass}}">' +
            '<span class="tui-tree-ico tui-ico-file"></span>{{text}}' +
          '</span>' +
        '</div>'
    }
  });

  //Bind custom event 
  tree.on('selectContextMenu', function(e) {
      const command = e.command;
      const nodeId = e.nodeId;

      switch(command) {
        case 'create':
          tree.createChildNode(nodeId);
          break;
        case 'update':
          tree.editNode(nodeId);
          break;
        case 'remove':
          if (confirm('카테고리를 삭제하시겠습니까?')) {
              tree.remove(nodeId);
          }
          break;
      }
  });

  tree.on('beforeCreateChildNode', function(event) {
      if (event.cause === 'blur') {
          tree.finishEditing();
          tree.remove(event.nodeId);
          return false;
      }
      return confirm('Are you sure you want to create?');
  });

  tree.on('beforeEditNode', function(event) {
      if (event.cause === 'blur') {
          tree.finishEditing();
          return false;
      }
      return confirm('Are you sure you want to edit?');
  });
  
  const loginUser = "${loginUserName}";
  
  //Add features
  tree.enableFeature('Selectable')
      .enableFeature('Editable', { dataKey: 'text' })
      .enableFeature('ContextMenu', {
        menuData: [
          { title: '생성', command: 'create' },
          { title: '수정', command: 'update' },
          { title: '삭제', command: 'remove' }
        ]
      })
      .enableFeature('Ajax', {
        command: {
          create: {
            url: '/admin/createCategory',
            method: 'POST',
            contentType: 'application/json',
            params: function(treeData) {
              const nodeData = tree.getNodeData(treeData.parentId);
              const parentId = nodeData?.data?.categoryId;
              const newName = treeData?.data?.text || "";
                
              console.log("Sending update:", { parentId, newName, loginUser });
                
              return { parentId, newName, loginUser };
            }
          },
          update: {
            url: '/admin/updateCategoryName',
            method: 'POST',
            contentType: 'application/json',
            params: function(treeData) {
              const nodeData = tree.getNodeData(treeData.nodeId);
              const categoryId = nodeData?.data?.categoryId;
              const newName = treeData?.data?.text || "";
              
              console.log("Sending update:", { categoryId, newName, loginUser });
              
              return { categoryId, newName, loginUser };
            }
          },
          remove: {
            url: '/admin/removeCategory',
            method: 'POST',
            contentType: 'application/json',
            params: function(treeData) {
              const nodeData = tree.getNodeData(treeData.nodeId);
              const categoryId = nodeData?.data?.categoryId;

              console.log("Sending update:", { categoryId, loginUser });
              
              return { categoryId, loginUser };
            }
          }
        },
        parseData: function(command, responseData, treeData) {
       	  if (command === 'create' && responseData.success) {
       	    setTimeout(() => {
       	      console.log("리로딩 실행됨");
       	      location.reload(); // 트리 리로드
       	    }, 10);
       	  }

       	  return responseData.success !== false;
       	}
      });
 
</script>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
