package com.boot;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
//@ResponseBody
public class DemoController {
	@RequestMapping("/")
	@ResponseBody
	public String hoem() {
		log.info("Boot Gradle~");
		return "home";
	}
	
	@RequestMapping("/hello.do")
	public String hoem(Model model) {
		log.info("안녕하세요~");
		return "hello";
	}
}
