package com.example.gym.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.gym.mapper.ReservationMapper;
import com.example.gym.vo.ProgramReservation;

@Service
@Transactional

public class ReservationService {
	@Autowired 
	private ReservationMapper reservationMapper;
	
	// 예약 목록
	public List<Map<String, Object>> selectProgramReservationList(Map<String, Object>paramMap) {
		List<Map<String, Object>> resultReservation = reservationMapper.selectReservationList(paramMap);	
		return resultReservation;
	}
	
}
