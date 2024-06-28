package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.service.BoardService;
import com.boot.service.CommentService;
import com.boot.service.UploadService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardContoller {

	@Autowired
	private BoardService service;
	@Autowired
	private CommentService commservice;
	@Autowired
	private UploadService uploadservice;
	
	//게시판 목록 조회
	@RequestMapping("/list")
	public String list(Model model) {
		log.info("@# list");
		
		ArrayList<BoardDTO> list = service.list();
		model.addAttribute("list", list);
		return "list";
	}
	
	@RequestMapping("/write")
	//public String write(HttpServletRequest request, Model model) {
	//public String write(@RequestParam HashMap<String, String> param) {
	public String write(BoardDTO boardDTO) {
		log.info("@# write");
		log.info("@# controller boardDTO => " + boardDTO);

		if(boardDTO.getAttachList() != null) {
			boardDTO.getAttachList().forEach(attach -> log.info("@# controller attach=>"+attach));
		}
		//service.write(param);
		service.write(boardDTO);
		
		return "redirect:list";
	}
	
	@RequestMapping("/write_view")
	public String write_view() {
		log.info("@# write_view");
		
		return "write_view";
	}
	
	@RequestMapping("/content_view")
	public String contentview(@RequestParam HashMap<String, String> param, Model model) {
		log.info("@# content_view");
		BoardDTO dto = service.contentView(param);
		
		//댓글 리스트
		ArrayList<CommentDTO> commentList = commservice.findAll(param);
		
		model.addAttribute("content_view", dto);
		model.addAttribute("commentList", commentList);
		
		return "content_view";
	}

	@RequestMapping("/modify")
	public String modify(@RequestParam HashMap<String, String> param) {
		log.info("@# modify");
		
		service.modify(param);
		return "redirect:list";
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam HashMap<String, String> param) {
		log.info("@# delete");
		log.info("@# parma.get(boardNo)=> "+param.get("boardNo"));
		service.delete(param);
		
		int boardNo = Integer.parseInt(param.get("boardNo"));
		
		//DB 쿼리 삭제
		List<BoardAttachDTO> fileList = uploadservice.getFileList(boardNo); 
		log.info("@# fileList=> "+fileList);
		uploadservice.deleteFiles(fileList); //실제 파일 삭제
		
		return "redirect:list";
	}
}