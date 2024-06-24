package com.boot.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.service.ItemService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ItemController {
	@Autowired
	private ItemService service;
	
	@RequestMapping("/item_write")
	public String write(Model model) {
		log.info("@# item_write");
		
		return "item_write";
	}
	
	@RequestMapping("/write_result")
	public String write(@RequestParam HashMap<String, String> param) {
		log.info("@# write_result");

		service.insert(param);
		
		return "write_result";
	}
	
	@RequestMapping("/content")
	public String content() {
		log.info("@# content");
		return "redirect:content_view";
	}
	
	@RequestMapping("/content_view")
	public String content_view(@RequestParam HashMap<String, String> param, Model model) {
		log.info("@# content_view");
		
		model.addAttribute("list", service.list());
		
		return "content_view";
	}
}