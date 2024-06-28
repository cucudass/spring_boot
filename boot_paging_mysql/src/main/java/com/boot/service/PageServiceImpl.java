package com.boot.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.PageDAO;
import com.boot.dto.BoardDTO;
import com.boot.dto.Criteria;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("PageService")
public class PageServiceImpl implements PageService {
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<BoardDTO> listWithPaging(Criteria cri) {
		log.info("@# PageServiceImpl listWithPaging");
		log.info("@# Criteria=> "+cri);
		
		PageDAO dao = sqlSession.getMapper(PageDAO.class);
		ArrayList<BoardDTO> list = dao.listWithPaging(cri);
		
		return list;
	}
}