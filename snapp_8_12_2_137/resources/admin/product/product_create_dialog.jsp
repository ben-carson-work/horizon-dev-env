<%@page import="com.vgs.snapp.dataobject.DODB.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.bko.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_AttributeItem.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />

<% 
String parentEntityId = pageBase.getNullParameter("ParentEntityId");
//String[] parentIDs = pageBase.getTreeIDs(pageBase.getEmptyParameter("ParentEntityType"), pageBase.getEmptyParameter("ParentEntityId")); 

QueryDef qdef = new QueryDef(QryBO_AttributeItem.class);
// Select
qdef.addSelect(Sel.AttributeId);
qdef.addSelect(Sel.AttributeName);
qdef.addSelect(Sel.AttributeItemId);
qdef.addSelect(Sel.AttributeItemCode);
qdef.addSelect(Sel.AttributeItemName);
// Filter
qdef.addFilter(Fil.ForAttributeParentEntityId, parentEntityId);
// Sort
qdef.addSort(Sel.AttributeName);
qdef.addSort(Sel.AttributeId);
qdef.addSort(Sel.PriorityOrder);

JvDataSet ds;
%>


<v:dialog id="product-create-dialog" width="1000" height="710" title="@Product.NewProductType">

<link type="text/css" href="<v:config key="site_url"/>/libraries/jquery-steps/jquery.steps.css" rel="stylesheet" media="all" />
<script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-steps/jquery.steps.js"></script>

