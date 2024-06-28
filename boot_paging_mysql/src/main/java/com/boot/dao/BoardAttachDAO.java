package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.BoardAttachDTO;

@Mapper
public interface BoardAttachDAO {
	public void inserFile(BoardAttachDTO vo);
	public List<BoardAttachDTO> getFileList(int boardNo);
	public void deleteFile(String boardNo);
}
