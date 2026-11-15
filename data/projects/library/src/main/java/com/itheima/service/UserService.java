package com.itheima.service;

import com.itheima.domain.User;
import com.itheima.entity.PageResult;

public interface UserService {
    //通过User的用户账号和用户密码查询用户信息
    User login(User user);
    //新增员工
    Integer addUser(User user);
    //办理离职
    Integer delUser(Integer id);
    //编辑员工信息
    Integer editUser(User user);
    //分页查询员工信息
    PageResult searchUsers(User user, Integer pageNum, Integer pageSize);
    //根据id查询员工信息
    User findById(Integer id);
    //检查员工姓名是否重复
    Integer checkName(String name);
    //检查员工邮箱是否重复
    Integer checkEmail(String email);

}
