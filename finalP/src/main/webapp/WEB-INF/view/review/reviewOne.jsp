<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="title" value="리뷰상세" />
<c:set var="description" value="헬스 관련 업무들을 할 수 있는 사이트" />
<c:set var="keywords" value="운동,헬스,헬스장,예약" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<c:set var="body">


	<el-descriptions title="" :column="2" border> <el-descriptions-item
		v-for="key of Object.keys(review)" :label="key">{{
	review[key] }}</el-descriptions-item> </el-descriptions>
	<c:if test="${ loginCustomer.customerNo == reviewMap.customerNo }">
		<!-- 로그인된 본인 글에만 표시 -->
		<br>
		<el-button type="primary" @click="updateForm()">수정</el-button>
		<el-button type="primary" @click="deleteForm()" id="deleteBtn">삭제</el-button>

		<span id="deleteForm" style="display: none;"> <!-- 삭제 시 고객PW 입력 form / 삭제버튼 클릭 시 보여지도록 구성 -->
			<el-form label-position="right" ref="form" label-width="150px"
				status-icon class="max-w-lg" action="${ctp}/review/delete"
				method="post" id="deleteAct"> <el-form-item label="PW">
			<input type="password" id="customerPw" placeholder="PW 입력" />&nbsp;
			<el-button type="primary" @click="deleteAct()">삭제</el-button> </el-form-item> <el-form-item>
			<input type="hidden" name="customerId" v-model="review.아이디">
			</el-form-item> <el-form-item> <input type="hidden" name="reviewNo"
				v-model="reviewNo"> </el-form-item> </el-form>
		</span>
	</c:if>
	<br>

	<strong> Content </strong>
	<br>
	<textarea readonly rows="20" cols="200" style="resize: none;"> {{ reviewContent }}</textarea>

	<c:if test="${ replyMap != null }">
		<!-- 답변 있을 시 답변표시 -->
		<el-descriptions title="리뷰 답변" column="2" border> 
			<el-descriptions-item
				v-for:="key of Object.keys(reply)" :label="key">
				{{ reply[key] }}
			</el-descriptions-item> 
		</el-descriptions>
	<br>
	<c:if test="${ loginEmployee != null }">
		<span id="replyBtn"> 
			<el-button type="primary" @click="updateReply()">수정</el-button> 
			<el-button type="primary" @click="deleteReply()">삭제</el-button>
		</span>
		<span id="updateReplyBtn" style="display: none;"> 
			<el-button type="primary" @click="updateReplyAct()">완료</el-button>
			<div>&nbsp; 수정 후 완료버튼 클릭 시 직원 ID 및 작성일 모두 자동변경됩니다.</div>
		</span>
	</c:if>
	<br>
	<br>

		<strong>Reply</strong>
		<textarea id="reviewReplyContent" readonly rows="10" cols="160"
			style="resize: none;">{{ replyContent }}</textarea>

	</c:if>
	<br>
	<br>
	
	<!-- 답변 없을 시 답변표시 -->
	<c:if test="${ replyMap == null }">		
		<p>답변이 등록되지 않았습니다. 조금만 기다려주세요.</p>
	</c:if>

	<c:if test="${ replyMap == null && loginEmployee != null}">
		<!-- 등록답변 없음 + 관리자 로그인 시 표시 -->
		<el-form label-position="right" ref="form" label-width="150px"
			status-icon class="max-w-lg" action="${ctp}/review/insertReply"
			method="post" id="insertReplyAct"> 
			<el-form-item column="2">
				<input type="hidden" name="reviewNo" v-model="reviewNo" /> 
				<input type="hidden" name="employeeNo" v-model="employeeNo" /> 
			</el-form-item> 
			
			<el-form-item label="작성자"> 
				<el-input readonly v-model="employeeId" />
			</el-form-item> 
			
			<el-form-item label="답변"> 
				<textarea rows="10" cols="160" style="resize: none;" name="reviewReplyContent"></textarea>
			</el-form-item> 
			
			<el-button type="primary" @click="insertReply()">등록</el-button> </el-form>
	</c:if>

	<br>
