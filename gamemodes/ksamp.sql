-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 14, 2026 at 07:11 PM
-- Server version: 5.7.44
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hendiganteng`
--

-- --------------------------------------------------------

--
-- Table structure for table `dataucp`
--

CREATE TABLE `dataucp` (
  `id` int(11) NOT NULL,
  `ucp` varchar(32) NOT NULL,
  `verifikasi` int(11) NOT NULL,
  `aktivasi` int(11) NOT NULL DEFAULT '0',
  `admin_level` tinyint(4) NOT NULL DEFAULT '0',
  `katasandi` varchar(64) DEFAULT '',
  `discord` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) NOT NULL,
  `name` varchar(64) NOT NULL,
  `ucp` varchar(64) NOT NULL,
  `health` float NOT NULL DEFAULT '100',
  `armour` float NOT NULL DEFAULT '0',
  `posx` float NOT NULL DEFAULT '1682.61',
  `posy` float NOT NULL DEFAULT '-2327.89',
  `posz` float NOT NULL DEFAULT '13.5469',
  `angel` float NOT NULL DEFAULT '3.4335',
  `interior` int(5) NOT NULL DEFAULT '0',
  `virtualworld` int(5) NOT NULL DEFAULT '0',
  `skin` int(5) NOT NULL DEFAULT '98',
  `level` int(3) NOT NULL DEFAULT '0',
  `money` int(10) NOT NULL DEFAULT '0',
  `kills` int(10) NOT NULL DEFAULT '0',
  `deaths` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabelle für die Spieler-Statistiken';

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `model` smallint(6) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `veh_pos` varchar(64) NOT NULL DEFAULT '0|0|0|0',
  `veh_int` int(11) NOT NULL DEFAULT '0',
  `veh_vw` int(11) NOT NULL DEFAULT '0',
  `veh_lock` tinyint(1) NOT NULL DEFAULT '0',
  `fuel` float NOT NULL DEFAULT '100',
  `health` float NOT NULL DEFAULT '1000',
  `mileage` float NOT NULL DEFAULT '0',
  `veh_stored` tinyint(1) NOT NULL DEFAULT '0',
  `color1` tinyint(4) NOT NULL DEFAULT '0',
  `color2` tinyint(4) NOT NULL DEFAULT '0',
  `plate` varchar(16) NOT NULL DEFAULT 'Konten',
  `created_at` int(11) NOT NULL DEFAULT '0',
  `last_used` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dataucp`
--
ALTER TABLE `dataucp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `dataucp`
--
ALTER TABLE `dataucp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
