package com.itheima.mapper;

import com.github.pagehelper.Page;
import com.itheima.domain.User;
import org.apache.ibatis.annotations.*;

@Mapper
public interface UserMapper {
    @Select("SELECT * FROM user WHERE user_name=#{name} AND user_password=#{password} AND user_status!='1'")
    @Results(id = "userMap",value = {
//id字段默认为false，表示不是主键
//column表示数据库表字段，property表示持久化类属性名称。
            @Result(id = true ,column = "user_id",property = "id"),
            @Result(column = "user_name",property = "name"),
            @Result(column = "user_password",property = "password"),
            @Result(column = "user_email",property = "email"),
            @Result(column = "user_role",property = "role"),
            @Result(column = "user_status",property = "status"),
            @Result(column = "user_hiredate",property = "hiredate")
    })
    User login(User user);

    //新增员工
    @Insert("INSERT INTO user(user_name,user_password,user_email,user_role,user_status,user_hiredate) " +
            "VALUES(#{name},#{password},#{email},#{role},#{status},#{hiredate})")
    Integer addUser(User user);

    //办理离职（逻辑删除，将员工状态修改为离职）
    @Update("UPDATE user SET user_status='1' WHERE user_id=#{id}")
    Integer delUser(Integer id);

    //编辑员工信息
    @Update({"<script>" +
            "UPDATE user " +
            "<set>" +
            "<if test=\"name != null\"> user_name=#{name}, </if>" +
            "<if test=\"password != null\"> user_password=#{password}, </if>" +
            "<if test=\"email != null\"> user_email=#{email}, </if>" +
            "<if test=\"role != null\"> user_role=#{role}, </if>" +
            "</set>" +
            "WHERE user_id=#{id}" +
            "</script>"})
    Integer editUser(User user);

    //分页查询在职员工信息，支持按姓名、邮箱模糊查询
    @Select({"<script>" +
            "SELECT * FROM user " +
            "WHERE user_status!='1'" +
            "<if test=\"name != null\"> AND user_name LIKE CONCAT('%',#{name},'%')</if>" +
            "<if test=\"email != null\"> AND user_email LIKE CONCAT('%',#{email},'%')</if>" +
            "ORDER BY user_id" +
            "</script>"})
    @ResultMap("userMap")
    Page<User> searchUsers(User user);

    //根据id查询员工信息
    @Select("SELECT * FROM user WHERE user_id=#{id}")
    @ResultMap("userMap")
    User findById(Integer id);

    //检查员工姓名是否重复
    @Select("SELECT count(*) FROM user WHERE user_name=#{name}")
    Integer checkName(String name);

    //检查员工邮箱是否重复
    @Select("SELECT count(*) FROM user WHERE user_email=#{email}")
    Integer checkEmail(String email);
}
