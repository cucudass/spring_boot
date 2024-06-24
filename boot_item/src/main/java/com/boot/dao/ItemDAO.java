package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ItemDAO {
	public ArrayList<ItemDAO> list();
	public void insert(HashMap<String, String> param);
}