<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-account-pic">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back custom-click"></div>
    <div class="toolbar-button btn-toolbar-camera btn-float-right"><i class="fa fa-camera"></i></div>
    <div class="tab-header-title"><span class="snp-itl" data-key="@Repository.ProfilePicture"/></div>
  </div>
  
  <div class="tab-body">
    <div class="profile-pic"></div>
    <div class="repository-list"></div>
  </div>
  
  <div class="templates">
    <div class="repository-item"></div>
  </div>
</div>



<style>

#view-account-pic .profile-pic {
  height: calc(100% - 40rem);
  max-height: 100vw;
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
}

#view-account-pic .repository-list {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 40rem;
  white-space: nowrap;
  overflow-x: auto;
  overflow-y: hidden;
}

#view-account-pic .repository-item {
  display: inline-block;
  width: 40rem;
  height: 40rem;
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  opacity: 0.4;
}

#view-account-pic .repository-item.selected {
  opacity: 1;
}

</style>
