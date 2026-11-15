<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>操作成功</title>
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
            background: #00cec9;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 20px;
            font-size: 35px;
            color: #1a1a2e;
        }
        .title {
            color: #00cec9;
            font-size: 22px;
            margin-bottom: 15px;
        }
        .message {
            color: #b2bec3;
            font-size: 15px;
            margin-bottom: 20px;
        }
        .detail {
            color: #636e72;
            font-size: 13px;
            margin-bottom: 25px;
            padding: 10px;
            background: #1a1a2e;
            border-radius: 6px;
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
            background: #00cec9;
            color: #1a1a2e;
        }
        .btn-secondary {
            background: #636e72;
            color: white;
        }
        a:hover {
            opacity: 0.85;
        }
        .auto-redirect {
            color: #636e72;
            font-size: 12px;
            margin-top: 15px;
        }
        .countdown {
            color: #fdcb6e;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">&#10003;</div>
        <div class="title">${title != null ? title : '操作成功'}</div>
        <div class="message">${message != null ? message : '操作已成功完成'}</div>
        <c:if test="${detail != null}">
            <div class="detail">${detail}</div>
        </c:if>
        <div class="auto-redirect">
            页面将在 <span class="countdown" id="countdown">3</span> 秒后自动跳转
        </div>
    </div>
    
    <script>
        var seconds = 3;
        var countdownElement = document.getElementById('countdown');
        <% 
            String jsRedirectUrl = (String) request.getAttribute("redirectUrl");
            if (jsRedirectUrl == null || jsRedirectUrl.isEmpty()) {
                jsRedirectUrl = "/game/list";
            }
        %>
        var redirectUrl = '<%= request.getContextPath() + jsRedirectUrl %>';
        
        var timer = setInterval(function() {
            seconds--;
            countdownElement.textContent = seconds;
            if (seconds <= 0) {
                clearInterval(timer);
                window.location.href = redirectUrl;
            }
        }, 1000);
    </script>
</body>
</html>