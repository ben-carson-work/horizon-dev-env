<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String[] accountIDs = JvArray.stringToArray(JvUtils.getCookieValue(request, PageAccount.COOKIENAME_ACCOUNT_MERGE), ",");
String[] metaFieldIDs = new String[0];
DOAccount[] accounts = new DOAccount[accountIDs.length];
for (int i=0; i<accountIDs.length; i++) {
  accounts[i] = pageBase.getBL(BLBO_Account.class).loadAccount(accountIDs[i]);
  for (DOMetaDataItem mdi : accounts[i].MetaDataList) {
    if (!mdi.MetaFieldType.isLookup(LkSNMetaFieldType.UserName, LkSNMetaFieldType.LoginEmail) && !JvArray.contains(mdi.MetaFieldId.getString(), metaFieldIDs)) 
      metaFieldIDs = JvArray.add(mdi.MetaFieldId.getString(), metaFieldIDs);
  }
}

DOMetaField[] metaFields = new DOMetaField[metaFieldIDs.length];
for (int i=0; i<metaFieldIDs.length; i++) {
  metaFields[i] = new DOMetaField();
  pageBase.getBL(BLBO_MetaData.class).fillMetaField(metaFields[i], metaFieldIDs[i]);
}
%>

<v:dialog id="account_merge_dialog" title="@Common.Merge" width="950" height="700">

<style>
.mrgdlg-grid {
  border-spacing: 0;
}
.mrgdlg-grid td {
  padding: 5px;
  text-align: center;
}
.mrgdlg-topleft,
.mrgdlg-header,
.mrgdlg-fieldname {
  border: 1px var(--tab-border-color) solid;
}
.mrgdlg-header,
.mrgdlg-fieldname {
  background-color: var(--pagetitle-bg-color);
  font-weight: bold;
}
.mrgdlg-topleft {
  border-top-width: 0;
  border-left-width: 0;
}
.mrgdlg-header {
  border-left-width: 0;
  text-align: center;
}
.mrgdlg-fieldname {
  border-top-width: 0;
  min-width: 150px;
}
.mrgdlg-datarow {
  background-color: --body-bg-color;
}
.mrgdlg-datacell {
  border: 1px rgba(0,0,0,0.1) solid;
  border-width: 0px 1px 1px 0px;
  border-style: solid;
  min-width: 200px;
  cursor: pointer;
}
.mrgdlg-datacell:last-child {
  border-right-color: var(--tab-border-color);
}
tr:last-child .mrgdlg-datacell {
  border-bottom-color: var(--tab-border-color);
}
.mrgdlg-datacell.selected {
  background-color: var(--highlight-color);
  font-weight: bold;
}
.mrgdlg-datacell:not(.selected):hover {
  background-color: rgba(0,0,0,0.05);
}
.mrgdlg-profile-pic {
  display: inline-block;
  width: 80px;
  height: 80px;
  background-size: cover;
}
</style>

<v:alert-box type="info" title="@Common.Info"><v:itl key="@Account.MergeWizardHint"/></v:alert-box>

