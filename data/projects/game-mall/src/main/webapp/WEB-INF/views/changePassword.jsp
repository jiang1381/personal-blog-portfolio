<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
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
        input {
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
        .success {
            color: #00cec9;
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
        <h2>修改密码</h2>
        <c:if test="${error != null}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${success != null}">
            <div class="success">${success}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/user/doChangePassword" method="post">
            <div class="form-group">
                <label>原密码</label>
                <input type="password" name="oldPassword" required placeholder="请输入原密码">
            </div>
            <div class="form-group">
                <label>新密码</label>
                <input type="password" name="newPassword" required placeholder="请输入新密码">
            </div>
            <div class="form-group">
                <label>确认新密码</label>
                <input type="password" name="confirmPassword" required placeholder="请再次输入新密码">
            </div>
            <button type="submit">修改密码</button>
            <a href="${pageContext.request.contextPath}/user/profile">返回个人设置</a>
        </form>
    </div>
</body>
</html>