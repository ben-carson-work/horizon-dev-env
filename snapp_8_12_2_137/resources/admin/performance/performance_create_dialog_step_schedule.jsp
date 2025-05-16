<%@page import="java.util.Calendar"%>
<%@page import="com.ibm.icu.text.DateFormatSymbols"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
int defaultDuration = pageBase.getDB().getInt("select Coalesce(DefaultPerformanceDuration, 30) from tbEvent where EventId=" + JvString.sqlStr(pageBase.getNullParameter("EventId")));
%>

<v:wizard-step id="performance-create-wizard-step-schedule" title="@Performance.Schedule">

  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Common.FromDate">
        <v:input-text type="datepicker" field="DateFrom"/>
      </v:form-field>
      <v:form-field caption="@Common.ToDate">
        <v:input-text type="datepicker" field="DateTo"/>
      </v:form-field>
      <v:form-field caption="@Common.Description">
        <v:input-text field="PerformanceName"/>
      </v:form-field>
      <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.Performance.getCode() + ",'TagIDs')"; %>
      <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Performance); %>
        <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
      </v:form-field>
      <v:form-field>
        <div><v:db-checkbox field="AllowOverlapping" value="true" caption="@Performance.AllowOverlapping"/></div>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <div style="overflow:auto">
    <v:grid id="day-of-week">
      <thead>
        <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td width="100%"><v:itl key="@Common.DayOfWeek"/></td>
        </tr>
      </thead>
      <tbody>
      <% String[] weekdays = DateFormatSymbols.getInstance(pageBase.getLocale()).getWeekdays(); %>
      <% int start = Calendar.getInstance(pageBase.getLocale()).getFirstDayOfWeek(); %>
      <% for (int i=start; i<start+7; i++) { %>
        <%   int value = ((i-1)%7)+1; %>
        <%   String dow = weekdays[value]; %>
        <tr>
          <td><v:grid-checkbox name="weekdays" value="<%=String.valueOf(value)%>"/></td>
          <td><%=JvString.escapeHtml(JvString.getPascalCase(dow))%></td>
        </tr>
      <% } %>
      </tbody>
    </v:grid>
    <script>
      $("#day-of-week .cblist").attr("checked", true);
    </script>
  
    <div id="group-box-add" style="margin-left:160px">
      <v:widget>
        <v:widget-block>
          <label class="checkbox-label"><input type="radio" id="radio-add-time" name="add-type" checked="checked"> <v:itl key="@Performance.AddTime"/></label> &nbsp;
          <label class="checkbox-label"><input type="radio" id="radio-add-interval" name="add-type" > <v:itl key="@Performance.AddInterval"/></label>
          <br/>&nbsp;<br/>
          <div id="add-time">
            <v:form-field caption="@Performance.StartTime">
              <input type="text" name="Fixed_StartTime_HH" class="next2 numonly enteradd form-control" maxlength="2" placeholder="HH" style="width:60px">
              <input type="text" name="Fixed_StartTime_MM" class="next2 numonly blur0 enteradd form-control" maxlength="2" placeholder="MM" style="width:60px">
            </v:form-field>
            <v:form-field caption="@Performance.Duration">
              <input type="text" name="Fixed_Duration" class="numonly enteradd form-control" value="<%=defaultDuration%>" style="width:60px">
              <select name="Fixed_Duration_UM" class="enteradd form-control" style="width:100px">
                <option value="MM"><v:itl key="@Performance.Minutes"/></option>
                <option value="HH"><v:itl key="@Performance.Hours"/></option>
              </select>
            </v:form-field>
          </div>
          <div id="add-interval" class="v-hidden">
            <v:form-field caption="@Common.FromTime">
              <input type="text" name="Interval_FromTime_HH" class="next2 numonly enteradd form-control" maxlength="2" placeholder="HH" style="width:60px">
              <input type="text" name="Interval_FromTime_MM" class="next2 numonly blur0 enteradd form-control" maxlength="2" placeholder="MM" style="width:60px">
            </v:form-field>
            <v:form-field caption="@Common.ToTime">
              <input type="text" name="Interval_ToTime_HH" class="next2 numonly enteradd form-control" maxlength="2" placeholder="HH" style="width:60px">
              <input type="text" name="Interval_ToTime_MM" class="next2 numonly blur0 enteradd form-control" maxlength="2" placeholder="MM" style="width:60px">
            </v:form-field>
            <v:form-field caption="@Performance.Interval">
              <input type="text" name="Interval_Interval" class="numonly enteradd form-control" value="<%=defaultDuration%>" style="width:60px">
              <select name="Interval_Interval_UM" class="enteradd form-control" style="width:100px">
                <option value="MM"><v:itl key="@Performance.Minutes"/></option>
                <option value="HH"><v:itl key="@Performance.Hours"/></option>
              </select>
            </v:form-field>
            <v:form-field caption="@Performance.Duration">
              <input type="text" name="Interval_Duration" class="numonly form-control" value="<%=defaultDuration%>" style="width:60px">
              <select name="Interval_Duration_UM" class="form-control" style="width:100px">
                <option value="MM"><v:itl key="@Performance.Minutes"/></option>
                <option value="HH"><v:itl key="@Performance.Hours"/></option>
              </select>
            </v:form-field>
          </div>
          &nbsp;<br/>
          <v:button id="btn-addtime" caption="@Common.Add" fa="plus"/>
        </v:widget-block>
      </v:widget>
    </div>
  </div>
  <div id="TimeList" style="overflow:hidden"></div>


