<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_RateCode bl = pageBase.getBL(BLBO_RateCode.class);
DORateCode rateCode = pageBase.isNewItem() ? bl.prepareNewRateCode() : bl.loadRateCode(pageBase.getId());
request.setAttribute("rateCode", rateCode);

String[] symbols = new String[] {
    "align-left", "align-center", "align-right", "align-justify", "arrow-circle-left", "arrow-circle-right", "arrow-circle-up", "arrow-circle-down", "arrow-left", "arrow-right", "arrow-up", "arrow-down", 
    "chevron-left", "chevron-right", "chevron-up", "chevron-down", "arrows", "chart-area", "chart-bar", "chart-line", "bars", 
    "battery-slash", "battery-quarter", "battery-half", "battery-three-quarters", "battery-full", "bookmark", "ticket", "calendar", "calendar-plus", "calendar-minus", "calendar-check", "calendar-times", 
    "check", "times", "male", "female", "child", "users", "flag", "flag-checkered", "hospital", "home", "university", "plane", "car", "train", "signal",
    "star", "star-half", "star-exclamation", "thermometer-empty", "thermometer-quarter", "thermometer-half", "thermometer-three-quarters", "thermometer-full", "thumbtack",
    "thumbs-up", "thumbs-down", "hand-point-left", "hand-point-right", "hand-point-up", "hand-point-down", "hand-paper", "hand-rock", "hand-pointer", "hand-spock", 
    "asterisk", "ban", "bell", "binoculars", "bullhorn", "bullseye", "clock", "database", "diamond",
    "exclamation-circle", "envelope", "gift", "glass-martini", "magic", "rocket", "heart", "sun", "cloud", "bolt", "umbrella", 
    "smile", "frown"};
%>


<v:dialog id="ratecode-dialog" width="950" height="800" title="@Common.RateCode" tabsView="true" autofocus="false">

  <style>
    .rc-symbol {
      width: 40px;
      height: 40px;
      line-height: 40px;
      font-size: 24px;
      text-align: center;
      cursor: pointer;
    }
    .rc-symbol:hover {
      background-color: rgba(0,0,0,0.1);
    }
    .rc-symbol.selected {
      background-color: var(--base-blue-color);
      color: white;
    }
  </style>

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="ratecode-tab-profile" caption="@Common.Profile" default="true">
      <div class="tab-content">
        <v:widget caption="@Common.General">
          <v:widget-block>
	      	  <v:form-field caption="@Common.Code" mandatory="true">
	      	    <v:input-text type="text" field="rateCode.RateCodeCode"/>
	      	  </v:form-field>
	      	  <v:form-field caption="@Common.Name" mandatory="true">
	      	    <snp:itl-edit field="rateCode.RateCodeName" entityType="<%=LkSNEntityType.RateCode%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.RateCode_Name%>"/>
	      	  </v:form-field>
	      	  <%-- 
	      	  <v:form-field caption="@Common.Color">
	      	    <input type="color" id="rateCode.RateCodeColor" value="<%=rateCode.RateCodeColor.getHtmlString()%>"/>
	      	  </v:form-field>
	      	  --%>
	      	</v:widget-block>
          <v:widget-block>
            <v:form-field caption="@Currency.Symbol">
	          <% for (String symbol : symbols) { %>
	            <% String sel = rateCode.RateCodeSymbol.isSameString(symbol) ? "selected" : ""; %>
	            <i class="fa fa-<%=symbol%> rc-symbol <%=sel%>" data-symbol="<%=symbol%>"></i>
	          <% } %>
            </v:form-field>
          </v:widget-block>    
        </v:widget>
         
        <v:widget caption="@Product.PriceRule">
          <v:widget-block>
            <table class="form-table">
              <tr>
                <th><label><v:itl key="@Product.PriceFormulaTitle"/></label></th>
                <td>
                  <% String chkNone = LkSNPriceActionType.NotSellable.equals(rateCode.PriceActionType.getLkValue()) ? "checked" : ""; %>
                  <label><input type="radio" name="rateCode.PriceActionType" value="<%=LkSNPriceActionType.NotSellable.getCode()%>" <%=chkNone%>/> <v:itl key="@Common.None"/></label>&nbsp;&nbsp;&nbsp;
                  <% String chkAdd = LkSNPriceActionType.Add.equals(rateCode.PriceActionType.getLkValue()) ? "checked" : ""; %>
                  <label><input type="radio" name="rateCode.PriceActionType" value="<%=LkSNPriceActionType.Add.getCode()%>" <%=chkAdd%>/> <%=LkSNPriceActionType.Add.getDescription()%></label>&nbsp;&nbsp;&nbsp;
                  <% String chkSub = LkSNPriceActionType.Subtract.equals(rateCode.PriceActionType.getLkValue()) ? "checked" : ""; %>
                  <label><input type="radio" name="rateCode.PriceActionType" value="<%=LkSNPriceActionType.Subtract.getCode()%>" <%=chkSub%>/> <%=LkSNPriceActionType.Subtract.getDescription()%></label>&nbsp;&nbsp;&nbsp;
                </td>
              </tr>
            </table>
          </v:widget-block>
          <v:widget-block id="PriceValueType-widget">
            <table class="form-table">
              <tr>
                <th><label><v:itl key="@Product.PriceAmountTitle"/></label></th>
                <td>
                  <% String chkAbs = LkSNPriceValueType.Absolute.equals(rateCode.PriceValueType.getLkValue()) ? "checked" : ""; %>
                  <label><input type="radio" name="rateCode.PriceValueType" value="<%=LkSNPriceValueType.Absolute.getCode()%>" <%=chkAbs%>/> <%=LkSNPriceValueType.Absolute.getDescription()%></label>&nbsp;&nbsp;&nbsp;
                  <% String chkPerc = LkSNPriceValueType.Percentage.equals(rateCode.PriceValueType.getLkValue()) ? "checked" : ""; %>
                  <label><input type="radio" name="rateCode.PriceValueType" value="<%=LkSNPriceValueType.Percentage.getCode()%>" <%=chkPerc%>/> <%=LkSNPriceValueType.Percentage.getDescription()%></label>&nbsp;&nbsp;&nbsp;
                  <v:input-text field="rateCode.PriceValue" placeholder="@Common.Value"/>
                </td>
              </tr>
            </table>
          </v:widget-block>
        </v:widget>
      </div>  
     </v:tab-item-embedded>
      
     <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
        <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
          <jsp:include page="../common/page_tab_historydetail.jsp"/>
        </v:tab-item-embedded>
     <% } %>
      
  </v:tab-group>    

