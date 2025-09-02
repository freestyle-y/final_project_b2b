<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <link rel="stylesheet" href="https://uicdn.toast.com/tui-tree/latest/tui-tree.css" />
  <link rel="stylesheet" href="https://uicdn.toast.com/tui.context-menu/latest/tui-context-menu.css"/>

</head>
<body>

<div id="tree" class="tui-tree-wrap"></div>

<script src="https://uicdn.toast.com/tui.context-menu/latest/tui-context-menu.js"></script>
<script src="https://uicdn.toast.com/tui-tree/latest/tui-tree.js"></script>

<script>
  // JSTL에서 넘어온 optionList를 트리 데이터로 변환
  const rawOptionTree = [
    <c:forEach var="entry" items="${groupedOptions}" varStatus="status1">
      {
        text: "${entry.key}", // optionName (예: "사이즈", "용량")
        data: { type: "optionGroup", optionGroupName: "${entry.key}" },
        children: [
          <c:forEach var="opt" items="${entry.value}" varStatus="status2">
            {
              text: "${opt.optionNameValue}", // 예: "300ml", "XL"
              data: { optionNo: ${opt.optionNo} }
            }<c:if test="${!status2.last}">,</c:if>
          </c:forEach>
        ]
      }<c:if test="${!status1.last}">,</c:if>
    </c:forEach>
  ];

  // Tree 생성
  const tree = new tui.Tree('#tree', {
    data: rawOptionTree,
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
            url: '/',
            method: 'POST',
            contentType: 'application/json',
            params: function(treeData) {
              const nodeData = tree.getNodeData(treeData.parentId);
              const newName = treeData?.data?.text || "";
                
              console.log("Sending update:", { newName, loginUser });
                
              return { newName, loginUser };
            }
          },
          update: {
            url: '/admin/updateOptionName',
            method: 'POST',
            contentType: 'application/json',
            params: function(treeData) {
              const nodeData = tree.getNodeData(treeData.nodeId);
              const type = nodeData?.data?.type;
              const optionNo = nodeData?.data?.optionNo;
              const newName = treeData?.data?.text || "";
              
              if (type === "optionGroup") {
                 const optionGroupName = nodeData?.data?.optionGroupName;
                 console.log("Updating option group:", { optionGroupName, newName, loginUser });
                 return { optionGroupName, newName, loginUser };
               } else {
                 const optionNo = nodeData?.data?.optionNo;
                 console.log("Updating option value:", { optionNo, newName, loginUser });
                 return { optionNo, newName, loginUser };
               }
            }
          },
          remove: {
            url: '/',
            method: 'POST',
            contentType: 'application/json',
            params: function(treeData) {
              const nodeData = tree.getNodeData(treeData.nodeId);
              const optionNo = nodeData?.data?.optionNo;

              console.log("Sending update:", { optionNo, loginUser });
              
              return { optionNo, loginUser };
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
</body>
</html>