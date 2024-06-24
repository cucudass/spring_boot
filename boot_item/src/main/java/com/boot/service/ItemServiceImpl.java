package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.ItemDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("ItemService")
public class ItemServiceImpl implements ItemService {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public ArrayList<ItemDAO> list() {
		log.info("@# ItemServiceImpl content_view");
		
		ItemDAO dao = sqlSession.getMapper(ItemDAO.class);
		ArrayList<ItemDAO> list = dao.list();
		
		return list;
	}

	@Override
	public void insert(HashMap<String, String> param) {
		log.info("@# ItemServiceImpl write_result");

		ItemDAO dao = sqlSession.getMapper(ItemDAO.class);
		dao.insert(param);
	}
}