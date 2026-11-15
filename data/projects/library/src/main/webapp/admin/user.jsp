<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="utf-8">
    <title>员工管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AdminLTE.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
    <script src="${pageContext.request.contextPath}/js/my.js"></script>
</head>

<body class="hold-transition skin-red sidebar-mini">
<!-- .box-body -->
<div class="box-header with-border">
    <h3 class="box-title">员工管理</h3>
</div>
<div class="box-body">
    <%--新增按钮：如果当前登录用户是管理员，页面展示新增按钮--%>
    <c:if test="${USER_SESSION.role =='admin'}">
        <div class="pull-left">
            <div class="form-group form-inline">
                <div class="btn-group">
                    <button type="button" class="btn btn-default" title="新建" data-toggle="modal"
                            data-target="#addOrEditUserModal" onclick="resetUserForm()"> 新增
                    </button>
                </div>
            </div>
        </div>
    </c:if>
    <%--新增按钮 /--%>
    <!--工具栏 数据搜索 -->
    <div class="box-tools pull-right">
        <div class="has-feedback">
            <form action="${pageContext.request.contextPath}/user/search" method="post">
                姓名：<input name="name" value="${search.name}">&nbsp&nbsp&nbsp&nbsp
                邮箱：<input name="email" value="${search.email}">&nbsp&nbsp&nbsp&nbsp
                <input class="btn btn-default" type="submit" value="查询">
            </form>
        </div>
    </div>
    <!--工具栏 数据搜索 /-->
    <!-- 数据列表 -->
    <div class="table-box">
        <!-- 数据表格 -->
        <table id="dataList" class="table table-bordered table-striped table-hover dataTable text-center">
            <thead>
            <tr>
                <th class="sorting_asc">姓名</th>
                <th class="sorting">邮箱</th>
                <th class="sorting">角色</th>
                <th class="sorting">状态</th>
                <th class="sorting">入职日期</th>
                <th class="text-center">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pageResult.rows}" var="user">
                <tr>
                    <td>${user.name}</td>
                    <td>${user.email}</td>
                    <td>
                        <c:if test="${user.role =='admin'}">管理员</c:if>
                        <c:if test="${user.role =='user'}">员工</c:if>
                    </td>
                    <td>
                        <c:if test="${user.status ==0}">在职</c:if>
                        <c:if test="${user.status ==1}">离职</c:if>
                    </td>
                    <td>${user.hiredate}</td>
                    <td class="text-center">
                        <c:if test="${USER_SESSION.role =='admin'}">
                            <button type="button" class="btn bg-olive btn-xs" data-toggle="modal"
                                    data-target="#addOrEditUserModal" onclick="findUserById(${user.id})"> 编辑
                            </button>
                            <button type="button" class="btn bg-red btn-xs" onclick="delUser(${user.id})"> 办理离职
                            </button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <!--数据表格/-->
        <%--分页插件--%>
        <div id="pagination" class="pagination"></div>
    </div>
    <!--数据列表/-->
</div>
<!-- /.box-body -->

<!-- 添加和编辑员工的模态窗口 -->
<div class="modal fade" id="addOrEditUserModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="myModalLabel">员工信息</h3>
            </div>
            <div class="modal-body">
                <form id="addOrEditUser">
                    <%--员工的id,不展示在页面--%>
                    <span><input type="hidden" id="uid" name="id"></span>
                    <table class="table table-bordered table-striped" width="800px">
                        <tr>
                            <td>姓名</td>
                            <td><input class="form-control" placeholder="姓名" name="name" id="uname"></td>
                            <td>邮箱</td>
                            <td><input class="form-control" placeholder="邮箱" name="email" id="uemail"></td>
                        </tr>
                        <tr>
                            <td>密码</td>
                            <td><input class="form-control" placeholder="密码" name="password" id="upassword"></td>
                            <td>角色</td>
                            <td>
                                <select class="form-control" id="urole" name="role">
                                    <option value="user">员工</option>
                                    <option value="admin">管理员</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success" data-dismiss="modal" aria-hidden="true" id="aoe" onclick="addOrEditUser()">保存
                </button>
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">关闭</button>
            </div>
        </div>
    </div>
</div>

</body>
<script>
    /*分页插件展示的总页数*/
    pageargs.total = Math.ceil(${pageResult.total}/pageargs.pagesize);
    /*分页插件当前的页码*/
    pageargs.cur = ${pageNum}
    /*分页插件页码变化时将跳转到的服务器端的路径*/
    pageargs.gourl = "${gourl}"
    /*保存搜索框中的搜索条件，页码变化时携带之前的搜索条件*/
    userVO.name = "${search.name}"
    userVO.email = "${search.email}"
    /*分页效果*/
    pagination(pageargs);
</script>
</html>
