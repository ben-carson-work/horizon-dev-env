<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
pageBase.setDefaultParameter("ValidityDate", JvDateTime.date().getXMLDate());
pageBase.setDefaultParameter("ValidityDays", "1");
%>


<v:dialog id="pkgwiz_dialog" title="Create Package" width="800" autofocus="false">

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="Package name">
        <v:input-text field="PackageName" clazz="pkgwiz-field" placeholder="PkgMyPackage"/>
      </v:form-field>
      <v:form-field caption="Package code">
        <v:input-text field="PackageCode" clazz="pkgwiz-field" placeholder="mypackage"/>
      </v:form-field>
      <v:form-field caption="Description">
        <v:input-text field="PackageDesc" clazz="pkgwiz-field" placeholder="Horizon extension package for..."/>
      </v:form-field>
      <v:form-field caption="Branches">
        <v:multibox field="Branches" clazz="pkgwiz-field"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>


<script>

$(document).ready(function() {

  var $dlg = $("#pkgwiz_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Run", _execute),
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
  
  _refreshBranchList();
  
  function _execute() {
    var reqDO = {
      Params: $dlg.find(".pkgwiz-field").viewToDoc()
    };
    
    snpAPI.cmd("PackageWizard", "CreatePackage", reqDO).then(ansDO => {
      confirmDialog("Package successfully created", function() {
        $dlg.dialog("close");
      });
    });
  }

  function _refreshBranchList() {
    snpAPI.cmd("PackageWizard", "GetBranches").then(ansDO => {
      var control = $("#Branches")[0].selectize;
      for (const branch of (ansDO.BranchList || [])) {
        control.addOption({
          value: branch.BranchPath,
          text: branch.BranchDesc
        });
      }
      control.refreshOptions(false);
    });
  }
});

</script>

</v:dialog>
 