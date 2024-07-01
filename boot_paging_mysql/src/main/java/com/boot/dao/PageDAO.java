package com.boot.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.BoardDTO;
import com.boot.dto.Criteria;

@Mapper
public interface PageDAO {
	public ArrayList<BoardDTO> listWithPaging(Criteria criteria);
	public int getTotalCount();
}
