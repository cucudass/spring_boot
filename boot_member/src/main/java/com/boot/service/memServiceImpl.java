package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.IMemDAO;
import com.boot.dto.MemDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("memService")
public class memServiceImpl implements memService {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public ArrayList<MemDTO> loginyn(HashMap<String, String> param) {
		log.info("@# memServiceImpl content_view");
		
		IMemDAO dao = sqlSession.getMapper(IMemDAO.class);
		ArrayList<MemDTO> list = dao.loginyn(param);
		
		return list;
	}

	@Override
	public void register(HashMap<String, String> param) {
		log.info("@# ItemServiceImpl register");
		
		IMemDAO dao = sqlSession.getMapper(IMemDAO.class);
		dao.register(param);
	}
}