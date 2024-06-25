package com.boot.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.EmpDeptDTO;

@Mapper
public interface EmpDeptDAO {
	public ArrayList<EmpDeptDTO> list();
}
