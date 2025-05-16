<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="shipaccount_dialog" title="@Account.B2B_Billing_Title" width="900" height="700" resizable="false" autofocus="false">

  <div class="body-block">
    <v:widget caption="@Common.Options">
      <v:widget-block clazz="noselect">
        <div>
          <label class="checkbox-label">
            <input type="radio" name="radio-AccountOption" value="anonymous" checked="checked"/> 
            <v:itl key="@Account.B2B_Billing_Anonymous"/>
          </label>
        </div>
        <div id="option-itemaccount">
          <label class="checkbox-label">
            <input type="radio" name="radio-AccountOption" value="itemaccount"/>
            <v:itl key="@Account.B2B_Billing_ItemAccount"/>
          </label>
        </div>
        <div>
          <label class="checkbox-label">
            <input type="radio" name="radio-AccountOption" value="newaccount"/>
            <v:itl key="@Account.B2B_Billing_New"/>
          </label>
        </div>
      </v:widget-block>
    </v:widget>
    
    <v:widget id="shipaccount_itemaccount_list" clazz="v-hidden" caption="@Account.Account">
      <v:widget-block clazz="noselect">
      </v:widget-block>
    </v:widget>
    
    <div id="shipaccount-newaccount-container" class="v-hidden"></div>
	</div>
  
  <div class="toolbar-block">
    <div id="btn-shipaccount-next" class="v-button btn-float-right hl-green"><v:itl key="@Common.Next"/></div>
    <div id="btn-shipaccount-back" class="v-button btn-float-right hl-green"><v:itl key="@Common.Back"/></div>
  </div>
  
  <div id="itemaccount-li-template" class="v-hidden">
	  <li class="tab-button noselect">
      <div class="tab-button-icon"></div>
      <div class="tab-button-account">Guest</div>
	    <div class="tab-button-product"></div>
	  </li>
  </div>

  <jsp:include page="shipaccount_dialog_js.jsp"/>

</v:dialog>