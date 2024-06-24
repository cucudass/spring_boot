package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dao.ItemDAO;

public interface ItemService {
	public ArrayList<ItemDAO> list();
	public void insert(HashMap<String, String> param);
}