<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑用户</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #1a1a2e;
            min-height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: #2d3436;
            padding: 40px;
            border-radius: 12px;
            width: 400px;
        }
        h2 {
            color: #00cec9;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            color: #b2bec3;
            margin-bottom: 8px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #333;
            border-radius: 5px;
            background: #1a1a2e;
            color: white;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #00cec9;
            color: #1a1a2e;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            opacity: 0.85;
        }
        .error {
            color: #ff6b6b;
            margin-bottom: 15px;
            text-align: center;
        }
        a {
            display: block;
            text-align: center;
            color: #636e72;
            text-decoration: none;
            margin-top: 15px;
        }
        a:hover {
            color: #00cec9;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>编辑用户</h2>
        <c:if test="${error != null}">
            <div class="error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/user/admin/doEdit" method="post">
            <input type="hidden" name="id" value="${user.id}">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" name="username" value="${user.username}" required>
            </div>
            <div class="form-group">
                <label>邮箱</label>
                <input type="email" name="email" value="${user.email}">
            </div>
            <div class="form-group">
                <label>手机号</label>
                <input type="tel" name="phone" value="${user.phone}">
            </div>
            <div class="form-group">
                <label>角色</label>
                <select name="role">
                    <option value="0" ${user.role == 0 ? 'selected' : ''}>普通用户</option>
                    <option value="1" ${user.role == 1 ? 'selected' : ''}>管理员</option>
                </select>
            </div>
            <button type="submit">保存</button>
            <a href="${pageContext.request.contextPath}/user/admin/list">返回列表</a>
        </form>
    </div>
</body>
</html>