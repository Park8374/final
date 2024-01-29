<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="title" value="리뷰목록" />
<c:set var="description" value="헬스 관련 업무들을 할 수 있는 사이트" />
<c:set var="keywords" value="운동,헬스,헬스장,예약" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<c:set var="body">


	<!-- 	programMapper.select 절에서 프로그램 목록 조회 후 select, option 태그로 가져와 검색 기능 구현 예정		 -->
	<p style="text-align: center; font-size: 30px;">리뷰목록</p>

	<el-button type="primary" @click="insert()">리뷰작성</el-button>
	<el-select class="m-2" placeholder="Select" style="width: 240px" id="programName" v-model="value">
		<el-option v-for="(item,i) in programList" :key="i" :value="item.programName" :label="item.programName" @click="selectProgram()"/>
	</el-select>	
		
	<el-table :data="reviewList" class="w-fit" @row-click="rowClick"
		class-name="cursor-pointer"> 
		<el-table-column prop="reviewNo" label="No" width="100"></el-table-column> 
		<el-table-column prop="branchName" label="지점명"></el-table-column> 
		<el-table-column prop="programName" label="프로그램명"></el-table-column> 
		<el-table-column prop="reviewTitle" label="제목"></el-table-column> 
		<el-table-column prop="customerId" label="작성자"></el-table-column>
		<el-table-column prop="createdate" label="작성일"></el-table-column>
		<el-table-column prop="updatedate" label="수정일"></el-table-column>
		<c:if test="${ loginEmployee != null }">
			<el-table-column label="삭제">
				<template #default="scope">
					<el-button type="primary" @click="remove(scope.row)">삭제</el-button>
				</template>
			</el-table-column>
		</c:if> 
	</el-table>

	<!-- 페이징 네비게이션 -->
	<%@ include file="/inc/pagination.jsp" %>

</c:set>
<c:set var="script">
	data() {
		return {
			reviewList: JSON.parse('${reviewList}'),	// 리뷰목록
			programList: JSON.parse('${programList}'),	// 프로그램 목록 /검색기능 
			pageNum: ${page.pageNum},					// 페이징
			rowPerPage: ${page.rowPerPage },
			totalCount: ${page.totalCount},
			totalPage: ${page.totalPage },
			value:'',
			programName: '${ programName }',
		}
	},
	
	methods: {	
		insert() {	// 작성
			if(${ loginCustomer != null && checkAttendance}){
				location.href='${ctp}/review/insert';
			} else if(${ loginCustomer != null && !checkAttendance}){
				alert('방문/출석정보가 없어 리뷰를 작성할 수 없습니다.');
			} else {
				alert('로그인 후 이용해주세요.');
				location.href ='${ctp}/customer/login';
			}
			
		},
				
		loadPage(pageNum) {	// 페이징
	      	const param = new URLSearchParams();
	      	param.set('pageNum', this.pageNum);
	      	param.set('rowPerPage', this.rowPerPage);
			location.href = '/review/list?' + param.toString()+ '&programName=' + this.programName;
      	},
		rowClick(row, column){	// 상세보기
			console.log('Row.data:',row, column);
			if (column.property) {
			  location.href='${ctp}/review/reviewOne?reviewNo=' + row.reviewNo;
		}
      },
		selectProgram(){	// 프로그램 옵션선택
			location.href = '${ctp}/review/list?programName=' + this.value;
		},
     
		remove(row) {	// 삭제
			console.log('row -> ', row.reviewNo)
			if(confirm('해당 게시글을 강제 삭제하시겠습니까?')){
				const self = this;
				const reviewNo = {reviewNo : row.reviewNo,};  
				
			axios.post('${ctp}/review/delete', reviewNo)
				.then((res) => {
					if(res.data == 1){
					alert('삭제가 완료되었습니다.');
					location.reload();
				}
			}).catch((error) => {
				alert('삭제 중 에러가 발생했습니다.');
				console.error(error);
				})
			}
		},  
   },
</c:set>

<c:if test="${ loginEmployee == null}">
	<%@ include file="/inc/user_layout.jsp"%>
</c:if>

<c:if test="${ loginEmployee != null}">
	<%@ include file="/inc/admin_layout.jsp"%>
</c:if>