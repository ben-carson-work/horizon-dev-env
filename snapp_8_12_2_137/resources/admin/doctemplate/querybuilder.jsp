<%@page import="com.vgs.snapp.dataobject.DOQueryBuilderCollection"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageQueryBuilder" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<%!
private String getFontAwesomeByDataType(LookupItem dataType) {
  if (dataType != null) {
    if (dataType.isLookup(LkSNQueryBuilderDataType.Text, LkSNQueryBuilderDataType.LookupDesc))
      return "font";
    else if (dataType.isLookup(LkSNQueryBuilderDataType.Money))
      return "dollar-sign";
    else if (dataType.isLookup(LkSNQueryBuilderDataType.UUID) || (dataType.getCode() >= 1000))
      return "code";
    else if (dataType.isLookup(LkSNQueryBuilderDataType.Date))
      return "calendar";
    else if (dataType.isLookup(LkSNQueryBuilderDataType.DateTime))
      return "calendar-exclamation";
    else if (dataType.isLookup(LkSNQueryBuilderDataType.Time))
      return "clock";
    else if (dataType.isLookup(LkSNQueryBuilderDataType.Integer, LkSNQueryBuilderDataType.Smallint, LkSNQueryBuilderDataType.Long))
      return "hashtag";
    else if (dataType.isLookup(LkSNQueryBuilderDataType.Bit))
      return "toggle-on";
  }
  return null;
} 
%>

<jsp:include page="querybuilder-css.jsp"/>
<jsp:include page="querybuilder-js.jsp"/>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Run" fa="bolt" onclick="execute('HTM', false)"/>
      
      <div class="btn-group">
        <v:button caption="@Common.Download" fa="download" style="float:right" dropdown="true"/>
        <v:popup-menu bootstrap="true">
          <v:popup-item caption="Microsoft Excel" href="javascript:execute('XLS', true)" />
          <v:popup-item caption="CSV" href="javascript:execute('CSV', true)" />
        </v:popup-menu>
      </div>
    </div>
  
    <v:last-error/>
    
    <div id="qb-tab-content" class="tab-content"> 
      <div id="datasource-container" class="vert-block noselect">
        <div id="collection-header">
          <input type="text" id="txt-collection-search" class="default-focus" placeholder="<v:itl key="@Common.Search"/>"/>
          <i id="btn-collection-explode-all" class="btn-collection fa fa-plus-square" title="<v:itl key="@Common.ExpandAll"/>"></i>
          <i id="btn-collection-collapse-all" class="btn-collection fa fa-minus-square" title="<v:itl key="@Common.CollapseAll"/>"></i>
        </div>
        <div id="collection-body">
        <% for (DOQueryBuilderCollection coll : BLBO_QueryBuilder.getCollections()) { %>
          <div class="property-box collapsed">
            <div class="property-box-header">
              <i class="explode-btn fa fa-plus"></i>
              <i class="collapse-btn fa fa-minus"></i>
              <span class="property-box-title"><%=coll.CollectionName.getHtmlString()%></span>
            </div>
            
            <div class="property-box-body">
            <% for (DOQueryBuilderCollection.DOQBField field : coll.FieldList) { %>
              <% String fa = getFontAwesomeByDataType(field.DataType.getLkValue()); %>
              <div class="collection-field" 
                  data-collectionname="<%=coll.CollectionName.getHtmlString()%>"
                  data-fieldtype="<%=field.FieldType.getInt()%>" 
                  data-fieldname="<%=field.FieldName.getHtmlString()%>" 
                  data-fieldalias="<%=field.FieldAlias.getHtmlString()%>" 
                  data-lookuptable="<%=field.LookupTable.getInt()%>" 
                  data-datatype="<%=field.DataType.getInt()%>">
                <% if (fa != null) { %><i class="collection-field-icon field-icon fa fa-<%=fa%>"></i><%}%>
                <span class="collection-field-alias"><%=field.FieldAlias.getHtmlString()%><span>
              </div>
            <% } %>
            </div>
          </div>
        <% } %>
        </div>
      </div>
      
      <div class="vert-block vert-split"></div>
      
      <div id="select-container" class="vert-block">
        <div id="select-box" class="property-box">
          <div class="property-box-header">
            <span class="property-box-title"><v:itl key="@DocTemplate.QB_SelectTitle"/></span>
          </div>
          <div class="property-box-body"></div>
        </div>
      </div>
       
      <div class="vert-block vert-split"></div>
      
      <form id="docproc-form" action="<v:config key="site_url"/>/docproc" method="post" target="result-container" class="hidden">
        <input type="hidden" name="ForceDownload" value="false"/>
        <input type="hidden" name="OutputFormat" value="HTM"/>
        <input type="hidden" name="QueryBuilder" value=""/>
      </form>
      <iframe id="result-container" name="result-container" class="vert-block"></iframe>
  </v:tab-item-embedded>
</v:tab-group>

<%-- 
<div id="column-block-template" class="hidden">
  <v:widget-block clazz="column-block collapsed">
    <div class="move-handle"><i class="fa fa-bars"></i></div>
    <div class="btn-remove"></div>
    <div class="field-name"></div>
    <div class="column-detail">
      <div class="filter-block">
        <table style="width:100%">
          <tr>
            <td width="25%">
              <select class="filter-oper form-control">
                <% for (LookupItem item : LkSN.QueryBuilderFilterOperator.getItems()) { %>
                  <option value="<%=item.getCode()%>"><%=((LkSNQueryBuilderFilterOperator.QBOperatorItem)item).getHtml()%></option>
                <% } %>
              </select>
            </td>
            <td>&nbsp;</td>
            <td width="75%">
              <input type="text" class="filter-value filter-value-from form-control"/>
              <input type="text" class="filter-value filter-value-to form-control"/>
            </td>
          </tr>
        </table>
      </div>
      <v:lk-combobox lookup="<%=LkSN.AggregateType%>" clazz="aggregate-type"/>
      <v:db-checkbox field="cb-subtotal" value="" caption="@Common.SubTotal"/>
      <v:db-checkbox field="cb-filteronly" value="" caption="Filter only"/>
    </div>
  </v:widget-block>
</div>  
--%>

<div id="qb-templates" class="hidden">

  <div class="column-item">
    <div class="column-header noselect">
      <i class="column-filter-icon field-icon fa fa-filter"></i>
      <span class="column-alias"></span>
      <i class="column-remove-icon field-icon fa fa-trash"></i>
      <i class="column-move-icon field-icon fa fa-bars"></i>
    </div>
    <div class="column-detail">
      ciaone
    </div>
  </div>
  
</div>


<jsp:include page="/resources/common/footer.jsp"/>
