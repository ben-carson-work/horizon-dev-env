<%@page import="com.vgs.web.library.BLBO_Event"%>
<%@page import="com.vgs.snapp.dataobject.DOResourceConfigRes"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>

<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate(); 
String sReadOnly = canEdit ? "" : " readonly=\"readonly\""; 
%>

<div class="tab-toolbar">
  <v:button id="btn-save" caption="@Common.Save" fa="save" enabled="<%=canEdit%>"/>
  <v:button id="btn-del" caption="@Common.Delete" fa="times" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <% String stepHint = pageBase.getLang().Common.TimeStepHint.getText() ; %>
      <v:form-field caption="@Resource.TimeUnit" hint="@Common.TimeStepHint">
        <v:input-text type="hidden" field="product.PriceStepValue"/>
        <v:input-text type="hidden" field="product.PriceStepType"/>
        <input type="text" id="PriceStep" class="form-control" title="<%=stepHint%>" <%=sReadOnly%>/>
      </v:form-field>
      <v:form-field caption="@Resource.MinimumUnits">
        <v:input-text field="product.MinStepQuantity" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Resource.DefaultUnits">
        <v:input-text field="product.DefaultStepQuantity" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Resource.TimeRounding">
        <v:lk-combobox field="product.TimeRounding" lookup="<%=LkSN.ResourceTimeRounding%>" allowNull="true" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Resource.CreatePerformance" hint="@Resource.CreatePerformanceHint">
        <v:combobox field="product.CreateEventId" lookupDataSet="<%=pageBase.getBL(BLBO_Event.class).getEventDS()%>" captionFieldName="EventName" idFieldName="EventId" allowNull="true" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox caption="@Resource.ResourceEndOfDay" value="true" field="product.ResourceEndOfDay"/>
    </v:widget-block>
  </v:widget>

	<v:grid id="resource-type-grid">
	  <thead>
	    <tr>
	      <td><v:grid-checkbox header="true"/></td>
	      <td width="20%">
	        <v:itl key="@Resource.ResourceType"/>
	      </td>
	      <td width="10%">
	        <v:itl key="@Common.Quantity"/>
	      </td>
	      <td width="35%">
	        <br/>
	        <v:itl key="@Common.Options"/>
	      </td>
	      <td width="35%">
	        <v:itl key="@Resource.Skills"/>
	      </td>
	    </tr>
	  </thead>
	  <tbody id="resource-type-tbody">
	  </tbody>
	  <tbody>
	    <tr>
	      <td colspan="100%">
	      <v:button id="btn-rt-add" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/>
	      <v:button id="btn-rt-del" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
	      </td>
	    </tr>
	  </tbody>
	</v:grid>
	
	<table id="resource-type-grid-template" class="hidden">
	  <tr>
	    <td><input name="ResourceTypeId" type="checkbox" class="cblist"></td>
	    <td>
	      <span class="list-title rt-name"></span>
	      <br/>
	      <span class="list-subtitle rt-code"></span>
	    </td>
	    <td><input type="text" class="form-control txt-quantity" <%=canEdit==true ? "" : "disabled"%>/></td>
	    <td>
	      <label class="checkbox-label"><input type="checkbox" name="cb-mandatory" value="true" <%=canEdit==true ? "" : "disabled"%>/>&nbsp;<v:itl key="@Common.Mandatory"/></label>
	      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	      <label class="checkbox-label"><input type="checkbox" name="cb-main" value="true" <%=canEdit==true ? "" : "disabled"%>/>&nbsp;<v:itl key="@Common.Main"/></label>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <label class="checkbox-label"><input type="checkbox" name="cb-auto" value="true" <%=canEdit==true ? "" : "disabled"%>/>&nbsp;<v:itl key="@Resource.AutoSelect"/></label>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <label class="checkbox-label"><input type="checkbox" name="cb-group" value="true" <%=canEdit==true ? "" : "disabled"%>/>&nbsp;<v:itl key="@Resource.GroupByPerformance"/></label>
	    </td> 
	    <td class="td-skills"></td>
	  </tr>
	</table>
</div>


<script>

