<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<v:widget caption="Info">
  <v:widget-block>
    <p>
    	To properly configure communication with court alarm system is mandatory to add to the event, that needs to trigger the message, 
    	specific Snapp meta fields 
    </p>
    <p>
    	Below table describes mapping between Snapp meta field codes, that system is expecting, and their meaning</br>
    </p>
    <table>
        <tr>
            <th>Meaning</th>
            <th>Snapp Metafield code</th>
        </tr>
        <tr>
            <td style="text-align:left;">Court alarm API end point</td>
            <td style="text-align:center;">DU-ALARM-URL</td>
        </tr>
        <tr>
            <td style="text-align:left;">Court alarm API token</td>
            <td style="text-align:center;">DU-ALARM-TOKEN</td>
        </tr>
        <tr>
            <td style="text-align:left;">Welcome playback message id</td>
            <td style="text-align:center;">DU-MSG-ID-WELCO</td>
        </tr>
        <tr>
            <td style="text-align:left;">Before the end playback message id</td>
            <td style="text-align:center;">DU-MSG-ID-BFEND</td>
        </tr>
        <tr>
            <td style="text-align:left;">End of play time playback message id</td>
            <td style="text-align:center;">DU-MSG-ID-END</td>
        </tr>
        <tr>
            <td style="text-align:left;">
            Minutes before end of play time at which "Before end Message" have to be triggered</br>
            Value must be numeric, default value is zero</td>
            <td style="text-align:center;">DU-MIN-BFEND</td>
        </tr>
        <tr>
            <td style="text-align:left;">Minutes before end of play time at which "End Message" have to be triggered</br>
            Value must be numeric, default value is zero</td>
            <td style="text-align:center;">DU-MIN-END</td>
        </tr>
	</table>
  </v:widget-block>
</v:widget>
