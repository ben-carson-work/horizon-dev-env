<%@page import="com.vgs.web.library.BLBO_Category"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
JvDataSet dsCategoryTree = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(entityType);
String parentCategoryId = pageBase.getNullParameter("ParentCategoryId");
String[] categoryIDs = pageBase.getParameters("CategoryIDs");
boolean add = JvString.isSameString(pageBase.getNullParameter("Operation"), "add"); 
boolean move = JvString.isSameString(pageBase.getNullParameter("Operation"), "move"); 

request.setAttribute("dsCategoryTree", dsCategoryTree);
request.setAttribute("addParentCategoryId", parentCategoryId);
%>

<v:dialog id="category-dialog" width="600" height="300" title="@Category.Categories">
  <div class="tab-content">
    <v:widget caption="@Common.General">
      <v:widget-block>
        <% if (add) { %>
          <% boolean enabled = true;
             if (parentCategoryId != null)
               enabled = false;
          %>
          <v:form-field caption="@Category.ParentCategory">
            <v:combobox field="addParentCategoryId" lookupDataSetName="dsCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName" enabled="<%=enabled%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Name">
            <v:input-text field="categoryName"/>
          </v:form-field>
        <% } %>
        <% if (move) { %>
          <v:form-field caption="@Category.ParentCategory">
            <v:combobox field="moveParentCategoryId" lookupDataSetName="dsCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName"/>
          </v:form-field>
        <% } %>
      </v:widget-block>
    </v:widget>
</div>

<script>
var dlg = $("#category-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSaveCategory,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

function doSaveCategory() {
  if (<%=add%>)
    doAddCategory();
  else 
    if (<%=move%>)
      doMoveCategory();
}

function doAddCategory() {
   var parentCategoryId = $("#addParentCategoryId").val();
   var categoryName = $("#categoryName").val();
   var reqDO = {
       Command: "AddCategory",
       AddCategory: {
         EntityType: <%=pageBase.getParameter("EntityType")%>, 
         ParentCategoryId: (parentCategoryId == "") ? null : parentCategoryId,
         CategoryName: (categoryName == "") ? null : categoryName
       }
   }
  
   vgsService("Category", reqDO, false, function(ansDO) {
     $("#category-dialog").dialog("close");
     window.location = "<%=pageBase.getContextURL()%>?page=category_list&EntityType=<%=pageBase.getParameter("EntityType")%>";  
   });
}

function doMoveCategory() {
  var ids = <%=JvString.jsString(JvArray.arrayToString(pageBase.getParameters("CategoryIDs"), ","))%>;
  var parentCategoryId = $("#moveParentCategoryId").val();
  var reqDO = {
    Command: "MoveCategory",
    MoveCategory: {
      EntityType: <%=pageBase.getParameter("EntityType")%>,
      ParentCategoryId: (parentCategoryId == "") ? null : parentCategoryId,
      CategoryIDs: ids
    }
  };
  
   vgsService("Category", reqDO, false, function(ansDO) {
     $("#category-dialog").dialog("close");
     window.location = "<%=pageBase.getContextURL()%>?page=category_list&EntityType=<%=pageBase.getParameter("EntityType")%>";  
   });
}

</script>  

</v:dialog>