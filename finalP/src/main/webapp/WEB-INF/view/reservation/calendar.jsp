<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="title" value="메인페이지" />
<c:set var="description" value="헬스 관련 업무들을 할 수 있는 사이트" />
<c:set var="keywords" value="운동,헬스,헬스장,예약" />
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<c:set var="body">
    <div class="container mt-5">
    	<div>
	        <el-text size="large" tag="b">예약하기</el-text>
    	</div>
	     <el-calendar v-model="date">
	     	<template #header="{ date }">
		      <span>{{ date }}</span>
		      <el-button-group>		       
		        <el-button size="small" @click="selectDate('prev-month')">Previous Month</el-button>
		        <el-button size="small" @click="selectDate('today')">Today</el-button>
		        <el-button size="small" @click="selectDate('next-month')">Next Month</el-button>
		      </el-button-group>
	    	</template>
	     </el-calendar>
    </div>
</c:set>

<c:set var="script">
    data() {
        return {
            date: new Date(${calendarMap.targetYear}, ${calendarMap.targetMonth}, ${calendarMap.targetDay})
        }
    },
    watch: {
        date(nv, pv) {
            const year = nv.getFullYear();
            const month = nv.getMonth() + 1;
            const day = nv.getDate();
            this.openPopup(year, month, day);
        }
        
    },
    methods: {
        openPopup(targetYear, targetMonth, targetDay) {
	        var url = "${contextPath}/reservationPopup?targetYear=" + targetYear + "&targetMonth=" + targetMonth + "&targetDay=" + targetDay;
	        window.open(url, "popupWindow", "width=800, height=600");
	    }
    }
</c:set>

<%@ include file="/inc/admin_layout.jsp" %>