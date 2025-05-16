<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<style>
.metafield-button {
  margin: 5px;
  margin-bottom: 0;
  margin-right: 15px;
}
#metafielditem-detail .form-field-caption {
  width: 100px;
}
#metafielditem-detail .form-field-value {
  margin-left: 103px;
}
</style>

<% 
BLBO_MetaData bl = pageBase.getBL(BLBO_MetaData.class);
DOMetaFieldGroup metaFieldGroup = pageBase.isNewItem() ? bl.prepareNewMetaFieldGroup() : bl.loadMetaFieldGroup(pageBase.getId()); 
String title = pageBase.isNewItem() ? pageBase.getLang().Common.MetaFieldGroup.getText() : metaFieldGroup.MetaFieldGroupName.getString();
boolean canEdit = pageBase.getRights().SettingsCustomForms.getBoolean();
request.setAttribute("metafieldgroup", metaFieldGroup);
%>

<div class="tab-content">
  <v:widget caption="@Common.Profile">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="metafieldgroup.MetaFieldGroupCode" />
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="metafieldgroup.MetaFieldGroupName" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.SearchMatchType" clazz="form-field-optionset">
        <label class="checkbox-label">
          <% String chkFullMatch = LkSNSearchMatchType.FullMatch.equals(metaFieldGroup.SearchMatchType.getLkValue()) ? "checked" : ""; %>
          <input type="radio" name="metafieldgroup.SearchMatchType" value="<%=LkSNSearchMatchType.FullMatch.getCode()%>" <%=chkFullMatch%>/> 
          <v:itl key="@Lookup.SearchMatchType.FullMatch"/>
        </label>
        &nbsp;&nbsp;&nbsp;
        <span class="description">(<v:itl key="@Lookup.SearchMatchType.FullMatchHint"/>)</span><br/>
        
        <label class="checkbox-label">
          <% String chkStartsWith = LkSNSearchMatchType.StartsWith.equals(metaFieldGroup.SearchMatchType.getLkValue()) ? "checked" : ""; %>
          <input type="radio" name="metafieldgroup.SearchMatchType" value="<%=LkSNSearchMatchType.StartsWith.getCode()%>" <%=chkStartsWith%>/>
          <v:itl key="@Lookup.SearchMatchType.StartsWith"/>
        </label>
        &nbsp;&nbsp;&nbsp;
        <span class="description">(<v:itl key="@Lookup.SearchMatchType.StartsWithHint"/>)</span>
      </v:form-field>
    </v:widget-block>    
    <v:widget-block>
      <% JvDataSet dsMetaFields = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="@Common.FormFields">
        <v:multibox field="metafieldgroup.MetaFieldIDs" lookupDataSet="<%=dsMetaFields%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
</div>

<script>

</script>