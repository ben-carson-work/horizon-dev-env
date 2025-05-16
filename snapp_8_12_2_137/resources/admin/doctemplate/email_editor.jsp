<%@page import="com.vgs.web.tag.TagAttributeBuilder"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<script src="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.css"/>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/xml/xml.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/javascript/javascript.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/css/css.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/vbscript/vbscript.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/htmlmixed/htmlmixed.js"></script>
<script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>

<style><%@ include file="email_editor.css" %></style>
<script> //# sourceURL=email_editor.jsp
<%@ include file="email_editor.js" %>
</script>


<div class="email-editor">
  <div>
    <v:form-field caption="@DocTemplate.Email_From">
      <v:input-text field="AddressFrom"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.Email_To" hint="@DocTemplate.Email_To_Hint">
      <v:input-text field="AddressTo" placeholder="@Common.Default"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.Email_CC">
      <v:input-text field="AddressCC"/>
    </v:form-field>
    <v:form-field caption="@DocTemplate.Email_BCC">
      <v:input-text field="AddressBCC"/>
    </v:form-field>
  </div>
  
  <v:tab-group id="lang-tabs-container" name="lang">
    <v:tab-plus id="plus_tab">
      <% 
      for (String langISO : SnappUtils.getLangISOs()) { 
        String icon = SnappUtils.getFlagName(langISO); 
        if (icon != null) { 
          Locale locale = new Locale(langISO); 
          String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale()));
          String langDesc = langName + " | " + locale.getDisplayLanguage(locale);
          TagAttributeBuilder tags = TagAttributeBuilder.builder().put("data-langiso", langISO).put("data-iconname", icon).put("data-langname", langName);
          %><v:popup-item clazz="add-lang-popop-item" icon="<%=icon%>" caption="<%=langDesc%>" attributes="<%=tags%>"/><%
        }
      }
      %>
    </v:tab-plus>
  </v:tab-group>
  
  <div id="doctemplate-email-templates" class="hidden">
    <v:tab-item-embedded tab="TEMP" icon="TEMP"></v:tab-item-embedded>
    
    <div class="v-tabs-panel lang-tab-content hidden">
      <div class="subject-container">
        <input type="text" class="txt-subject" placeholder="<v:itl key="@DocTemplate.Email_Subject"/>"/>
        
        <v:button-group clazz="lang-buttons">
          <v:button clazz="btn-preview" caption="@DocTemplate.Preview" fa="eye"/>
          <v:button clazz="btn-editor-html" caption="@DocTemplate.HTMLEditor" fa="spell-check"/>   
          <v:button clazz="btn-plain-html" caption="@DocTemplate.PlainHTML" fa="code"/>    
        </v:button-group>
      </div>
      <div class="ckeditor-container"><textarea></textarea></div>
      <div class="codemirror-container"><textarea></textarea></div>
    </div>
    
    <span class="btn-close-tab"><i class="fa fa-times"></i></span>
  </div>
</div>
