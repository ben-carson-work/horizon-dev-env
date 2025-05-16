<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType")); %>

<%
boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true");

DOProductUpgrade productUpgrade = pageBase.getBL(BLBO_Product.class).loadProductUpgrade(pageBase.getId(), entityType);
if (!entityType.isLookup(LkSNEntityType.ProductType))
  productUpgrade = pageBase.getBL(BLBO_Product.class).loadProductUpgrade(pageBase.getId(), entityType);
else {
  DOProduct product = SrvBO_OC.getProduct(pageBase.getConnector(), pageBase.getId()).Product;
  productUpgrade = product.ProductUpgrade;
  request.setAttribute("product", product);
}

DOProductUpgrade.DOProductUpgradeFlags upgradeFlags = productUpgrade.Flags;
request.setAttribute("productUpgrade", productUpgrade);
request.setAttribute("upgradeFlags", upgradeFlags);
%>

<v:dialog id="productupg_dialog" tabsView="true" title="Upgrade" width="900" autofocus="false">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <jsp:include page="productupg_dialog_tab_main.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-quickupg" caption="@Product.QuickUpgrades">
      <jsp:include page="productupg_dialog_tab_quickupg.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-crossloc" caption="@Product.AllowedLocations">
      <jsp:include page="productupg_dialog_tab_crossloc.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>

</v:dialog>

<script>

var productUpgrade = <%=productUpgrade.getJSONString()%>;

$(document).ready(function() {
  initMain();
  initQuickUpg();
  initCrossLoc();
  
  var dlg = $("#productupg_dialog");
  dlg.dialog({
    modal: true,
    close: function() {
      dlg.remove();
    },
    buttons: {
      Save: {
      	text: <v:itl key="@Common.Save" encode="JS"/>,
      	click: doSaveProductUpgrade,
      	disabled: <%=!canEdit%>
      },
      Cancel: {
      	text: <v:itl key="@Common.Cancel" encode="JS"/>,
      	click: doCloseDialog
      }
    }
  });
});


function doSaveProductUpgrade() {
  var upgradable = $("#upgradeFlags\\.Upgradable").isChecked();
  var downgradable = $("#upgradeFlags\\.Downgradable").isChecked();
  var upgradeUsedTicket = $("[name='upgradeFlags\\.UpgradeUsedTicket']").isChecked();
  
  var reqDO = {
    Command: "SaveProduct",
    SaveProduct: {
      Product: {
        ProductId: <%=JvString.jsString(pageBase.getId())%>,
        ProductUpgrade: {
          Flags: {
            Upgradable: upgradable,
            Downgradable: downgradable,
            FirstUsageUpgradeDays: (upgradable || downgradable) ? strToIntDef($("#upgradeFlags\\.FirstUsageUpgradeDays").val(), null) : null,
            ExpirationUpgradeDays: (upgradable || downgradable) ? strToIntDef($("#upgradeFlags\\.ExpirationUpgradeDays").val(), null) : null,
            LimitUpgradeMaxTimes: (upgradable || downgradable) ? $("#upgradeFlags\\.LimitUpgradeMaxTimes").isChecked() : null,
            AllowCrossLocationUpg: (upgradable || downgradable) ? $("#upgradeFlags\\.AllowCrossLocationUpg").isChecked() : null,
            InheritFromCat: (upgradable || downgradable) ? $("#upgradeFlags\\.InheritFromCat").isChecked() : null,
            FromVisitUpgradeDays: (upgradable || downgradable) ? $("#upgradeFlags\\.FromVisitUpgradeDays").val() : null,
            FromVisitUpgradePerfDays: (upgradable || downgradable) ? $("#upgradeFlags\\.FromVisitUpgradePerfDays").val() : null,
            PreventChangePerformance: (upgradable || downgradable) ? $("#upgradeFlags\\.PreventChangePerformance").isChecked() : null
          },
          ProductList: getProductList(),
          LocationList: getLocationList()
        }  
      }
    }
  }
  
  var dlg = $("#productupg_dialog");
  
  vgsService("Product", reqDO, false, function(ansDO) {
    dlg.dialog("close");
  });
};
  

</script>