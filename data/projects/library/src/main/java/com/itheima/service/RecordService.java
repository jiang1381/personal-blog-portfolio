package com.itheima.service;

import com.itheima.domain.Record;
import com.itheima.domain.User;
import com.itheima.entity.PageResult;

public interface RecordService {
    //分页查询借阅记录
    PageResult searchRecords(Record record, User user, Integer pageNum, Integer pageSize);
    //新增借阅记录
    Integer addRecord(Record record);
    //删除借阅记录
    Integer delRecord(Integer id);

}