$(document).ready(function() {
  var dsSkill = <%=pageBase.getDB().executeQuery("select * from tbResourceSkill order by PriorityOrder").getDocJSON()%>;
  
  decodeStepType("#PriceStep", "#product\\.PriceStepValue", "#product\\.PriceStepType");
  $("#btn-save").click(doSave);
  $("#btn-del").click(doDelete);

  $("#btn-rt-add").click(function() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.ResourceType.getCode()%>,
      onPickup: function(item) {
        doAddResourceType({
          ResourceTypeId: item.ItemId,
          ResourceTypeCode: item.ItemCode,
          ResourceTypeName: item.ItemName
        });
      }
    });
  });

  $("#btn-rt-del").click(function() {
    $("#resource-type-tbody .cblist:checked").closest("tr").remove();
  });
  
  <% for (DOResourceConfigRes rc : product.ResourceConfigList) {%>
    doAddResourceType(<%=rc.getJSONString()%>);
  <% } %>
  
  function doAddResourceType(item) {
    item = (item) ? item : {};
    var $tr = $("#resource-type-grid-template tr").clone().appendTo("#resource-type-tbody");

    $tr.find(".cblist").attr("value", item.ResourceTypeId);
    $tr.find(".rt-name").text(item.ResourceTypeName);
    $tr.find(".rt-code").text(item.ResourceTypeCode);
    $tr.find(".txt-quantity").val((item.Quantity) ? item.Quantity : "1");
    $tr.find("[name='cb-mandatory']").setChecked(item.Mandatory);
    $tr.find("[name='cb-main']").setChecked(item.Main);
    $tr.find("[name='cb-auto']").setChecked(item.AutoSelect);
    $tr.find("[name='cb-group']").setChecked(item.GroupByPerformance);
    
    
    var $tdSkills = $tr.find(".td-skills");
    for (var i=0; i<dsSkill.length; i++) {
      var skill = dsSkill[i];
      if (skill.ResourceTypeId == item.ResourceTypeId) {
        var $label = $("<label class='checkbox-label'><input type='checkbox' name='cb-skill'/>&nbsp;<span/></label>").appendTo($tdSkills);
        $label.find("input").val(skill.ResourceSkillId);
        if ((item.ResourceSkillIDs) && (item.ResourceSkillIDs.indexOf(skill.ResourceSkillId) >= 0))
          $label.find("input").setChecked(true);
        $label.find("span").text(skill.ResourceSkillName);
        $tdSkills.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
      }
    }
  }

  function encodeStepType(src, dstValue, dstType) {
    var srcValue = $(src).val();
    if ((srcValue) && (srcValue != "")) {
      var lastChar = srcValue[srcValue.length-1].toLowerCase();
      var type = <%=LkSNResourceStepType.Hour.getCode()%>;
      if (lastChar == "d")
        type = <%=LkSNResourceStepType.Day.getCode()%>;
      if (lastChar == "m")
        type = <%=LkSNResourceStepType.Minute.getCode()%>;
      if (isNaN(parseInt(lastChar)))
        srcValue = srcValue.substring(0, srcValue.length-1);

      var value = parseInt(srcValue);
      if (isNaN(value)) 
        showMessage("Invalid step type: '" + $(src).val() + "'");
      else {
        $(dstValue).val(value);
        $(dstType).val(type);
      }
    }
  }

  function decodeStepType(src, dstValue, dstType) {
    if ($(src).length > 0) {
      if (($(dstType).val() == "") || ($(dstValue).val() == ""))
        $(src).val("");
      else {
        var type = "h";
        if ($(dstType).val() == "<%=LkSNResourceStepType.Day.getCode()%>")
          type = "d";
        if ($(dstType).val() == "<%=LkSNResourceStepType.Minute.getCode()%>")
          type = "m";
        $(src).val($(dstValue).val() + type);
      }
    }
  }      

  function doSave() {
    encodeStepType("#PriceStep", "#product\\.PriceStepValue", "#product\\.PriceStepType");
    
    var reqDO = {
      Command: "SaveProduct",
      SaveProduct: {
        Product: {
          ProductId: <%=product.ProductId.getJsString()%>,
          PriceStepValue: $("[name='product\\.PriceStepValue']").val(), 
          PriceStepType: $("[name='product\\.PriceStepType']").val(),
          DefaultStepQuantity: $("[name='product\\.DefaultStepQuantity']").val(),
          MinStepQuantity: $("[name='product\\.MinStepQuantity']").val(),
          TimeRounding: $("[name='product\\.TimeRounding']").val(),
          ResourceEndOfDay: $("[name='product\\.ResourceEndOfDay']").isChecked(),
          CreateEventId: $("[name='product\\.CreateEventId']").val(), 
          ResourceConfigList: []
        }
      }
    };
    
    $("#resource-type-tbody tr").each(function(idx, item) {
      $tr = $(item);
      reqDO.SaveProduct.Product.ResourceConfigList.push({
        ResourceTypeId: $tr.find(".cblist").val(),
        Quantity: $tr.find(".txt-quantity").val(),
        Mandatory: $tr.find("[name='cb-mandatory']").isChecked(),
        Main: $tr.find("[name='cb-main']").isChecked(),
        AutoSelect: $tr.find("[name='cb-auto']").isChecked(),
        GroupByPerformance: $tr.find("[name='cb-group']").isChecked(),
        ResourceSkillIDs: $tr.find("[name='cb-skill']").getCheckedValues()
      });
    });

    showWaitGlass();
    vgsService("Product", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.Answer.SaveProduct.ProductId, "tab=resconfig");
    });
  }
  
  function doDelete() {
    confirmDialog(<v:itl key="@Resource.RemoveConfirmMsg" encode="JS"/>, function() {
      var reqDO = {
        Command: "SaveProduct",
        SaveProduct: {
          Product: {
            ProductId: <%=product.ProductId.getJsString()%>,
            ResourceConfigList: []
          }
        }
      };
      
      showWaitGlass();
      vgsService("Product", reqDO, false, function() {
        window.location = getPageURL(<%=LkSNEntityType.ProductType.getCode()%>, <%=product.ProductId.getJsString()%>) 
      });
    });
  }
});

</script>

