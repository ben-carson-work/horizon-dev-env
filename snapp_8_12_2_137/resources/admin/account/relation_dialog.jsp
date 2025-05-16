<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_Account bl = pageBase.getBL(BLBO_Account.class);
DORelation rel = pageBase.isNewItem() ? bl.prepareNewRelation() : bl.loadRelation(pageBase.getId());
request.setAttribute("rel", rel);
%>

<v:dialog id="relation_dialog" title="<%=rel.RelationName.isNull(pageBase.getLang().Common.New.getText())%>" icon="chain.png" width="500">

<v:widget caption="@Common.Profile" icon="profile.png">
  <v:widget-block>
    <v:form-field caption="@Common.Name" mandatory="true"><v:input-text type="text" field="rel.RelationName"/></v:form-field>
    <v:form-field caption="@Account.RelationReverse" mandatory="true"><v:input-text type="text" field="rel.ReverseRelationName"/></v:form-field>
  </v:widget-block>
</v:widget>

<script>

var dlg = $("#relation_dialog");

dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSaveRelation,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSaveRelation();
});

function doSaveRelation() {
  var reqDO = {
    Command: "SaveRelation",
    SaveRelation: {
      Relation: {
        RelationId: <%=pageBase.isNewItem() ? null : "\"" + rel.RelationId.getHtmlString() + "\""%>,
        RelationName: $("#rel\\.RelationName").val(),
        ReverseRelationName: $("#rel\\.ReverseRelationName").val()
      }
    }
  };
  
  vgsService("Account", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.Relation.getCode()%>, ansDO.Answer.SaveRelation.RelationId);
    $("#relation_dialog").dialog("close");
  });
}

</script>

</v:dialog>


