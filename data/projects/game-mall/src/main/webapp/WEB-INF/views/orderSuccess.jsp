<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>下单成功</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            color: #fff;
        }
        .success-container {
            text-align: center;
            background: rgba(255,255,255,0.1);
            padding: 4rem;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        .success-icon {
            width: 100px;
            height: 100px;
            background: #28a745;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 2rem;
            font-size: 3rem;
        }
        h1 {
            color: #28a745;
            margin-bottom: 1rem;
        }
        .order-info {
            margin: 2rem 0;
            padding: 1.5rem;
            background: rgba(0,0,0,0.2);
            border-radius: 10px;
        }
        .order-info p {
            margin-bottom: 0.5rem;
        }
        .order-info .order-no {
            font-size: 1.2rem;
            color: #00d4ff;
        }
        .order-items {
            margin: 2rem 0;
            text-align: left;
        }
        .order-items h3 {
            margin-bottom: 1rem;
            color: #00d4ff;
        }
        .item-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 1rem 0;
            font-size: 1.2rem;
            color: #00d4ff;
        }
        .btn-group {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
        }
        .btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: #fff;
        }
        .btn-primary {
            background: #00d4ff;
        }
        .btn-primary:hover {
            background: #00a8cc;
        }
        .btn-secondary {
            background: rgba(255,255,255,0.2);
        }
        .btn-secondary:hover {
            background: rgba(255,255,255,0.3);
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">✓</div>
        <h1>下单成功!</h1>
        <p>感谢您的购买，订单已提交成功</p>
        
        <div class="order-info">
            <p class="order-no">订单号: ${order.orderNo}</p>
            <p>下单时间: <fmt:formatDate value="${order.createTime}" pattern="yyyy年MM月dd日 HH时mm分" /></p>
        </div>
        
        <div class="order-items">
            <h3>订单商品:</h3>
            <c:forEach var="item" items="${orderItems}">
                <div class="item-row">
                    <span>${item.gameName} x ${item.quantity}</span>
                    <span>¥${item.totalPrice}</span>
                </div>
            </c:forEach>
            <div class="total-row">
                <span>合计:</span>
                <span>¥${order.totalAmount}</span>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="/order/list" class="btn btn-primary">查看订单</a>
            <a href="/game/list" class="btn btn-secondary">继续购物</a>
        </div>
    </div>
</body>
</html>