<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.b2b.page.PageB2B_User"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String langISO = JvString.getEmpty(account.LangISO.isNull() ? account.DefaultLangISO.getString() : account.LangISO.getString()); 
Locale loc = new Locale(langISO); 
String langName = JvString.escapeHtml(JvString.getPascalCase(loc.getDisplayLanguage(pageBase.getLocale())));
boolean canEdit = pageBase.getRights().B2BAgent_EditPersonalData.getBoolean() || pageBase.getRights().B2BAgent_ManageUsers.getBoolean();
String disabled = (canEdit) ? "" : "disabled=\"disabled\"";
%>


<v:page-form id="account-form">
  <v:input-text field="account.AccountId" type="hidden" />
  <v:input-text field="account.EntityType" type="hidden" />
  <v:input-text field="account.ParentAccountId" type="hidden" />
   
<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(account.MetaDataList)%>;
</script>
  
<v:tab-toolbar include="<%=canEdit%>">
  <v:button id="btn-save" caption="@Common.Save" fa="save" href="javascript:doSaveAccount()"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=account.EntityType.getLkValue()%>" field="account.ProfilePictureId" enabled="<%=canEdit%>"/>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget caption="@Common.General">
      <v:widget-block>
          <v:form-field caption="@Category.Category" mandatory="true">
          <% for (String categoryId : account.CategoryIDs.getArray()) { %>
            <div><%=JvString.escapeHtml(pageBase.getBL(BLBO_Category.class).getCategoryRecursiveName(categoryId))%></div>
          <% } %>
          </v:form-field>
          <v:form-field caption="@Common.Language">
            <select id="account.LangISO" name="account.LangISO" class="form-control" <%=disabled%>><%=pageBase.getBL(BLBO_Lang.class).getLangOptions(account.LangISO.getString(), account.DefaultLangISO.getString(), true)%></select>
          </v:form-field>
      </v:widget-block>
    </v:widget>

    <v:widget caption="@Account.Security" include="<%=account.AccountId.isNull()%>">
      <v:widget-block>
        <v:form-field caption="@Common.UserName" mandatory="true">
          <v:input-text field="txtUserName" enabled="<%=canEdit%>" autocomplete="new-password"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>

    <div id="maskedit-container"></div>
  </v:profile-main>
</v:tab-content>

</v:page-form>

<script>

var categoryIDs = <%=JvString.jsString(JvArray.arrayToString(account.CategoryIDs.getArray(), ","))%>;
asyncLoad("#maskedit-container", "<%=pageBase.getContextURL()%>?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=account.EntityType.getInt()%>&CategoryIDs=" + categoryIDs + "&readonly=<%=!canEdit%>");

function doSaveAccount() {
  var list = prepareMetaDataArray($(".tab-content"));
  if (!(list)) 
    showMessage(itl("@Common.CheckRequiredFields"));
  else {
    var reqDO = {
      AccountId: <%=pageBase.isNewItem() ? null : JvString.jsString(pageBase.getId())%>,
      ParentAccountId: <%=JvString.jsString(pageBase.getSession().getOrgAccountId())%>,
      EntityType: <%=LkSNEntityType.Person.getCode()%>,
      CategoryIDs: <%=JvString.jsString(account.CategoryIDs.getString())%>,
      LangISO: $("#account\\.LangISO").val(),
      ProfilePictureId: $("#account\\.ProfilePictureId").val(),
      MetaDataList: list
    };
    
    <% if (account.AccountId.isNull()) { %>
      reqDO.AccountLogin = {
        UserName: $("#txtUserName").val(),
        LoginB2B: true
      };
    <% } %>

    snpAPI.cmd("Account", "SaveAccount", reqDO).then(ansDO => {
      window.location = "b2b?page=user&id=" + ansDO.AccountId + "&ParentAccountId=<%=pageBase.getSession().getOrgAccountId()%>";
    });
  }
}

</script>
