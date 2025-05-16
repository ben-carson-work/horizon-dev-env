<%@page import="com.vgs.snapp.dataobject.multiedit.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType")); 
DOMultiEdit multiEdit = BLBO_MultiEdit.getStructure(request, entityType);
%>

<v:dialog id="multiedit_dialog" tabsView="true" title="@Common.MultiEdit" width="950" height="700">

  <jsp:include page="multiedit_dialog_js.jsp"></jsp:include>
  
  <v:tab-group name="multiedit" sideNav="true">
    <% for (DOMultiEditTopic topic : multiEdit.TopicList) { %>
      <v:tab-item-embedded 
          tab="<%=\"multiedit-\"+topic.TopicCode.getString()%>" 
          caption="<%=topic.Title.getString()%>" 
          fa="<%=topic.IconAlias.getString()%>" 
          iconBGColor="<%=\"var(--base-\"+topic.IconColor.getString()+\"-color)\"%>"
          default="<%=topic==multiEdit.TopicList.getItem(0)%>">
          
        <v:tab-content>
        <% for (DOMultiEditSection section : topic.SectionList) { %>
          <v:section caption="<%=section.Title.getString()%>">
            <% for (DOMultiEditField field : section.FieldList) { %>
              <div class="v-cfgform-field" data-field="<%=field.Field.getHtmlString()%>">
                <v:db-checkbox clazz="v-cfgform-field-select" field="" value="true" caption="<%=field.Caption.getString()%>"/>
                <div class="v-cfgform-field-value">
                <% NConfigFormFieldType fieldType = NConfigFormFieldType.valueOf(field.Type.getString()); %>
                <% if (fieldType.equals(NConfigFormFieldType.DYNCOMBO)) { %>
                  <snp:dyncombo clazz="value-control" entityType="<%=field.DynCombo.EntityType.getLkValue()%>" allowNull="true" filters="<%=field.DynCombo.Filters%>"/>
                <% } else if (fieldType.equals(NConfigFormFieldType.DYNMULTI)) { %>
                  <v:multibox clazz="value-control" linkEntityType="<%=field.DynMulti.EntityType.getLkValue()%>"/>
                <% } else if (fieldType.equals(NConfigFormFieldType.BOOLEAN)) { %>
                  <div class="v-switch value-control"><div class="v-switch-button"></div></div>
                <% } else if (fieldType.equals(NConfigFormFieldType.TEXT)) { %>
                  <v:input-text clazz="value-control"/>
                <% } else if (fieldType.equals(NConfigFormFieldType.LKCOMBO)) { %>
                  <v:lk-combobox clazz="value-control" lookup="<%=LkSN.getTableByName(field.LkCombo.LookupTableName.getString())%>"/>
                <% } else if (fieldType.equals(NConfigFormFieldType.DATEPICKER)) { %>
                  <v:input-text clazz="v-date value-control" type="datepicker" field="<%=field.Field.getString()%>" placeholder="@Common.Unlimited"/>
                <% } else { %>
                  FIELD TYPE NOT HANDLED: <b><%=field.Type.getHtmlString()%></b>
                <% } %>
                </div>
              </div>
            <% } %>
          </v:section>
        <% } %>
        </v:tab-content>
      </v:tab-item-embedded>
    <% } %>
  </v:tab-group>

</v:dialog>