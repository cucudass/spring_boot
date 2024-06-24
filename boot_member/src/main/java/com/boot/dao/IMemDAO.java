package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.MemDTO;

@Mapper
public interface IMemDAO {
	public ArrayList<MemDTO> loginyn(HashMap<String, String> param);
	public void register(HashMap<String, String> param);
}