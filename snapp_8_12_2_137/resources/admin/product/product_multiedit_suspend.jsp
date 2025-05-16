<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<div class="tab-content">
  <v:widget>
    <v:widget-block>
	    <v:alert-box type="info" title="@Common.Info"><v:itl key="@Product.SuspensionHint"/></v:alert-box>
			<v:form-field id="ProdME-Suspend" caption="@Product.Suspension" checkBoxField="Upd_Suspend">
		    <v:input-text type="datepicker" field="Suspend-DateFrom"/>
	      <v:input-text type="datepicker" field="Suspend-DateTo"/>
		    <div id="suspend-operation-type-container">
		      <label><input type="radio" name="SuspendOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
		      <label><input type="radio" name="SuspendOperation" value="remove"><v:itl key="@Common.Remove"/></label>
		    </div>
		  </v:form-field>
		</v:widget-block>
  </v:widget>
</div>

