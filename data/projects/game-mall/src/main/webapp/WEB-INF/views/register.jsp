
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>游戏商城 - 用户注册</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); min-height: 100vh; margin: 0; }
        .container { width: 400px; margin: 80px auto; padding: 30px; background: #2d3436; border-radius: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.3); }
        h2 { text-align: center; color: #00cec9; margin-bottom: 30px; font-size: 24px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 8px; color: #b2bec3; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #4a5568; border-radius: 6px; font-size: 14px; box-sizing: border-box; background: #1a1a2e; color: white; }
        .form-group input:focus { outline: none; border-color: #00cec9; }
        .btn { width: 100%; padding: 12px; background: linear-gradient(135deg, #00cec9 0%, #81ecec 100%); color: #1a1a2e; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; }
        .btn:hover { opacity: 0.9; }
        .error { color: #ff6b6b; text-align: center; margin-bottom: 15px; }
        .link { text-align: center; margin-top: 15px; }
        .link a { color: #00cec9; text-decoration: none; }
        .link a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h2>游戏商城 - 用户注册</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/user/doRegister" method="post">
            <div class="form-group">
                <label>用户名：</label>
                <input type="text" name="username" required placeholder="请输入用户名">
            </div>
            <div class="form-group">
                <label>密码：</label>
                <input type="password" name="password" required placeholder="请输入密码">
            </div>
            <div class="form-group">
                <label>邮箱：</label>
                <input type="email" name="email" required placeholder="请输入邮箱">
            </div>
            <div class="form-group">
                <label>手机号：</label>
                <input type="tel" name="phone" placeholder="请输入手机号">
            </div>
            <button type="submit" class="btn">注册</button>
        </form>
        <div class="link">
            <a href="${pageContext.request.contextPath}/user/login">已有账号？点击登录</a>
        </div>
    </div>
</body>
</html>
