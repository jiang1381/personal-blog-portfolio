package com.itheima.controller;

import com.itheima.domain.User;
import com.itheima.entity.PageResult;
import com.itheima.entity.Result;
import com.itheima.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class UserController {
    //注入userService
    @Autowired
    private UserService userService;
    /*
    用户登录
    */
    @RequestMapping("/login")
    public  String login(User user, HttpServletRequest request){
        try  {
            User u=userService.login(user);
/*
用户账号和密码是否查询出用户信息
是：将用户信息存入Session，并跳转到后台首页
否：Request域中添加提示信息，并转发到登录页面
*/
            if (u!=null){
                request.getSession().setAttribute("USER_SESSION",u);
                return  "redirect:/admin/main.jsp";
            }
            request.setAttribute("msg","用户名或密码错误");
            return  "forward:/admin/login.jsp";
        }catch (Exception e){
            e.printStackTrace();
            request.setAttribute("msg","系统错误");
            return  "forward:/admin/login.jsp";
        }
    }
    /*
注销登录
 */
    @RequestMapping("/logout")
    public String logout( HttpServletRequest request){
        try {
            HttpSession session = request.getSession();
            //销毁Session
            session.invalidate();
            return  "forward:/admin/login.jsp";
        }catch(Exception e){
            e.printStackTrace();
            request.setAttribute("msg","系统错误");
            return  "forward:/admin/login.jsp";
        }
    }

    /*
    新增员工
     */
    @ResponseBody
    @RequestMapping("/user/addUser")
    public Result addUser(User user) {
        try {
            Integer count = userService.addUser(user);
            if (count != 1) {
                return new Result(false, "新增失败!");
            }
            return new Result(true, "新增成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "新增失败!");
        }
    }

    /*
    办理离职
     */
    @ResponseBody
    @RequestMapping("/user/delUser")
    public Result delUser(Integer id) {
        try {
            Integer count = userService.delUser(id);
            if (count != 1) {
                return new Result(false, "离职办理失败!");
            }
            return new Result(true, "离职办理成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "离职办理失败!");
        }
    }

    /*
    编辑员工信息
     */
    @ResponseBody
    @RequestMapping("/user/editUser")
    public Result editUser(User user) {
        try {
            Integer count = userService.editUser(user);
            if (count != 1) {
                return new Result(false, "修改失败!");
            }
            return new Result(true, "修改成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "修改失败!");
        }
    }

    /*
    分页查询员工信息
     */
    @RequestMapping("/user/search")
    public ModelAndView search(User user, Integer pageNum, Integer pageSize, HttpServletRequest request) {
        if (pageNum == null) {
            pageNum = 1;
        }
        if (pageSize == null) {
            pageSize = 10;
        }
        //查询到的员工信息
        PageResult pageResult = userService.searchUsers(user, pageNum, pageSize);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("user");
        //将查询到的数据存放在 ModelAndView的对象中
        modelAndView.addObject("pageResult", pageResult);
        //将查询的参数返回到页面，用于回显到查询的输入框中
        modelAndView.addObject("search", user);
        //将当前页码返回到页面，用于分页插件的分页显示
        modelAndView.addObject("pageNum", pageNum);
        //将当前查询的控制器路径返回到页面，页码变化时继续向该路径发送请求
        modelAndView.addObject("gourl", request.getContextPath() + "/user/search");
        return modelAndView;
    }

    /*
    根据id查询员工信息
     */
    @ResponseBody
    @RequestMapping("/user/findById")
    public User findById(Integer id) {
        return userService.findById(id);
    }

    /*
    检查员工姓名是否重复
     */
    @ResponseBody
    @RequestMapping("/user/checkName")
    public Result checkName(String name) {
        try {
            Integer count = userService.checkName(name);
            if (count > 0) {
                return new Result(false, "名字重复!");
            }
            return new Result(true, "名字可用!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "校验失败!");
        }
    }

    /*
    检查员工邮箱是否重复
     */
    @ResponseBody
    @RequestMapping("/user/checkEmail")
    public Result checkEmail(String email) {
        try {
            Integer count = userService.checkEmail(email);
            if (count > 0) {
                return new Result(false, "邮箱重复!");
            }
            return new Result(true, "邮箱可用!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "校验失败!");
        }
    }
}
