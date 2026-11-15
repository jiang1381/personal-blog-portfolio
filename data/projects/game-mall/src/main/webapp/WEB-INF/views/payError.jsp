<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>支付失败</title>
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
            text-align: center;
            width: 350px;
        }
        .icon {
            width: 70px;
            height: 70px;
            background: #ff6b6b;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 20px;
            font-size: 35px;
            color: white;
        }
        .title {
            color: #ff6b6b;
            font-size: 22px;
            margin-bottom: 15px;
        }
        .message {
            color: #b2bec3;
            font-size: 15px;
            margin-bottom: 25px;
        }
        .button-group {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        a {
            padding: 10px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #ff6b6b;
            color: white;
        }
        .btn-secondary {
            background: #636e72;
            color: white;
        }
        a:hover {
            opacity: 0.85;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">X</div>
        <div class="title">支付失败</div>
        <div class="message">${errorMsg}</div>
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/order/list" class="btn-primary">返回订单</a>
            <a href="${pageContext.request.contextPath}/game/list" class="btn-secondary">继续购物</a>
        </div>
    </div>
</body>
</html>