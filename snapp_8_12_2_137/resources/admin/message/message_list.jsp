<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMessageList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>
<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

<script>
  function search() {
    setGridUrlParam("#message-grid", "FullText", $("#search-text").val(), true);
  }

  function searchKeyPress() {
    if (event.keyCode == KEY_ENTER) {
      search();
      event.preventDefault();
    }
  }

  function doDeleteMessages() {
    var ids = $("[name='MessageId']").getCheckedValues();
    if (ids == "")
      showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
    else {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "DeleteMessage",
          DeleteMessage: {
            MessageIDs: ids
          }
        };
        
        vgsService("Message", reqDO, false, function(ansDO) {
          triggerEntityChange(<%=LkSNEntityType.Message.getCode()%>);
        });
      });
    } 
  }

  function categorySelected(categoryId) {
    setGridUrlParam("#message-grid", "CategoryId", categoryId, true);
  }
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button id="search-btn" caption="@Common.Search" fa="search" href="javascript:search()"/>   
      <span class="divider"></span>
      <% String hrefNew = "javascript:asyncDialogEasy('message/message_dialog', 'id=new')"; %>
      <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
      <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:doDeleteMessages()"/>
      <v:pagebox gridId="message-grid"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="form-toolbar">
          <input type="text" id="search-text" class="form-control default-focus" style="width:97%" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
        </div>
        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.Message)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.Message%>"/>
          </v:widget-block>
        </v:widget>
      </div>

      <div class="profile-cont-div">
        <v:async-grid id="message-grid" jsp="message/message_grid.jsp" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


 
<jsp:include page="/resources/common/footer.jsp"/>