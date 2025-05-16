<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="statdate-import-dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <jsp:include page="repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    <v:alert-box type="info" title="@Common.Info">
      <v:itl key="This wizard will import statistical date from a CSV file into the system."/><br/>
      <v:itl key="@Account.ImportWizard_Line2"/>
      <ul>
        <li><strong>CalendarDate</strong>: The calendar date in yyyy-mm-dd format. Example: 2000-01-01, 1999-04-21 </li>
        <li><strong>CalendarDayNumber</strong>: The day number within the calendar year for this calendar date. Synonym: Julian Day. Examples: 5 (Jan 5, 2000), 33 (Feb 2, 2000)</li>
        <li><strong>CalendarWeekNumber</strong>: The number for the week within the calendar year in which this calendar date occurs. Examples: 2 (Jan 12, 2000)</li>
        <li><strong>CalendarMonthNumber</strong>: The number for the month in the year on which this calendar date occurs. Examples:1 (January), 2 (February), ... , 11 (November), 12 (December)</li>
        <li><strong>CalendarMonthName</strong>: The name for the month in the year on which this calendar date occurs. Examples: January, ... , November, December</li>
        <li><strong>CalendarQuarterNumber</strong>: The number for the calendar quarter in which the calendar date occurs. Example: 1 (January 12, 2000) </li>
        <li><strong>CalendarSeasonName</strong>: The season to which this calendar date belongs. Examples: Spring, Summer, Fall, Winter</li>
        <li><strong>CalendarYearNumber</strong>: The year in which this calendar date occurs. Example:  2000, 2001</li>
        <li><strong>CalendarWeekDayNumber</strong>: The number for the day of the week on which this calendar date occurs. Examples: 01 (Sunday), 02 (Monday), ... , 06 (Friday), 07 (Saturday)</li>
        <li><strong>CalendarWeekDayName</strong>: The name for the calendar week day. Examples: Sunday, Monday, ... , Friday, Saturday</li>
        <li><strong>CalendarWeekDayIndicator</strong>: Indicates that this date value is a week day (Monday through Friday are Calendar Week Days). Example: Y, N </li>
        <li><strong>CalendarWeekEndIndicator</strong>: Indicates that this date value is  Saturday or Sunday. Example: Y, N</li>
        <li><strong>CalendarWeekEndDate</strong>: The Saturday week ending date for the calendar day in the week. Example: 1999-7-31 (For calendar date 1999-07-27)</li>
        <li><strong>CalendarMonthDayNumber</strong>: The day within the calendar month. Example: 1 (The first of the month), 20 (the twentieth day of the month)</li>
        <li><strong>CalendarMonthWeekNumber</strong>: The week number within the calendar month in which the date value occurs. Example: 2 (Feb 12, 2000)</li>
        <li><strong>CalendarMonthEndIndicator</strong>: Indicates that this day is the last day of the month.</li>
        <li><strong>FiscalDayNumber</strong>: A number representing the day within a fiscal calendar year. Example: 22 (Correlates to 1999-10-24: fiscal year month October and Year 2000)</li>
        <li><strong>FiscalWeekNumber</strong>: The number for the fiscal week in which the calendar date occurs. Example:  3 (1999-10-24)</li>
        <li><strong>FiscalWeekStartDate</strong>: The starting date for the fiscal week</li>
        <li><strong>FiscalWeekEndDate</strong>: The  week ending date for the fiscal week</li>
        <li><strong>FiscalWeekDayNumber</strong>: The number for the day of the fiscal week on which this calendar date occurs.  This is for the case where the fiscal week starts on a different day then the Calendar week</li>
        <li><strong>FiscalWeekDayIndicator</strong>: Indicates that this date value is considered a week day by the business which may be different than the calendar date of  Monday through Friday. Example: Y, N</li>
        <li><strong>FiscalWeekEndIndicator</strong>: Indicates that this date value is considered a week end day. Example: Y, N</li>
        <li><strong>FiscalMonthNumber</strong>: The number for the fiscal month in which the calendar date occurs. Examples:  1 (October), 2 (November), ... , 11 (August), 12 (September)</li>
        <li><strong>FiscalMonthName</strong>: Name of Month for Fiscal Year. Example: January,February, ... ,November,December</li>
        <li><strong>FiscalMonthStartDate</strong>: The starting date for the fiscal month</li>
        <li><strong>FiscalMonthEndDate</strong>: The ending date for the fiscal month</li>
        <li><strong>FiscalQuarterNumber</strong>: The number for the fiscal quarter in which the calendar date occurs. Example:  2 (January 12, 2000)</li>
        <li><strong>FiscalQuarterStartDate</strong>: The starting date for the fiscal quarter in which the calendar date occurs</li>
        <li><strong>FiscalHalfNumber</strong>: The number for the fiscal half in which the calendar date occurs. Example: 1 (first half of the year) 2 (second half of the year)</li>
        <li><strong>FiscalYearNumber</strong>: The number for the fiscal year in which the calendar date occurs. Example: 2000 (1999-10-24) </li>
        <li><strong>FiscalYearStartDate</strong>: The starting date for the fiscal year in which the calendar date occurs</li>
        <li><strong>FiscalMonthDayNumber</strong>: The day within the fiscal month. Example: 1 (May 30), 2 (May 31), 3 (June 1)</li>
        <li><strong>FiscalMonthWeekNumber</strong>: The ordinal number of the week within the fiscal month.  A fiscal month contains either 4, 5 or 6 weeks. Examples:  1, 2, 3, 4, 5, 6</li>
        <li><strong>FiscalMonthEndIndicator</strong>: Indicates that this day is the last day of the fiscal month</li>
        <li><strong>PriorCalendarYearNumber</strong>: The prior year represented as a number Examples: 1999, 2002, 2005</li>
        <li><strong>PriorFiscalMonthEndDate</strong>: The end date for the prior fiscal month</li>
        <li><strong>PriorFiscalYearFiscalYearEndDate</strong>: The end date for the fiscal year of the prior year</li>
        <li><strong>PriorFiscalYearFiscalQuarterEndDate</strong>: The end date for the fiscal quarter of the prior year</li>
        <li><strong>PriorFiscalYearFiscalMonthEndDate</strong>: The end date for the fiscal month of the prior year</li>
        <li><strong>SpecialEventName</strong>: Identifies any special event that is scheduled to occur or has occurred on this date</li>
        <li><strong>BusinessSeasonName</strong>: Identifies the business season under which this date falls</li>
        <li><strong>HolidayName</strong>: Identifies a recognized holiday which occurs on this date</li>
        <li><strong>HolidayObserveName</strong>: Identifies a recognized holiday which is observed by the organization on this date</li>
        <li><strong>HolidaySeasonName</strong>: Identifies the holiday season under which this date falls</li>
        <li><strong>PriorFiscalYearFiscalYearNumber</strong>: The fiscal year  prior to the fiscal year in which this calendar date occurs. Example:  2000, 2001</li>
        <li><strong>CurrentDayIndicator</strong>: A temporal flag indicating that the calendar date is today's date, where 'Y' is today's date.  This flag is reset daily. Only one record should be flagged as today's day</li>
        <li><strong>PreviousDayIndicator</strong>: A temporal flag indicating the calendar date is yesterday's date, This flag is reset daily. Only one record should be flagged as yesterday's date</li>
        <li><strong>PriorFiscalWeekIndicator</strong>: A temporal flag (Y) indicating the dates belonging to last fiscal week, relative to today's date.   This flag is reset weekly, with only 7 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalMonthIndicator</strong>: A temporal flag (Y) indicating the dates belonging to last fiscal month, relative to today's date.  This flag is reset weekly, with only 28 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalQuarterIndicator</strong>: A temporal flag (Y) indicating the dates belonging to last fiscal quarter, relative to today's date.  This flag is reset weekly, with only 90 or 91 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalYearIndicator</strong>: A temporal flag (Y) indicating the dates belonging to last fiscal year, relative to today's date.  This flag is reset yearly, with only 364-365 records being marked, and all others remaining null</li>
        <li><strong>Previous14DaysIndicator</strong>: A temporal flag (Y) marking the 14 calendar days previous to today's date.  This flag is reset daily, with only 14 records being marked, and all others remaining null</li>
        <li><strong>Previous5DaysIndicator</strong>: A temporal flag (Y) marking the 5 calendar days previous to today's date.  This flag is reset daily, with only 5 records being marked, and all others remaining null</li>
        <li><strong>Previous7DaysIndicator</strong>: A temporal flag (Y) marking the 7 calendar days previous to today's date.  This flag is reset daily, with only 5 records being marked, and all others remaining null</li>
        <li><strong>Previous90DaysIndicator</strong>: A temporal flag (Y) marking the 90 calendar days previous to today's date.  This flag is reset daily, with only 90 records being marked, and all others remaining null</li>
        <li><strong>CurrentFiscalMonthLastWeekEndDateIndicator</strong>: A temporal flag (Y) marking the week-ending date for the last fiscal week of the current fiscal month, relative to today's date.  This flag is reset weekly, with only one record being marked, and all others remaining null</li>
        <li><strong>CurrentFiscalYearWeekEndDateIndicator</strong>: A temporal flag (Y) marking the week-ending dates occuring in the current fiscal year, up until today's date.  This flag is reset daily, with between 1 - 52 records being marked, and others remaining null</li>
        <li><strong>CurrentFiscalYearToWeekIndicator</strong>: A temporal flag (Y) marking the prior dates occuring in the current fiscal year, relative to today's date, prior to the current fiscal week.  This flag is reset daily, with between 1 - 357 records being marked, and all others remaining null</li>
        <li><strong>CurrentFiscalYearToDateIndicator</strong>: A temporal flag (Y) marking the prior dates occuring in the current fiscal year, relative to today's date, including the current fiscal week.  This flag is reset daily, with between 1 - 365 records being marked, and all others remaining null</li>
        <li><strong>CurrentFiscalQuarterToWeekIndicator</strong>: A temporal flag (Y) marking the prior dates occuring in the current fiscal quarter, relative to today's date, prior to the current fiscal week.  This flag is reset daily, with between 1 - 83 records being marked, and all others remaining null</li>
        <li><strong>CurrentFiscalYearMonthToWeekIndicator</strong>: A temporal flag (Y) marking the prior dates occuring in the current fiscal month, relative to today's date, prior to the current fiscal week.  This flag is reset daily, with between 1 - 21 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalYearPriorWeekIndicator</strong>: A temporal flag (Y) marking the seven days in the prior fiscal week of the last fiscal year, relative to the last year's corresponding date to today's date.   This flag is reset weekly, with only 7 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalMonthToWeekIndicator</strong>: A temporal flag (Y) marking the prior dates occuring in the prior fiscal month, relative to today's date, prior to the current fiscal week.  This flag is reset daily, with between 1 - 21 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalQuarterToWeekIndicator</strong>: A temporal flag (Y) marking the prior dates occuring in the prior fiscal quarter, relative to today's date, prior to the current fiscal week.  This flag is reset daily, with between 1 - 83 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalYearToWeekIndicator</strong>: A temporal flag (Y) marking the prior dates occuring in the prior fiscal year, relative to today's date, prior to the current fiscal week.  This flag is reset daily, with between 1 - 357 records being marked, and all others remaining null</li>
        <li><strong>CurrentFiscalYearPrevious12MonthEndDateIndicator</strong>: A temporal flag (Y) marking the month-ending dates of the last12 fiscal months, relative to today's date.  This flag is reset daily, with 12 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalYearPrevious12MonthEndDateIndicator</strong>: A temporal flag (Y) marking the month-ending dates of the prior year's last12 fiscal months, relative to the Prior Year Calendar Date for today's date.  This flag is reset daily, with 12 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalWeekEndDateIndicator</strong>: A temporal flag (Y) marking the week-ending date for the last fiscal week (usually a Saturday) relative to today's date.  This flag is reset weekly, with only one record being marked, and all others remaining null</li>
        <li><strong>PriorYearLastFiscalWeekEndDateIndicator</strong>: A temporal flag (Y) marking the week-ending date for the last fiscal week of the prior fiscal year, relative to the Prior Year Calendar Date for today's date.  This flag is reset weekly, with only one record being marked, and all others remaining null</li>
        <li><strong>Previous2DaysIndicator</strong>: A temporal flag (Y) marking the 2 calendar dates prevoius to today's date.  This flag is reset daily, with only 2 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalMonthEndDateIndicator</strong>: A temporal flag (Y) marking the last date of previous fiscal month, relative to today's date.  This flag is reset monthly, with only one record being marked, and all others remaining null</li>
        <li><strong>PriorFiscalYearEndDateIndicator</strong>: A temporal flag (Y) marking the last date of previous fiscal year, relative to today's date.  This flag is reset yearly, with only one record being marked, and all others remaining null</li>
        <li><strong>PriorFiscalMonthWeekEndDateIndicator</strong>: A temporal flag (Y) marking the week-ending dates for the fiscal weeks in the prior fiscal month, relative to today's date.  This flag is reset weekly, with 4-5 records being marked, and all others remaining null</li>
        <li><strong>CurrentFiscalYearFiscalWeekStartDate</strong>: The date of the start of the current fiscal week for this calendar date</li>
        <li><strong>CurrentFiscalYearFiscalMonthStartDate</strong>: The date of the start of the current fiscal month for this calendar date</li>
        <li><strong>CurrentFiscalYearFiscalQuarterStartDate</strong>: The date of the start of the current fiscal quarter for this calendar date</li>
        <li><strong>CurrentFiscalYearFiscalYearStartDate</strong>: The date of the start of the current fiscal year for this calendar date</li>
        <li><strong>PriorFiscalYearFiscalWeekEndDate</strong>: The date of the end of the fiscal week in the prior fiscal year, relative to the corresponding calendar date in the prior year</li>
        <li><strong>PriorFiscalYearFiscalWeekStartDate</strong>: The date of the start of the fiscal week in the prior fiscal year, relative to the corresponding calendar date in the prior year</li>
        <li><strong>PriorFiscalYearFiscalMonthStartDate</strong>: The date of the start of the fiscal month in the prior fiscal year, relative to the corresponding calendar date in the prior year</li>
        <li><strong>PriorFiscalYearFiscalQuarterStartDate</strong>: The date of the start of the fiscal quarter in the prior fiscal year, relative to the corresponding calendar date in the prior year</li>
        <li><strong>PriorFiscalYearFiscalYearStartDate</strong>: The date of the start of the prior fiscal year for this calendar date</li>
        <li><strong>PriorYearCalendarDate</strong>: The calendar date of the prior year corresponding to the calendar date of the current record. Examples: 2012-07-04, 2011-07-03</li>
        <li><strong>CurrentFiscalYearEndDateIndicator</strong>: A temporal flag (Y) marking the end of the current fiscal year, relative to today's date.  This flag is reset yearly, with only 1 record being marked, and all others remaining null</li>
        <li><strong>PreviousCalendarMonthDaysIndicator</strong>: A temporal flag (Y) marking the dates of the previous calendar month, relative to today's date.  This flag is reset monthly, with between 1-31 records being marked, and all others remaining null</li>
        <li><strong>FiscalQuarterEndDateIndicator</strong>: A flag (Y) indicating that this date is the end of a fiscal quarter</li>
        <li><strong>CurrentFiscalYearPrevious8FiscalWeekIndicator</strong>: A temporal flag (Y) marking calendar dates within the prior 8 fiscal weeks, relative to today's date.  This flag is reset weekly, with 56 records being marked, and all others remaining null</li>
        <li><strong>PriorFiscalYearPrevious8FiscalWeekIndicator</strong>: A temporal flag (Y) marking calendar dates within the prior 8 fiscal weeks of the prior fiscal year, relative to the Prior Year Calendar Date for today's date.  This flag is reset weekly, with 56 records being marked, and all others remaining null</li>
      </ul>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_START_DATE%>"/>
    </jsp:include>
  </div>

<script>

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

</script>

</v:dialog>
