package com.itheima.mapper;

import com.github.pagehelper.Page;
import com.itheima.domain.Record;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

public interface RecordMapper {
    //新增借阅记录（SQL见RecordMapper.xml）
    Integer addRecord(Record record);

    //分页查询借阅记录，支持按图书名称、借阅人模糊查询
    @Select({"<script>" +
            "SELECT * FROM record " +
            "WHERE 1=1" +
            "<if test=\"bookname != null\"> AND record_bookname LIKE CONCAT('%',#{bookname},'%')</if>" +
            "<if test=\"borrower != null\"> AND record_borrower LIKE CONCAT('%',#{borrower},'%')</if>" +
            "ORDER BY record_borrowtime DESC" +
            "</script>"})
    @Results(id = "recordMap", value = {
            @Result(id = true, column = "record_id", property = "id"),
            @Result(column = "record_bookname", property = "bookname"),
            @Result(column = "record_bookisbn", property = "bookisbn"),
            @Result(column = "record_borrower", property = "borrower"),
            @Result(column = "record_borrowtime", property = "borrowTime"),
            @Result(column = "record_remandtime", property = "remandTime")
    })
    Page<Record> searchRecords(Record record);

    //根据id删除借阅记录
    @Delete("DELETE FROM record WHERE record_id=#{id}")
    Integer delRecord(Integer id);
}