<jsp:include page="product_create_dialog_css.jsp"/>
<jsp:include page="product_create_dialog_js.jsp"/>


  <div id="wizard">
    <h3><v:itl key="@Product.CreateWizStep1"/></h3>
    <section>
      <table id="step1-table">
        <tr>
          <td colspan="2" width="66.66%" style="padding-right:7px">
            <input type="text" id="attr-search-box" class="attr-search-box form-control" placeholder="<v:itl key="@Common.Search"/>" onkeyup="doSearchAttribute()"/>
          </td>
          <td rowspan="2" width="33.34%" style="padding-left:7px">
            <v:widget clazz="recap-widget" caption="@Common.Recap">
              <v:widget-block>
                <div class="recap-total"><v:itl key="@Product.ProductsCreated"/>: <span class="recap-total-value"></span></div>
              </v:widget-block>
              <v:widget-block clazz="recap-block">
              </v:widget-block>
            </v:widget>
          </td>
        </tr>
        <tr>
          <td width="33.33%" style="padding-right:7px">
            <v:widget caption="@Product.Attributes" id="attribute-widget">
              <v:widget-block>
                <% String lastId = null; %>
               <v:ds-loop dataset="<%=ds=pageBase.execQuery(qdef)%>">
                <% String thisId = ds.getField(Sel.AttributeId).getHtmlString(); %>
                <% if (!(JvString.isSameString(lastId, thisId))) { %>
                  <% lastId = thisId; %>
                  <div class="attribute-row" data-attributeid="<%=thisId%>" onclick="onAttributeClick(this)"><%=ds.getField(Sel.AttributeName).getHtmlString()%></div>
              <% } %>
               </v:ds-loop>
              </v:widget-block>
            </v:widget>
          </td>
          <td width="33.33%" style="padding-left:7px;padding-right:7px">
            <v:widget caption="@Common.Items" id="attribute-item-widget">
              <v:widget-block>
                <v:lk-combobox field="selection-type" lookup="<%=LkSN.AttributeSelection%>" allowNull="false" onclick="onSelTypeClick(this)"/>
              </v:widget-block>
              <v:widget-block>
                <% String lastId = null; %>
                <v:ds-loop dataset="<%=ds=pageBase.execQuery(qdef)%>">
									<% 
									String thisId = ds.getField(Sel.AttributeId).getHtmlString(); 
									if (!(JvString.isSameString(lastId, thisId))) { 
									  if (lastId != null)
									    out.print("</div>");
									  out.print("<div class='attribute-block' data-attributeid='" + thisId + "'>");
									  lastId = thisId;
									} 
									%>
                  <div class="attribute-item-row">
                    <v:db-checkbox field="" value="<%=ds.getField(Sel.AttributeItemId).getString()%>" caption="<%=ds.getField(Sel.AttributeItemName).getString()%>" onclick="onAttributeItemClick(this)"/>
                  </div>
                </v:ds-loop>
                <% 
                if (lastId != null) 
                  out.print("</div>");
                %>
              </v:widget-block>
            </v:widget>
          </td>
        </tr>
      </table>
    </section>

    <h3><v:itl key="@Product.CreateWizStep2"/></h3>
    <section>
      <table id="step2-table">
        <tr>
          <td width="66.66%" style="padding-right:7px">
            <v:widget clazz="product-parameters" caption="@Common.Parameters">
              <v:widget-block>
                <v:form-field caption="@Common.Status">
                  <v:lk-combobox field="ProductStatus" lookup="<%=LkSN.ProductStatus%>" allowNull="false" />
                </v:form-field>
                <v:form-field caption="@Category.Category">
                  <% JvDataSet dsCat = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.ProductType); 
                  String categoryId = pageBase.getEmptyParameter("CategoryId");
                  if("all".equals(categoryId)){
                    categoryId = "";
                  }
                  %>
                  <v:combobox name="CategoryId" lookupDataSet="<%=dsCat%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" value="<%=categoryId%>" linkEntityType="<%=LkSNEntityType.Category%>" />
                </v:form-field>
                <v:form-field caption="@Payment.PaymentProfile">
                  <v:combobox 
                      name="PaymentProfileId"
                      field="PaymentProfileId" 
                      lookupDataSet="<%=pageBase.getBL(BLBO_PaymentProfile.class).getPaymentProfileDS()%>" 
                      idFieldName="PaymentProfileId" 
                      captionFieldName="PaymentProfileName" 
                      allowNull="true" 
                      linkEntityType="<%=LkSNEntityType.PaymentProfile%>"
                      enabled="true"/>
                </v:form-field>
                <v:form-field caption="@Common.Tags">
                  <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
                  <v:multibox field="product-create-dialog-TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" />
                </v:form-field>
                <v:form-field caption="@SaleChannel.SaleChannels">
                  <% JvDataSet dsSaleChannelAll = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null); %>
                  <v:multibox field="salechannels" lookupDataSet="<%=dsSaleChannelAll%>" idFieldName="SaleChannelId" captionFieldName="SaleChannelName" />
                </v:form-field>
                <v:form-field caption="@Performance.PerformanceTypes">
                  <% String[] parentIDs = pageBase.getTreeIDs(pageBase.getEmptyParameter("ParentEntityType"), pageBase.getEmptyParameter("ParentEntityId"));
                  JvDataSet dsPerfTypeAll = pageBase.getBL(BLBO_PerformanceType.class).getDS(parentIDs);%>
                  <v:multibox field="perftypes" lookupDataSet="<%=dsPerfTypeAll%>" idFieldName="PerformanceTypeId" captionFieldName="PerformanceTypeName" />
                </v:form-field>
              </v:widget-block>
            </v:widget>
          </td>
          <td width="33.34%" style="padding-left:7px">
            <v:widget clazz="recap-widget" caption="@Common.Recap">
              <v:widget-block>
                <div class="recap-total"><v:itl key="@Product.ProductsCreated"/>: <span class="recap-total-value"></span></div>
              </v:widget-block>
              <v:widget-block clazz="recap-block">
              </v:widget-block>
            </v:widget>
          </td>
        </tr>
      </table>
    </section>
    
    <h3><v:itl key="@Product.CreateWizStep3"/></h3>
    <section>
      <div class="product-list">
        <div class="product-list-header widget-title container">
          <div class="row">
            <div class="col-md-5">
              <v:itl key="@Common.Code" />
            </div>
            <div class="col-md-5">
              <v:itl key="@Common.Name" />
            </div>
            <div class="col-md-2">
              <v:itl key="@Product.Price" />
            </div>
          </div>
        </div>
        <div class="product-list-body container">
        </div>
      </div>
    </section>    
  </div>
  
  <!-- Templates -->
	<div id="product-create-templates" class="hidden">
	  <div class='recap-group'>
	    <div class='recap-title'>
	      <span class='recap-title-attribute'></span>
	      <span class='recap-title-seltype'></span>
	    </div>
	    <div class='recap-body'></div>
	  </div>
	
	  <div class="product-row row">
	    <div class="col-md-5"><input type="text" class="form-control product-code" placeholder="<v:itl key="@Common.Code"/>" maxlength="<%=tbProduct.dummy().ProductCode.getSize()%>"/></div>
	    <div class="col-md-5"><input type="text" class="form-control product-name" placeholder="<v:itl key="@Common.Name"/>" maxlength="<%=tbProduct.dummy().ProductName.getSize()%>"/></div>
	    <div class="col-md-2"><input type="text" class="form-control product-price" placeholder="<v:itl key="@Product.BasePrice"/>"/></div>
	  </div>
  </div>

</v:dialog>


