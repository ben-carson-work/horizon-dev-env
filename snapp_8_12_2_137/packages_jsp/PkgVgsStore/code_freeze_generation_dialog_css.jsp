<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

/* attribute/items list */

#table-build-version {
  width: 100%;
}

#table-build-version td {

  vertical-align: top;
  padding: 5px;
}

#archive-version-widget .widget-block,
#wip-version-widget .widget-block, 
#compile-version-widget .widget-block {
  height: 500px;
  overflow: auto;
  padding: 0;
}

/* Recap */

.recap-version-block {
  padding: 10px;
}

.recap-description-edit {
  display: inline-flex;
  margin-left: 10px;
  font-weight: bold;
}

.recap-description {
  float: right;
  font-weight: bold;
}

.recap-version {
  font-weight: bold;
}

.recap-description .span-desc,
.recap-description-edit .span-desc {
  margin: 5px;
  padding: 2px 5px;
  border-radius: 3px;
}

.recap-description .label-unreleased,
.recap-description-edit .label-unreleased {
  border: 1px solid #b3d4ff;
  color: #0052cc;
}

.recap-description .label-released,
.recap-description-edit .label-released {
  border: 1px solid #abf5d1;
  color: #00875a;
}

.recap-description .label-archived,
.recap-description-edit .label-archived {
  border: 1px solid #c1c7d0;
  color: #42526e;
}

.edit-version-block {
  display: flex;
  margin: 10px;
}

.recap-version {
  display: inline;
}

.recap-version.new {
  color: #0052cc;
  background-color: #fff;
  border-color: #b3d4ff;
}

.recap-version.release {
  color: #00875a;
  background-color: #fff;
  border-color: #abf5d1;
}

.recap-version.archive {
  color: #42526e;
  background-color: #fff;
  border-color: #c1c7d0;
}

.recap-description {
  display: inline;
}

.waiting #content {
  display: none;
}

/* Execute */

.spinner-step,
.check-step,
.failed-step {
  display: none;
}

.visible.spinner-step,
.visible.check-step,
.visible.failed-step {
  display: block;
}

.create-jira-versions-step,
.create-branch-step {
  display: flex;
  padding: 10px;
}

.execute-step-recap span {
  font-size: large;
  align-self: center;
}

.spinner-step,
.check-step,
.failed-step {
  margin-left: 30px
}

#spinner-icon {
  color: #428bca;
}

#step-fail-icon {
  color: #428bca;
}

#step-success-icon {
  color: #8ad222;
}

.progressbar-status {
  font-weight: bold;
}

.progress-block {
  margin-top: 20px;
  margin-bottom: 30px;
}


</style>