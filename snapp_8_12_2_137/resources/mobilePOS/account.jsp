<%@ page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>
<jsp:include page="account-js.jsp" />
<jsp:include page="account-css.jsp" />

<div id="registrationContent">
  <div style="position:fixed;margin-top:-100px;z-index:1;    width: 100%;">
    <div id="existingAccounts" style="">
      <div class="accountscontainer"></div>
    </div>
<!--   <form id="saveAccount" novalidate> -->
      <table id="selectCategory" style="width: 100%; background: #fff; padding: 0 5px;border-bottom: 2px solid #ccc;z-index:2">
        <tbody>
          <tr>
            <td style="width: 30%"><label for="categorySelect"
              class="fieldlabel">Select Category</label></td>
            <td style="width: 50%">
            <select name="" id="categorySelect">
  
            </select>
            </td>
            <td  style="width: 20%">
  <!--                 <input type="submit" value="Save" id="saveAccountButton" class="button"> -->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div id="accountFormContainer" style="margin-top:80px;padding-top: 12px;">
        <div id="accountFormFields"></div>
    </div>
  
<!--   </form> -->
  <div id="existAccountForm" class="hidden">
    <form id="existSaveAccount" novalidate>
      <div class="toolbar">
        <div id="buttons">
          <input type="submit" value="Update" class="btn btn-lg btn-default update">
          <input type="submit" value="Copy as New" class="btn btn-lg btn-default copy">
          <input type="submit" value="Back" class="btn btn-lg btn-default back pull-right">
          <br clear="all" />
        </div>
      </div>
      <div id="existAccountFormFields"></div>

    </form>
  </div>
</div>
