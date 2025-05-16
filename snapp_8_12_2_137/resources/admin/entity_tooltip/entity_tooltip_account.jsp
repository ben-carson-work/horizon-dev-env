<%@page import="com.vgs.web.page.PageTooltip"%>
<%@page import="com.vgs.cl.document.JvFieldNode"%>
<%@page import="com.vgs.dataobject.DOWsLang"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
  String entityId = pageBase.getParameter("EntityId");

  DOAccountRef account = pageBase.getBL(BLBO_QueryRef_Account.class).loadItem(entityId);

  FtCRUD rightLevel = pageBase.getBL(BLBO_Account.class).getAccountOverallRightCRUD(account.EntityType.getLkValue());

  String code = "";
  if (!account.AccountCode.isNull())
    code = "[" + getAccountFieldValue(pageBase, account.AccountCode, !rightLevel.canUpdate()) + "] ";
%>

<%! 
  private String printRecapLine(DOWsLang.DOLangItem lang, String caption, String text) {
    if (JvString.getNull(text) != null)
      return JvMultiLang.translate(lang, caption) + " <span class=\"recap-value\">" + JvString.escapeHtml(text) + "</span><br/>";
  
    return "";
  }
  
  private String getAccountFieldValue(PageTooltip pageBase, JvFieldNode field, boolean masked) {
    return masked ? JvString.escapeHtml(pageBase.getBL(BLBO_Account.class).maskAccountFieldValue(field, pageBase.getLang())) : field.getHtmlString();
  }
%>

<style>
  .tooltip-account-block {
    margin-top: 10px;
  }
  .tooltip-account-label {
    color: var(--base-blue-color);
    /* border-bottom-style: solid;
    border-bottom-width: thin; */
  }
</style>

<div class="entity-tooltip-baloon">

<% if (account.ProfilePictureId.isNull()) { %>
  <div class="profile-pic-icon" style="background-image:url('<v:image-link name="<%=account.IconName.getHtmlString()%>" size="48"/>')"></div>
<% } else { %>
  <div class="profile-pic-img" style="background-image:url('<v:config key="site_url"/>/repository?type=small&id=<%=account.ProfilePictureId.getHtmlString()%>')"></div>
<% } %>

