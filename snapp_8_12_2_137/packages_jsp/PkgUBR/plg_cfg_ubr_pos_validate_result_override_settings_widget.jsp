<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.cl.JvDocUtils"%>
<%@page import="org.w3c.dom.Element"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="@Common.Translations">
	<div class="tab-content">
	  <v:grid id="validate-result-grid" style="margin-bottom:10px">
	    <thead>
	      <tr>
	        <td width="16%">
	          <v:itl key="Validate result"/><br/>
	          <v:itl key="Function closed"/>
	        </td>
	        <td width="19%"><v:itl key="Layout ID"/></td>
	        <td width="7%"><v:itl key="Sound field"/></td>
	        <td width="18%"><v:itl key="Light sequence type"/></td>
	        <td width="20%"><v:itl key="EN"/></td>
	        <td width="20%"><v:itl key="ZH"/></td>  
	      </tr>
	    </thead>
	    <tbody id="validate-result-body">
	    <% for (LookupItem lkItem : LkSN.ValidateResult.getItems()) { %>
	    <%   boolean goodRes = lkItem.getCode() < LkSNValidateResult.GoodTicketLimit.getCode(); %>
	      <% if (!lkItem.isLookup(LkSNValidateResult.OK_AlreadyExitDeprecated)) { %>   
		      
		      
		      <% if (lkItem.isLookup(LkSNValidateResult.InactiveTicket)) { %> 
		      <%   for (LookupItem lkTckStatusItem : LkSN.TicketStatus.getItems()) { %>
		      <%     boolean validTckStatus = (
		                                        (lkTckStatusItem.getCode() > LkSNTicketStatus.VoidLimitStart) && 
		                                        (lkTckStatusItem.getCode() < LkSNTicketStatus.VoidLimitEnd)
		                                      ) ||
		                                      (
		                                        (lkTckStatusItem.getCode() > LkSNTicketStatus.Active.getCode()) && 
		                                        (lkTckStatusItem.getCode() < LkSNTicketStatus.GoodTicketLimit)
		                                      ); %>

		      <%     if (validTckStatus) { %>
					        <tr class="grid-row" data-code="<%=lkItem.getCode()%>" data-tck-status="<%=lkTckStatusItem.getCode()%>">
				            <td>[<%=lkItem.getCode()%>][<%=lkTckStatusItem.getCode()%>] <%=JvString.jsString(lkTckStatusItem.getHtmlDescription())%></td>
				            <td>
				              <input type="text" name="LayoutId" class="form-control">
				            </td>
				            <td>
				              <input type="text" name="SoundField" class="form-control">
				            </td>
				            <td>
				              <v:lk-combobox lookup="<%=LkSN.TurnstileLightType%>" field="LightSeq" allowNull="false"/>
				            </td>
				            <td>
				              <textarea name="EN" class="form-control"></textarea>
				            </td>
				            <td>
				              <textarea name="ZH" class="form-control"></textarea>
				            </td>
				          </tr>
	        <%     } %>
		      <%   } %>         
		      <% } else { %>       
			      <tr class="grid-row" data-code="<%=lkItem.getCode()%>">
				      <td>[<%=lkItem.getCode()%>] <%=JvString.jsString(lkItem.getHtmlDescription())%></td>
						  <td>
						    <input type="text" name="LayoutId" class="form-control">
						    <% if (goodRes) { %>
						      <br/><input type="text" name="LayoutIdFC" class="form-control">
						    <% } %>
						  </td>
						  <td>
						    <input type="text" name="SoundField" class="form-control">
						    <% if (goodRes) { %>
						      <br/><input type="text" name="SoundFieldFC" class="form-control">
						    <% } %>
						  </td>
						  <td>
						    <v:lk-combobox lookup="<%=LkSN.TurnstileLightType%>" field="LightSeq" allowNull="false"/>
						    <% if (goodRes) { %>
						      <br/><v:lk-combobox lookup="<%=LkSN.TurnstileLightType%>" field="LightSeqFC" allowNull="false"/>
						    <% } %>
						  </td>
						  <td>
						    <textarea name="EN" class="form-control"></textarea>
						  </td>
						  <td>
						    <textarea name="ZH" class="form-control"></textarea>
						  </td>
			      </tr>
		      <% } %>
	      <% } %>
	    <% } %>
	    </tbody>
	  </v:grid>
	</div>
</v:widget>

