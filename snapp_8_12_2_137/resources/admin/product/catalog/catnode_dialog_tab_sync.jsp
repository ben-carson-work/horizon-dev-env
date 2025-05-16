<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="node" class="com.vgs.snapp.dataobject.DOCatalog" scope="request"/>

<% List<LookupItem> items = LookupManager.getArray(LkSNEntityType.ProductType, LkSNEntityType.ProductFamily, LkSNEntityType.Event); %>

<style>
.entity-tbody tr.tag-rule {
  display: none;
}
.entity-tbody.show-detail tr.tag-rule {
  display: table-row;
}

.sync-entity-add {
  float: right;
  display: none;
}
.entity-tbody.show-detail tr.group:hover .sync-entity-add {
  display: inline;
}

.btn-del-tag-rule {
  display: inline-block;
  width: 20px;
  height: 20px;
  cursor: pointer;
  opacity: 0.4;
}
.btn-del-tag-rule:hover {
  opacity: 1;
}
</style>

<div class="v-hidden">
<% for (LookupItem item : items) { %>
  <% JvDataSet ds = pageBase.getBL(BLBO_Tag.class).getTagDS(item); %>  
  <% String field = "tag-template-" + item.getCode(); %>
  <v:combobox field="<%=field%>" lookupDataSet="<%=ds%>" idFieldName="TagId" captionFieldName="TagName"/>
<% } %>
</div>

<div class="tab-content">

  <div style="margin-bottom:10px"><v:db-checkbox field="node.AutoSynchronize" caption="@Catalog.AutoSynchronize" value="true"/></div>

  <v:grid>
    <thead>
      <v:grid-title caption="Rules"/>
    </thead>
    <% for (LookupItem item : items) { %>
      <tbody class="entity-tbody" data-EntityType="<%=item.getCode()%>">
        <tr class="group">
          <td colspan="100%">
            <v:db-checkbox caption="<%=item.getRawDescription()%>" value="<%=item.getCode()%>" field="TagRuleEntityType" onclick="tagRuleEntityType_Click(this)"/>
            <span class="sync-entity-add"><a href="javascript:tagRuleAddLine(<%=item.getCode()%>)"><v:itl key="@Common.Add"/></a></span>
          </td>
        </tr>
      </tbody>
    <% } %>
  </v:grid>
</div>

<script>
function tagRuleEntityType_Click(cb) {
  var entityType = $(cb).val();
  var tbody = $(".entity-tbody[data-EntityType='" + entityType + "']");
  tbody.setClass("show-detail", $(cb).isChecked());
  
  if ($(cb).isChecked()) {
    if (tbody.find("tr.tag-rule").length == 0) 
      tagRuleAddLine(entityType);
  }
}

function tagRuleAddLine(entityType) {
  var tbody = $(".entity-tbody[data-EntityType='" + entityType + "']");
  var tr = $("<tr class='tag-rule'/>").appendTo(tbody);
  var tbInc = $("<td width='25%'><select class='rule-include form-control'><option value='1'/><option value='0'/></select></td>").appendTo(tr);
  var tbTag = $("<td width='75%'/>").appendTo(tr);
  var tbDel = $("<td><span class='btn-del-tag-rule fa fa-lg fa-trash row-hover-visible'/></td>").appendTo(tr);
  
  tbInc.find("option[value='1']").text(<v:itl key="@Catalog.TagRuleInclude" encode="JS"/>);
  tbInc.find("option[value='0']").text(<v:itl key="@Catalog.TagRuleExclude" encode="JS"/>);
  
  var mbox = $("<select class='rule-tags' multiple/>").appendTo(tbTag);
  mbox.html($("#tag-template-" + entityType).html());
  mbox.selectize({
    dropdownParent: "body",
    plugins: ['remove_button','drag_drop']
  });
  
  tbDel.find(".btn-del-tag-rule").click(function() {
    tr.remove();
  });
  
  return tr;
}

function getSyncRuleList() {
  var result = [];
  $(".entity-tbody.show-detail").each(function(idx, tbody) {
    var entityType = parseInt($(tbody).attr("data-EntityType"));
    $(tbody).find("tr.tag-rule").each(function(idx, tr) {
      result.push({
        EntityType: entityType,
        RuleInclude: ($(tr).find(".rule-include").val() == "1") ? true : false,
        TagIDs: $(tr).find(".rule-tags").getStringArray()
      });
    });
  });
  return result;
}

<% 
JvDataSet dsRule = pageBase.getDB().executeQuery("select EntityType, CatalogRuleLine, RuleInclude, TagId from tbCatalogRule where CatalogId=" + JvString.sqlStr(pageBase.getId()));
while (!dsRule.isEof()) {
  int entityType = dsRule.getField("EntityType").getInt();
  int line = dsRule.getField("CatalogRuleLine").getInt();
  boolean include = dsRule.getField("RuleInclude").getBoolean();
  String tagId = dsRule.getField("TagId").getString();    
  %>
  
  var tbody = $(".entity-tbody[data-EntityType='<%=entityType%>']");
  tbody.addClass("show-detail");
  tbody.find("[name='TagRuleEntityType']").setChecked(true);
  
  var tr = tbody.find("tr.tag-rule[data-RuleLine=<%=line%>]");
  if (tr.length == 0) {
    tr = tagRuleAddLine(<%=entityType%>);
    tr.attr("data-RuleLine", <%=line%>);
    tr.find(".rule-include").val(<%=include%> ? 1 : 0);
  }
  tr.find(".rule-tags")[0].selectize.addItem(<%=JvString.jsString(tagId)%>);
  
  <%
  dsRule.next();
}
%>

</script>