</c:set>

<c:set var="script">	

	data() {
		return {
		// review 관련 데이터
			review: {
				고객번호 : '${ reviewMap.customerNo }',
				아이디 : '${ reviewMap.customerId }',
				제목 : '${ reviewMap.reviewTitle }',
				출석일자 : '${ reviewMap.customerAttendanceEnterTime }',
				지점번호 : '${ reviewMap.branchNo }',
				지점명 : '${ reviewMap.branchName }',				
				작성일 : '${ reviewMap.createdate }',
				수정일: '${ reviewMap.updatedate }',
			},
			
		// reply 관련 데이터
			reply: {
				소속지점 : '${ replyMap.branchName }',
				답변자 : '${ replyMap.employeeId }',
				작성일 : '${ replyMap.createdate }',
				수정일 : '${ replyMap.updatedate }',
			},			
		// 표로 작성하지 않을 부분 / 따로 바인딩
			reviewNo: '${ reviewMap.reviewNo }',
			reviewContent : '${ reviewMap.reviewContent }',
			replyContent : '${ replyMap.reviewReplyContent }',
			reviewReplyNo: '${ replyMap.reviewReplyNo }',
			employeeNo : '${ loginEmployee.employeeNo }',
			employeeId : '${ loginEmployee.employeeId }',
			
		}
	},
	
	methods: {
		updateForm(){	// 리뷰 수정Form으로 이동
			if(this.reviewReplyNo == ''){
				location.href = '${ctp}/review/update?reviewNo=${ reviewMap.reviewNo }';
			} else {
				alert('답변 등록된 글은 수정할 수 없습니다.');
			}			
		},
		
		deleteForm(){	// 리뷰 삭제위한 PW 입력창 조회
			document.getElementById('deleteForm').style.display = "flex";
			document.getElementById('deleteBtn').style.display = "none";
		},		
		deleteAct(){	// 리뷰 삭제기능
			if(confirm('삭제 후에는 복구할 수 없습니다. 정말로 삭제하시겠습니까?')){
				const self = this;
				const review = {
					customerId: this.review.아이디,
					customerPw: document.getElementById('customerPw').value,
					reviewNo: this.reviewNo,
				};
				axios.post('${ctp}/review/delete', review)
				.then((res) => {
					if(res.data == 1){
					alert('삭제가 완료되었습니다.');
					location.href = '${ctp}/review/list';
				} else {
					alert('비밀번호가 일치하지 않습니다.');
				}
				}).catch((res) => {
					alert('error');
				})				
			}
		},
		
		insertReply(){	// 리뷰답글 입력
			document.getElementById('insertReplyAct').submit();
		},
		
		updateReply(){	// 리뷰답글 수정기능 
			document.getElementById('replyBtn').style.display = "none";
			document.getElementById('updateReplyBtn').style.display = "flex";
			document.getElementById('reviewReplyContent').readOnly = false;			
		},
		updateReplyAct(){
			const self = this;
			const review = {
				reviewReplyNo: this.reviewReplyNo,
				employeeNo: this.employeeNo,
				reviewReplyContent: document.getElementById('reviewReplyContent').value,
			};
			axios.post('${ctp}/review/updateReply', review)
			.then((res) => {
				if(res.data == 1){
					alert('수정이 완료되었습니다.');
					location.reload();
				}
			}).catch((res) => {
				alert('error');
			})
		},
		
		deleteReply(){	// 리뷰답글 삭제
			if(confirm('답변을 삭제하시겠습니까?')){
				const self = this;
				const reply = {
					reviewNo: this.reviewNo,
				};				
				axios.post('${ctp}/review/deleteReply', reply)
				.then((res) => {
					alert('삭제가 완료되었습니다');
					location.reload();
				}).catch((res) => {
					alert('error');
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