-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 24, 2023 at 04:20 PM
-- Server version: 8.0.31
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_nt3102`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `EventManager`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EventManager` (IN `eventNameVal` VARCHAR(255), IN `eventDescVal` VARCHAR(255), IN `eventIDVal` INT, IN `eventDateVal` TIMESTAMP, IN `orgIDVal` INT)   BEGIN
	SET @statusID = 1;
    INSERT INTO events (eventID,eventName,eventDesc,e_date,org_ID,statusID) VALUES (eventIDVal,eventNameVal,eventDescVal,evenDateVal,orgIDVal,@statusID);
    SET @eventID = LAST_INSERT_ID();
    SET @superID = orgIDVal;
    INSERT INTO eventrecords(eventID,superID) VALUES ( @eventID, orgIDVal);
END$$

DROP PROCEDURE IF EXISTS `RegisterModerator`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegisterModerator` (IN `org_namevalue` VARCHAR(255), IN `passwordvalue` VARCHAR(255), IN `usernamevalue` VARCHAR(255), IN `deptIDvalue` INT)   BEGIN
	SET @salt = (SUBSTRING(MD5(RAND()), 1, 10));
    SET @password = SHA2(CONCAT(passwordvalue,@salt),256);
    INSERT INTO superusers (username,password,salt) VALUES (usernamevalue,@password,@salt);
    SET @superID = LAST_INSERT_ID();
    
    INSERT INTO organization (dept_ID,org_name,superID) VALUES ( deptIDvalue, org_namevalue,@superID);
END$$

DROP PROCEDURE IF EXISTS `registerStudents`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `registerStudents` (IN `sr_codeIN` VARCHAR(10), IN `firstnameIN` VARCHAR(255), IN `lastnameIN` VARCHAR(255))   BEGIN
    INSERT INTO tb_studentinfo(lastname, firstname, course) VALUES (lastnameIN, firstnameIN, 'BSIT'); 
    SET @studid = LAST_INSERT_ID();
    INSERT INTO students(sr_code, courseID, year, section, stud_id) VALUES (sr_codeIN, 6, '3rd', 'NT-3102', @studid);
    SET @salt =  SUBSTRING(MD5(RAND()) FROM 1 FOR 10);
	SET @password = SHA2(CONCAT(sr_codeIN,@salt),256);
	INSERT INTO userstudents(sr_code,password,salt) values(sr_codeIN,@password,@salt);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `atendees_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `atendees_view`;
