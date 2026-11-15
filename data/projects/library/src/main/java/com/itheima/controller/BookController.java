package com.itheima.controller;

import com.itheima.domain.Book;
import com.itheima.domain.User;
import com.itheima.entity.PageResult;
import com.itheima.entity.Result;
import com.itheima.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/book")
public class BookController {
    //注入BookService对象
    @Autowired
    private BookService bookService;
    /**
     * 查询最新上架的图书
     */
    @RequestMapping("/selectNewbooks")
    public ModelAndView selectNewbooks() {
//查询最新上架的5个的图书信息
        int  pageNum = 1;
        int  pageSize = 5;
        PageResult pageResult = bookService.selectNewBooks(pageNum, pageSize);
        ModelAndView modelAndView = new  ModelAndView();
        modelAndView.setViewName("books_new");
        modelAndView.addObject("pageResult", pageResult);
        return  modelAndView;
    }

    /**
     * 根据图书id查询图书信息
     * @param id 查询的图书id
     */
    @ResponseBody
    @RequestMapping("/findById")
    public Result<Book> findById(String id) {
        try {
            Book book=bookService.findById(id);
            if(book==null){
                return new Result(false,"查询图书失败！");
            }
            return new Result(true,"查询图书成功",book);
        }catch (Exception e){
            e.printStackTrace();
            return new Result(false,"查询图书失败！");
        }
    }

    /**
     * 借阅图书
     * @param book 借阅的图书
     * @return
     */
    @ResponseBody
    @RequestMapping("/borrowBook")
    public Result borrowBook(Book book, HttpSession session) {
        //获取当前登录的用户姓名
        String pname = ((User) session.getAttribute("USER_SESSION")).getName();
        book.setBorrower(pname);
        try {
            //根据图书的id和用户进行图书借阅
            Integer count = bookService.borrowBook(book);
            if (count != 1) {
                return new Result(false, "借阅图书失败!");
            }
            return new Result(true, "借阅成功，请到行政中心取书!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "借阅图书失败!");
        }
    }

    /**
     * 分页查询符合条件且未下架图书信息
     * @param book 查询的条件封装到book中
     * @param pageNum  数据列表的当前页码
     * @param pageSize 数据列表1页展示多少条数据
     */
    @RequestMapping("/search")
    public ModelAndView search(Book book, Integer pageNum, Integer pageSize, HttpServletRequest request) {
        if (pageNum == null) {
            pageNum = 1;
        }
        if (pageSize == null) {
            pageSize = 10;
        }
        //查询到的图书信息
        PageResult pageResult = bookService.search(book, pageNum, pageSize);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("books");
        //将查询到的数据存放在 ModelAndView的对象中
        modelAndView.addObject("pageResult", pageResult);
        //将查询的参数返回到页面，用于回显到查询的输入框中
        modelAndView.addObject("search", book);
        //将当前页码返回到页面，用于分页插件的分页显示
        modelAndView.addObject("pageNum", pageNum);
        //将当前查询的控制器路径返回到页面，页码变化时继续向该路径发送请求
        modelAndView.addObject("gourl", request.getRequestURI());
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/addBook")
    public Result addBook(Book book) {
        try {
            Integer count=bookService.addBook(book);
            if(count!=1) { return new Result(false, "新增图书失败!"); }
            return new Result(true, "新增图书成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "新增图书失败!");
        }
    }
    @ResponseBody
    @RequestMapping("/editBook")
    public Result editBook(Book book) {
        try {
            Integer count= bookService.editBook(book);
            if(count!=1) { return new Result(false, "编辑失败!"); }
            return new Result(true, "编辑成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "编辑失败!"); }}

    /**
     * 分页查询当前用户借阅的图书
     * @param book 查询的条件封装到book中
     * @param pageNum  数据列表的当前页码
     * @param pageSize 数据列表1页展示多少条数据
     */
    @RequestMapping("/searchBorrowed")
    public ModelAndView searchBorrowed(Book book, Integer pageNum, Integer pageSize, HttpServletRequest request) {
        if (pageNum == null) {
            pageNum = 1;
        }
        if (pageSize == null) {
            pageSize = 10;
        }
        //获取当前登录的用户信息
        User user = (User) request.getSession().getAttribute("USER_SESSION");
        //查询到的当前借阅的图书信息
        PageResult pageResult = bookService.searchBorrowed(book, user, pageNum, pageSize);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("book_borrowed");
        modelAndView.addObject("pageResult", pageResult);
        modelAndView.addObject("search", book);
        modelAndView.addObject("pageNum", pageNum);
        modelAndView.addObject("gourl", request.getRequestURI());
        return modelAndView;
    }

    /**
     * 归还图书
     * @param id 归还的图书id
     */
    @ResponseBody
    @RequestMapping("/returnBook")
    public Result returnBook(String id, HttpSession session) {
        //获取当前登录的用户信息
        User user = (User) session.getAttribute("USER_SESSION");
        try {
            boolean flag = bookService.returnBook(id, user);
            if (!flag) {
                return new Result(false, "还书失败!");
            }
            return new Result(true, "还书确认中，请先到行政中心还书!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "还书失败!");
        }
    }

    /**
     * 归还确认
     * @param id 确认归还的图书id
     */
    @ResponseBody
    @RequestMapping("/returnConfirm")
    public Result returnConfirm(String id) {
        try {
            Integer count = bookService.returnConfirm(id);
            if (count != 1) {
                return new Result(false, "确认失败!");
            }
            return new Result(true, "确认成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "确认失败!");
        }
    }

    /**
     * 删除图书（下架）
     * @param id 删除的图书id
     */
    @ResponseBody
    @RequestMapping("/delBook")
    public Result delBook(String id, HttpSession session) {
        try {
            User user = (User) session.getAttribute("USER_SESSION");
            if (user == null || !"admin".equals(user.getRole())) {
                return new Result(false, "无权限执行删除操作");
            }
            Book book = bookService.findById(id);
            if (book == null) { return new Result(false, "图书不存在"); }
            if ("1".equals(book.getStatus()) || "2".equals(book.getStatus())) {
                return new Result(false, "图书正在借阅或归还中，无法删除");
            }
            Book updateBook = new Book();
            updateBook.setId(Integer.parseInt(id));
            updateBook.setStatus("3");
            Integer count = bookService.editBook(updateBook);
            if (count == 1) { return new Result(true, "删除成功"); } else { return new Result(false, "删除失败"); }
        } catch (NumberFormatException e) {
            return new Result(false, "无效的图书ID");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false, "删除失败：" + e.getMessage());
        }
    }

}