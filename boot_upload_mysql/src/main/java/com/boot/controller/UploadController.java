package com.boot.controller;

import java.awt.PageAttributes.MediaType;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;
import com.boot.service.UploadService;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Slf4j
public class UploadController {
	
	@Autowired
	private UploadService service;
	
	@PostMapping("/uploadAjaxAction")
	//public void uploadAjaxPost(MultipartFile[] uploadFile) {
	public ResponseEntity<List<BoardAttachDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		//파일 정보를 저장
		log.info("upload ajax post...");
		
		ArrayList<BoardAttachDTO> list = new ArrayList<>();
		
		String uploadFolder = "D:\\dev\\upload";
		String uploadFolderPath = getFolder();//년월일 폴더 생성 메소드
		//"D:\\dev\\upload"+년월일 폴더
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("@# uploadPath =>"+uploadPath);
		
		//폴더 없으면 폴더 생성
		if(!uploadPath.exists()) {
			uploadPath.mkdirs();
		}
		//여러 파일 정보를 저장(폴더)
		for (MultipartFile multipartFile : uploadFile) {
			log.info("==============================");
			log.info("@# 파일 이름 => "+multipartFile.getOriginalFilename()); //업로드되는 파일 이름
			log.info("@# 파일 크기 => "+multipartFile.getSize()); //업로드되는 파일 크기
			
			String uploadFileName = multipartFile.getOriginalFilename();
			UUID uuid = UUID.randomUUID(); //중복 방지 랜덤 난수 생성
			log.info("@# uuid => "+uuid);
			
			BoardAttachDTO boardattachDTO = new BoardAttachDTO();
			boardattachDTO.setFileName(uploadFileName);
			boardattachDTO.setUuid(uuid.toString());
			boardattachDTO.setUploadPath(uploadFolderPath);
			log.info("@# boardattachDTO 01 => "+boardattachDTO);
			
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			log.info("@# uuid_uploadFileName => "+uploadFileName);
			
			//saveFile : 경로하고 파일이름
			File saveFile = new File(uploadPath, uploadFileName);
			FileInputStream fis = null;
			try {
				//transferTo : savaFile 내용을 저장
				multipartFile.transferTo(saveFile);
				//참이면 이미지 파일
				if(checkImageType(saveFile)) {
					//썸네일 추가 로직
					boardattachDTO.setImage(true);
					log.info("@# boardattachDTO 02 => "+boardattachDTO);
					
					fis = new FileInputStream(saveFile);
					//썸네일 파일은 s_를 앞에 추가
					FileOutputStream thumnail = new FileOutputStream(new File(uploadPath, "s_"+uploadFileName));
					//썸내일 파일 형식을 100*100 크기로 생성
					Thumbnailator.createThumbnail(fis, thumnail, 100, 100);
					thumnail.close();
				}
				
				list.add(boardattachDTO);
				log.info("@# list.add()");
			} catch(Exception e) {
				log.error(e.getMessage());
			} finally {
				try {
					if(fis != null) fis.close();
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
		}// end for
		return new ResponseEntity<List<BoardAttachDTO>>(list, HttpStatus.OK);
	}
	
	//날짜별 폴더 생성 
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		
		log.info("@# str=>"+str);
		log.info("@# separator=>"+File.separator); //시스템 종속 기본 이름 구분 문자
		
		return str.replace("-", File.separator);
	}
	
	//이미지 체크 여부
	private Boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			log.info("@# contentType => "+contentType);
			
			//startsWith: 파일종류 판단
			return contentType.startsWith("image"); //참이면 이미지 파일
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	//이미지 파일을 받아서 화면에 출력(byte 배열타입)
	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName) {
		//폴더에 저장된 파일을 화면에 출력
		log.info("@# fileName=> "+fileName);
		
		//업로드 파일경로+이름
		File file = new File("D:\\dev\\upload\\"+fileName);
		log.info("@# file=> "+file);
		
		ResponseEntity<byte[]> result = null;
		HttpHeaders headers = new HttpHeaders();
		try {
			//파일타입을 헤더에 추가
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
			//파일정보를 byte 배열로 복사+헤더정보+http상태 정상을 결과에 저장
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return result; //결과를 jsp에 반환
	}
	
	@PostMapping("/deleteFile")
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		log.info("@# deleteFile fileName=> "+fileName);
		File file = null;
		try {
			//URLDecoder.decode : 서버에 올라간 파일을 삭제하기 위해서 디코딩
			file = new File("D:\\dev\\upload\\"+URLDecoder.decode(fileName, "UTF-8"));
			file.delete();
			
			//이미지 파일이면 썸네일도 삭제
			if(type.equals("image")) {
				//getAbsolutePath: 절대 경로(full path)
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("@# largeFileName=>"+largeFileName);
				
				file = new File(largeFileName);
				file.delete();
			}
		} catch(Exception e) {
			e.printStackTrace();
			//오류 발생 시 404 not found 처리
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		//deleted : success의 result로 전송
		return new ResponseEntity<String>("deleted", HttpStatus.OK); //jsp단에서 경고창으로 출력
	}
	
	@GetMapping(value ="/getFileList")
	public ResponseEntity<List<BoardAttachDTO>> getFileList(@RequestParam HashMap<String, String> param) {
		log.info("@# getFileList");
		log.info("@# param=>"+param);
		log.info("@# boardNo=>"+param.get("boardNo"));
		
		return new ResponseEntity<>(service.getFileList(Integer.parseInt(param.get("boardNo"))), HttpStatus.OK);
	}
}