<%@page import="com.vgs.snapp.dataobject.DOProduct.*"%>
<%@page import="com.vgs.cl.document.FtList"%>
<%@page import="com.vgs.cl.document.FtUUIDArray"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
String defaulEventId = pageBase.getBL(BLBO_Product.class).findProductDefaultEventId(product);
%>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" id="search-btn" fa="search"  />
</div>
 
<div id="pricesim-tab" class="tab-content">
	<div class="profile-pic-div">
		<div class="v-filter-container">
			<v:widget caption="@Common.Month">
         <v:widget-block>
           <table style="width:100%">
             <tr>
               <td width="50%">
							  <div class="filter-label"><v:itl key="@Common.Month"/></div>
							  <select id="RangeMonth" class="form-control"/>
               </td>
               <td>&nbsp;</td>
               <td width="50%">
                 <div class="filter-label"><v:itl key="@Common.Year"/></div>
                 <v:input-text type="number" field="RangeYear" />
               </td> 
             </tr>
           </table>
           </v:widget-block>
           </v:widget>
        	<v:widget caption="@Common.Filters">
        	<v:widget-block> 
           <div class="filter-divider"></div>
           
           <label for="SellDate"><v:itl key="@Common.ReferenceDate"/></label> <v:hint-handle hint="@Product.SimulatedSellDate"/><br/>
           <v:input-text type="datepicker" field="SellDate"/>
           
           <div class="filter-divider"></div>
           
           <v:itl key="@Event.Event"/><br/>
           <snp:dyncombo id="EventId" entityType="<%=LkSNEntityType.Event%>" entityId="<%=defaulEventId%>" auditLocationFilter="true" allowNull="false"/>
           
           <div class="filter-divider"></div>
           
           <v:itl key="@SaleChannel.SaleChannel"/><br/>
           <snp:dyncombo id="SalechannelId" entityType="<%=LkSNEntityType.SaleChannel%>" auditLocationFilter="true" allowNull="true"/>
         </v:widget-block>
       </v:widget>  
		</div>
	</div>
 
 	<div class="profile-cont-div" >
 		<!-- [CALENDAR] -->
   	<div id="pricesim-calendar"></div>
 	</div>
	</div>

	<div id="pricesim-templates" class="hidden">
	<div>
		<table>
     	<tr>
				<td class="cal-price-cell cal-price-cell-blank">
  				</td>
  				<td class="cal-price-cell cal-price-cell-valued cal-price-cell-price">
					<div class="cal-price-cell-valued-num"></div>
					<div class="cal-price-cell-valued-price"></div>
					<div class="cal-price-cell-valued-performance">
						<div class="cal-price-cell-valued-performance-container">
							<i id="performance-icon"></i>
						</div>
					</div>
					<div class="cal-price-cell-valued-availability">
 						<div class="prgbar-lbl"></div>
						<div class="prgbar-ext"><div class="prgbar-int"/></div></div>
					</div>
				</td>
				<td class="cal-price-cell cal-price-cell-valued cal-price-cell-noprice">
					<div class="cal-price-cell-valued-num"></div>
					<div class="cal-price-cell-valued-price"><i class="fa fa-ban"></i></div>
  				</td>
      </tr>
    </table>
  </div>
</div>
 
<jsp:include page="product_tab_price_simulator_css.jsp"/>
<jsp:include page="product_tab_price_simulator_js.jsp"/>
