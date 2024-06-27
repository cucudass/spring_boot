package com.boot.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardAttachDAO;
import com.boot.dto.BoardAttachDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("UploadService")
public class UploadServiceImpl implements UploadService {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public List<BoardAttachDTO> getFileList(int boardNo) {
		log.info("@# UploadServiceImpl getFileList");
		
		BoardAttachDAO dao = sqlSession.getMapper(BoardAttachDAO.class);

		return dao.getFileList(boardNo);
	}
}