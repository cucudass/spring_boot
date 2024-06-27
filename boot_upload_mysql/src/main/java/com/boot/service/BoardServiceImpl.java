package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardAttachDAO;
import com.boot.dao.BoardDAO;
import com.boot.dto.BoardDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("BoardService")
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public ArrayList<BoardDTO> list() {
		log.info("@# BoardServiceImpl list");
		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		//model.addAttribute("list", dao.list());
		ArrayList<BoardDTO> list = dao.list();
		
		return list;
	}

	@Override
	//public void write(String boardName, String boardTitle, String boardContent) {
	//public void write(HashMap<String, String> param) {
	public void write(BoardDTO boardDTO) {
		log.info("@# BoardServiceImpl write");
		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		BoardAttachDAO adao = sqlSession.getMapper(BoardAttachDAO.class);
		dao.write(boardDTO);
		log.info("@# boardDTO=>"+boardDTO);
		
		//첨부파일 있는지 체크
		log.info("@# boardDTO.getAttachlist() => "+boardDTO.getAttachList());
		if(boardDTO.getAttachList() == null || boardDTO.getAttachList().size() == 0) {
			log.info("@# getAttachlist() => null");
			return;
		}
		
		//첨부파일 있는 겅우
		boardDTO.getAttachList().forEach(attach -> {
			attach.setBoardNo(boardDTO.getBoardNo());
			log.info("@# attach=>"+attach);
			adao.inserFile(attach);
		});
	}

	@Override
	public BoardDTO contentView(HashMap<String, String> param) {
		log.info("@# BoardServiceImpl content_view");
		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.upHit(param);
		BoardDTO dto = dao.contentView(param);
		
		return dto;
	}

	@Override
	public void upHit(HashMap<String, String> param) {
		log.info("@# BoardServiceImpl upHit");
		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.upHit(param);
	}

	@Override
	public void modify(HashMap<String, String> param) {
		log.info("@# BoardServiceImpl modify");
		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.modify(param);
	}

	@Override
	public void delete(HashMap<String, String> param) {
		log.info("@# BoardServiceImpl delete");
		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.delete(param);
	}
}