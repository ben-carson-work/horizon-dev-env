<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  QueryDef qdef = new QueryDef(QryBO_AccountCrossPlatform.class);
  // Select
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.IconName);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CommonStatus);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CrossPlatformId);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CrossPlatformType);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CrossPlatformTypeDesc);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CrossPlatformStatus);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CrossPlatformURL);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CrossPlatformName);
  qdef.addSelect(QryBO_AccountCrossPlatform.Sel.CrossPlatformRef);
  JvDataSet dsCrossPlatform = pageBase.execQuery(qdef);
%>


<v:dialog id="xpi-prod-sync-create-dialog" width="700" height="650" title="@Product.NewProductType">

<link type="text/css" href="<v:config key="site_url"/>/libraries/jquery-steps/jquery.steps.css" rel="stylesheet" media="all" />
<script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-steps/jquery.steps.js"></script>

<jsp:include page="xpi_sync_create_dialog_css.jsp"/>
<jsp:include page="xpi_product_sync_create_dialog_js.jsp"/>

<div id="wizard">
  <h3><v:itl key="@XPI.ProdCreateWizStep1"/></h3>
  <section>
    <v:widget clazz="event-parameters" caption="@XPI.CrossProduct">
      <v:widget-block>
			  <v:form-field caption="@XPI.CrossPlatformName" mandatory="true">
			    <select name="productCrossSell.CrossPlatformId" id="productCrossSell.CrossPlatformId" class="form-control">
    		    <option></option>
            <v:ds-loop dataset="<%=dsCrossPlatform%>">
              <option value="<%=dsCrossPlatform.getField("CrossPlatformId").getString()%>" data-Desc="<%=dsCrossPlatform.getField("CrossPlatformTypeDesc").getString()%>" data-Ref="<%=dsCrossPlatform.getField("CrossPlatformRef").getString()%>" data-URL="<%=dsCrossPlatform.getField("CrossPlatformURL").getString()%>" data-Type="<%=dsCrossPlatform.getField("CrossPlatformType").getInt()%>" ><%=dsCrossPlatform.getField("CrossPlatformName").getHtmlString()%></option>
            </v:ds-loop>
			    </select>
			  </v:form-field>
			  <v:form-field id="xpi-crossproductid" caption="@XPI.CrossProductId" clazz="v-hidden" mandatory="true">
			    <v:input-text type="text" field="productCrossSell.CrossProductId"/>
			  </v:form-field>
			  <%-- SNAPP PRODUCT --%>
			  <v:form-field id="snapp-prod" caption="@XPI.CrossProductName" clazz="v-hidden">   
			    <select id="productCrossSell.CrossProductNameSnapp" class="form-control"></select>
			  </v:form-field>
			  <%-- ** --%>
			  <%-- GENERIC PRODUCT --%>
			  <v:form-field id="generic-prod" caption="@XPI.CrossProductName" clazz="v-hidden" mandatory="true"> 
			    <v:input-text type="text" field="productCrossSell.CrossProductNameGeneric"/>
			  </v:form-field>
			  <%-- ** --%>
			  <v:form-field caption="@XPI.CrossProductCode">
			    <v:input-text type="text" field="productCrossSell.CrossProductCode"/>
			  </v:form-field>
			  <v:form-field caption="@Product.Price" mandatory="true">
			    <v:input-text type="text" field="productCrossSell.Price"/>
			  </v:form-field>
			</v:widget-block>
	  </v:widget>
	</section>
	<h3><v:itl key="@XPI.ProdCreateWizStep2"/></h3>
  <section>
    <v:widget clazz="product-parameters" caption="@Common.Parameters">
      <v:widget-block>
        <v:form-field caption="@Common.Code">
          <v:input-text type="text" field="product.ProductCode"/>
        </v:form-field>
        <v:form-field caption="@Common.Name">
          <v:input-text type="text" field="product.ProductName"/>
        </v:form-field>
        <v:form-field caption="@Product.BasePrice">
          <v:input-text type="text" field="product.Price"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Common.Status">
          <v:lk-combobox field="product.ProductStatus" lookup="<%=LkSN.ProductStatus%>" allowNull="false" />
	      </v:form-field>
	      <v:form-field caption="@Category.Category">
	        <% JvDataSet dsCat = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.ProductType); 
	        String categoryId = pageBase.getEmptyParameter("CategoryId");
	        if("all".equals(categoryId)){
	          categoryId = "";
	        }
	        %>
	        <v:combobox name="product.CategoryId" lookupDataSet="<%=dsCat%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" value="<%=categoryId%>"/>
	      </v:form-field>
	      <v:form-field caption="@Common.Tags">
	        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
	        <v:multibox field="product.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" />
	      </v:form-field>
	      <v:form-field caption="@SaleChannel.SaleChannels">
	        <% JvDataSet dsSaleChannelAll = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null); %>
	        <v:multibox field="product.SaleChannelIDs" lookupDataSet="<%=dsSaleChannelAll%>" idFieldName="SaleChannelId" captionFieldName="SaleChannelName" />
	      </v:form-field>
	      <v:form-field caption="@Performance.PerformanceTypes">
	        <% String[] parentIDs = pageBase.getTreeIDs(pageBase.getEmptyParameter("ParentEntityType"), pageBase.getEmptyParameter("ParentEntityId"));
	        JvDataSet dsPerfTypeAll = pageBase.getBL(BLBO_PerformanceType.class).getDS(parentIDs);%>
	        <v:multibox field="product.PerfTypeIDs" lookupDataSet="<%=dsPerfTypeAll%>" idFieldName="PerformanceTypeId" captionFieldName="PerformanceTypeName" />
	      </v:form-field>
      </v:widget-block>
    </v:widget>
  </section>
  <h3><v:itl key="@XPI.ProdCreateWizStep3"/></h3>
  <section>
    <v:widget clazz="product-parameters" caption="@Common.Media">
      <v:widget-block>
        <% BLBO_DocTemplate blDocTemplate = pageBase.getBL(BLBO_DocTemplate.class); %>
        <v:form-field caption="@DocTemplate.POS_Template" checkBoxField="product.POS_AllowPrint">
				  <v:combobox field="product.POS_DocTemplateId" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
				</v:form-field>
				<v:form-field caption="@DocTemplate.CLC_Template" checkBoxField="product.CLC_AllowPrint">
				  <v:combobox field="product.CLC_DocTemplateId" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
				</v:form-field>
				<v:form-field caption="@DocTemplate.B2B_Template" checkBoxField="product.B2B_AllowPrint">
				  <v:combobox field="product.B2B_DocTemplateId" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
				</v:form-field>
				<v:form-field caption="@DocTemplate.B2C_Template" checkBoxField="product.B2C_AllowPrint">
				  <v:combobox field="product.B2C_DocTemplateId" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
				</v:form-field>
				<v:form-field caption="@DocTemplate.MOB_Template" checkBoxField="product.MOB_AllowPrint">
				  <v:combobox field="product.MOB_DocTemplateId" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LkSNDocTemplateType.Media)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
				</v:form-field>
      </v:widget-block>
    </v:widget>
  </section>
</div>  
  
</v:dialog>