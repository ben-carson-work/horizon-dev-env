<%@page import="com.vgs.snapp.web.search.BLBO_QueryRef_Repository"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.security.interfaces.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
DORepositoryRef repository = pageBase.getBL(BLBO_Repository.class).loadRepositoryRef(pageBase.getId());
request.setAttribute("repository", repository);
boolean canEdit = pageBase.isParameter("canEdit", "true") && repository.ArchivedOnDateTime.isNull();
%> 

<v:dialog id="repository_dialog" title="@Common.Document" width="1024">
  <v:profile-recap style="text-align:center">
    <div class="profile-pic-container" style="margin-bottom:10px">
      <div class="profile-pic-inner">
        <div class="choose-pic"><v:itl key="@Common.Download"/></div>
      </div>
    </div>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget>
      <v:widget-block>
        <v:form-field caption="@Common.FileName">
          <v:input-text field="repository.FileName" enabled="false"/>
        </v:form-field>
        <v:form-field caption="@Common.Size">
          <v:input-text field="repository.SmoothSize" enabled="false"/>
        </v:form-field>
        <v:form-field caption="@Common.Code" mandatory="true">
          <v:input-text field="repository.RepositoryCode" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Description">
          <v:input-text field="repository.Description" enabled="<%=canEdit%>"/>
        </v:form-field>
        <% String hrefTag = !canEdit ? null : "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.Repository.getCode() + ",'repository.TagIDs')"; %>
        <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
          <% JvDataSet dsDocTags = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Repository); %>
          <v:multibox field="repository.TagIDs" lookupDataSet="<%=dsDocTags%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.DocTemplate"> 
          <snp:dyncombo field="repository.DocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":32}}" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.ValidFrom">
           <v:input-text type="datepicker" field="repository.ValidDateFrom" placeholder="@Common.Unlimited" />
           <v:itl key="@Common.To" transform="lowercase"/>
           <v:input-text type="datepicker" field="repository.ValidDateTo" placeholder="@Common.Unlimited" />
        </v:form-field>
        <v:form-field caption="@Common.Options" clazz="form-field-optionset">
          <div><v:db-checkbox field="repository.Shared" caption="@Common.Shared" value="true" checked="<%=repository.Shared.getBoolean()%>" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="repository.RequireParsing" caption="@Repository.RequireParsing" hint="@Repository.RequireParsingHint" value="true" checked="<%=repository.RequireParsing.getBoolean()%>" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="repository.DistinctAttachment" caption="@Repository.DistinctAttachment" hint="@Repository.DistinctAttachmentHint" value="true" checked="<%=repository.DistinctAttachment.getBoolean()%>" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="repository.ConvertToPDF" caption="@Repository.ConvertToPDF" hint="@Repository.ConvertToPDFHint" value="true" checked="<%=repository.ConvertToPDF.getBoolean()%>" enabled="<%=canEdit%>"/></div>
        </v:form-field>                
      </v:widget-block>
    </v:widget>
  </v:profile-main>
  
<script>
var $dlg = $("#repository_dialog");

function doSave() {
  checkRequired("#repository_dialog", function() {
    _doSaveRepository();
  });
}

<%if (canEdit) { %>
  function _doSaveRepository() {
    var reqDO = {
      Command: "Save",
      Save: {
        RepositoryId: "<%=pageBase.getId()%>",
        Description: $dlg.find("#repository\\.Description").val(),
        RepositoryCode: $dlg.find("#repository\\.RepositoryCode").val(),
        TagIDs: $dlg.find("[name='repository\\.TagIDs']").val(),
        Shared: $dlg.find("[name='repository\\.Shared']").isChecked(),
        RequireParsing: $dlg.find("[name='repository\\.RequireParsing']").isChecked(),
        DistinctAttachment: $dlg.find("[name='repository\\.DistinctAttachment']").isChecked(),
        ConvertToPDF: $dlg.find("[name='repository\\.ConvertToPDF']").isChecked(),
        DocTemplate: {DocTemplateId: $dlg.find("[name='repository\\.DocTemplateId']").val()},
        ValidDateFrom: $("#repository\\.ValidDateFrom-picker").getXMLDate(),
        ValidDateTo: $("#repository\\.ValidDateTo-picker").getXMLDate()
      }
    };
    
    vgsService("Repository", reqDO, false, function(ansDO) {
      changeGridPage("#repository-grid", "first");
      $dlg.dialog("close");
    });
  }
<% } %>

$dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSave();
});

$(document).ready(function() {
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <%if (canEdit) { %>
        {
          id: 'btn-save',
          text: itl("@Common.Save"),
          click: doSave,
          disabled: <%=!canEdit%>
        },
        <% } %>
      {
        id: 'btn-close',
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ];
  });
  
  <% if (repository.HasThumbnail.getBoolean()) { %>
    $dlg.find(".profile-pic-inner").css("background-image", "url('<%=RepositoryDownloadServlet.getUrl(pageBase.getId(), "small")%>')");
  <% } else { %>
    $dlg.find(".profile-pic-inner")
      .css("background-image", "url('<v:image-link name="<%=repository.IconName.getEmptyString()%>" size="64"/>')")
      .css("background-size", "auto")
      .css("background-position", "center center");
  <% } %>
  
  $dlg.find(".profile-pic-inner").click(function() {
    window.location = "<%=RepositoryDownloadServlet.getUrl(pageBase.getId(), "download")%>";
  });
  
  $dlg.find("[name='Description']").focus();
});

</script>

</v:dialog>
