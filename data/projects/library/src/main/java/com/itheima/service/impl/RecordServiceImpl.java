package com.itheima.service.impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.itheima.domain.Record;
import com.itheima.domain.User;
import com.itheima.entity.PageResult;
import com.itheima.mapper.RecordMapper;
import com.itheima.service.RecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class RecordServiceImpl implements RecordService {
    // 注入RecordMapper对象
    @Autowired
    private RecordMapper recordMapper;

    /**
     * 分页查询借阅记录
     * @param record 封装查询条件的对象
     * @param user 当前登录用户
     * @param pageNum 当前页码
     * @param pageSize 每页显示数量
     */
    @Override
    public PageResult searchRecords(Record record, User user, Integer pageNum, Integer pageSize) {
        // 设置分页查询的参数，开始分页
        PageHelper.startPage(pageNum, pageSize);
        //如果是普通用户，只能查询自己的借阅记录
        if (!"admin".equals(user.getRole())) {
            record.setBorrower(user.getName());
        }
        Page<Record> page = recordMapper.searchRecords(record);
        return new PageResult(page.getTotal(), page.getResult());
    }

    /**
     * 新增借阅记录
     * @param record
     */
    @Override
    public Integer addRecord(Record record) {
        return recordMapper.addRecord(record);
    }

    /**
     * 删除借阅记录
     * @param id 借阅记录id
     */
    @Override
    public Integer delRecord(Integer id) {
        return recordMapper.delRecord(id);
    }
}