<div class="content">

  <div class="entity-name"><a href="<v:config key="site_url"/>/admin?page=account&id=<%=account.AccountId.getHtmlString()%>"><%=code%><%=getAccountFieldValue(pageBase, account.AccountName, !rightLevel.canUpdate())%></a></div>
  <div class="entity-cat"><%=getAccountFieldValue(pageBase, account.CategoryNames, !rightLevel.canUpdate())%></div>

  <% if(!account.UserName.isNull() || !account.LoginEmail.isNull()) { %>
    <div class="tooltip-account-block">
      <div class="tooltip-account-label"><v:itl key="@Account.Security"/></div>
      <% if (!account.UserName.isNull()) { %>
        <v:itl key="@Common.UserName"/><span class="recap-value"><%=getAccountFieldValue(pageBase, account.UserName, !rightLevel.canUpdate())%></span><br/>
      <% } %>
      <% if (!account.LoginEmail.isNull()) { %>
        <v:itl key="@Common.Email"/><span class="recap-value"><%=getAccountFieldValue(pageBase, account.LoginEmail, !rightLevel.canUpdate())%></span><br/>
      <% } %>
      <% if (!account.LoginStatusDesc.isNull()) { %>
        <v:itl key="@Common.LoginStatus"/><span class="recap-value"><%=getAccountFieldValue(pageBase, account.LoginStatusDesc, !rightLevel.canUpdate())%></span><br/>
      <% } %>
      <% if (!account.LoginSNP.isNull() || !account.LoginB2B.isNull() || !account.LoginB2C.isNull()) { %>
        <% String[] platforms = new String[0]; %>
        <v:itl key="@Common.Platform"/>
        <% if (account.LoginSNP.getBoolean()) { %>
          <% platforms = JvArray.add(pageBase.getLang().Common.PlatformPOS.getDefaultText(), platforms);%>
        <% } %>
        <% if (account.LoginB2B.getBoolean()) { %>
           <% platforms = JvArray.add(pageBase.getLang().Common.PlatformB2B.getDefaultText(), platforms);%>
        <% } %>
        <% if (account.LoginB2C.getBoolean()) { %>
          <% platforms = JvArray.add(pageBase.getLang().Common.PlatformB2C.getDefaultText(), platforms);%>
        <% } %>
        <span class="recap-value"><%=JvArray.arrayToString(platforms, ",")%></span><br/>
      <% } %>
      <% if (!account.RoleNames.isNull()) { %>
        <v:itl key="@Common.SecurityRoles"/><span class="recap-value"><%=getAccountFieldValue(pageBase, account.RoleNames, !rightLevel.canUpdate())%></span><br/>
      <% } %>
    </div>
  <% } %>
  
  <% String companyName = pageBase.getBL(BLBO_MetaData.class).getMetaFieldValue(account.MetaDataList.getItems(), LkSNMetaFieldType.CompanyName1, !rightLevel.canUpdate()); %>
  <% if (account.EntityType.isLookup(LkSNEntityType.Person) && (companyName != null)) { %>
    <div class="tooltip-account-block"><strong><%=JvString.escapeHtml(companyName)%></strong></div>
  <% } %>

  <% 
  String mobilePhone = pageBase.getBL(BLBO_MetaData.class).getMetaFieldValue(account.MetaDataList.getItems(), LkSNMetaFieldType.MobilePhone, !rightLevel.canUpdate()); 
  String homePhone = pageBase.getBL(BLBO_MetaData.class).getMetaFieldValue(account.MetaDataList.getItems(), LkSNMetaFieldType.HomePhone, !rightLevel.canUpdate()); 
  String businessPhone = pageBase.getBL(BLBO_MetaData.class).getMetaFieldValue(account.MetaDataList.getItems(), LkSNMetaFieldType.BusinessPhone, !rightLevel.canUpdate()); 
  String fax = pageBase.getBL(BLBO_MetaData.class).getMetaFieldValue(account.MetaDataList.getItems(), LkSNMetaFieldType.Fax, !rightLevel.canUpdate()); 
  %>

  <% if((mobilePhone != null) || (homePhone != null) || (businessPhone != null) || (fax != null) || !account.CalcAddress.getString().isEmpty()) { %>
    <div class="tooltip-account-block">
      <div class="tooltip-account-label"><v:itl key="@Common.Info"/></div>
      <% if (!account.CalcAddress.getString().isEmpty()) { %>
        <div>
          <v:itl key="@Common.Address"/>
          <span class="recap-value" align="right"><%=getAccountFieldValue(pageBase, account.CalcAddress, !rightLevel.canUpdate())%></span>
        </div><br/>
      <% } %>
      <%=printRecapLine(pageBase.getLang(), "@Account.Phone_Mobile", mobilePhone)%>
      <%=printRecapLine(pageBase.getLang(), "@Account.Phone_Home", homePhone)%>
      <%=printRecapLine(pageBase.getLang(), "@Account.Phone_Business", businessPhone)%>
      <%=printRecapLine(pageBase.getLang(), "@Account.Phone_Fax", fax)%>
    </div>
  <% } %>
  
  <% if (account.EntityType.isLookup(LkSNEntityType.Location)) { %>
    <%
      DORightRoot locationRights = pageBase.getBL(BLBO_Right.class).loadMergedRights(account.EntityType.getLkValue(), entityId, true, true);
        LookupItem timeZone = locationRights.TimeZone.getLkValue();
        TimeZone zone = ((LkTimeZone.TimeZoneItem)timeZone).getTimeZone();
        JvDateTime dt = JvDateTime.now();
    %>
    <div class="tooltip-account-block">
      <div class="tooltip-account-label"><v:itl key="@Common.DateTime"/></div>
      <div><%=JvDateTime.now().format(pageBase.getShortDateFormat() + " " + pageBase.getLongTimeFormat(), zone)%></div>
      <div><%=timeZone.getHtmlDescription(pageBase.getLang())%></div>
    </div>
  <% } %>
</div>

