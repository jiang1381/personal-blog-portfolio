-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: cloudlibrary
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `cloudlibrary`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cloudlibrary` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `cloudlibrary`;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `book_id` int NOT NULL AUTO_INCREMENT COMMENT '图书编号',
  `book_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书名称',
  `book_isbn` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书标准ISBN编号',
  `book_press` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书出版社',
  `book_author` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书作者',
  `book_pagination` int DEFAULT NULL COMMENT '图书页数',
  `book_price` double(10,0) DEFAULT NULL COMMENT '图书价格',
  `book_uploadtime` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书上架时间',
  `book_status` varchar(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '图书状态（0：可借阅，1：借阅中，2：归还中，3：已下架）',
  `book_borrower` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书借阅人',
  `book_borrowtime` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书借阅时间',
  `book_returntime` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书预计归还时间',
  PRIMARY KEY (`book_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,'Java基础案例教程（第2版）','9787115547477','人民邮电出版社','张三',291,59,'2020-12-11','0',NULL,NULL,NULL),(2,'挪威的森林','9787546205618','上海译文出版社','村上春树',380,34,'2020-12-12','0',NULL,NULL,NULL),(4,'JavaWeb程序设计任务教程','9787115439369','人民邮电出版社','张三',419,56,'2020-12-14','0',NULL,NULL,NULL),(5,'Java基础入门（第2版）','9787302511410','清华大学出版社','张三',413,59,'2020-12-15','0',NULL,NULL,NULL),(6,'SpringCloud微服务架构开发','9787115529046','人民邮电出版社','张三',196,43,'2020-12-16','0',NULL,NULL,NULL),(7,'SpringBoot企业级开发教程','9787115512796','人民邮电出版社','张三',270,56,'2020-12-17','0',NULL,NULL,NULL),(8,'Spark大数据分析与实战','9787302534327','清华大学出版社','张三',228,49,'2020-12-18','0',NULL,NULL,NULL),(10,'边城','9787543067028','武汉出版社','沈从文',368,26,'2020-12-20','0',NULL,NULL,NULL),(12,'自在独行','9787535488473','长江文艺出版社','贾平凹',320,39,'2020-12-22','0',NULL,NULL,NULL),(13,'沉默的巡游','9787544280662','南海出版公司','东野圭吾',400,59,'2020-12-23','1','张三','2020-12-11','2020-12-23'),(15,'测试图书','9780000000000','测试出版社','测试作者',100,66,'2026-10-30','3',NULL,NULL,NULL);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `record`
--

DROP TABLE IF EXISTS `record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `record` (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '借阅记录id',
  `record_bookname` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '借阅的图书名称',
  `record_bookisbn` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '借阅的图书的ISBN编号',
  `record_borrower` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书借阅人',
  `record_borrowtime` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书借阅时间',
  `record_remandtime` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图书归还时间',
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `record`
--

LOCK TABLES `record` WRITE;
/*!40000 ALTER TABLE `record` DISABLE KEYS */;
INSERT INTO `record` VALUES (23,'Java基础案例教程（第2版）','9787115547477','张三','2020-12-21','2020-12-21'),(24,'沉默的巡游','9787544280662','张三','2020-12-11','2021-01-06'),(25,'边城','9787543067028','root','2026-10-30','2026-12-15'),(26,'Java基础案例教程（第2版）','9787115547477','root','2026-10-30','2026-10-31');
/*!40000 ALTER TABLE `record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_name` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户名称',
  `user_password` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户密码',
  `user_email` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户邮箱（用户账号）',
  `user_role` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户角色（admin：管理员，user：普通用户）',
  `user_status` varchar(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户状态（0：正常，1：离职）',
  `user_hiredate` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '入职时间',
  `user_departuredate` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '离职时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'root','12345','root@cloudlibrary.com','admin','0','2020-12-01',NULL),(2,'user','user','zhangsan@itcast.cn','user','0','2020-12-02',NULL),(3,'李四','123456','lisi@itcast.cn','user','0','2020-12-03',NULL),(4,'测试员工','123456','test@test.com','user','1','2026-10-30',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-30  2:36:17
