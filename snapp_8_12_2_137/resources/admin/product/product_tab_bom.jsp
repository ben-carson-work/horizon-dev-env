<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>

<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate();
%>

<jsp:include page="product_tab_bom_css.jsp" />
<jsp:include page="product_tab_bom_js.jsp" />

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSaveBOM()" enabled="<%=canEdit%>"/>

  <span class="divider"></span>

  <div class="btn-group">
    <v:button id="btn-add" caption="@Common.Add" fa="plus" dropdown="true" enabled="<%=canEdit%>"/>
    <v:popup-menu bootstrap="true">
      <v:popup-item caption="@Product.BOM_Item" onclick="addBomRow(null, 'smart')"/>
      <v:popup-item caption="@Product.BOM_Group" onclick="addBomRow({GroupItem:true})"/>
    </v:popup-menu>
  </div>
  
  <v:button id="btn-del" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:widget caption="@Common.Options">
    <v:widget-block>
      <v:form-field caption="@Product.PreparationTime" hint="@Product.PreparationTimeHint">
        <v:input-text field="product.PreparationMins" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

  <v:grid id="bom-grid">
    <thead>
      <tr>
        <td><input type="checkbox" class="cblist header"/></td>
        <td>&nbsp;</td>
        <td width="40%"><v:itl key="@Product.Material"/></td>
        <td width="40%"><v:itl key="@Product.Measure"/></td>
        <td width="20%" align="right"><v:itl key="@Common.Quantity"/></td>
        <td align="center" title="<v:itl key="@Common.Included"/>">INC</td>
        <td align="center" title="<v:itl key="@Common.Optional"/>">OPT</td>
      </tr>
    </thead>
    
    <tbody id="bom-grid-body"></tbody>
  </v:grid>
  
  
<div id="templates" class="hidden">
  <% 
  QueryDef qdef = new QueryDef(QryBO_Product.class);
  // Select
  qdef.addSelect(
      QryBO_Product.Sel.ProductId,
      QryBO_Product.Sel.ProductName,
      QryBO_Product.Sel.MeasureProfileId,
      QryBO_Product.Sel.Active);
  // Filter
  qdef.addFilter(QryBO_Product.Fil.ProductFlag, LkSNProductFlag.ProductAsMaterial.getCode());
  // Sort
  qdef.addSort(QryBO_Product.Sel.ProductName);
  // Exec
  JvDataSet dsMaterial = pageBase.execQuery(qdef);
  %>
  
  <table>
    <tr class="bom-row grid-row">
      <td nowrap><input type="checkbox" class="cblist"/></td>
      <td><i class="fa fa-bars drag-handle"></i></td>
      <td align="right">
        <span class="indent-item" title="<v:itl key="@Product.MaterialAlternativeOptionHint"/>"><i class="fa fa-chevron-right"></i>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <div class="input-group material-input-group">
          <select name="material-combo" class="form-control" data-entitytype="<%=LkSNEntityType.ProductType.getCode()%>" <%=canEdit ? "" : "disabled"%>>
            <v:ds-loop dataset="<%=dsMaterial%>">
              <option 
                  class="<%=dsMaterial.getField(QryBO_Product.Sel.Active).getBoolean() ? "" : "inactive"%>"
                  value="<%=dsMaterial.getField(QryBO_Product.Sel.ProductId).getHtmlString()%>" 
                  data-measureprofileid="<%=dsMaterial.getField(QryBO_Product.Sel.MeasureProfileId).getHtmlString()%>">
                <%=dsMaterial.getField(QryBO_Product.Sel.ProductName).getHtmlString()%>
              </option>
            </v:ds-loop>
          </select>
          <span class="input-group-btn"><button type="button" class="btn btn-default combo-link-btn" title="<v:itl key="@Common.OpenLinkNewTab"/>"><i class="fa fa-external-link"></i></button></span>
        </div>
      </td>
      <td>
        <v:combobox 
            name="measure-combo" 
            lookupDataSet="<%=pageBase.getBL(BLBO_Measure.class).getMeasureDS()%>" 
            idFieldName="MeasureId" 
            captionFieldName="MeasureName" 
            codeFieldName="MeasureCode" 
            enabledFieldName="Enabled"
            linkEntityType="<%=LkSNEntityType.Measure%>"
            allowNull="false"
            enabled="<%=canEdit%>"/>
      </td>
      <td><input type="text" class="form-control" name="quantity" <%=canEdit ? "" : "disabled"%>/></td>
      <td align="center"><input type="checkbox" name="included" <%=canEdit ? "" : "disabled"%>/></td>
      <td align="center"><input type="checkbox" name="optional" <%=canEdit ? "" : "disabled"%>/></td>
    </tr>
    <tr class="bom-group grid-row">
      <td nowrap><input type="checkbox" class="cblist"/></td>
      <td><i class="fa fa-bars drag-handle"></i></td>
      <td colspan="3"><v:input-text field="group-name" placeholder="@Common.Name"/></td>
      <td align="center"></td>
      <td align="center"><input type="checkbox" name="optional"/></td>
    </tr>
  </table>
</div>
  
</div>
