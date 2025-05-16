<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageSchemaTable"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="schema" class="com.vgs.snapp.dataobject.DOSchemaTable" scope="request"/>

<div class="tab-toolbar">
  <v:button id="btn-openschema" caption="ERD schema" fa="project-diagram"/>

  <% if (rights.SuperUser.getBoolean()) { %>
    <div class="btn-group">
      <v:button caption="@Common.Tools" dropdown="true" fa="tools"/>
      <v:popup-menu bootstrap="true">
        <v:popup-item id="menu-updatestats" caption="Update table statistics"/>
      </v:popup-menu>
    </div>
  <% } %>
</div>

<div class="tab-content">
  <div>
    <% if (schema.TableDescription.getNullString(true) != null) { %>
      <v:alert-box type="info"><%=schema.TableDescription.getHtmlString()%></v:alert-box>
    <% } %>
    
    <v:grid id="columns">
      <thead>
        <v:grid-title caption="Columns"/>
        <tr>
          <td width="3%"></td>
          <td width="18%">Field Name</td>
          <td width="10%">Data Type</td>
          <td width="8%" align="center">Mandatory</td>
          <td width="61%">Description</td>
        </tr>
      </thead>

      <tbody>
        <% for (DOSchemaTable.DOSchemaColumn column : schema.ColumnList) { %>
        <tr class="grid-row">
          <td width="3%">
            <span>
              <% if (column.PrimaryKey.getBoolean() && column.ForeignKey.getBoolean()) { %>
                PFK
              <% } else if(column.PrimaryKey.getBoolean()) { %>
                PK
              <% } else if(column.ForeignKey.getBoolean()) { %>
                FK
              <% } %>
            </span>
          </td>
          
          <td>
            <%=column.ColumnName.getHtmlString()%>
          </td>
          
          <%
          String type = "";
          if (column.ColumnType.isSameString("decimal"))
            type = "Decimal(" + column.DataLength.getInt() + ", " + column.Decimal;
          else if (column.ColumnType.isSameString("varchar"))
            type = "Varchar(" + column.DataLength.getInt() + ")";
          else if (column.ColumnType.isSameString("int"))
            type = "Integer"; 
          else if (column.ColumnType.isSameString("nvarchar")) 
            type = "Nvarchar(" + column.DataLength.getInt() + ")";
          else
            type = JvString.getSentenceCase(column.ColumnType.getEmptyString());
          %>
          <td><%=JvString.escapeHtml(type)%></td>
          
          <td align="center">
            <% if (column.Mandatory.getBoolean()) { %>
              <i class="fa fa-check"></i>
            <% } %>
          </td>
          
          <td>
          <% if (column.ColumnDescription.getEmptyString().contains("LK[") ) { %>
            <%
            String code = column.ColumnDescription.getString().substring(column.ColumnDescription.getString().indexOf("LK[")+3, column.ColumnDescription.getString().indexOf("]"));
            String lktag = "<a href=\""+pageBase.getContextURL()+"?page=doc_lookup_list&LookupTable="+code+"\" class=\"lk-tooltip-link v-tooltip\" data-LookupTable=\""+code+"\">LK["+code+"]</a>";
            String comment = column.ColumnDescription.getHtmlString().replace("LK["+code+"]", lktag);
            %>
            <%=comment%>
          <% } else { %>
            <div class="list-subtitle"><%=column.ColumnDescription.getHtmlString()%></div>
          <%} %>
          </td>
        </tr>
        <% } %>
      </tbody>
    </v:grid>
    
    <% if(schema.IndexList.getSize() > 0) { %>
      <v:grid id="index">
        <thead>
          <v:grid-title caption="Indexes"/>
          <tr>
            <td width="3%"></td>
            <td width="18%">Name</td>
            <td width="10%">Type</td>
            <td width="40%">Fields</td>
            <td width="11%">Stats last update</td>
            <td width="6%" align="right">Rows</td>
            <td width="6%" align="right">Frag.</td>
            <td width="6%" align="right">Size</td>
          </tr>
        </thead>
        
        <tbody>
        <% for (DOSchemaTable.DOSchemaIndex index : schema.IndexList) { %>
          <tr class="grid-row">
            <td></td>
            <td><%=index.IndexName.getHtmlString()%></td>
            <td><%=index.Unique.getHtmlString()%></td>
            <%
            String[] onfields = {};
            for (DOSchemaTable.DOSchemaIndex.DOSchemaIndexColumn idxcol : index.ColumnList) 
              onfields = JvArray.add(idxcol.ColumnName.getHtmlString() + " " + idxcol.Option.getHtmlString(), onfields);
            %>
            <td><%=JvArray.arrayToString(onfields, ", ")%></td>
            <td><snp:datetime timestamp="<%=index.StatsLastUpdate%>" timezone="local" format="shortdatetime"/> </td>
    
    
            <td align="right"><%=JvString.escapeHtml((new DecimalFormat("#,##0")).format(index.RowCount.getLong()))%></td>
            <td align="right" style="<%=(index.Fragmentation.getFloat()>25)?"color:red":""%>">
              <%=JvString.escapeHtml((new DecimalFormat("0.00")).format(index.Fragmentation.getFloat()))%>%
            </td>
            <td align="right"><%=JvString.getSmoothSize(index.SpaceUsed.getLong())%></td>
          </tr>
        <% } %>
        </tbody>
      </v:grid>
    <% } %>
    
    <% if (schema.ForeignKeyList.getSize() > 0) { %>
      <v:grid id="forkeys">
        <thead>
          <v:grid-title caption="Foreign keys"/>
        </thead>

        <tbody>
        <% for (DOSchemaTable.DOSchemaForeignKey foreignKey : schema.ForeignKeyList) { %>
          <tr class="grid-row">
            <td width="3%"></td>
            <td width="18%"><%=foreignKey.ForeignKeyName.getHtmlString()%></td>
            <td width="82%">
            <% for (DOSchemaTable.DOSchemaForeignKey.DOSchemaForeignKeyColumn fkcol : foreignKey.ColumnList) { %>
              <div>(<%=fkcol.ColumnName.getHtmlString()%>) ON ref <a href="admin?page=schematable&table=<%=foreignKey.ToTable.getHtmlString()%>"><%=foreignKey.ToTable.getHtmlString()%></a> ( <%=fkcol.PrimaryKey.getHtmlString()%> )</div>
            <% } %>
            </td>
          </tr>
        <% } %>
        </tbody>
      </v:grid>
    <% } %>
  </div>
</div>

<script>
$(document).ready(function() {
  var tableName = <%=JvString.jsString(request.getParameter("table"))%>;
  $("#btn-openschema").click(_openSchema);
  $("#menu-updatestats").click(_updateStats);

  function _openSchema() {
    var url = "admin?page=erdschema&table=" + tableName;
    window.open(url, "_blank");
  }

  function _updateStats() {
    confirmDialog(null, function() {
      snpAPI.cmd("SYSTEM", "UpdateTableStatistics", {TableNames: tableName});
    });
  }
});
</script>

<jsp:include page="/resources/common/footer.jsp"/>