<style>

#day-of-week {
  float: left;
  width: 150px;
}

#TimeList {
  margin-top: 10px;
}

.PerfTime {
  float: left;
  background-color: var(--highlight-color);
  padding: 5px 10px;
  margin: 0px 0px 4px 4px;
  border-radius: 3px;
  position: relative;
  cursor: default;
}

.PerfTime .perf-time-icon {
  color: rgba(0,0,0,0.5);
  margin-right: 4px;
}

.PerfTime .remove-btn {
  visibility: hidden;
  position: absolute;
  top: 6px;
  right: 4px;
  cursor: pointer;
  color: var(--base-red-color);
  font-size: 16px;
  text-shadow: 0 0 10px white;
}

.PerfTime:hover .remove-btn {
  visibility: visible;
}

#day-of-week td, tr {
  margin: 0px;
  padding: 4px 6px;
}

#day-of-week tbody td {
  border: 0;
}
#day-of-week tbody tr:last-child td {
  border-bottom: 1px #dfdfdf solid;
}

#add-time .form-field-caption,
#add-interval .form-field-caption {
  width: 33%;
}
#add-time .form-field-value,
#add-interval .form-field-value {
  margin-left: 33%;
}

</style>


<script>

$(document).ready(function() {
  const $step = $("#performance-create-wizard-step-schedule");
  const $wizard = $step.closest(".wizard");
  const $dtFrom = $step.find("#DateFrom-picker").datepicker("setDate", new Date());
  const $dtTo = $step.find("#DateTo-picker").datepicker("setDate", new Date());

  $step.vWizard("step-validate", _stepValidate);
  $step.vWizard("step-filldata", _stepFillData);
  $step.find("#btn-addtime").click(_addTime);

  $dtFrom.change(function() {
    var xmlFrom = $dtFrom.getXMLDate();
    var xmlTo = $dtTo.getXMLDate();
    if (xmlFrom > xmlTo)
      $dtTo.datepicker("setDate", $dtFrom.datepicker("getDate"));
  });

  $dtTo.change(function() {
    var xmlFrom = $dtFrom.getXMLDate();
    var xmlTo = $dtTo.getXMLDate();
    if (xmlFrom > xmlTo)
      $dtFrom.datepicker("setDate", $dtTo.datepicker("getDate"));
  });
  
  $step.find("[name='add-type']").change(function() {
    setVisible("#add-time", _isFixedRadio());
    setVisible("#add-interval", !_isFixedRadio());
    if (_isFixedRadio())
      $step.find("[name='Fixed_StartTime_HH']").focus();
    else
      $step.find("[name='Interval_FromTime_HH']").focus();
  });
  
  $step.find(".next2").keyup(function() {
    var value = $(this).val();
    if (value.length == 2) 
      focusNextEdit(this);
  });
  
  $step.find(".blur0").blur(function() {
    if ($(this).val() == "")
      $(this).val("00");
  });
  
  $step.find(".numonly").keydown(function(e) {
    var allowed = (e.keyCode>=KEY_0 && e.keyCode<=KEY_9) || (e.keyCode>=KEY_NUM_0 && e.keyCode<=KEY_NUM_9) || $.inArray(e.keyCode, [KEY_ENTER, KEY_ESC, KEY_TAB, KEY_BACKSPACE, KEY_DELETE]);
    if (!allowed)
      e.preventDefault();
  });
  
  $step.find(".enteradd").keydown(function(e) {
    if (e.keyCode == KEY_ENTER)
      _addTime();
  });
  
  function _stepValidate(callback) {
    if ($step.find("#TimeList .PerfTime").length <= 0)
      showMessage(itl("@Performance.NoTimesError"));
    else
      callback();
  }
  
  function _isFixedRadio() {
    return $step.find("#radio-add-time").isChecked();
  }
  
  function _removeTime() {
    if ((event.ctrlKey) || (event.shiftKey))
      $step.find(".PerfTime").remove();
    else
      $(this).closest(".PerfTime").remove();
  }
  
  function _encodeTime(hh, mm) {
    var result = new Date();
    result.setHours(hh);
    result.setMinutes(mm);
    result.setSeconds(0);
    result.setMilliseconds(0);
    return result;
  }
  
  function _addSingleTime(time, duration, duration_um) {
    var hh = time.getHours().toString();
    while (hh.length < 2)
      hh = "0" + hh;
    var mm = time.getMinutes().toString();
    while (mm.length < 2)
      mm = "0" + mm;
    var caption = hh + ":" + mm + " (" + duration + " " + duration_um.charAt(0) + ".)";
    
    var div = $("<div class='PerfTime'/>").appendTo("#TimeList");
    div.append("<i class='perf-time-icon fa fa-calendar'></i>")
    div.append(caption);
    
    var $remove = $("<i class='remove-btn fa fa-times-circle'></i>").appendTo(div);
    $remove.attr("title", itl("@Common.Remove"));
    $remove.click(_removeTime);
    
    div.data("time", {
      Time: ("0000-00-00T" + hh + ":" + mm + ":00"),
      Duration: (duration_um.charAt(0) == "M") ? duration : duration * 60
    });
  }
  
  function _addTime() {
    if (_isFixedRadio()) {
      var hh = $("[name='Fixed_StartTime_HH']");
      var mm = $("[name='Fixed_StartTime_MM']");
      var dur = $("[name='Fixed_Duration']");
      var um = $("[name='Fixed_Duration_UM']");
      _addSingleTime(_encodeTime(hh.val(), mm.val()), dur.val(), um.val());
      hh.val("");
      mm.val("");
      hh.focus();
    } 
    else {
      var hhFrom = $("[name='Interval_FromTime_HH']");
      var mmFrom = $("[name='Interval_FromTime_MM']");
      var hhTo = $("[name='Interval_ToTime_HH']");
      var mmTo = $("[name='Interval_ToTime_MM']");
      var dur = $("[name='Interval_Duration']");
      var dur_um = $("[name='Interval_Duration_UM']");
      var inte = $("[name='Interval_Interval']");
      var inte_um = $("[name='Interval_Interval_UM']");
      
      var from = _encodeTime(hhFrom.val(), mmFrom.val());
      var to = _encodeTime(hhTo.val(), mmTo.val());
      var current = from;
      while (current.getTime() < to.getTime()) {
        _addSingleTime(current, dur.val(), dur_um.val());
        var min_inte = Math.max(1, parseInt(inte.val()));
        if (inte_um.val() == "HH")
          min_inte = min_inte * 60;
        current.setMinutes(current.getMinutes() + min_inte);
      }
    }
  }
  
  function _stepFillData(data) {
    data.DateFrom         = $step.find("#DateFrom").val();
    data.DateTo           = $step.find("#DateTo").val();
    data.PerformanceName  = $step.find("#PerformanceName").val() == "" ? null : $step.find("#PerformanceName").val();
    data.WeekDays         = $step.find("[name='weekdays']").getCheckedValues();
    data.AllowOverlapping = $step.find("#AllowOverlapping").isChecked();
    data.TagIDs           = $step.find("#TagIDs").val();
    data.PerfTimeList     = [];
  
    var times = $step.find(".PerfTime");
    for (var i=0; i<times.length; i++) {
      data.PerfTimeList.push($(times[i]).data("time"));
    }
  }
});

</script>


    
</v:wizard-step>
