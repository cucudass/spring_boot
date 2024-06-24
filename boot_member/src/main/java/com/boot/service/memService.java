package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.MemDTO;

public interface memService {
	public ArrayList<MemDTO> loginyn(HashMap<String, String> param);
	public void register(HashMap<String, String> param);
}