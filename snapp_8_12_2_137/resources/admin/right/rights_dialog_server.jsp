<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rightsEnt" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsDef" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsUI" class="com.vgs.snapp.dataobject.DORightDialogUI" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<rgt:menu>
  <rgt:menu-divider/>
  <rgt:menu-item contentId="rights-menu-params"     fa="cog"     color="gray"  caption="@Common.Parameters"/>
</rgt:menu>


<rgt:menu-body>
  <rgt:menu-content id="rights-menu-params">
    <rgt:section caption="@Common.Modules">
      <rgt:bool rightType="<%=LkSNRightType.SRV_ModuleBKO%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SRV_ModuleB2B%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SRV_ModuleCLC%>"/>
    </rgt:section>

    <rgt:section caption="@Common.Services">
      <rgt:bool rightType="<%=LkSNRightType.SRV_RestrictServices%>"/>
      <rgt:multi rightType="<%=LkSNRightType.SRV_EnabledServices%>"/>
    </rgt:section>

    <rgt:section>
      <rgt:text rightType="<%=LkSNRightType.SRV_OutboundQueuePoolSize%>"/>
      <rgt:text rightType="<%=LkSNRightType.SRV_OutboundRetryMinutes%>"/>
      <rgt:text rightType="<%=LkSNRightType.SRV_OutboundDataSourceTimeoutSecs%>"/>
    </rgt:section>

    <rgt:section>
      <rgt:text rightType="<%=LkSNRightType.SRV_AsyncFinalizePoolSize%>"/>
      <rgt:bool rightType="<%=LkSNRightType.SRV_AsyncFinalizeCheckDB%>"/>
    </rgt:section>
  </rgt:menu-content>
  
</rgt:menu-body>
