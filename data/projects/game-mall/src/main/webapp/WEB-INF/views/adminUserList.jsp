<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #1a1a2e;
            margin: 0;
            padding: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        h1 {
            color: #00cec9;
        }
        a {
            padding: 10px 20px;
            background: #00cec9;
            color: #1a1a2e;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }
        a:hover {
            opacity: 0.85;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #333;
            color: #b2bec3;
        }
        th {
            background: #2d3436;
            color: #00cec9;
        }
        tr:hover {
            background: #2d3436;
        }
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 13px;
            text-decoration: none;
            display: inline-block;
            margin-right: 5px;
        }
        .edit-btn {
            background: #fdcb6e;
            color: #1a1a2e;
        }
        .delete-btn {
            background: #ff6b6b;
            color: white;
        }
        .reset-btn {
            background: #0984e3;
            color: white;
        }
        .action-btn:hover {
            opacity: 0.85;
        }
        .role-admin {
            color: #ff6b6b;
            font-weight: bold;
        }
        .role-user {
            color: #00cec9;
        }
        .back-btn {
            background: #636e72;
            color: white;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>用户管理</h1>
        <div>
            <a href="${pageContext.request.contextPath}/game/list" class="action-btn back-btn">返回首页</a>
            <a href="${pageContext.request.contextPath}/user/admin/add" class="action-btn">添加用户</a>
        </div>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>用户名</th>
                <th>邮箱</th>
                <th>手机号</th>
                <th>角色</th>
                <th>创建时间</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${users}" var="user">
                <tr>
                    <td>${user.id}</td>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>${user.phone}</td>
                    <td>
                        <span class="${user.role == 1 ? 'role-admin' : 'role-user'}">
                            ${user.role == 1 ? '管理员' : '普通用户'}
                        </span>
                    </td>
                    <td>${user.createTime}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/user/admin/edit/${user.id}" class="action-btn edit-btn">编辑</a>
                        <a href="${pageContext.request.contextPath}/user/admin/resetPassword/${user.id}" class="action-btn reset-btn">重置密码</a>
                        <a href="${pageContext.request.contextPath}/user/admin/delete/${user.id}" class="action-btn delete-btn" onclick="return confirm('确定删除该用户吗？')">删除</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>