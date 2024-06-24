package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.MemDTO;
import com.boot.service.memService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MemController {
	
	@Autowired
	private memService service;
	
	@RequestMapping("/login")
	public String login() {
		log.info("@# login");
		
		return "login";
	}
	
	@RequestMapping("/login_ck")
	public String login_ok(@RequestParam HashMap<String, String> param) {
		log.info("@# login_ck");
		
		ArrayList<MemDTO> dto = service.loginyn(param);
		
		if(dto.isEmpty()) {
			return "redirect:login";
		} else {
			if(dto.get(0).getMem_pwd().equals(param.get("mem_pwd")))
				return "redirect:login_ok";
			else
				return "redirect:login";
		}
	}
	
	@RequestMapping("/login_ok")
	public String login_ok() {
		return "login_ok";
	}
	
	@RequestMapping("/register")
	public String register() {
		log.info("@# register");
		return "register";
	}
	
	@RequestMapping("/register_ok")
	public String register_ok(@RequestParam HashMap<String, String> param) {
		log.info("@# register_ok");
		
		service.register(param);
		
		return "redirect:login"; 
	}
}