<table class="mrgdlg-grid noselect">
  <%-- DISPLAY NAME --%>
  <tr>
    <td class="mrgdlg-topleft"></td>
    <% for (int i=0; i<accounts.length; i++) { %>
      <td class="mrgdlg-header <%=(i==0)?"mrgdlg-first":""%>"><%=accounts[i].DisplayName.getHtmlString()%></td>
    <% } %>
  </tr>
  
  <%-- PROFILE PICTURE --%>
  <tr class="mrgdlg-datarow">
    <td class="mrgdlg-fieldname mrgdlg-first"><v:itl key="@Repository.ProfilePicture"/></td>
    <% boolean picFound = false; %>
    <% for (DOAccount account : accounts) { %>
      <%
        boolean selected = false;
        String picUrl = "imagecache?size=80&name=" + account.IconName.getHtmlString();
        if (!account.ProfilePictureId.isNull()) {
          picUrl = "repository?type=small&id=" + account.ProfilePictureId.getHtmlString();
          if (!picFound) {
            selected = true;
            picFound = true;
          }
        }
      %>
      <td class="mrgdlg-datacell <%=selected?"selected":""%>" data-Type="profilepic" data-Value="<%=account.ProfilePictureId.getHtmlString()%>">
        <div class="mrgdlg-profile-pic" style="background-image:url('<v:config key="site_url"/>/<%=picUrl%>')">
        </div>
      </td>
    <% } %>
  </tr>
  
  <%-- ACCOUNTCODE --%>
  <tr class="mrgdlg-datarow">
    <td class="mrgdlg-fieldname mrgdlg-first"><v:itl key="@Common.Code"/></td>
    <%boolean checked = false;%>
    <% for (DOAccount account : accounts) { %>
    <%
      boolean selected = false;
      if (!checked) {
        selected = true;
        checked = true;
      }
      %>
      <td class="mrgdlg-datacell <%=selected?"selected":""%>" data-Type="accountcode" data-Value="<%=account.AccountCode.getHtmlString()%>">
      <%=account.AccountCode.getHtmlString()%>
      </td>
    <% } %>
  </tr>
  
  <%-- META DATA --%>
  <% for (DOMetaField metaField : metaFields) { %>
    <tr class="mrgdlg-datarow">
      <td class="mrgdlg-fieldname"><%=metaField.MetaFieldName.getHtmlString()%></td>
      <% boolean mdiFound = false; %>
      <% for (DOAccount account : accounts) { %>
        <%
          String value = "";
          String displayText = "";
          boolean selected = false;
          for (DOMetaDataItem mdi : account.MetaDataList) {
            if (mdi.MetaFieldId.isSameString(metaField.MetaFieldId)) {
              value = mdi.Value.getHtmlString();
              
              if (!mdi.Value.isNull() && metaField.FieldDataType.isLookup(LkSNMetaFieldDataType.Date, LkSNMetaFieldDataType.Time, LkSNMetaFieldDataType.DateTime)) {
                try {
                  JvDateTime dt = JvDateTime.createByXML(mdi.Value.getString());
                  if (metaField.FieldDataType.isLookup(LkSNMetaFieldDataType.Date))
                    displayText = pageBase.format(dt, pageBase.getShortDateFormat());
                  else if (metaField.FieldDataType.isLookup(LkSNMetaFieldDataType.Time))
                    displayText = pageBase.format(dt, pageBase.getShortTimeFormat());
                  else if (metaField.FieldDataType.isLookup(LkSNMetaFieldDataType.DateTime))
                    displayText = pageBase.format(dt, pageBase.getShortDateTimeFormat());
                  else
                    displayText = "[not handled]";
                }
                catch (Throwable t) {
                  displayText = mdi.Value.getHtmlString();
                }
              }
              else
                displayText = mdi.Value.getHtmlString();
              
              if (!mdiFound && !mdi.Value.isNull()) {
                selected = true;
                mdiFound = true;
              }
              break;
            }
          }
        %>
        <td class="mrgdlg-datacell <%=selected?"selected":""%>" 
            data-Type="metadata" 
            data-MetaFieldId="<%=metaField.MetaFieldId.getHtmlString()%>" 
            data-Value="<%=value%>">
          <%=displayText%>
        </td>
      <% } %>
    </tr>
  <% } %>
</table>

<script>
$(document).ready(function() {
  setCookie(<%=JvString.jsString(PageAccount.COOKIENAME_ACCOUNT_MERGE)%>, "", 0);
  
  $("#account_merge_dialog").on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Save", _doMergeAccounts),
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });

  $(".mrgdlg-datacell").click(function() {
    $(this).siblings().removeClass("selected");
    $(this).addClass("selected");
  });

  function _doMergeAccounts() {
    <%
    String finalAccountId = accountIDs[0];
    accountIDs = JvArray.remove(accountIDs, finalAccountId);
    %>
    var reqDO = {
      Command: "Merge",
      Merge: {
        FinalAccount: {
          AccountId: <%=JvString.jsString(finalAccountId)%>
        },
        SourceAccountList: [],
        AccountCode: $(".mrgdlg-grid [data-Type='accountcode'].selected").attr("data-Value"),
        ProfilePictureId: $(".mrgdlg-grid [data-Type='profilepic'].selected").attr("data-Value"),
        MetaDataList: []
      }
    };
    
    <% for (String accountId : accountIDs) { %>
      reqDO.Merge.SourceAccountList.push({AccountId: <%=JvString.jsString(accountId)%>});
    <% } %>
    
    var cells = $(".mrgdlg-grid [data-Type='metadata'].selected");
    for (var i=0; i<cells.length; i++) {
      reqDO.Merge.MetaDataList.push({
        MetaFieldId: $(cells[i]).attr("data-MetaFieldId"),
        Value: $(cells[i]).attr("data-Value")
      });
    }
    
    showWaitGlass();
    vgsService("account", reqDO, false, function(ansDO) {
      window.location = <%=JvString.jsString(pageBase.getContextURL())%> + "?page=account&id=" + ansDO.Answer.Merge.AccountId;
    });
  }
});

</script>

</v:dialog>


