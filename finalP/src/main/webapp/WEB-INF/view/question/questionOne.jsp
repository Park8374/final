<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="title" value="문의작성" />
<c:set var="description" value="헬스 관련 업무들을 할 수 있는 사이트" />
<c:set var="keywords" value="운동,헬스,헬스장,예약" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />

<c:set var="body">

	
	<!-- 문의 작성자 / 제목 정보 등 표기  -->
	<el-descriptions title="문의 상세" :column="1" border> <el-descriptions-item
		v-for="key of Object.keys(question)" :label="key">{{
	question[key] }}</el-descriptions>
	</eldescriptions>

	<br>

	<c:if test="${ loginCustomer.customerNo == questionMap.customerNo }">
		<!-- 로그인된 본인 글에만 표시 -->
		<el-button type="primary" @click="updateForm(question)">수정</el-button>
		<!-- 수정Form으로 이동 -->
		<el-button type="primary" @click="deleteForm()" id="deleteBtn">삭제</el-button>
		<!-- 고객PW 입력Form 표시 / 입력 후 삭제가능 -->

		<!-- 삭제 시 고객PW 입력 form / 삭제버튼 클릭 시 보여지도록 구성 -->
		<span id="deleteForm" style="display: none;"> <input
			type="hidden" v-model="question.작성자"> <input type="hidden"
			v-model="question.문의번호"> <input type="password"
			id="customerPw" placeholder="PW 입력" /> <el-button type="primary"
				@click="deleteAct()">삭제</el-button>
		</span>
	</c:if>
	<br>


	<strong>Content</strong>
	<br>
	<textarea readonly rows="20" cols="200" style="resize: none; border: 20em;">{{ questionContent }}</textarea>
	
	<c:if test="${ replyMap != null }">
		<!-- 답변 -->
		<el-descriptions title="문의 답변" :column="1" border> 
			<el-descriptions-item
				v-for="key of Object.keys(reply)" :label="key">
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
		<textarea id="questionReply" rows="20" cols="170" 
			style="resize: none;" readonly>{{ replyContent }}</textarea>
	</c:if>
	<br>
	<br>

	<!-- 답변 없을 시 표시 -->
	<c:if test="${ replyMap == null }">
		<p>답변이 등록되지 않았습니다. 조금만 기다려주세요.</p>
	</c:if>

	<!-- 답변 없을 시 + 관리자에게만 표시 -->
	<c:if test="${ replyMap == null && loginEmployee != null}">
		<el-form label-position="right" ref="form" label-width="150px"
			status-icon class="max-w-lg" action="${ctp}/question/insertReply"
			method="post" id="insertReplyAct"> 
			<el-form-item label="답변자" column="2"> 
				<el-input v-model="employee.employeeId" readonly /> 
			</el-form-item> 
			
			<el-form-item> 
				<el-input type="hidden" name="employeeNo" v-model="employee.employeeNo" /> 
			</el-form-item> 
			
			<el-form-item>
				<el-input type="hidden" name="questionNo" v-model="employee.questionNo" /> 
			</el-form-item> 
			
			<el-form-item label="답변내용">
				<textarea rows="10" cols="50" style="resize: none;" name="questionReplyContent" v-model="employee.replyContent"></textarea>
			</el-form-item> 
			
			<el-button type="primary" @click="insertReply()">등록</el-button>
	</c:if>

	<br>
</c:set>

<c:set var="script">
	
	data() {
		return{
		// question 관련 데이터
			question: {
				문의번호: '${ questionMap.questionNo }',
				제목: '${ questionMap.questionTitle }',
				작성자: '${ questionMap.customerId }',
				최종수정일: '${ questionMap.updatedate }',			
			},
			questionContent: '${ questionMap.questionContent }',
			
		// reply 관련 데이터
			reply: {
				답변번호: '${ replyMap.questionReplyNo }' ,
				직원ID: '${ replyMap.employeeId }' ,				
				작성일:  '${ replyMap.updatedate }',				
			},
			replyContent: '${ replyMap.questionReplyContent }',
			
		// reply insert 시 필요 데이터	
			employee: {
				employeeNo: '${ loginEmployee.employeeNo }',
				employeeId: '${ loginEmployee.employeeId }',
				replyContent: '',
				questionNo: '${ questionMap.questionNo }',
			},		
		}
	},
	
	methods: {
		updateForm(){	// 문의내용 수정 기능 
			if(this.reply.답변번호 == ''){ // 등록된 답변이 없다면
				location.href = '${ctp}/question/update?questionNo=${ questionMap.questionNo }';
			} else {
				alert('답변 등록된 글은 수정할 수 없습니다.');
			}			
		},		
		
		deleteForm(){	// 문의내용 삭제 폼 (비번 입력창) 조회 기능
			document.getElementById('deleteForm').style.display = "flex";
			document.getElementById('deleteBtn').style.display = "none";
		},		
		deleteAct(){	// 문의내용 삭제 기능
			if(confirm('삭제 후에는 복구할 수 없습니다. 정말로 삭제하시겠습니까?')){
				const self = this;
				const question = {
					questionNo:	this.question.문의번호,
					customerId: this.question.작성자,
					customerPw: document.getElementById('customerPw').value,				
				};				
				axios.post('${ctp}/question/delete', question)
				.then((res) => {
					if(res.data==1){
					alert('삭제가 완료되었습니다.');
					location.href = '${ctp}/question/list';
				} else {
					alert('비밀번호가 일치하지 않습니다.');
				}
				}).catch((res) => {
					alert('error');
				})
			}			
		},
		
			
		insertReply(){	// 답변 입력 기능
			document.getElementById('insertReplyAct').submit();
		},
		
			
		updateReply(){	// 답변 수정 기능
			document.getElementById('questionReply').readOnly = false;
			document.getElementById('replyBtn').style.display = "none";
			document.getElementById('updateReplyBtn').style.display = "flex";			
		},	
		updateReplyAct(){
			const self = this;
			const reply = {
				questionReplyNo: this.reply.답변번호,
				employeeNo: this.employee.employeeNo,
				questionReplyContent: document.getElementById('questionReply').value,
			};			
			axios.post('${ctp}/question/updateReply', reply)
			.then((res) => {
				if(res.data == 1){
					alert('수정이 완료되었습니다.');
					location.reload();
				}
			}).catch((res) => {
				alert('error');
			})			
		},
		
		
		deleteReply(){	// 답변 삭제 기능	
			if(confirm('답변을 삭제하시겠습니까?')){
			const self = this;
			const reply = {
				questionNo: this.question.문의번호,
			};			
			axios.post('${ctp}/question/deleteReply', reply)
			.then((res) => {
				alert('삭제가 완료되었습니다.');
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