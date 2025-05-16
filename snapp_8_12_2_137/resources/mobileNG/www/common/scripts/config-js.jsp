<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSNTicketStatus"%>
<%@page import="com.vgs.cl.lookup.LkCommonStatus"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="apt" class="com.vgs.snapp.dataobject.DOAccessPointRef" scope="request"/>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
String workstationId = pageBase.getId();
DORightRoot wksRights = pageBase.getBL(BLBO_Right.class).getFinalRights(workstationId, null);

String profilePictureId = null;
if (!BLBO_DBInfo.isDatabaseEmpty() && !BLBO_DBInfo.isDatabaseUpdateNeeded()) 
  profilePictureId = pageBase.getBL(BLBO_Repository.class).findProfilePictureId(BLBO_DBInfo.getMasterAccountId());
%>

<script>
  var COMMON_JS = {
    debug: false,
    local: false,
    appName: 'MOB_NG',
    title: '<v:config key="site_title"/>',
    site_url: '<v:config key="site_url"/>/',
    base_url: '<v:config key="resources_url"/>/mobileNG/www/',
    apt: <%=apt.getJSONString()%>,
    autoLogin: <%=!wksRights.AutoLoginName.isNull()%>,
    workstationId: <%=JvString.jsString(workstationId)%>,
    langISO: '<%=wksRights.LangISO%>',
    thousandSeparator: '<%=pageBase.getRights().ThousandSeparator.getString()%>',
    decimalSeparator: '<%=pageBase.getRights().DecimalSeparator.getString()%>',
    dateFormat: <%=wksRights.ShortDateFormat.getInt()%>,
    timeFormat: <%=wksRights.ShortTimeFormat.getInt()%>,
    mob_apps_keys: {
      adm: 'AppMOB_Admission',
      operator: 'AppMOB_SalesOperator',
      guest: 'AppMOB_SalesGuest',
      payment: 'AppMOB_Payment'
    },
    accessPointControl: {
      controlled: <%=LkSNAccessPointControl.Controlled.getCode()%>,
      closed: <%=LkSNAccessPointControl.Closed.getCode()%>,
      free: <%=LkSNAccessPointControl.Free.getCode()%>
    },
    accessPointOperator: {
      none: <%=LkSNAccessPointOperatorCmd.None.getCode()%>,
      ticket: <%=LkSNAccessPointOperatorCmd.UseTicket.getCode()%>
    },
    usageTypeCodes: {
      entry: <%=LkSNTicketUsageType.Entry.getCode()%>, 
      exit: <%=LkSNTicketUsageType.Exit.getCode()%> 
    },
    usageTypes: {
      entry: '<v:image-link name="adm_entry_green.png" size="128"/>',
      simulate: '<v:image-link name="adm_entry_green.png" size="128"/>',
      exit: '<v:image-link name="adm_exit_blue.png" size="128"/>',
      lookup: '<v:image-link name="adm_lookup_gray.png" size="128"/>'
    },
    icons: { 
      keyboard: '<v:image-link name="[font-awesome]keyboard" size="128"/>',
      keyboard_active: '<v:image-link name="[font-awesome]keyboard|TransformNegative" size="128"/>',
      barcode: '<v:image-link name="bkoact-barcode.png|TransformNegative" size="128"/>',
      attendance: '<v:image-link name="bkoact-attendance.png|TransformNegative" size="128"/>',
      info: '<v:image-link name="bkoact-info.png" size="128"/>',
      infoNegative: '<v:image-link name="bkoact-info.png|TransformNegative" size="128"/>',
      check: '<v:image-link name="bkoact-check.png" size="128"/>',
      arrow_r: '<v:image-link name="bkoact-forward-grey.png" size="128"/>',
      event: '<v:image-link name="bkoact-event.png" size="128"/>',
      location: '<v:image-link name="bkoact-location-black.png" size="128"/>',
      payment: '<v:image-link name="bkoact-pay.png" size="128"/>',
      performance: '<v:image-link name="bkoact-calendar.png" size="128"/>',
      print: '<v:image-link name="bkoact-print.png" size="128"/>',
      product: '<v:image-link name="bkoact-product.png" size="128"/>',
      status: '<v:image-link name="bkoact-flag.png" size="128"/>',
      catalog: '<v:image-link name="mob-menu.png|TransformNegative" size="128"/>',
      shopcart: '<v:image-link name="bkoact-basket.png|TransformNegative" size="128"/>',
    },
    profilePictureId: '<%=profilePictureId%>',
    operatingAreaCode: <%=LkSNEntityType.OperatingArea.getCode()%>,
    buttonColor: 'var(--highlight-color)',
    redColor: 'var(--base-red-color)',
    greenColor: 'var(--base-green-color)',
    orangeColor: 'var(--base-orange-color)',
    grayColor: 'var(--base-gray-color)',
    blueColor: 'var(--base-blue-color)',
    purpleColor: 'var(--base-purple-color)',
    mediaNotFound: <%=LkSNValidateResult.MediaNotFound.getCode()%>,
    ticketStatusActive: <%=LkSNTicketStatus.Active.getCode()%>,
    ticketStatusGoodLimit: <%=LkSNTicketStatus.GoodTicketLimit%>,
    mediaLookupCommonStatus: {
      draft: <%=LkCommonStatus.Draft.getCode()%>,
      active: <%=LkCommonStatus.Active.getCode()%>,
      warn: <%=LkCommonStatus.Warn.getCode()%>,
      deleted: <%=LkCommonStatus.Deleted.getCode()%>,
      completed: <%=LkCommonStatus.Completed.getCode()%>,
      fatalError: <%=LkCommonStatus.FatalError.getCode()%>
    }
  };

  COMMON_JS.logo = (function() {
    var logo = '';

     <% if (profilePictureId == null) { %>
        logo = '<v:image-link name="snapp-icon-round.png" size="128"/>';
      <% } else { %>
        logo = '<v:config key="site_url"/>/repository?type=small&id=<%=profilePictureId%>';
      <% } %>

    return logo;
  })();

  COMMON_JS.initScanType = function() {
    var result = '';

    if (COMMON_JS.apt.AptEntryControl === COMMON_JS.accessPointControl.controlled) {
      result = COMMON_JS.setScanType('entry');
    } else if (COMMON_JS.apt.AptExitControl === COMMON_JS.accessPointControl.controlled) {
      result = COMMON_JS.setScanType('exit');
    } else if (COMMON_JS.apt.AptEntryControl === COMMON_JS.accessPointControl.free) {
      result = COMMON_JS.setScanType('simulate');
    } else {
      result = COMMON_JS.setScanType('lookup');
    }

    return result;
  };

  COMMON_JS.setScanType = function(scanType) {
			switch (scanType) {
				case 'entry':
					COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.controlled;
					COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.closed;
					break;
				case 'simulate':
					COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.free;
					COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.closed;
					break;
				case 'exit':
					COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.closed;
					COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.controlled;
					break;
				default:
					COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.closed;
					COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.closed;
					break;
			}

			return scanType;
	};

  COMMON_JS.mob_apps = [
      {
        key: COMMON_JS.mob_apps_keys.adm,
        icon: '<v:image-link name="mobgly-app-adm.png|TransformNegative" size="128"/>'
      },
      {
        key: COMMON_JS.mob_apps_keys.operator,
        icon: '<v:image-link name="mobgly-app-gst.png|TransformNegative" size="128"/>'
      },
      {
        key: COMMON_JS.mob_apps_keys.guest,
        icon: '<v:image-link name="mobgly-app-cas.png|TransformNegative" size="128"/>'
      },
      {
        key: COMMON_JS.mob_apps_keys.payment,
        icon: '<v:image-link name="mobgly-app-pay.png|TransformNegative" size="128"/>'
      }
  ];

</script>