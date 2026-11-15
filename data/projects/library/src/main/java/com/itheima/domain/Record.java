package com.itheima.domain;
import java.io.Serializable;
public class Record implements Serializable {
    private Integer id;         //借阅记录id
    private String bookname;    //图书名称
    private String bookisbn;    //图书标准ISBN编号
    private String borrower;    //借阅人
    private String borrowTime;  //借阅时间
    private String remandTime;  //归还时间
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getBookname() {
        return bookname;
    }
    public void setBookname(String bookname) {
        this.bookname = bookname;
    }
    public String getBookisbn() {
        return bookisbn;
    }
    public void setBookisbn(String bookisbn) {
        this.bookisbn = bookisbn;
    }
    public String getBorrower() {
        return borrower;
    }
    public void setBorrower(String borrower) {
        this.borrower = borrower;
    }
    public String getBorrowTime() {
        return borrowTime;
    }
    public void setBorrowTime(String borrowTime) {
        this.borrowTime = borrowTime;
    }
    public String getRemandTime() {
        return remandTime;
    }
    public void setRemandTime(String remandTime) {
        this.remandTime = remandTime;
    }
}
