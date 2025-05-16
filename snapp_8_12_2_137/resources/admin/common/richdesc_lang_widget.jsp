<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<jsp:useBean id="richdesc" class="com.vgs.web.dataobject.DOUI_RichDesc" scope="request" />
<% boolean canEdit = !pageBase.isParameter("readonly", "true"); %>

<script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>

<style>

#cke_editor1 {
  margin: 0px;
  padding: 0px;
  border-width: 0px;
  border-radius: 0px;
}

#cke_editor1 .cke_ltr {
  border-radius: 0px;
}

</style>

<v:page-form>
<v:input-text type="hidden" field="richdesc.RichDescId"/>
<v:input-text type="hidden" field="richdesc.EntityType"/>
<v:input-text type="hidden" field="richdesc.EntityId"/>
<v:input-text type="hidden" field="richdesc.LangISO"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" href="postaction:richdesc_lang_widget.save" enabled="<%=canEdit%>"/>
  <v:button caption="@Common.Remove" fa="minus" href="postaction:richdesc_lang_widget.remove:confirm" enabled="<%=canEdit%>"/>
</div>

<textarea id="editor1" name="richdesc.Description"><%=richdesc.Description.getEmptyString()%></textarea>
<script type="text/javascript">CKEDITOR.replace("editor1", {readOnly:<%=!canEdit%>});</script>

</v:page-form>