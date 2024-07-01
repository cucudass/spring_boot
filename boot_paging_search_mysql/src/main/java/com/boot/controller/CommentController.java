package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.CommentDTO;
import com.boot.service.CommentService;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestBody;


@Controller
@Slf4j
@RequestMapping("/comment")
public class CommentController {
	
	@Autowired
	private CommentService service;
	
	@PostMapping("/save")
	//public ArrayList<CommentDTO> save(@RequestParam HashMap<String, String> param) {
	public @ResponseBody ArrayList<CommentDTO> save(@RequestParam HashMap<String, String> param) {
		log.info("@# save");
		log.info("@# param=>"+param);
		
		//댓글 저장
		service.save(param);
		
		//댓글 리스트
		ArrayList<CommentDTO> commentList = service.findAll(param);
		return commentList;
	}
}
