<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>游戏商城 - 切换角色</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); min-height: 100vh; margin: 0; }
        .container { width: 400px; margin: 100px auto; padding: 30px; background: #2d3436; border-radius: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.3); }
        h2 { text-align: center; color: #00cec9; margin-bottom: 20px; font-size: 24px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #b2bec3; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #4a5568; border-radius: 6px; font-size: 14px; box-sizing: border-box; background: #1a1a2e; color: white; }
        .form-group input:focus { outline: none; border-color: #00cec9; }
        .btn { width: 100%; padding: 12px; background: linear-gradient(135deg, #00cec9 0%, #81ecec 100%); color: #1a1a2e; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; }
        .btn:hover { opacity: 0.9; }
        .btn-secondary { background: #636e72; color: white; margin-top: 10px; }
        .error { color: #ff6b6b; text-align: center; margin-bottom: 15px; }
        .role-info { background: #1a1a2e; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .role-info p { color: #b2bec3; margin: 5px 0; }
        .role-badge { display: inline-block; padding: 5px 15px; border-radius: 20px; font-size: 14px; font-weight: bold; margin-top: 10px; }
        .role-user { background: #0984e3; color: white; }
        .role-admin { background: #d63031; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h2>切换角色</h2>
        
        <div class="role-info">
            <p>当前用户：${user.username}</p>
            <p>当前角色：<span class="role-badge ${user.role == 1 ? 'role-admin' : 'role-user'}">${user.role == 1 ? '管理员' : '普通用户'}</span></p>
            <p>即将切换到：<span class="role-badge ${targetRole == 1 ? 'role-admin' : 'role-user'}">${targetRole == 1 ? '管理员' : '普通用户'}</span></p>
        </div>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/doSwitchRole" method="post">
            <input type="hidden" name="role" value="${targetRole}">
            <div class="form-group">
                <label>请输入当前密码以验证身份：</label>
                <input type="password" name="password" required placeholder="请输入密码">
            </div>
            <button type="submit" class="btn">确认切换</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/game/list'">取消</button>
        </form>
    </div>
</body>
</html>