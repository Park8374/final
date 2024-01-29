<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="title" value="문의내용" />
<c:set var="description" value="헬스 관련 업무들을 할 수 있는 사이트" />
<c:set var="keywords" value="운동,헬스,헬스장,예약" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />

<c:set var="body">

    <div class="flex justify-between">
        <el-text size="large" tag="b">문의내용</el-text>
        <el-button type="primary" @click="insert()">문의하기</el-button>
    </div>


	<el-table :data="questionList" @row-click="rowClick"> 
		<el-table-column prop="questionNo" label="No"  width="100"></el-table-column> 
		<el-table-column prop="questionTitle" label="제목"></el-table-column> 
		<el-table-column prop="customerId" label="작성자"></el-table-column>
		<el-table-column prop="createdate" label="작성일"></el-table-column>
		<el-table-column prop="updatedate" label="수정일"></el-table-column>
	</el-table>
	
	
	<!-- 페이징 네비게이션 -->
	<%@ include file="/inc/pagination.jsp" %>
</c:set>

<c:set var="script">
	
	data() {
		return {			
			questionList: JSON.parse('${ questionList }'),	// 리스트
			pageNum: ${page.pageNum},						// 페이징
			rowPerPage: ${page.rowPerPage },
			totalCount: ${page.totalCount},
			totalPage: ${page.totalPage },
		}
	},
	
	methods: {
		insert(){	// 추가
			if(${ loginCustomer != null }){
				location.href = '${ctp}/question/insert';
			} else {
				alert('로그인 후 이용해주세요.');
				location.href ='${ctp}/customer/login';
			}
			
		},
		
		rowClick(row, column){	// 상세보기
	      	console.log('Row.data:',row, column);
	      	if (column.property) {
	      	  location.href='${ctp}/question/questionOne?questionNo=' + row.questionNo;
	      	}
	      },
		
		loadPage(pageNum) {	// 페이징
      	const param = new URLSearchParams();
      	param.set('pageNum', this.pageNum);
      	param.set('rowPerPage', this.rowPerPage);
      	
		location.href = '/question/list?' + param.toString();
      },     
	},
 
</c:set>

<c:if test="${ loginEmployee == null}">
	<%@ include file="/inc/user_layout.jsp"%>
</c:if>

<c:if test="${ loginEmployee != null}">
	<%@ include file="/inc/admin_layout.jsp"%>
</c:if>