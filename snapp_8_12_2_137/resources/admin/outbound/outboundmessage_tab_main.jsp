<%@page import="java.util.AbstractMap.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOutboundMessage" scope="request"/>

<%!
private boolean isRecursiveNode(JvNode node, Class<?> match) {
  if (node == null)
    return false;
  else if (node.getClass() == match)
    return true;
  else
    return isRecursiveNode(node.getParentNode(), match);
}

private void recursiveFillFields(List<SimpleEntry<JvNode, Integer>> list, JvNode node, int indent) {
  list.add(new SimpleEntry<>(node, indent));
  
  if (!isRecursiveNode(node.getParentNode(), node.getClass())) {
    for (JvNode child : node.getChildNodes()) 
      recursiveFillFields(list, child, indent + 1);

    if (node instanceof FtList) {
      for (JvNode child : ((FtList<?>)node).add().getChildNodes()) 
        recursiveFillFields(list, child, indent + 1);
    }
  }
}
%>

<% 
OutboundMessageBase<?> obm = JvUtils.create(BOOutboundManager.getInstance().getMessageClass(pageBase.getId()));
JvDocument doc = JvUtils.create(obm.getDocClass());

List<SimpleEntry<JvNode, Integer>> list = new ArrayList<>();
recursiveFillFields(list, doc, 0);
%>

<style>

.field-indent {
  color: rgba(0,0,0,0.2);
}

.field-name {
  font-weight: bold;
}

.field-desc {
  font-style: italic;
}

</style>

<div class="tab-content">

<v:grid>
  <thead>
    <td>Field</td>
    <td>Type</td>
    <td width="100%">Description</td>
  </thead>
  <tbody>
  <% for (SimpleEntry<JvNode, Integer> entry : list) { %>
    <% 
    JvNode node = entry.getKey();
    int indent = entry.getValue();
    String nodeName = node.getNodeName();
    if (node instanceof FtList)
      nodeName = "[" + nodeName + "]";
    %>
    <tr class="grid-row">
      <td nowrap>
        <span class="field-indent">
          <% for (int i=0; i<indent; i++) { %>
            &mdash;
          <% } %>
        </span>
        <span class="field-name"><%=JvString.escapeHtml(nodeName)%></span>
      </td>
      <td nowrap>
        <span class="field-type">
        <% if (node instanceof JvFieldNode) { %>
          <%=JvString.escapeHtml(node.getClass().getSimpleName())%>
        <% } %>
        </span>
      </td>
      <td>
        <%
        String desc = JvString.escapeHtml(node.getAnnotation());
        if (node instanceof FtLookup) {
          int tableCode = ((FtLookup<?>)node).getLookupTable().getCode();
          String href = pageBase.getContextURL() + "?page=doc_lookup_list&LookupTable=" + tableCode;
          desc = "<a href='" + href + "' target='_new'>" + desc + "</a>";
        }
        %>
        <span class="field-desc"><%=desc%></span>
      </td>
    </tr>
  <% } %>
  </tbody>
</v:grid>

</div>