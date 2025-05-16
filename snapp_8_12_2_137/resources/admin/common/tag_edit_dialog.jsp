<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String tagId = pageBase.getId();
String handlerId = pageBase.getNullParameter("HandlerId");
boolean listMode = pageBase.isParameter("ListMode", "true");

BLBO_Tag bl = pageBase.getBL(BLBO_Tag.class);
DOTag tag = pageBase.isNewItem() ? bl.prepareNewTag(LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"))) : bl.loadTag(pageBase.getId());
request.setAttribute("tag", tag);

LookupItem entityType = tag.EntityType.getLkValue();

String title =  entityType.getDescription(pageBase.getLang());
if (pageBase.isNewItem()) 
  title = pageBase.getLang().Common.New.getText() + ": " + title;

boolean enabled = entityType.getCode() > 1000;

%>


<v:dialog id="tag-edit-dialog" tabsView="true" title="<%=title%>" width="900" height="700" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="role-tab-profile" caption="@Common.Profile" default="true">
     <div class="tab-content">
        <v:widget caption="@Common.General" icon="profile.png">
          <v:widget-block>
            <v:form-field caption="@Common.Code"><v:input-text type="text" field="tag.TagCode" enabled="<%=enabled%>" /></v:form-field>
            <v:form-field caption="@Common.Name" mandatory="true"><v:input-text type="text" field="tag.TagName" /></v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
    
    <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
      <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
        <jsp:include page="../common/page_tab_historydetail.jsp"/>
      </v:tab-item-embedded>
    <% } %>
    
  </v:tab-group>  


<script>
var dlg = $("#tag-edit-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <% if (!pageBase.isNewItem() && !listMode) { %>
      <v:itl key="@Common.Delete" encode="JS"/>: doDeleteTag,
    <% } %>
    <v:itl key="@Common.Save" encode="JS"/>: doSaveTag,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSaveTag();
});

function doSaveTag() {
  var tagCode = $("#tag\\.TagCode").val();
  var tagName = $("#tag\\.TagName").val();
  var reqDO = {
    Command: "Save",
    Save: {
      Tag: {
        TagId: <%=pageBase.isNewItem() ? null : tag.TagId.getJsString()%>,
        EntityType: <%=tag.EntityType.getInt()%>,
        TagCode: tagCode,
        TagName: tagName
      }
    }
  };
  
  vgsService("Tag", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.Tag.getCode()%>, ansDO.Answer.Save.TagId);
  
    var handlerId = <%=JvString.jsString(handlerId)%>;
    <% if (pageBase.isNewItem()) { %>
      comboBtnCallback(handlerId, ansDO.Answer.Save.TagId, tagCode, tagName);
    <% } else if (!listMode) { %>
      asyncDialogEasy("common/tag_pickup_dialog", "EntityType=<%=tag.EntityType.getInt()%>&HandlerId=" + handlerId);
    <% } %>
    
    $("#tag-edit-dialog").dialog("close");
  });
}

function doDeleteTag() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "Delete",
      Delete: {
        TagIDs: <%=JvString.jsString(tagId)%>
      }
    };
    
    vgsService("Tag", reqDO, null, function() {
      triggerEntityChange(<%=LkSNEntityType.Tag.getCode()%>);
      $("#tag-edit-dialog").dialog("close");
    });
  });
}
</script>

</v:dialog>