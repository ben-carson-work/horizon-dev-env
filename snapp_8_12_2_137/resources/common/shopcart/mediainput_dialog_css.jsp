<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<style>
#mediainput_dialog {
  #mediainput-table {
    width: 100%;

    .mi-item {
    
      .mi-item-title {
        font-size: 1.5em;
        border-bottom: 1px solid black;
        padding-bottom: 5px;
      }
      
      &:not(:first-child) .mi-item-title {
        padding-top: 30px;
      }
      
      .mi-detail {
        td {
          padding: 2px;
        }
          
        .mi-detail-position {
          text-align: right;
          padding-left: 20px;
          font-weight: bold;
        }
        
        .mi-detail-position:before {
          content: '#';
        }
        
        .mi-detail-account {
          width: 20%;
          font-weight: bold;
          text-align: center;
          
          &.anonymous-account {
            opacity: 0.5;
          }
        }
        
        .mi-detail-mediacode {
          width: 80%;
        }
      }
    }

  }
}
</style>
