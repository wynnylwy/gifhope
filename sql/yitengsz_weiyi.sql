-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 26, 2020 at 02:54 PM
-- Server version: 10.3.23-MariaDB
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `yitengsz_weiyi`
--

-- --------------------------------------------------------

--
-- Table structure for table `BOOKHISTORY`
--

CREATE TABLE `BOOKHISTORY` (
  `EMAIL` varchar(100) NOT NULL,
  `BOOKID` varchar(50) NOT NULL,
  `BILLID` varchar(50) NOT NULL,
  `CARID` varchar(50) NOT NULL,
  `CQUANTITY` varchar(50) NOT NULL,
  `PRICE` varchar(100) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `BOOKHISTORY`
--

INSERT INTO `BOOKHISTORY` (`EMAIL`, `BOOKID`, `BILLID`, `CARID`, `CQUANTITY`, `PRICE`, `DATE`) VALUES
('weiyilim980106@gmail.com', 'weiyi-24-07-2020 10:54 AML466h7', 'a74lnuub', '1003', '1', '290', '2020-07-24 10:54:58'),
('weiyi_lim@icloud.com', 'weiyi-22-07-2020 09:04 AM173743', 'vev6megn', '1004', '1', '190', '2020-07-22 09:05:07'),
('wynnylimweiyi@gmail.com', 'wynny-13-07-2020 05:17 AM007M85', 'si4suf5y', '1002', '1', '160.00', '2020-07-13 05:17:57'),
('wynnylimweiyi@gmail.com', 'wynny-12-07-2020 04:18 PM044050', 'xdlvzur7', '1002', '1', '160.00', '2020-07-12 16:19:38'),
('wynnylimweiyi@gmail.com', 'wynny-11-07-2020 03:10 PMIi48mR', 'p1k62y5u', '1003', '2', '290', '2020-07-11 15:13:09'),
('wynnylimweiyi@gmail.com', 'wynny-12-07-2020 02:14 PM2hoDbx', 'ftlysfyt', '1003', '1', '290', '2020-07-12 14:14:46'),
('wynnylimweiyi@gmail.com', 'wynny-12-07-2020 02:26 PMdY8IQl', 'k28bpypq', '1002', '1', '160.00', '2020-07-12 14:27:13'),
('wynnylimweiyi@gmail.com', 'wynny-13-07-2020 04:31 AM8GYSMJ', 'uxobhrml', '1001', '1', '230.00', '2020-07-13 04:32:10'),
('wynnylimweiyi@gmail.com', 'wynny-12-07-2020 04:26 PM5O8saF', 'ujo0zve3', '1003', '1', '290', '2020-07-12 16:27:03');

-- --------------------------------------------------------

--
-- Table structure for table `BOOKING`
--

CREATE TABLE `BOOKING` (
  `EMAIL` varchar(50) NOT NULL,
  `PRODID` varchar(20) NOT NULL,
  `CQUANTITY` varchar(100) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `CAR`
--

CREATE TABLE `CAR` (
  `ID` int(4) NOT NULL,
  `NAME` varchar(40) NOT NULL,
  `PRICE` varchar(40) NOT NULL,
  `QUANTITY` varchar(100) DEFAULT NULL,
  `SOLD` varchar(100) NOT NULL,
  `TYPE` varchar(40) NOT NULL,
  `SPECIFICATION` varchar(50) NOT NULL,
  `SEATS_NUM` varchar(50) NOT NULL,
  `DOORS_NUM` varchar(50) NOT NULL,
  `AIR_COND` varchar(200) NOT NULL,
  `AIR_BAG` varchar(200) NOT NULL,
  `LUGGAGE` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(500) NOT NULL,
  `BRAND` varchar(50) NOT NULL,
  `DATE` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CAR`
--

INSERT INTO `CAR` (`ID`, `NAME`, `PRICE`, `QUANTITY`, `SOLD`, `TYPE`, `SPECIFICATION`, `SEATS_NUM`, `DOORS_NUM`, `AIR_COND`, `AIR_BAG`, `LUGGAGE`, `DESCRIPTION`, `BRAND`, `DATE`) VALUES
(1001, 'Honda Civic 1.5 TC', '230.00', '27', '3', 'Sedan', 'Manual', '5', '4', 'Yes', '2', '2', 'Civic 1.5 TC variant is powered by a 1498 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC.It offers several security features like Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Honda', '2020-04-06 18:49:06.685670'),
(1002, 'Honda Accord 1.5 TC', '160.00', '27', '3', 'Sedan', 'Automatic', '5', '4', 'No', '2', '3', 'Honda Accord 1.5 TC variant is powered by a 1997 cc Petrol Engine, Inline 4 Cylinder 4 Valve SOHC. It offers several security features like Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Honda', '2020-04-06 19:05:36.891013'),
(1003, 'Honda City 1.5L S', '290', '27', '1', 'Sedan', 'Manual', '5', '4', 'Yes', '2', '3', 'City 1.5L S measures 4442 mm in length, 1694 mm in width, and 1477 mm in height. The 5 seater Sedan car has 135 mm ground clearance, 2600 mm wheel base and has a fuel tank capacity of 40 L.', 'Honda', '2020-04-06 19:05:36.891013'),
(1004, 'Honda Jazz 1.5L S', '190', '29', '1', 'Hatchback', 'Automatic', '5', '4', 'Yes', '3', '2', 'Honda Jazz 1.5L S measures 3989 mm in length, 1694 mm in width, and 1524 mm in height. It has 137 mm ground clearance, 2530 mm wheel base and has a fuel tank capacity of 40 L. It offers several security features like Central Locking, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Honda', '2020-04-06 19:05:36.891013'),
(1005, 'Perodua Axia E MT', '140', '25', '5', 'Hatchback', 'Manual', '5', '4', 'No', '2', '2', 'Axia E MT offers several security features like Anti Theft Device and Engine Immobilizer. It has fuel consumption of 22.5 kmpl.', 'Perodua', '2020-04-06 19:05:36.891013'),
(1006, 'Perodua Axia G AT', '150', '29', '1', 'Hatchback', 'Automatic', '5', '4', 'Yes', '2', '2', 'Axia G AT offers several security features like Central Locking, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer. It has fuel consumption of 21.6 kmpl.', 'Perodua', '2020-04-06 19:05:36.891013'),
(1007, 'Perodua Alza 1.5S MT', '120', '15', '0', 'MPV', 'Manual', '7', '4', 'No', '2', '4', 'Alza 1.5 S MT measures 4270 mm in length, 1695 mm in width, and 1620 mm in height. The 7 seater MPV car has 133 mm ground clearance, 2750 mm wheel base and has a fuel tank capacity of 42 L.', 'Perodua', '2020-04-06 19:05:36.891013'),
(1008, 'Toyota Avanza 1.5S AT', '160', '15', '0', 'MPV', 'Automatic', '7', '4', 'Yes', '2', '4', 'Avanza 1.5S AT variant is powered by a 1496 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It offers several security features like Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Toyota', '2020-04-06 19:05:36.891013'),
(1009, 'Toyota Innova 2.0X AT', '210', '15', '0', 'MPV', 'Automatic', '5', '4', 'Yes', '3', '3', 'Innova 2.0X AT variant is powered by a 1998 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. IT offers several security features like Central Locking, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Toyota', '2020-04-06 19:05:36.891013'),
(1010, 'Honda CR-V 2.0L 2WD', '320', '15', '0', 'SUV', 'Automatic', '5', '4', 'Yes', '3', '4', 'CR-V 2.0L 2WD variant is powered by a 1997 cc Petrol Engine, Inline 4 Cylinder 4 Valve SOHC. It offers several security features like Smart Access Card Entry, Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Honda', '2020-04-06 19:05:36.891013'),
(1011, 'Proton X70 2020 Premium 2WD', '290', '15', '0', 'SUV', 'Automatic', '7', '4', 'Yes', '3', '4', 'Proton X70 2020 Premium 2WD variant is powered by a 1799 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It offers several security features like Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.Proton ', 'Proton', '2020-04-06 19:05:36.891013'),
(1012, 'Mazda CX-9 2.5 SkyActiv-G Turbo 2WD', '350', '13', '2', 'SUV', 'Automatic', '5', '4', 'Yes', '3', '4', 'Mazda CX-9 2.5 SkyActiv-G Turbo 2WD measures 5075 mm in length, 1969 mm in width, and 1747 mm in height. The 5 seater SUV car has 222 mm ground clearance, 2930 mm wheel base and has a fuel tank capacity of 72 L.', 'Mazda', '2020-04-06 19:05:36.891013'),
(1013, 'Mazda MX-5 RF 2.0(M)', '380', '5', '0', 'Convertible', 'Automatic', '2', '2', 'Yes', '3', '2', 'Mazda MX-5 RF 2.0(M) variant is powered by a 1998 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It offers several security features like Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Mazda', '2020-04-06 19:05:36.891013'),
(1014, 'Mercedes-Benz SLC 200', '480', '4', '1', 'Convertible', 'Automatic', '2', '2', 'Yes', '3', '2', 'Mercedes-Benz SLC 200 variant is powered by a 1991 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It runs on 18 Inch alloy wheels and its tyre size and type are 225/40 R18 and Radial, respectively.', 'Mercedes-Benz', '2020-04-06 19:05:36.891013'),
(1015, 'Mercedes-Benz E 300 Cabriolet AMG Line', '520', '5', '0', 'Convertible', 'Automatic', '5', '2', 'Yes', '3', '2', 'Mercedes-Benz E 300 Cabriolet AMG Line variant is powered by a 1991 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It offers 245 hp of power and 370 Nm of torque.', 'Mercedes-Benz', '2020-04-06 19:05:36.891013'),
(1016, 'Mazda MX-5 RF 2.0(A)', '400', '5', '0', 'Convertible', 'Automatic', '2', '2', 'Yes', '3', '2', ' Mazda MX-5 RF 2.0(A) variant is powered by a 1998 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It offers several security features like Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Mazda', '2020-04-06 19:40:16.446608'),
(1017, 'Mercedes-Benz S 560 Cabriolet AMG Line', '580', '5', '0', 'Convertible', 'Automatic', '4', '2', 'Yes', '3', '2', 'Mercedes-Benz S 560 Cabriolet AMG Line variant is powered by a 3982 cc Petrol Engine, Inline 8 Cylinder 4 Valve DOHC. It runs on 20 Inch alloy wheels and its tyre size and type are 245/40 R20 and Radial, respectively.', 'Mercedes-Benz', '2020-04-06 19:40:16.446608'),
(1018, 'Proton X70 2020 Executive 2WD', '270', '15', '0', 'SUV', 'Automatic', '7', '4', 'Yes', '3', '4', 'Proton X70 2020 Executive 2WD variant is powered by a 1799 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It offers several security features like Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Proton', '2020-04-06 19:40:16.446608'),
(1019, 'Proton X70 2020 Standard 2WD', '240', '15', '0', 'SUV', 'Manual', '7', '4', 'Yes', '3', '4', 'Proton X70 2020 Standard 2WD variant is powered by a 1799 cc Petrol Engine, Inline 4 Cylinder 4 Valve DOHC. It offers several security features like Central Locking, Power Door Locks, Anti Theft Device, Anti-Theft Alarm and Engine Immobilizer.', 'Proton', '2020-04-06 19:40:16.446608'),
(1020, 'Proton Exora 1.6 Executive CVT', '150', '15', '0', 'MPV', 'Manual', '7', '4', 'Yes', '2', '4', 'Exora 1.6 Executive CVT measures 4610 mm in length, 1809 mm in width, and 1691 mm in height. The 7 seater MPV car has 155 mm ground clearance, 2730 mm wheel base and has a fuel tank capacity of 55 L.', 'Proton', '2020-04-06 19:40:16.446608'),
(1021, 'Proton Exora 1.6 Premium CVT', '180', '15', '0', 'MPV', 'Automatic', '7', '4', 'Yes', '2', '4', 'Exora 1.6 Premium CVT measures 4610 mm in length, 1809 mm in width, and 1691 mm in height. The 7 seater MPV car has 155 mm ground clearance, 2730 mm wheel base and has a fuel tank capacity of 55 L.', 'Proton', '2020-04-06 19:40:16.446608'),
(1022, 'Mercedes-Benz B 200 Progressive Line', '350', '30', '0', 'Hatchback', 'Automatic', '5', '4', 'Yes', '3', '3', 'Mercedes-Benz B 200 Progressive Line variant is powered by a 2999 cc Petrol Engine, Inline 8 Cylinder 4 Valve DOHC. It offers 367 hp of power and 500 Nm of torque.', 'Mercedes-Benz', '2020-04-06 19:40:16.446608'),
(1023, 'Honda Jazz 1.5L E', '200', '30', '0', 'Hatchback', 'Manual', '5', '4', 'Yes', '3', '2', 'Jazz 1.5L E measures 3989 mm in length, 1694 mm in width, and 1524 mm in height. The 5 seater Hatchback car has 137 mm ground clearance, 2530 mm wheel base and has a fuel tank capacity of 40 L.', 'Honda', '2020-04-06 19:40:16.446608'),
(1024, 'Perodua Bezza 1.3 Advance', '130', '30', '0', 'Sedan', 'Automatic', '5', '4', 'Yes', '2', '3', 'Perodua Bezza 1.3 Advance has fuel consumption of 21.3 kmpl. The variant is powered by a 998 cc Petrol Engine, Inline 3 Cylinder 4 Valve DOHC. It runs on 14 Inch alloy wheels and its tyre size and type are 175/65 R14 and Radial, respectively.', 'Perodua', '2020-04-06 19:40:16.446608'),
(1040, 'Honda New', '120.00', '20', '0', 'Sedan', 'Manual', '5', '4', 'Yes', '2', '2', 'new', 'Honda', '2020-07-20 01:25:17.268371');

-- --------------------------------------------------------

--
-- Table structure for table `CUSTOMERORDER`
--

CREATE TABLE `CUSTOMERORDER` (
  `EMAIL` varchar(200) NOT NULL,
  `BILLID` varchar(200) NOT NULL,
  `CARID` varchar(100) NOT NULL,
  `CQUANTITY` varchar(200) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CUSTOMERORDER`
--

INSERT INTO `CUSTOMERORDER` (`EMAIL`, `BILLID`, `CARID`, `CQUANTITY`, `DATE`) VALUES
('wynnylimweiyi@gmail.com', 'ujo0zve3', '1003', '1', '2020-07-12 16:27:03'),
('weiyi_lim@icloud.com', 'vev6megn', '1004', '1', '2020-07-22 09:05:07'),
('weiyilim980106@gmail.com', 'a74lnuub', '1003', '1', '2020-07-24 10:54:58');

-- --------------------------------------------------------

--
-- Table structure for table `PAYMENT`
--

CREATE TABLE `PAYMENT` (
  `BOOKID` varchar(100) NOT NULL,
  `BILLID` varchar(100) NOT NULL,
  `TOTAL` varchar(10) NOT NULL,
  `USERID` varchar(100) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `PAYMENT`
--

INSERT INTO `PAYMENT` (`BOOKID`, `BILLID`, `TOTAL`, `USERID`, `DATE`) VALUES
('weiyi-24-07-2020 10:54 AML466h7', 'a74lnuub', '203.00', 'weiyilim980106@gmail.com', '2020-07-24 10:54:58'),
('weiyi-22-07-2020 09:04 AM173743', 'vev6megn', '133.00', 'weiyi_lim@icloud.com', '2020-07-22 09:05:07');

-- --------------------------------------------------------

--
-- Table structure for table `USER`
--

CREATE TABLE `USER` (
  `NAME` varchar(100) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `PASSWORD` varchar(60) NOT NULL,
  `PHONE` varchar(15) NOT NULL,
  `CREDIT` varchar(100) NOT NULL,
  `DATEREG` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `VERIFY` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USER`
--

INSERT INTO `USER` (`NAME`, `EMAIL`, `PASSWORD`, `PHONE`, `CREDIT`, `DATEREG`, `VERIFY`) VALUES
('Admin', 'admin@carvroom.com', 'cf62addbcaea61e1a4055e73445ed6e8a061c38f', '0124569823', '0', '2020-07-13 04:17:57', '1'),
('unregistered', 'unregistered', 'f7c3bc1d808e04732adf679965ccc34ca7ae3441', '0123456789', '0', '2020-07-13 04:18:04', '1'),
('Lim', 'weiyilim980106@gmail.com', '32d101a8275e543fb004f3aa6474ff070141e02e', '0124706399', '0', '2020-07-24 07:58:24', '1'),
('Wynny', 'wynnylimweiyi@gmail.com', 'cf62addbcaea61e1a4055e73445ed6e8a061c38f', '0124705858', '0', '2020-07-19 17:37:28', '1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `CAR`
--
ALTER TABLE `CAR`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `CUSTOMERORDER`
--
ALTER TABLE `CUSTOMERORDER`
  ADD PRIMARY KEY (`EMAIL`);

--
-- Indexes for table `USER`
--
ALTER TABLE `USER`
  ADD PRIMARY KEY (`EMAIL`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
