<%@ page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request" />
<jsp:include page="registration-js.jsp" />
<jsp:include page="registration-css.jsp" />

<div id="registrationContent">
  <div id="existingAccounts" style="">
    <div class="accountscontainer"></div>
  </div>
  <form id="saveAccount" novalidate>
    <table id="selectCategory" style="width: 100%;width: 100%; position: fixed; background: #fff; margin-top: 31px; left: 0; padding: 0 4%;border-bottom: 2px solid #ccc;z-index:2">
          <tbody>
            <tr>
              <td style="width: 30%"><label for="categorySelect"
                class="fieldlabel">Select Category</label></td>
              <td style="width: 50%">
              <select name="" id="categorySelect">
  
              </select>
              </td>
              <td  style="width: 20%">
                <input type="submit" value="Save" id="saveAccountButton" class="button">
              </td>
            </tr>
          </tbody>
        </table>
    <div id="accountForm">
        <div id="accountFormFields"></div>
    </div>
  </form>
  <div id="existAccountForm" class="hidden">
    <form id="existSaveAccount" novalidate>
      <div class="toolbar">
        <div id="buttons">
          <input type="submit" value="Update" class="button update">
          <input type="submit" value="Copy as New" class="button copy">
          <input type="submit" value="Back" class="button back">
          <br clear="all" />
        </div>
      </div>
      <div id="existAccountFormFields"></div>

    </form>
  </div>
</div>
