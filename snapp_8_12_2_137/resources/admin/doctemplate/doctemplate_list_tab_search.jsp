<%@page import="java.util.*"%>
<%@page import="java.util.stream.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplateList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
BLBO_DocTemplate.DocTemplateInfo info = (BLBO_DocTemplate.DocTemplateInfo)request.getAttribute("DocTemplateInfo");
FtCRUD rightCRUD = pageBase.getBLDef().getOverallRightCRUD(info.docTemplateType); 
DODocTemplateCreateInfo createInfoDO = pageBase.getBL(BLBO_DocTemplate.class).getCreateInfo(info);
boolean reportExec = pageBase.isParameter("reportexec", "true");

int[] editorTypes = new int[0];
for (LookupItem[] editorCodes : info.docEditorTypes.values())
  editorTypes = JvArray.add(editorTypes, LookupManager.getIntArray(editorCodes));
editorTypes = JvArray.distinct(editorTypes);

%>

<v:tab-toolbar>
  <v:button id="search-btn" caption="@Common.Search" fa="search" onclick="search()"/>
  <% if (!reportExec) { %>
    <% boolean canCreate = rightCRUD.canCreate(); %>
    <% boolean canDelete = rightCRUD.canDelete(); %>
    
    <span class="divider"></span>
    
    <v:button-group>
      <% if (createInfoDO.ItemList.isEmpty()) { %>
        <v:button caption="@Common.New" fa="plus" enabled="false" bindGrid="doctemplate-grid" bindGridEmpty="true"/>
      <% } else if (createInfoDO.ItemList.getSize() == 1) {%>
        <v:button caption="@Common.New" fa="plus" href="<%=createInfoDO.ItemList.findFirst().CreateURL.getString()%>"/>
      <% } else { %>
        <div class="btn-group">
          <v:button id="new-btn" caption="@Common.New" fa="plus" dropdown="true" bindGrid="doctemplate-grid" bindGridEmpty="true"/>
          <v:popup-menu bootstrap="true">
            <% for (DODocTemplateCreateInfo.DODocTemplateCreateItem item : createInfoDO.ItemList) { %>
              <v:popup-item caption="<%=item.Description.getString()%>" href="<%=item.CreateURL.getString()%>"/>
            <% } %>
          </v:popup-menu>
        </div>
      <% } %>
    
      <v:button id="del-btn" caption="@Common.Delete" fa="trash" bindGrid="doctemplate-grid" enabled="<%=canDelete%>" onclick="doDelete()"/>
    </v:button-group>

    <span class="divider"></span>
    <v:button caption="@Common.Import" fa="sign-in" bindGrid="doctemplate-grid" bindGridEmpty="true" enabled="<%=canCreate%>" onclick="_showImportDialog()"/>
  <% } %>

  <v:pagebox gridId="doctemplate-grid"/>
</v:tab-toolbar>

<% boolean showCats = info.docTemplateType.isLookup(LkSNDocTemplateType.StatReport); %>

<v:tab-content>
  <v:profile-recap>
    
    <v:widget caption="@Common.Search">
      <v:widget-block>
        <input type="text" id="FullText" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>"/>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Common.Type" include="<%=info.docTemplateType.isLookup(LkSNDocTemplateType.Media, LkSNDocTemplateType.StatReport)%>">
      <v:widget-block>
      <% for (LookupItem item : info.docEditorTypes.get(info.docTemplateType)) { %>
        <div><v:db-checkbox field="DocEditorType" value="<%=item.getCode()%>" caption="<%=item.getDescription()%>"/></div>
      <% } %>
      </v:widget-block>
    </v:widget>
    
    <% 
    List<LookupItem> docTemplateTypeList = Arrays.asList(info.docTemplateType.getSlaveTemplateTypes());
    docTemplateTypeList.sort(Comparator.comparing(it -> it.getDescription()));
    %>
    <v:widget caption="@Common.Type" include="<%=(docTemplateTypeList.size() > 1)%>">
      <v:widget-block>
      <% for (LookupItem type : docTemplateTypeList) { %>
        <% if (pageBase.getBL(BLBO_DocTemplate.class).getOverallRightCRUD(type).canRead()) { %>
          <div><v:db-checkbox field="DocTemplateType" value="<%=type.getCode()%>" caption="<%=type.getDescription()%>"/></div>
        <% } %>
      <% } %>
      </v:widget-block>
    </v:widget>
    
    <% String hrefCatEdit = reportExec ? null : pageBase.getCategoryEditLink(LkSNEntityType.DocTemplate); %>
    <v:widget caption="@Category.Categories" editHRef="<%=hrefCatEdit%>" include="<%=info.docTemplateType.isLookup(LkSNDocTemplateType.StatReport)%>">
      <v:widget-block>
        <snp:category-tree-widget entityType="<%=LkSNEntityType.DocTemplate%>"/>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>

  <v:profile-main>
    <% String params = "DocTemplateType=" + pageBase.getEmptyParameter("DocTemplateType") + "&ReportExec=" + reportExec; %>
    <v:async-grid id="doctemplate-grid" jsp="doctemplate/doctemplate_grid.jsp" params="<%=params%>"/>
  </v:profile-main>
</v:tab-content>



<script>

$("#FullText").keypress(function(e) {
  if (e.keyCode == KEY_ENTER) {
    search();
    return false;
  }
});


function showInsuffRightError() {
  showMessage(itl("@Common.PermissionDenied"));
}

function search() {
  var types = $("[name='DocTemplateType']").getCheckedValues();
  var editorTypes = $("[name='DocEditorType']").getCheckedValues();
  setGridUrlParam("#doctemplate-grid", "DocTemplateType", (types != "") ? types : <%=info.docTemplateType.getCode()%>);
  setGridUrlParam("#doctemplate-grid", "DocEditorType", (editorTypes != "") ? editorTypes : "");
  setGridUrlParam("#doctemplate-grid", "FullText", $("#FullText").val(), true);
}

function categorySelected(categoryId) {
  setGridUrlParam("#doctemplate-grid", "CategoryId", categoryId, false);
  search();
}

function _showImportDialog() {
  vgsImportDialog("<v:config key="site_url"/>/admin?page=doctemplate&action=import");
}

function doDelete() {
  var ids = $("[name='DocTemplateId']").getCheckedValues();
  if (ids == "")
    showMessage(it("@Common.NoElementWasSelected"));
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "Delete",
        Delete: {
          DocTemplateIDs: ids
        }
      };
      
      vgsService("DocTemplate", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.DocTemplate.getCode()%>);
      });
    });
  }
}

</script>
