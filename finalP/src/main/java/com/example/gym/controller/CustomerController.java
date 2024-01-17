package com.example.gym.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.gym.service.CustomerService;
import com.example.gym.util.ViewRoutes;
import com.example.gym.vo.Customer;
import com.example.gym.vo.CustomerForm;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("customer")
public class CustomerController extends DefaultController{
	@Autowired
	private CustomerService customerService;
	
	// login (로그인) Form
	@GetMapping("/login")
	public String loginCustomer(HttpSession session) {
	
		return ViewRoutes.사용자_로그인;
	}
	// login 후 Act -> session 세팅 후 home.jsp로 이동
	@PostMapping("/login")
	@ResponseBody
	public int loginCustomer(HttpSession session, @RequestBody Customer customer) {
		Map<String,Object> loginCustomer = customerService.loginCustomer(customer);
		int result = 0;
		if (loginCustomer != null) { // 등록된 ID가 있을 시
			session.setAttribute("loginCustomer", loginCustomer);
			log.info("login");
			result = 1;

		} else { // 정보 없을 시
			log.info(customer.getCustomerId() + " / " + customer.getCustomerPw() + " / login 실패");			
		}
			return result;
	}
	
	// insert (회원가입) Form
	@GetMapping("/insert")
	public String insertCustomer() {	
		return ViewRoutes.사용자_추가;
	}
	// insert (회원가입) Act
	@PostMapping("/insert")
	public String insertCustomer(CustomerForm customerForm) {
		int result = customerService.insertCustomer(customerForm); 
		
		if (result == 1) {// 가입 완 		  
			return ViewRoutes.사용자_로그인; 
		} else { // 예외발생
			return ViewRoutes.사용자_추가;
		}		
	}

	// delete (탈퇴) update(customerActive : Y -> N), delete(customerImg ,
	// customerDetail)
	@GetMapping("/delete")
	public String deleteCustomer(Model model) {
		return ViewRoutes.사용자_삭제;
	}

	// delete (탈퇴) Act
	@PostMapping("/delete")
	public String deleteCustomer(Customer customer, HttpSession session) {
		
		
		int result = customerService.deleteCustomer(customer);
		if (result == 1) { // 탈퇴 완 --> login 창으로 이동
			session.invalidate();
			return ViewRoutes.사용자_로그인;
		} else { // 예외발생
			return ViewRoutes.사용자_삭제;
		}

	}

	// 마이페이지
	@GetMapping("/customerOne")
	public String customerOne(HttpSession session, Model model) {
		Map<String,Object> loginCustomer = (Map) session.getAttribute("loginCustomer");

		Map<String, Object> resultMap = customerService.customerOne((int) loginCustomer.get("customerNo"));
		model.addAttribute("resultMap", resultMap);

		return ViewRoutes.사용자_정보_확인;
	}

	// 내정보 수정 Form
	// 접속 전 PW 확인
	@GetMapping("/updateOneForPw")
	public String customerOneForCheckPw() {
		return ViewRoutes.사용자_암호_확인;
	}
	// PW확인 후 Form 접속
	@PostMapping("/updateOneForm")
	public String updateCustomerOne(HttpSession session, Model model , Customer customer) {
		
			log.info("PW 일치, 접속성공");

			Map<String, Object> resultMap = customerService.customerOne(customer.getCustomerNo());

			// Email 값 표기
			String customerEmail = (String) resultMap.get("customerEmail");
			String customerEmailId = customerEmail.substring(0, customerEmail.lastIndexOf("@"));
			String customerEmailJuso = customerEmail.substring(customerEmail.lastIndexOf("@") + 1);
			resultMap.put("emailId", customerEmailId);
			resultMap.put("emailJuso", customerEmailJuso);
			model.addAttribute("resultMap", resultMap);

			return ViewRoutes.사용자_정보_수정;	
	}
	// 내정보 수정 Act
	@PostMapping("/updateOne")
	public String updateCustomerOne(HttpSession session, CustomerForm customerForm, 
									String address1, String address2, String address3) {

		customerForm.setCustomerAddress(address1 + " " + address2 + address3);

		Map<String,Object> loginCustomer = (Map) session.getAttribute("loginCustomer");
		customerService.updateCustomerOne(customerForm, (int) loginCustomer.get("customerNo"));
		return Redirect(ViewRoutes.사용자_정보_확인);
				
	}

	// PW 수정 Form
	@GetMapping("/updatePw")
	public String updateCustomerPw(Model model) { // ID값 표기 위한 세션 세팅
		return "customer/updatePw";
	}
	// PW 수정 Act
	@PostMapping("/updatePw")
	public String updateCustomerPw(HttpSession session, Customer customer) {
		int result = 0;
		result = customerService.updateCustomerPw(customer);	
			
		if(result == 1) {
			session.invalidate();		
			return ViewRoutes.사용자_로그인;
		} else {			
			return ViewRoutes.사용자_암호_변경;
		}	
	}

	// logout -> login.jsp로 이동
	@GetMapping("/logout")
	public String logoutCustomer(HttpSession session) {
		if(session.getAttribute("loginCustomer") != null) {
			session.invalidate();
		}
		return  ViewRoutes.사용자_로그인;
	}
	
	@PostMapping("/pwCheck")
	@ResponseBody	// PW 체크로직
	public int pwCheck(@RequestBody Customer customer) {
		int result = 0;
		boolean check = customerService.loginCustomer(customer) != null;
		if(check) {	// PW 일치
			result = 1;
		}		
		return result;
	}
	
	// ID 중복체크
	@PostMapping("/idCheck")
	@ResponseBody
	public int idCheck(@RequestBody Customer customer) {
		int result = 0;
		boolean check = customerService.checkId(customer).isEmpty();
		if(!check) { // id 중복
			log.info(customer.getCustomerId() + " / 중복 ID");
			result = 1;
		}
		return result;
	}
}