CREATE TABLE IF NOT EXISTS `atendees_view` (
`userID` int
,`stud_deptid` int
,`eventName` varchar(50)
,`eventDesc` varchar(50)
,`department_Name` varchar(100)
,`event_deptid` int
,`org_Name` varchar(255)
,`attendeeID` int
,`eventID` int
,`DateRegistered` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `attendance_tbl`
--

DROP TABLE IF EXISTS `attendance_tbl`;
CREATE TABLE IF NOT EXISTS `attendance_tbl` (
  `AttendanceID` int NOT NULL AUTO_INCREMENT,
  `studid` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
  `AttendanceDate` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
  `ClassSection` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
  `Room` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
  `TimeStart` time(6) NOT NULL,
  `TimeEnd` time(6) NOT NULL,
  PRIMARY KEY (`AttendanceID`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `attendance_tbl`
--

INSERT INTO `attendance_tbl` (`AttendanceID`, `studid`, `AttendanceDate`, `ClassSection`, `Room`, `TimeStart`, `TimeEnd`) VALUES
(1, '3', '2023-11-02', 'BSIT-NT-3102', 'CECS 503', '08:00:00.000000', '11:00:00.000000'),
(2, '2', '2023-11-02', 'BSIT-NT-3102', 'CECS 503', '08:00:00.000000', '11:00:00.000000'),
(3, '1', '2023-11-02', 'BSIT-NT-3102', 'CECS 503', '08:00:00.000000', '11:00:00.000000'),
(4, '3', '2023-11-04', 'BSIT-NT-3102', 'HEB 502', '12:00:00.000000', '16:00:00.000000'),
(11, '1', '2023-11-17', 'BSIT-NT-1104', 'CECS 301', '08:00:00.000000', '12:00:00.000000'),
(10, '3', '2023-11-17', 'BSCS-NT-1102', 'HEB 402', '12:00:00.000000', '16:00:00.000000'),
(14, '4', '2023-11-24', 'BSCS-NT-1102', 'HEB 402', '12:00:00.000000', '16:00:00.000000'),
(15, '5', '2023-11-24', 'BSCS-NT-1102', 'HEB 402', '12:00:00.000000', '16:00:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
CREATE TABLE IF NOT EXISTS `course` (
  `courseID` int NOT NULL AUTO_INCREMENT,
  `courseName` text NOT NULL,
  `dept_ID` int NOT NULL,
  PRIMARY KEY (`courseID`),
  KEY `dept_ID` (`dept_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`courseID`, `courseName`, `dept_ID`) VALUES
(1, 'Bachelor of Science in Business Administration', 1),
(2, 'Bachelor of Science in Management Accounting', 1),
(3, 'Bachelor of Science in Psychology', 2),
(4, 'Bachelor of Arts in Communication', 2),
(5, 'Bachelor of Industrial Technology', 3),
(6, 'Bachelor of Science in Information Technology', 4),
(7, 'Bachelor of Science in Computer Science', 4),
(8, 'Bachelor of Secondary Education', 5),
(9, 'Bachelor of Science in Industrial Engineering ', 6);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
CREATE TABLE IF NOT EXISTS `department` (
  `dept_ID` int NOT NULL AUTO_INCREMENT,
  `department_Name` varchar(100) NOT NULL,
  PRIMARY KEY (`dept_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`dept_ID`, `department_Name`) VALUES
(0, 'General Department'),
(1, 'CABEIHM'),
(2, 'CAS'),
(3, 'CIT'),
(4, 'CICS'),
(5, 'CTE'),
(6, 'CE');

-- --------------------------------------------------------

--
-- Table structure for table `eventattendees`
--

DROP TABLE IF EXISTS `eventattendees`;
CREATE TABLE IF NOT EXISTS `eventattendees` (
  `attendeeID` int NOT NULL,
  `eventID` int NOT NULL,
  `sr_code` varchar(11) NOT NULL,
  `DateRegistered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `eventattendees`
--

INSERT INTO `eventattendees` (`attendeeID`, `eventID`, `sr_code`, `DateRegistered`) VALUES
(1, 1, '21-33273', '2023-11-20 01:28:13');

-- --------------------------------------------------------

--
-- Table structure for table `eventrecords`
--

DROP TABLE IF EXISTS `eventrecords`;
CREATE TABLE IF NOT EXISTS `eventrecords` (
  `recordID` int NOT NULL AUTO_INCREMENT,
  `eventID` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) NOT NULL,
  `superID` int NOT NULL,
  PRIMARY KEY (`recordID`),
  KEY `superID` (`superID`),
  KEY `statusID` (`eventID`(250)),
  KEY `fk_eventID` (`eventID`(250))
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `eventrecords`
--

INSERT INTO `eventrecords` (`recordID`, `eventID`, `remarks`, `superID`) VALUES
(1, '1', 'NA', 1);

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `eventID` int NOT NULL AUTO_INCREMENT,
  `eventName` varchar(50) NOT NULL,
  `eventDesc` varchar(50) NOT NULL,
  `org_ID` int NOT NULL,
  `statusID` int NOT NULL,
  `e_date` datetime NOT NULL,
  PRIMARY KEY (`eventID`),
  KEY `org_ID` (`org_ID`),
  KEY `statusID` (`statusID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`eventID`, `eventName`, `eventDesc`, `org_ID`, `statusID`, `e_date`) VALUES
(1, 'sample', 'sample', 1, 1, '2023-11-19 09:32:12'),
(2, 'sample2', 'sample3', 1, 1, '2023-11-19 13:44:43');

-- --------------------------------------------------------

--
-- Table structure for table `eventstatus`
--

DROP TABLE IF EXISTS `eventstatus`;
CREATE TABLE IF NOT EXISTS `eventstatus` (
  `statusID` int NOT NULL AUTO_INCREMENT,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`statusID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `eventstatus`
--

INSERT INTO `eventstatus` (`statusID`, `status`) VALUES
(1, 'Pending'),
(2, 'Approved'),
(3, 'Cancelled');

-- --------------------------------------------------------

--
-- Stand-in structure for view `event_info`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `event_info`;
CREATE TABLE IF NOT EXISTS `event_info` (
`statusID` int
,`status` varchar(255)
,`eventID` int
,`eventName` varchar(50)
,`eventDesc` varchar(50)
,`org_ID` int
,`e_date` datetime
,`department_Name` varchar(100)
,`dept_ID` int
,`org_Name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `faculty_tbl`
--

DROP TABLE IF EXISTS `faculty_tbl`;
CREATE TABLE IF NOT EXISTS `faculty_tbl` (
  `FacultyID` int NOT NULL AUTO_INCREMENT,
  `FacultyUsername` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
  `FacultyPassword` varchar(25) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`FacultyID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `faculty_tbl`
--

INSERT INTO `faculty_tbl` (`FacultyID`, `FacultyUsername`, `FacultyPassword`) VALUES
(1, 'BSU_admin123!', 'adminAccess123BSU');

-- --------------------------------------------------------

--
-- Table structure for table `lost_items`
--

DROP TABLE IF EXISTS `lost_items`;
CREATE TABLE IF NOT EXISTS `lost_items` (
  `lostitems_id` int NOT NULL AUTO_INCREMENT,
  `item_number` varchar(255) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `date_found` date NOT NULL,
  `date_claimed` date DEFAULT NULL,
  `SecId` int DEFAULT NULL,
  `StudentId` int DEFAULT NULL,
  PRIMARY KEY (`lostitems_id`),
  KEY `SecId` (`SecId`),
  KEY `StudentId` (`StudentId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `moderatorcookies`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `moderatorcookies`;
CREATE TABLE IF NOT EXISTS `moderatorcookies` (
`superID` int
,`userName` varchar(255)
,`password` varchar(255)
,`salt` varchar(10)
,`org_ID` int
,`dept_ID` int
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `moderators`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `moderators`;
CREATE TABLE IF NOT EXISTS `moderators` (
`superID` int
,`username` varchar(255)
,`org_Name` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `notifications`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
`statusID` int
,`status` varchar(255)
,`eventID` int
,`eventName` varchar(50)
,`eventDesc` varchar(50)
,`org_ID` int
,`e_date` datetime
,`department_Name` varchar(100)
,`dept_ID` int
,`org_Name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
CREATE TABLE IF NOT EXISTS `organization` (
  `org_ID` int NOT NULL AUTO_INCREMENT,
  `dept_ID` int NOT NULL,
  `org_Name` varchar(255) NOT NULL,
  `superID` int NOT NULL,
  PRIMARY KEY (`org_ID`),
  KEY `superID` (`superID`),
  KEY `dept_ID` (`dept_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `organization`
--

INSERT INTO `organization` (`org_ID`, `dept_ID`, `org_Name`, `superID`) VALUES
(1, 1, 'Junior Philippine Association of Management Accountants', 1),
(2, 1, 'Junior Marketing Executives', 2),
(3, 1, 'College of Accountancy, Business and Economics Council', 3),
(4, 1, 'Public Administration Student Association', 4),
(5, 1, 'Association Of Operation Management Students', 5),
(6, 1, 'Young People Management Association of the Philippines', 6),
(7, 2, 'Association of College of Arts and Sciences Students', 7),
(8, 2, 'Circle of Psychology Students', 8),
(9, 2, 'Poderoso Communicador Sociedad', 9),
(10, 3, 'Alliance of Industrial Technology Students', 10),
(11, 3, 'CTRL+A', 11),
(12, 4, 'Junior Philippine Computer Society - Lipa Chapter', 12),
(13, 4, 'Tech Innovators Society', 13),
(14, 5, 'Aspiring Future Educators Guild', 14),
(15, 5, 'Language Educators Association', 15),
(16, 6, 'Junior Philippine Institute of Industrial Engineers', 16),
(17, 0, 'Red Spartan Sports Council', 17),
(18, 0, 'Supreme Student Council Lipa Campus', 18);

-- --------------------------------------------------------

--
-- Table structure for table `security_lostnfound`
--

DROP TABLE IF EXISTS `security_lostnfound`;
CREATE TABLE IF NOT EXISTS `security_lostnfound` (
  `SecId` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` enum('admin','security') DEFAULT 'security',
  `usersign` varchar(50) NOT NULL,
  PRIMARY KEY (`SecId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `studentinfoview`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `studentinfoview`;
CREATE TABLE IF NOT EXISTS `studentinfoview` (
`userID` int
,`sr_code` varchar(250)
,`password` varchar(255)
,`salt` varchar(10)
,`firstName` varchar(25)
,`lastName` varchar(25)
,`courseID` int
,`year` varchar(255)
,`section` varchar(250)
,`courseName` text
,`dept_ID` int
,`department_Name` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students` (
  `sr_code` varchar(250) NOT NULL,
  `courseID` int NOT NULL,
  `year` varchar(255) NOT NULL,
  `section` varchar(250) NOT NULL,
  `stud_id` int NOT NULL,
  PRIMARY KEY (`sr_code`),
  KEY `courseID` (`courseID`),
  KEY `stud_id` (`stud_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`sr_code`, `courseID`, `year`, `section`, `stud_id`) VALUES
('21-33273', 6, '3rd', 'NT-3102', 1),
('21-38474', 6, '3rd', 'NT-3102', 2),
('21-32782', 6, '3rd', 'NT-3102', 3),
('21-36452', 6, '3rd', 'NT-3102', 4),
('21-35509', 6, '3rd', 'NT-3102', 5),
('21-31630', 6, '3rd', 'NT-3102', 6),
('21-30506', 6, '3rd', 'NT-3102', 7),
('21-36155', 6, '3rd', 'NT-3102', 8),
('22-35794', 6, '3rd', 'NT-3102', 9),
('21-35078', 6, '3rd', 'NT-3102', 10),
('21-30802', 6, '3rd', 'NT-3102', 11),
('21-34772', 6, '3rd', 'NT-3102', 12),
('21-36111', 6, '3rd', 'NT-3102', 13),
('21-30320', 6, '3rd', 'NT-3102', 14),
('21-36991', 6, '3rd', 'NT-3102', 15),
('21-37287', 6, '3rd', 'NT-3102', 16),
('21-32548', 6, '3rd', 'NT-3102', 17),
('21-37831', 6, '3rd', 'NT-3102', 18),
('21-37178', 6, '3rd', 'NT-3102', 19),
('21-30812', 6, '3rd', 'NT-3102', 20),
('21-34330', 6, '3rd', 'NT-3102', 21),
('21-32259', 6, '3rd', 'NT-3102', 22),
('21-33470', 6, '3rd', 'NT-3102', 23),
('21-37046', 6, '3rd', 'NT-3102', 24),
('21-36999', 6, '3rd', 'NT-3102', 25),
('21-34053', 6, '3rd', 'NT-3102', 26);

-- --------------------------------------------------------

--
-- Table structure for table `student_lostnfound`
--

DROP TABLE IF EXISTS `student_lostnfound`;
CREATE TABLE IF NOT EXISTS `student_lostnfound` (
  `StudentId` int NOT NULL AUTO_INCREMENT,
  `Sr_code` varchar(191) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`StudentId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_tbl`
--

DROP TABLE IF EXISTS `student_tbl`;
CREATE TABLE IF NOT EXISTS `student_tbl` (
  `StudentID` int NOT NULL AUTO_INCREMENT,
  `studid` int NOT NULL,
  `StudentQR` varchar(300) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`StudentID`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `student_tbl`
--

INSERT INTO `student_tbl` (`StudentID`, `studid`, `StudentQR`) VALUES
(1, 1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzcmNvZGUiOiIyMS0zNjk5OSIsImZ1bGxuYW1lIjoiVkFMREVaLCBGUllBTiBBVVJJQyBMLiIsInRpbWVzdGFtcCI6IjIwMjMtMTEtMTYgMjI6MDA6MTUiLCJ0eXBlIjoiU1RVREVOVCIsInVzZXJpZCI6IjIxLTM2OTk5In0.Zvx0BjtFexJ1dKbr295nGIUDCA9vZ44yqmdoBBw7rfc'),
(2, 2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzcmNvZGUiOiIyMS0zNjQ1MiIsImZ1bGxuYW1lIjoiQkFZQkFZLCBFTU1BTlVFTCBULiIsInRpbWVzdGFtcCI6IjIwMjMtMTEtMTYgMTk6MDE6MDYiLCJ0eXBlIjoiU1RVREVOVCIsInVzZXJpZCI6IjIxLTM2NDUyIn0.rXk1EvJwCKX0S1Lw9OpjZV7onA0Nzmj1VpXwPYTZgBE'),
(3, 3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzcmNvZGUiOiIyMS0zNjExMSIsImZ1bGxuYW1lIjoiTEFUT1JSRSwgSk9ITiBBRVJPTiBELiIsInRpbWVzdGFtcCI6IjIwMjMtMTEtMTYgMjE6NTA6MDQiLCJ0eXBlIjoiU1RVREVOVCIsInVzZXJpZCI6IjIxLTM2MTExIn0.qVMtyeO9V_qiWnM9lJe8fNT9NnZPaAYVDTFgdyAstYo');

-- --------------------------------------------------------

--
-- Stand-in structure for view `stud_atendees_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `stud_atendees_view`;
CREATE TABLE IF NOT EXISTS `stud_atendees_view` (
`userID` int
,`dept_ID` int
,`stud_dept` varchar(100)
,`statusID` int
,`status` varchar(255)
,`stud_deptid` int
,`org_ID` int
,`e_date` datetime
,`attendeeID` int
,`eventID` int
,`DateRegistered` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `superusers`
--

DROP TABLE IF EXISTS `superusers`;
CREATE TABLE IF NOT EXISTS `superusers` (
  `superID` int NOT NULL AUTO_INCREMENT,
  `userName` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(10) NOT NULL,
  PRIMARY KEY (`superID`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `superusers`
--

INSERT INTO `superusers` (`superID`, `userName`, `password`, `salt`) VALUES
(0, 'adminval', '95e1d817e753fe6392b68de89c337e4cbcf63d280e77245d5c7a3fc4938863d9', 'kckKVzx9k1'),
(1, 'JPAMA', '3913342ed7e247f86dc7bf83229b90a0cec7d8f7f9a6851927f7becc7fec9035', 'b79dc59cf1'),
(2, 'JME', '18d7d94a8343f46b943d963da0d1b8bb42520ba84d4329280be02e5c542a9ee4', 'fc39983032'),
(3, 'CABE Council', '423a577e2d08ee38ad7969840840efd3ebc0adde65ccce896eb93c3d2c491fc8', '02eb527701');

-- --------------------------------------------------------

--
-- Table structure for table `tbemployee`
--

DROP TABLE IF EXISTS `tbemployee`;
CREATE TABLE IF NOT EXISTS `tbemployee` (
  `empid` int NOT NULL,
  `lastname` varchar(25) NOT NULL,
  `firstname` varchar(25) NOT NULL,
  `department` varchar(20) NOT NULL,
  PRIMARY KEY (`empid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tb_studentinfo`
--

DROP TABLE IF EXISTS `tb_studentinfo`;
CREATE TABLE IF NOT EXISTS `tb_studentinfo` (
  `studid` int NOT NULL AUTO_INCREMENT,
  `lastname` varchar(25) NOT NULL,
  `firstname` varchar(25) NOT NULL,
  `course` varchar(20) NOT NULL,
  PRIMARY KEY (`studid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `userstudents`
--

DROP TABLE IF EXISTS `userstudents`;
CREATE TABLE IF NOT EXISTS `userstudents` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `sr_code` varchar(250) NOT NULL,
  `password` varchar(255) NOT NULL,
  `salt` varchar(10) NOT NULL,
  PRIMARY KEY (`userID`),
  KEY `sr_code` (`sr_code`)
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `userstudents`
--

INSERT INTO `userstudents` (`userID`, `sr_code`, `password`, `salt`) VALUES
(1, '21-33470', 'e0999eedf060a2ee05ab267bdb52f827b5f0174d839ac30eae6cd235392531f6', '1ea831d0d9'),
(3, '21-33273', 'e0999eedf060a2ee05ab267bdb52f827b5f0174d839ac30eae6cd235392531f6', '1ea831d0d9'),
(4, '21-33273', '23c6d48a00b788f4320fc0d653c625328b81b0581d57462ba89ace017adf9c44', 'c44aa3a058'),
(5, '21-38474', '35c28aea904ded8c9c437afeba533a6ee13f5465bb3f5822ef73fc08b1cef010', '53960cb772'),
(6, '21-32782', 'e2a8841c2277ea31634a3c27f3cc669f222b27b757d38d3efdfa8b0318f0ed76', 'a773feb234'),
(7, '21-36452', 'aed995f2de3756582e6bb8f0d9b549ce9df23e8bf9efda7ad7b994dd6bc402c9', '284137775a'),
(8, '21-35509', 'dcb96931e5270887f1e269d6e7a44490274546e805f64ccefc206847079034e8', '82951ffcce'),
(9, '21-31630', 'f3b3d6b8aad787b0ad30ef25adc59e312820a5ccf7e01115cddc6d16e9dcc461', 'b2abbfc60d'),
(10, '21-30506', '6f39702664586f3d509bc77ee42c838c406a3f33d90915f51ba1ba22af48fb84', '6ec4e9d9f0'),
(11, '21-36155', '4e18bf45e06d4888668546ed97bfa9e0909097920faf20e612799f32f13b3c7a', '3f4bbdab6d'),
(12, '22-35794', 'da1c5672ef43a3f7367c4aa7a212c5bdd7097ff788385190f3653fda2aa4ae12', '3cd08b0e6a'),
(13, '21-35078', '5665f29b7a92645d37e8cd791724b506b6e7394c30bb60dab0cd07dbb3a1f9af', '6c25e8d9e1'),
(14, '21-30802', '7d0e99c6fee777ea1f30a9186ab7dae76b3a6406742096dc622db669176faacf', 'eea1c4f492'),
(15, '21-34772', 'def4c95290e36182ddb7da31691b5692d608cd56662e52765644c8f076c36643', '8c7fef9a6d'),
(16, '21-36111', '4256d0d3a201173dfa7bf36a289d308e7372770bf46274411c614608d99e1bd8', 'b6b32a26cf'),
(17, '21-30320', '1ff6eb118be202033401b3442dc450389f599bc14acad1cb7313f64c4e12e3f8', '2f4670448c'),
(18, '21-36991', 'd4322e2b6a0784c0a6afb2990db03b79923c0bbbdfae9e679615776436cade5c', '6588dcc0c6'),
(19, '21-37287', '3a1c5357f24955a304071090063987792fcaee52d90d491e380010480ac2cea0', '3fcf4a2ab2'),
(20, '21-32548', '0383fb17ee2b2f504cedfd4fb0e5120f6648c6a75cb509d14ee3ef7dd5c93f82', '634e96ed91'),
(21, '21-37831', 'ddf46a85000cca62dd84b8c33ef7982529a68683518a25fcf146b7228a79abb5', 'a89144c60a'),
(22, '21-37178', 'f2050cc01a83d7ea7a0a261d1868175e40076a1cfa2caa850238c0d32cc97293', 'a7d41fd40e'),
(23, '21-30812', '822c65e98e94d2e748e2e04169f4480eb7a88fa6f450a84308f518f093060ce4', '2e5e3bb366'),
(24, '21-34330', 'ae6683704320dc04f440b879b908270673a0f87477e73f25426bd06c68c53704', '33453b2552'),
(25, '21-32259', 'f11e284e286ea3e4d36568d3b0e29756908ccf4e4210df742464d5afea39b956', 'fdc8e43ed9'),
(26, '21-33470', '5422e523deca4f879bb30925e7da94771f3cd143d28a91308ec003b6754077a6', '694ce3b4d2'),
(27, '21-37046', 'f6c7f7a408aa8074afc9ed6650d87f652ad81d4a3d65b2b7a6171453ba1c4b0b', 'e322d97483'),
(28, '21-36999', '8bc101c7d7014ba9643f67a0746a68cd75dd00112de70f5cf8dd98daf39057a9', '8eef147eff'),
(29, '21-34053', '0e06991b15b19746ba3b5370a985d91b9a38a6479685abea98accc0fe5f1d063', 'f23bb77976');

-- --------------------------------------------------------

--
-- Structure for view `atendees_view`
--
DROP TABLE IF EXISTS `atendees_view`;

DROP VIEW IF EXISTS `atendees_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `atendees_view`  AS SELECT `studentinfoview`.`userID` AS `userID`, `event_info`.`eventID` AS `stud_deptid`, `event_info`.`eventName` AS `eventName`, `event_info`.`eventDesc` AS `eventDesc`, `event_info`.`department_Name` AS `department_Name`, `event_info`.`dept_ID` AS `event_deptid`, `event_info`.`org_Name` AS `org_Name`, `eventattendees`.`attendeeID` AS `attendeeID`, `eventattendees`.`eventID` AS `eventID`, `eventattendees`.`DateRegistered` AS `DateRegistered` FROM ((`eventattendees` join `event_info` on((`event_info`.`eventID` = `eventattendees`.`eventID`))) join `studentinfoview` on((`studentinfoview`.`sr_code` = `eventattendees`.`sr_code`))) GROUP BY `eventattendees`.`attendeeID`, `eventattendees`.`eventID``eventID`  ;

-- --------------------------------------------------------

--
-- Structure for view `event_info`
--
DROP TABLE IF EXISTS `event_info`;

DROP VIEW IF EXISTS `event_info`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `event_info`  AS SELECT `eventstatus`.`statusID` AS `statusID`, `eventstatus`.`status` AS `status`, `events`.`eventID` AS `eventID`, `events`.`eventName` AS `eventName`, `events`.`eventDesc` AS `eventDesc`, `events`.`org_ID` AS `org_ID`, `events`.`e_date` AS `e_date`, `department`.`department_Name` AS `department_Name`, `organization`.`dept_ID` AS `dept_ID`, `organization`.`org_Name` AS `org_Name` FROM (((`eventstatus` join `events` on((`eventstatus`.`statusID` = `events`.`eventID`))) join `organization` on((`organization`.`org_ID` = `events`.`org_ID`))) join `department` on((`department`.`dept_ID` = `organization`.`dept_ID`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `moderatorcookies`
--
DROP TABLE IF EXISTS `moderatorcookies`;

DROP VIEW IF EXISTS `moderatorcookies`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `moderatorcookies`  AS SELECT `superusers`.`superID` AS `superID`, `superusers`.`userName` AS `userName`, `superusers`.`password` AS `password`, `superusers`.`salt` AS `salt`, `organization`.`org_ID` AS `org_ID`, `department`.`dept_ID` AS `dept_ID` FROM ((`superusers` join `organization` on((`superusers`.`superID` = `organization`.`superID`))) join `department` on((`department`.`dept_ID` = `organization`.`dept_ID`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `moderators`
--
DROP TABLE IF EXISTS `moderators`;

DROP VIEW IF EXISTS `moderators`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `moderators`  AS SELECT `superusers`.`superID` AS `superID`, `superusers`.`userName` AS `username`, `organization`.`org_Name` AS `org_Name` FROM (`organization` join `superusers` on((`organization`.`superID` = `superusers`.`superID`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `notifications`
--
DROP TABLE IF EXISTS `notifications`;

DROP VIEW IF EXISTS `notifications`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `notifications`  AS SELECT `event_info`.`statusID` AS `statusID`, `event_info`.`status` AS `status`, `event_info`.`eventID` AS `eventID`, `event_info`.`eventName` AS `eventName`, `event_info`.`eventDesc` AS `eventDesc`, `event_info`.`org_ID` AS `org_ID`, `event_info`.`e_date` AS `e_date`, `event_info`.`department_Name` AS `department_Name`, `event_info`.`dept_ID` AS `dept_ID`, `event_info`.`org_Name` AS `org_Name` FROM `event_info` WHERE ((cast(`event_info`.`e_date` as date) between now() and (now() + interval 7 day)) AND (`event_info`.`status` = 'Approved'))  ;

-- --------------------------------------------------------

--
-- Structure for view `studentinfoview`
--
DROP TABLE IF EXISTS `studentinfoview`;

DROP VIEW IF EXISTS `studentinfoview`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `studentinfoview`  AS SELECT `userstudents`.`userID` AS `userID`, `students`.`sr_code` AS `sr_code`, `userstudents`.`password` AS `password`, `userstudents`.`salt` AS `salt`, `tb_studentinfo`.`firstname` AS `firstName`, `tb_studentinfo`.`lastname` AS `lastName`, `course`.`courseID` AS `courseID`, `students`.`year` AS `year`, `students`.`section` AS `section`, `course`.`courseName` AS `courseName`, `department`.`dept_ID` AS `dept_ID`, `department`.`department_Name` AS `department_Name` FROM ((((`userstudents` join `students` on((`students`.`sr_code` = `userstudents`.`sr_code`))) join `tb_studentinfo` on((`students`.`stud_id` = `tb_studentinfo`.`studid`))) join `course` on((`course`.`courseID` = `students`.`courseID`))) join `department` on((`department`.`dept_ID` = `course`.`dept_ID`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `stud_atendees_view`
--
DROP TABLE IF EXISTS `stud_atendees_view`;

DROP VIEW IF EXISTS `stud_atendees_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `stud_atendees_view`  AS SELECT `studentinfoview`.`userID` AS `userID`, `studentinfoview`.`dept_ID` AS `dept_ID`, `studentinfoview`.`department_Name` AS `stud_dept`, `event_info`.`statusID` AS `statusID`, `event_info`.`status` AS `status`, `eventattendees`.`eventID` AS `stud_deptid`, `event_info`.`org_ID` AS `org_ID`, `event_info`.`e_date` AS `e_date`, `eventattendees`.`attendeeID` AS `attendeeID`, `eventattendees`.`eventID` AS `eventID`, `eventattendees`.`DateRegistered` AS `DateRegistered` FROM ((`eventattendees` join `event_info` on((`event_info`.`eventID` = `eventattendees`.`eventID`))) join `studentinfoview` on((`studentinfoview`.`userID` = `eventattendees`.`attendeeID`)))  ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