<script>
var dlg = $("#ratecode-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSave,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSave();
});

function priceRuleRefreshVisibility() {
  setVisible("#PriceValueType-widget", $("input[name='rateCode\\.PriceActionType']:checked").val() != "<%=LkSNPriceActionType.NotSellable.getCode()%>");
}

$(document).ready(function() {
  priceRuleRefreshVisibility();
});

$("input[name='rateCode\\.PriceActionType']").change(function() {
  priceRuleRefreshVisibility();
});

$(".rc-symbol").click(function() {
  var $this = $(this);
  if ($this.hasClass("selected"))
    $this.removeClass("selected");
  else
    $this.addClass("selected").siblings().removeClass("selected");
});

function doSave() {
  checkRequired("#ratecode-dialog", function() {
    doSaveRateCode();
  });
}

function doSaveRateCode() {
  var reqDO = {
    Command: "SaveRateCode",
    SaveRateCode: {
      RateCode: {
        RateCodeId: <%=rateCode.RateCodeId.getJsString()%>,
        RateCodeCode: $("#rateCode\\.RateCodeCode").val(),
        RateCodeName: $("#rateCode\\.RateCodeName").val(),
        /* RateCodeColor: $("#rateCode\\.RateCodeColor").val(), */
        RateCodeSymbol: $(".rc-symbol.selected").attr("data-symbol"),
        PriceActionType: $("input[name='rateCode\\.PriceActionType']:checked").val(),
        PriceValueType: $("input[name='rateCode\\.PriceValueType']:checked").val(),
        PriceValue: convertPriceValue($("#rateCode\\.PriceValue").val())
      }
    }
  };
  
  showWaitGlass();
  vgsService("Product", reqDO, false, function(ansDO) {
    hideWaitGlass();
    dlg.dialog("close");
    triggerEntityChange(<%=LkSNEntityType.RateCode.getCode()%>);
  });
}

</script>

</v:dialog>