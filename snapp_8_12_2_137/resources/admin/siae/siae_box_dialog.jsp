<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
DOSiaeBox siaeBox = pageBase.getId() == null ? bl.prepareNewSiaeBox() : bl.loadSiaeBox(pageBase.getId());
request.setAttribute("siaeBox", siaeBox);
%>

<v:dialog id="siae_box_dialog" icon="siae.png" title="SIAE box" width="600" height="320" autofocus="false">
<v:widget caption="@Common.General" icon="profile.png">
  <v:widget-block>
    <v:form-field caption="ID">
      <v:input-text field="siaeBox.SiaeBoxId" enabled="<%=pageBase.getId() == null %>" />
    </v:form-field>
    <v:form-field caption="@Common.Name" mandatory="true">
      <v:input-text field="siaeBox.SiaeBoxName" />
    </v:form-field>
    <v:form-field caption="URL" mandatory="true">
      <v:input-text field="siaeBox.SiaeBoxUrl" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>

$(document).ready(function() {
  var dlg = $("#siae_box_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSave,
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }
    ];
    setTimeout(function() {
      $(".default-focus").focus();
    }, 1);
  });

});

function doSave() {
  var name = $('#siaeBox\\.SiaeBoxName').val();
  var url = new URL($('#siaeBox\\.SiaeBoxUrl').val());
  if (name === '' || url === '') {
    showMessage('Tutti campi sono obbligatori');
    return;
  }
  
  var regex = /(http|https):\/\/(\w+:{0,1}\w*)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%!\-\/]))?/;
  if(!regex .test(url)) {
    showMessage('Formato URL non valido');
    return;
  }
  
  var reqDO = {
      Command: "SaveSiaeBox",
      SaveSiaeBox: {
        SiaeBox: {
          SiaeBoxId: <%=JvString.jsString(pageBase.getId()) %>,
          NewSiaeBoxId: $('#siaeBox\\.SiaeBoxId').val(),
          SiaeBoxName: name,
          SiaeBoxUrl: url.href,
        }
      }
    };
  vgsService("siae", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.SiaeBox.getCode()%>);
    $("#siae_box_dialog").dialog("close");
  });
};
</script>

</v:dialog>