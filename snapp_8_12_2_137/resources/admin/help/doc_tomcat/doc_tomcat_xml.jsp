<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.annotation.*"%>
<%@page import="java.lang.annotation.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTomcat" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<style>
  .tab-doc-tomcat-xml .alert-content {line-height:initial}
  .doc-xml-tag {color:#3f7f7f}
  .doc-xml-symbol {color:gray}
  .doc-xml-attrname {color:#7f007f}
  .doc-xml-attrvalue {color:#2a00ff}
</style>

<script>
$(document).ready(function() {
  const docTomcatXML = {
    SectionList: [
      <%@ include file="doc_tomcat_xml_section_mandatory.json" %>,
      <%@ include file="doc_tomcat_xml_section_servercode.json" %>,
      <%@ include file="doc_tomcat_xml_section_testmode.json" %>,
      <%@ include file="doc_tomcat_xml_section_dbpool.json" %>,
      <%@ include file="doc_tomcat_xml_section_procqueue.json" %>,
      <%@ include file="doc_tomcat_xml_section_other.json" %>,
      <%@ include file="doc_tomcat_xml_section_siae.json" %>,
      <%@ include file="doc_tomcat_xml_section_siaebox.json" %>
    ]
  };
  const vgsSupport = <%=rights.VGSSupport.getBoolean()%>;
  
  sections = docTomcatXML.SectionList || [];
  for (var i=0; i<sections.length; i++) 
    _renderSection(sections[i]);

  function _renderAlertBox($container, alertBox) {
    $container.find(".alert").not(".alert-" + alertBox.Type).remove();
    $container.find(".alert-content").commonMark(alertBox.Text.join("\n"));
  }

  function _renderSection(section) {
    var $section = $("#doc-tomcat-xml-templates .doc-tomcat-xml-section").clone().appendTo(".tab-doc-tomcat-xml .profile-cont-div");
    var id = "doc-tomcat-xml-" + section.SectionCode;
    $section.attr("id", id);
    $section.find(".widget-title-caption").text(section.SectionName);

    var $index = $("#doc-tomcat-xml-templates .doc-tomcat-xml-index-item").clone().appendTo("#doc-tomcat-xml-index");
    $index.find("a").attr("href", "#"+id).text(section.SectionName);
    
    var $widgetContent = $section.find(".widget-content");
    if (section.AlertBox) {
      var $block = $("#doc-tomcat-xml-templates .doc-tomcat-xml-alertbox-widgetblock").clone().appendTo($widgetContent);
      _renderAlertBox($block, section.AlertBox);
    }
    
    var paramGroups = section.ParamGroupList || [];
    for (var i=0; i<paramGroups.length; i++) {
      var paramGroup = paramGroups[i];
      if (!paramGroup.InternalUse || vgsSupport)
        _renderParamGroup($widgetContent, paramGroup);
    }
  }
  
  function _renderParamGroup($container, paramGroup) {
    var $group = $("#doc-tomcat-xml-templates .doc-tomcat-xml-paramgroup-widgetblock").clone().appendTo($container);
    $group.find(".form-field-caption").text(paramGroup.Caption);
    _renderAlertBox($group, paramGroup.AlertBox);
    
    var params = paramGroup.ParamList || [];
    for (var i=0; i<paramGroup.ParamList.length; i++) {
      var $param = $("#doc-tomcat-xml-templates .doc-xml-tagcontainer").clone().appendTo($group.find("pre"));
      $param.find(".doc-xml-attrvalue-name").text("\"" + params[i].ParamName + "\"");
      $param.find(".doc-xml-attrvalue-value").text("\"" + params[i].ParamValue + "\"");
    }
  }
});
</script>

<div class="tab-content tab-doc-tomcat-xml">

  <div class="profile-pic-div">
    <v:widget caption="Index">
      <v:widget-block>
        <ul id="doc-tomcat-xml-index" class="nav nav-pills nav-stacked"></ul>
      </v:widget-block>
    </v:widget>
  </div>

  <div class="profile-cont-div">
  </div>
  
  <div id="doc-tomcat-xml-templates" class="hidden">
    <ul>
      <li class="doc-tomcat-xml-index-item"><a></a></li>
    </ul>
    
    <v:widget clazz="doc-tomcat-xml-section" caption="***">
    </v:widget>
    
    <v:widget>
      <v:widget-block clazz="doc-tomcat-xml-alertbox-widgetblock">
        <v:alert-box type="success"></v:alert-box>
        <v:alert-box type="danger"></v:alert-box>
        <v:alert-box type="warning"></v:alert-box>
        <v:alert-box type="info"></v:alert-box>
      </v:widget-block>
    </v:widget>
    
    <v:widget>
      <v:widget-block clazz="doc-tomcat-xml-paramgroup-widgetblock">
        <v:form-field caption="***">
          <pre></pre>
          <v:alert-box type="success"></v:alert-box>
          <v:alert-box type="danger"></v:alert-box>
          <v:alert-box type="warning"></v:alert-box>
          <v:alert-box type="info"></v:alert-box>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <div class="doc-xml-tagcontainer"><span class="doc-xml-symbol">&lt;</span><span class="doc-xml-tag">Parameter</span> <span class="doc-xml-attrname">name</span><span class="doc-xml-symbol">=</span><span class="doc-xml-attrvalue doc-xml-attrvalue-name"></span> <span class="doc-xml-attrname">value</span><span class="doc-xml-symbol">=</span><span class="doc-xml-attrvalue doc-xml-attrvalue-value"></span><span class="doc-xml-symbol">/&gt;</span></div>
    
  </div>

</div>

