package com.boot.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.dto.EmpDeptDTO;
import com.boot.service.EmpInfoService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpDeptContoller {
	
	@Autowired
	private EmpInfoService service;
	
	//게시판 목록 조회
	@RequestMapping("/list")
	public String list(Model model) {
		log.info("@# list");
		
		ArrayList<EmpDeptDTO> list = service.list();
		model.addAttribute("list", list);
		
		return "list";
	}
}