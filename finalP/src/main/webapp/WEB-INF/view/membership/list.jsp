<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="title" value="멤버십 리스트" />
<c:set var="description" value="헬스 관련 업무들을 할 수 있는 사이트" />
<c:set var="keywords" value="운동,헬스,헬스장,예약" />
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="body">

    <div class="flex justify-between">
        <el-text size="large" tag="b">멤버쉽 구매</el-text>
		<el-button type="primary" @click="insert()" v-if="isEmployee">상품추가</el-button>
    </div>

	<el-table :data="membershipList" border style="width: 100%">
		<el-table-column type="index" label="No" width="120"></el-table-column>
		<el-table-column prop="membershipNo" label="상품번호"></el-table-column>
		<el-table-column prop="membershipName" label="상품명"></el-table-column>
		<el-table-column prop="membershipPrice" label="가격"></el-table-column>
	 		
				<el-table-column v-if="isEmployee" label="수정/삭제"> <template #default="scope">
					<el-button type="primary" @click="update(scope.row)">수정</el-button> 
					<el-button type="primary" @click="remove(scope.row)">삭제</el-button></template> 
				</el-table-column>
	 		
		 	
				<el-table-column v-if="isCustomer" label="결제"> 
					<template #default="scope">
						<el-button type="primary" @click="insertPayment(scope.row)">상품결제</el-button> 
					</template>
				</el-table-column>

	</el-table>
	
	

</c:set>
<c:set var="script">
	data() {
		return {
			membershipList : JSON.parse('${ membershipList }'),
            isEmployee: Boolean('${ loginEmployee }'),
            isCustomer: Boolean('${loginCustomer}'),
		}
	},
	methods: {
		insert(){
			location.href = '${ctp}/membership/insert';
		},
		
		update(row){
			location.href = '${ctp}/membership/update?membershipNo='+row.membershipNo;
		},
		
		remove(row){
			if(confirm('삭제 후 원복할 수 없습니다. 해당 상품을 삭제하시겠습니까?')){
				const self = this;
				const membership = {membershipNo: row.membershipNo,};
				
				axios.post('${ctp}/membership/delete', membership)
				.then((res) => {
					if(res.data == 1){
						alert('삭제가 완료되었습니다.');
						
						location.reload();
					} else {
						self.$notify({
						  title: '삭제 실패',
						  message: '멤버십 이용자 수가 많아 삭제가 불가합니다.',
						  type: 'error',
						})
					}
				}).catch((res) => {	<!-- 외래키 제약조건에 의해 삭제 안될 수 있음 / result = 0 도출이 아닌 DB 측 오류로 조회되기에 catch란에 메시지 작성 -->
					self.$notify({
						  title: '삭제 실패',
						  message: '멤버십 이용자 수가 많아 삭제가 불가합니다.',
						  type: 'error',
					})
				})
			}
		},
		
		insertPayment(membership){
			if(${ loginCustomer == null }){
				alert('로그인 후 이용해주세요.');
				location.href = '${ctp}/customer/login';
			} else if(${ loginCustomer.paymentActive == '사용중' }) {
				alert('이전 구매한 멤버십 기간만료 후 결제 가능합니다.');
			} else {
				if(confirm(membership.membershipName + ' 상품을 결제하시겠습니까?')){
					const self = this;
					const payment = {
						membershipNo : membership.membershipNo,
					};
					
					axios.post('${ctp}/payment/insert', payment)
					.then((res) => {
						if(res.data == 1){
							self.$notify({
							  title: '결제 완료',
							  message: '결제가 완료되었습니다.',
							  type: 'success',
						})
						} 
					}).catch((res) => {	
						alert('error');
					})
				}
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