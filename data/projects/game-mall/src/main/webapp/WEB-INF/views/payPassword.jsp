<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>支付验证</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 2rem;
            width: 400px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        h2 {
            text-align: center;
            margin-bottom: 1.5rem;
            color: #00d4ff;
        }
        .order-info {
            background: rgba(0,0,0,0.2);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .order-info p {
            margin-bottom: 0.5rem;
        }
        .order-info p:last-child {
            margin-bottom: 0;
            font-size: 1.2rem;
            color: #00d4ff;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #b2bec3;
        }
        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #00d4ff;
            border-radius: 8px;
            background: rgba(0,0,0,0.3);
            color: #fff;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.3s;
        }
        .form-group input:focus {
            border-color: #00a8cc;
        }
        .error-msg {
            color: #ff4757;
            margin-bottom: 1rem;
            text-align: center;
        }
        .btn {
            width: 100%;
            padding: 0.75rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #00d4ff;
            color: #fff;
        }
        .btn-primary:hover {
            background: #00a8cc;
        }
        .btn-secondary {
            background: rgba(255,255,255,0.2);
            color: #fff;
            margin-top: 0.5rem;
        }
        .btn-secondary:hover {
            background: rgba(255,255,255,0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔐 支付验证</h2>
        
        <div class="order-info">
            <p>订单号: ${order.orderNo}</p>
            <p>订单金额: ¥${order.totalAmount}</p>
        </div>
        
        <form action="${pageContext.request.contextPath}/order/pay/${order.id}" method="post">
            <div class="form-group">
                <label for="password">请输入支付密码（即登录密码）</label>
                <input type="password" id="password" name="password" placeholder="请输入密码" required />
            </div>
            
            <c:if test="${not empty errorMsg}">
                <div class="error-msg">${errorMsg}</div>
            </c:if>
            
            <button type="submit" class="btn btn-primary">确认支付</button>
            <a href="${pageContext.request.contextPath}/order/list" class="btn btn-secondary" style="display: block; text-align: center; text-decoration: none;">取消支付</a>
        </form>
    </div>
</body>
</html>