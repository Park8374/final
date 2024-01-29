package com.example.gym.controller;

import com.example.gym.service.BranchService;
import com.example.gym.service.NoticeService;
import com.example.gym.service.ProgramService;
import com.example.gym.vo.Branch;
import com.example.gym.vo.Notice;
import com.example.gym.vo.Page;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController extends DefaultController {

    @Autowired
    NoticeService noticeService;

    @Autowired
    BranchService branchService;

    @Autowired
    ProgramService programService;

    @GetMapping("/")
    public String index(HttpSession session, Model model) {
        return home(session, model);
    }

    @GetMapping("/home")
    public String home(HttpSession session, Model model) {
        Page page = Page.builder().rowPerPage(Integer.MAX_VALUE).build();
        List<Branch> branchList = branchService.getBranchList(page);

        Map<String, Object> programList = programService.selectProgramListService(
            session,
            1,
            "Y",
            ""
        );
        model.addAttribute("programList", toJson(programList));
        model.addAttribute("branchList", toJson(branchList));

        page.setRowPerPage(13);
        int totalCount = noticeService.getNoticeTotal(); // 게시글 총 갯수
        page.setTotalCount(totalCount);

        // 서비스 호출
        List<Notice> noticeList = noticeService.getNoticeList(page);
        model.addAttribute("noticeList", toJson(noticeList));

        // 모델객체에 담아서 뷰에 전달
        model.addAttribute("page", page);
        return "home";
    }

    @GetMapping("/emailCheck")
    @ResponseBody
    public ResponseEntity<Boolean> emailCheck() {
        return ResponseEntity.ok(Math.random() >= 0.5);
    }

    @GetMapping("/dashboard")
    public String dashboard() {
        return "dashboard";
    }
}