<script>



$(document).ready(function() {
  var settings = <%=settings.getJSONString()%>; 
  
  $.each(settings.ValidateResultItemList, function(key, value) {
	  var $tr = null;
	  if (value.ValidateResult == <%=LkSNValidateResult.InactiveTicket.getCode()%>)
		  $tr=$("#validate-result-body").find("tr[data-tck-status='" + value.TicketStatus + "']");
	  else  
      $tr=$("#validate-result-body").find("tr[data-code='" + value.ValidateResult + "']");
    $tr.find("input[name='LayoutId']").val(value.LayoutId);
    $tr.find("input[name='SoundField']").val(value.SoundField);
    $tr.find("input[name='LightSeq']").val(value.LightSeq);
    $tr.find("textarea[name='EN']").val(value.English);
    $tr.find("textarea[name='ZH']").val(value.Chinese);
    var $select = $tr.find("select[name='LightSeq']");
    $($select).find("option").each(function(i){
      if ($(this).val() == value.LightSeq)
        $(this).attr("selected","selected");
    });
    
    if (value.ValidateResult < <%=LkSNValidateResult.GoodTicketLimit.getCode()%>) {
	    $tr.find("input[name='LayoutIdFC']").val(value.LayoutIdFC);
	    $tr.find("input[name='SoundFieldFC']").val(value.SoundFieldFC);
	    $tr.find("input[name='LightSeqFC']").val(value.LightSeqFC);
	    var $selectFC = $tr.find("select[name='LightSeqFC']");
	    $($selectFC).find("option").each(function(i){
	      if ($(this).val() == value.LightSeqFC)
	        $(this).attr("selected","selected");
	    });
    }
  });
  
});

function prepareItem($source, itemCode, tckStatus) {
	var goodLimit = itemCode < <%=LkSNValidateResult.GoodTicketLimit.getCode()%>;
	
	var item = {};
  item.ValidateResult = itemCode;
  item.TicketStatus = tckStatus;
  item.LayoutId =$source.find("input[name='LayoutId']").val();
  item.SoundField = $source.find("input[name='SoundField']").val();
  item.LightSeq = $source.find("select[name='LightSeq']").val();
  item.English = $source.find("textarea[name='EN']").val();
  item.Chinese = $source.find("textarea[name='ZH']").val();
  item.LayoutIdFC = goodLimit ? $source.find("input[name='LayoutIdFC']").val() : null;
  item.SoundFieldFC = goodLimit ? $source.find("input[name='SoundFieldFC']").val() : null;
  item.LightSeqFC = goodLimit ? $source.find("select[name='LightSeqFC']").val() : null;
  
	return item;
}

function getPluginSettings() {
  var settings = {};
  settings.ValidateResultItemList = [];
  <% for (LookupItem lkItem : LkSN.ValidateResult.getItems()) { %>
    <% if (!lkItem.isLookup(LkSNValidateResult.OK_AlreadyExitDeprecated)) { %>    
      <% if (lkItem.isLookup(LkSNValidateResult.InactiveTicket)) { %>
      <%   for (LookupItem lkTckStatusItem : LkSN.TicketStatus.getItems()) { %>
      <%     boolean validTckStatus = (
                                        (lkTckStatusItem.getCode() > LkSNTicketStatus.VoidLimitStart) && 
                                        (lkTckStatusItem.getCode() < LkSNTicketStatus.VoidLimitEnd)
                                      ) ||
                                      (
                                        (lkTckStatusItem.getCode() > LkSNTicketStatus.Active.getCode()) && 
                                        (lkTckStatusItem.getCode() < LkSNTicketStatus.GoodTicketLimit)
                                      ); %>
      <%     if (validTckStatus) { %>
               var $tr=$("#validate-result-body").find("tr[data-tck-status='" + <%=lkTckStatusItem.getCode()%> + "']");
               settings.ValidateResultItemList.push(prepareItem($tr, <%=lkItem.getCode()%>, <%=lkTckStatusItem.getCode()%>));
      <%     } %>                          
      <%   } %>
      <% } else { %>
            var $tr=$("#validate-result-body").find("tr[data-code='" + <%=lkItem.getCode()%> + "']");
			      settings.ValidateResultItemList.push(prepareItem($tr, <%=lkItem.getCode()%>, null));
	    <% } %>
    <% } %>
  <% } %>
  return settings;
}

</script>