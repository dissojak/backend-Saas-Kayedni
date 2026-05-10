-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 09, 2026 at 08:22 PM
-- Server version: 9.6.0
-- PHP Version: 8.5.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Kayedni`
--

-- --------------------------------------------------------

--
-- Table structure for table `activation_tokens`
--

CREATE TABLE `activation_tokens` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expiry_date` datetime(6) NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `date` date NOT NULL,
  `end_time` time(6) NOT NULL,
  `notes` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `start_time` time(6) NOT NULL,
  `status` enum('PENDING','CONFIRMED','CANCELLED','REJECTED','COMPLETED','NO_SHOW') COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `cancellation_reason` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `reminder_sent_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `created_at`, `date`, `end_time`, `notes`, `price`, `start_time`, `status`, `updated_at`, `cancellation_reason`, `reminder_sent_at`) VALUES
(1, '2025-12-20 10:00:00.000000', '2025-12-26', '09:00:00.000000', 'Regular customer, prefers fade style', 6.00, '08:30:00.000000', 'COMPLETED', '2025-12-20 10:00:00.000000', NULL, NULL),
(2, '2025-12-20 11:00:00.000000', '2025-12-26', '10:30:00.000000', 'First time client', 6.00, '10:00:00.000000', 'CANCELLED', '2026-01-01 17:54:06.000000', NULL, NULL),
(3, '2025-12-20 14:00:00.000000', '2025-12-26', '12:15:00.000000', 'Kids haircut, bring toys', 3.00, '12:00:00.000000', 'NO_SHOW', '2026-01-01 17:54:15.000000', NULL, NULL),
(4, '2025-12-21 09:00:00.000000', '2025-12-26', '15:00:00.000000', 'Hot towel shave requested', 7.00, '14:45:00.000000', 'NO_SHOW', '2026-01-01 17:54:19.000000', NULL, NULL),
(5, '2025-12-21 10:00:00.000000', '2025-12-27', '09:30:00.000000', 'Haircut and beard trim', 6.00, '09:00:00.000000', 'CONFIRMED', '2025-12-21 10:00:00.000000', NULL, NULL),
(6, '2025-12-21 11:00:00.000000', '2025-12-27', '11:00:00.000000', 'Quick trim', 6.00, '10:30:00.000000', 'CONFIRMED', '2025-12-21 11:00:00.000000', NULL, NULL),
(7, '2025-12-22 08:00:00.000000', '2025-12-27', '14:30:00.000000', 'Hair coloring appointment', 20.00, '13:30:00.000000', 'CONFIRMED', '2025-12-22 08:00:00.000000', NULL, NULL),
(8, '2025-12-22 09:00:00.000000', '2025-12-28', '10:00:00.000000', 'Regular cut', 6.00, '09:30:00.000000', 'CONFIRMED', '2025-12-22 09:00:00.000000', NULL, NULL),
(9, '2025-12-22 10:00:00.000000', '2025-12-28', '11:45:00.000000', 'Shave and haircut combo', 7.00, '11:00:00.000000', 'CONFIRMED', '2025-12-22 10:00:00.000000', NULL, NULL),
(10, '2025-12-23 08:00:00.000000', '2025-12-30', '08:45:00.000000', 'Early morning appointment', 6.00, '08:15:00.000000', 'NO_SHOW', '2026-01-01 17:54:22.000000', NULL, NULL),
(11, '2025-12-23 09:00:00.000000', '2026-01-01', '19:50:00.000000', 'Kids haircut', 3.00, '19:35:00.000000', 'COMPLETED', '2026-01-01 19:29:57.000000', NULL, NULL),
(12, '2025-12-23 14:00:00.000000', '2026-01-01', '22:00:00.000000', 'Lunchtime quick cut', 6.00, '21:30:00.000000', 'COMPLETED', '2026-01-02 04:10:39.000000', NULL, NULL),
(13, '2025-12-24 08:00:00.000000', '2026-01-01', '19:15:00.000000', 'New Year party prep', 6.00, '18:35:00.536000', 'COMPLETED', '2026-01-01 18:21:30.000000', NULL, NULL),
(14, '2025-12-24 09:00:00.000000', '2025-12-31', '10:45:00.000000', 'Hot towel shave for party', 7.00, '10:30:00.000000', 'CONFIRMED', '2025-12-24 09:00:00.000000', NULL, NULL),
(15, '2025-12-24 10:00:00.000000', '2025-12-31', '12:00:00.000000', 'Haircut before celebration', 6.00, '11:30:00.000000', 'CONFIRMED', '2025-12-24 10:00:00.000000', NULL, NULL),
(16, '2025-12-25 08:00:00.000000', '2026-01-02', '09:00:00.000000', 'Post-holiday trim', 6.00, '08:30:00.000000', 'CANCELLED', '2026-01-02 14:05:18.000000', NULL, NULL),
(17, '2025-12-25 09:00:00.000000', '2026-01-02', '11:30:00.000000', 'Fresh start haircut', 6.00, '11:00:00.000000', 'CONFIRMED', '2025-12-25 09:00:00.000000', NULL, NULL),
(18, '2025-12-25 10:00:00.000000', '2026-01-03', '10:00:00.000000', 'Regular customer', 6.00, '09:30:00.000000', 'CONFIRMED', '2025-12-25 10:00:00.000000', NULL, NULL),
(19, '2025-12-25 11:00:00.000000', '2026-01-03', '14:15:00.000000', 'Hair wash and style', 5.00, '13:50:00.000000', 'CONFIRMED', '2025-12-25 11:00:00.000000', NULL, NULL),
(20, '2025-12-25 12:00:00.000000', '2026-05-21', '11:00:00.000000', 'Walk-in appointment', 6.00, '10:30:00.000000', 'PENDING', '2026-05-08 23:40:11.159557', NULL, NULL),
(21, '2025-12-26 08:00:00.000000', '2026-01-06', '09:30:00.000000', 'Weekly regular', 6.00, '09:00:00.000000', 'CONFIRMED', '2025-12-26 08:00:00.000000', NULL, NULL),
(22, '2025-12-26 09:00:00.000000', '2026-01-06', '11:00:00.000000', 'Haircut and shave', 7.00, '10:30:00.000000', 'CONFIRMED', '2025-12-26 09:00:00.000000', NULL, NULL),
(23, '2025-12-27 08:00:00.000000', '2026-01-08', '10:15:00.000000', 'Business meeting prep', 6.00, '09:45:00.000000', 'CONFIRMED', '2025-12-27 08:00:00.000000', NULL, NULL),
(24, '2025-12-27 09:00:00.000000', '2026-01-08', '13:00:00.000000', 'Kids haircut', 3.00, '12:45:00.000000', 'CONFIRMED', '2025-12-27 09:00:00.000000', NULL, NULL),
(25, '2025-12-27 10:00:00.000000', '2026-01-10', '09:00:00.000000', 'Hot towel shave', 7.00, '08:45:00.000000', 'CONFIRMED', '2025-12-27 10:00:00.000000', NULL, NULL),
(26, '2025-12-27 11:00:00.000000', '2026-01-10', '10:30:00.000000', 'Regular haircut', 6.00, '10:00:00.000000', 'CONFIRMED', '2025-12-27 11:00:00.000000', NULL, NULL),
(27, '2025-12-27 12:00:00.000000', '2026-01-10', '15:30:00.000000', 'Hair coloring', 20.00, '14:30:00.000000', 'CONFIRMED', '2025-12-27 12:00:00.000000', NULL, NULL),
(31, '2026-01-02 22:45:25.000000', '2026-01-08', '13:30:00.000000', '', 6.00, '13:00:00.000000', 'CONFIRMED', NULL, NULL, NULL),
(32, '2026-01-02 22:46:27.000000', '2026-01-15', '15:00:00.000000', 'sec test', 3.00, '14:45:00.000000', 'CONFIRMED', NULL, NULL, NULL),
(33, '2026-01-02 22:47:39.000000', '2026-01-10', '13:15:00.000000', NULL, 3.00, '13:00:00.000000', 'CONFIRMED', '2026-01-02 22:49:01.000000', NULL, NULL),
(36, '2026-01-02 23:32:25.000000', '2026-01-13', '14:15:00.000000', NULL, 3.00, '14:00:00.000000', 'CONFIRMED', '2026-01-02 23:33:22.000000', NULL, NULL),
(38, '2026-04-23 10:33:48.422375', '2026-04-25', '10:35:00.000000', NULL, 14.00, '10:00:00.000000', 'CONFIRMED', '2026-04-24 15:10:02.446860', NULL, NULL),
(39, '2026-04-26 13:53:02.530707', '2026-04-26', '15:45:00.000000', NULL, 80.00, '15:00:00.000000', 'CONFIRMED', '2026-04-26 13:54:15.986241', NULL, NULL),
(40, '2026-04-26 13:55:05.947952', '2026-04-27', '10:30:00.000000', NULL, 120.00, '10:00:00.000000', 'CONFIRMED', '2026-04-26 13:55:18.128462', NULL, NULL),
(41, '2026-04-26 13:56:06.551064', '2026-04-27', '09:00:00.000000', NULL, 250.00, '08:00:00.000000', 'CONFIRMED', '2026-04-26 13:57:29.309863', NULL, NULL),
(42, '2026-04-26 13:56:56.209263', '2026-04-27', '09:45:00.000000', NULL, 80.00, '09:00:00.000000', 'CONFIRMED', '2026-04-26 14:12:58.949461', NULL, NULL),
(167, '2026-04-28 19:23:04.707992', '2026-05-09', '11:30:00.000000', NULL, 6.00, '12:30:00.699000', 'CONFIRMED', '2026-04-28 19:23:35.817729', NULL, NULL),
(216, '2026-05-08 23:05:34.178874', '2026-05-22', '10:20:00.000000', NULL, 3.00, '10:00:00.000000', 'REJECTED', '2026-05-08 23:06:37.736537', 'Rejected by staff from Telegram', NULL),
(217, '2026-05-08 23:07:15.992145', '2026-05-23', '10:15:00.000000', NULL, 3.00, '10:00:00.000000', 'CONFIRMED', '2026-05-08 23:07:22.169445', NULL, NULL),
(218, '2026-05-08 23:10:02.625007', '2026-05-22', '10:15:00.000000', NULL, 3.00, '10:00:00.000000', 'CONFIRMED', '2026-05-08 23:10:08.610950', NULL, NULL),
(219, '2026-05-08 23:11:20.781641', '2026-05-27', '10:15:00.000000', NULL, 3.00, '10:00:00.000000', 'CONFIRMED', '2026-05-08 23:17:17.503354', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE `businesses` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('ACTIVE','DELETED','DRAFT','INACTIVE','PENDING','SUSPENDED') COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `category_id` bigint NOT NULL,
  `owner_id` bigint NOT NULL,
  `weekend_day` enum('FRIDAY','MONDAY','SATURDAY','SUNDAY','THURSDAY','TUESDAY','WEDNESDAY') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `enable_resources` bit(1) NOT NULL,
  `enable_services` bit(1) NOT NULL,
  `qr_code_url` varchar(2048) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `qr_updated_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `businesses`
--

INSERT INTO `businesses` (`id`, `created_at`, `description`, `email`, `location`, `name`, `phone`, `status`, `updated_at`, `category_id`, `owner_id`, `weekend_day`, `enable_resources`, `enable_services`, `qr_code_url`, `qr_updated_at`) VALUES
(1, '2025-11-25 20:15:15.000000', 'Men’s barbershop in Maamoura specializing in precision haircuts, clean fades, expert beard grooming, and classic shaves.', 'contact@stoonbarber.com', 'Rue Habib Bourguiba, Maamoura, Nabeul, Tunisia', 'Stoon Barber', '+21680138013', 'ACTIVE', '2026-04-26 00:45:27.422460', 2, 1, 'TUESDAY', b'0', b'0', 'https://res.cloudinary.com/duvougrqx/image/upload/v1777164326/Bookify/business-qr/business-1.png', '2026-04-26 00:45:27.413173'),
(2, '2025-11-26 20:37:59.000000', 'Modern grooming spot with pro barbers and stylish cuts.', 'hello@freshfade.tn', '45 Avenue Habib Bourguiba, Tunis, Tunisia', 'Stoon Production Studio', '+21650112233', 'PENDING', '2026-04-22 00:54:52.310405', 5, 6, 'MONDAY', b'0', b'0', NULL, NULL),
(3, '2025-10-15 14:30:00.000000', 'Fine dining Italian restaurant featuring authentic pasta, wood-fired pizza, and seasonal specialties.  Wine bar with 100+ selections.', 'reservations@bellaitalia.fr', '78 Boulevard Saint-Germain, 75005 Paris, France', 'Bella Italia', '+33142567890', 'ACTIVE', '2026-01-03 21:08:33.000000', 1, 8, 'MONDAY', b'0', b'0', NULL, NULL),
(4, '2025-09-20 09:00:00.000000', 'Traditional Tunisian restaurant serving couscous, tagines, brik, and Mediterranean seafood. Family recipes passed down for generations.', 'info@darsarrar.tn', '12 Rue du Pacha, Sidi Bou Said, Tunisia', 'Dar Sarrar', '+21671234567', 'ACTIVE', '2025-12-18 12:30:00.000000', 1, 9, 'SUNDAY', b'0', b'0', NULL, NULL),
(5, '2025-11-01 11:20:00.000000', 'Premium salon specializing in hair coloring, balayage, keratin treatments, and bridal styling. Luxury products and experienced stylists.', 'appointments@glamourhair.com', '156 Avenue Mohammed V, Tunis, Tunisia', 'Glamour Hair Salon', '+21698765432', 'ACTIVE', '2025-12-20 15:00:00.000000', 3, 10, 'SUNDAY', b'0', b'0', NULL, NULL),
(6, '2025-08-10 10:00:00.000000', 'Trendy urban barbershop with vintage vibes.  Specializing in classic cuts, beard trims, and straight razor shaves.  Complimentary coffee. ', 'book@urbancuts.com', '89 Rue de la République, 69002 Lyon, France', 'Urban Cuts Barbershop', '+33478901234', 'ACTIVE', '2025-12-22 09:15:00.000000', 2, 11, 'MONDAY', b'0', b'0', NULL, NULL),
(7, '2025-07-05 16:45:00.000000', 'Authentic Japanese restaurant offering sushi, sashimi, ramen, and teppanyaki. Fresh fish delivered daily.  Omakase available.', 'contact@sakuratokyo.fr', '34 Rue Sainte-Anne, 75001 Paris, France', 'Sakura Tokyo', '+33145678901', 'ACTIVE', '2025-12-19 18:30:00.000000', 1, 12, 'TUESDAY', b'0', b'0', NULL, NULL),
(8, '2025-06-12 13:00:00.000000', 'Modern fitness studio offering personal training, group classes, yoga, pilates, and nutritional coaching. State-of-the-art equipment. ', 'hello@fitlifestudio.tn', '67 Avenue de la Liberté, Tunis, Tunisia', 'FitLife Studio', '+21655443322', 'ACTIVE', '2025-12-21 07:30:00.000000', 4, 13, 'FRIDAY', b'0', b'0', NULL, NULL),
(9, '2025-05-18 15:00:00.000000', 'Family-friendly pizzeria with authentic Neapolitan pizza baked in wood-fired oven.  Casual dining atmosphere with outdoor seating.', 'orders@pizzanapoletana.fr', '45 Avenue Jean Jaurès, 75019 Paris, France', 'Pizza Napoletana', '+33149876543', 'ACTIVE', '2025-12-17 19:00:00.000000', 1, 14, 'MONDAY', b'0', b'0', NULL, NULL),
(10, '2025-04-22 11:30:00.000000', 'Elegant spa offering massages, facials, body treatments, and wellness therapies. Tranquil environment for complete relaxation and rejuvenation.', 'bookings@zenspacenter.tn', '88 Rue de Carthage, La Marsa, Tunisia', 'Zen Spa Center', '+21670112233', 'ACTIVE', '2025-12-16 14:00:00.000000', 3, 15, 'SUNDAY', b'0', b'0', NULL, NULL),
(11, '2025-03-15 09:00:00.000000', 'Professional dental clinic offering general dentistry, cosmetic procedures, orthodontics, and emergency dental care. Modern equipment and experienced team.', 'appointments@dentalcare.fr', '12 Rue de la Santé, 75014 Paris, France', 'Dental Care Clinic', '+33144556677', 'ACTIVE', '2025-12-20 16:30:00.000000', 5, 16, 'SUNDAY', b'0', b'0', NULL, NULL),
(12, '2025-02-10 14:00:00.000000', 'Full-service auto repair shop specializing in engine diagnostics, brake service, oil changes, tire replacement, and general maintenance. ', 'service@autoexpress.tn', '234 Route de Sfax, Tunis, Tunisia', 'Auto Express', '+21698123456', 'ACTIVE', '2025-12-18 10:00:00.000000', 6, 17, 'FRIDAY', b'0', b'0', NULL, NULL),
(13, '2025-01-20 10:30:00.000000', 'Professional photography studio for weddings, portraits, corporate events, and commercial shoots. Experienced photographers with creative vision.', 'info@capturemoments.fr', '67 Rue de Rennes, 75006 Paris, France', 'Capture Moments Photography', '+33156789012', 'ACTIVE', '2025-12-15 11:00:00.000000', 7, 18, 'MONDAY', b'0', b'0', NULL, NULL),
(14, '2025-12-01 13:00:00.000000', 'Luxury nail salon offering manicures, pedicures, gel nails, nail art, and spa treatments. Sterilized tools and premium products.', 'hello@nailglam.tn', '23 Avenue de la République, Sousse, Tunisia', 'Nail Glam Studio', '+21673445566', 'ACTIVE', '2025-12-22 15:00:00.000000', 9, 19, 'SUNDAY', b'0', b'0', NULL, NULL),
(15, '2025-11-15 08:00:00.000000', 'Pet grooming salon providing bathing, haircuts, nail trimming, and styling for dogs and cats. Experienced groomers who love animals.', 'contact@pawsandfur.fr', '89 Boulevard Voltaire, 75011 Paris, France', 'Paws & Fur Grooming', '+33167889900', 'ACTIVE', '2025-12-19 09:00:00.000000', 11, 20, 'MONDAY', b'0', b'0', NULL, NULL),
(17, '2026-04-25 20:47:09.175599', 'A9wa 7amas fel Maamoura provides reliable and efficient legal services tailored to individuals and businesses in Nabeul. We assist with contracts, company creation, legal consulting, dispute resolution, and administrative procedures.', 'contact@kaishamas.com', 'maamoura, nabeul', 'hamas', '+216977018809', 'ACTIVE', '2026-04-25 20:52:57.747343', 14, 33, NULL, b'0', b'0', 'https://res.cloudinary.com/duvougrqx/image/upload/v1777150377/Bookify/business-qr/business-17.png', '2026-04-25 20:52:57.746049');

-- --------------------------------------------------------

--
-- Table structure for table `business_clients`
--

CREATE TABLE `business_clients` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `notes` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `business_id` bigint NOT NULL,
  `telegram_chat_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_clients`
--

INSERT INTO `business_clients` (`id`, `created_at`, `email`, `name`, `notes`, `phone`, `updated_at`, `business_id`, `telegram_chat_id`) VALUES
(1, '2026-01-02 22:21:50.000000', NULL, 'hazem ben saria', 'test test', '+21654775034', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `business_evaluations`
--

CREATE TABLE `business_evaluations` (
  `id` bigint NOT NULL,
  `branding_details` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `branding_score` int DEFAULT NULL,
  `branding_suggestions` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `category_details` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `category_score` int DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `description_details` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description_professionalism_score` int DEFAULT NULL,
  `description_suggestions` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email_details` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email_professionalism_score` int DEFAULT NULL,
  `email_suggestions` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location_details` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location_score` int DEFAULT NULL,
  `name_details` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name_professionalism_score` int DEFAULT NULL,
  `name_suggestions` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `overall_score` int DEFAULT NULL,
  `source` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `business_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_evaluations`
--

INSERT INTO `business_evaluations` (`id`, `branding_details`, `branding_score`, `branding_suggestions`, `category_details`, `category_score`, `created_at`, `description_details`, `description_professionalism_score`, `description_suggestions`, `email_details`, `email_professionalism_score`, `email_suggestions`, `location_details`, `location_score`, `name_details`, `name_professionalism_score`, `name_suggestions`, `overall_score`, `source`, `business_id`) VALUES
(2, 'Assessed consistency between name, email, description, location, category.', 60, 'Secure a domain matching your brand, use a domain email (e.g., info@stoonproductionstudio.com), create a simple logo and tagline, keep the same name across platforms.', 'Category does not match provided name/description.\nSuggestion: Consider changing category to match your activity (e.g., Barber / Salon).', 25, '2025-11-26 20:38:00.000000', 'Checked length, clarity, category/city relevance.', 55, 'Write 3-5 sentences covering: what you do (Health Care), who you serve in Tunisia, your strengths, services list, and a simple call-to-action.', 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.', 85, 'Checked length, characters, alignment with category.', 95, NULL, 68, 'HEURISTIC', 2),
(10, 'Assessed consistency between name, email, description, location, category.', 100, NULL, 'Category appears consistent with name/description.', 90, '2026-01-02 18:34:41.000000', 'Checked length, clarity, category/city relevance.', 65, NULL, 'Valid format.', 100, NULL, 'Checked number, street type, postal code, city formatting.', 100, 'Checked length, characters, alignment with category.', 100, NULL, 92, 'HEURISTIC', 1),
(11, 'Assessed consistency between name, email, description, location, category.', 100, NULL, 'Category appears consistent with name/description.', 90, '2026-01-02 18:38:14.000000', 'Checked length, clarity, category/city relevance.', 65, NULL, 'Valid format.', 100, NULL, 'Checked number, street type, postal code, city formatting.', 100, 'Checked length, characters, alignment with category.', 100, NULL, 92, 'HEURISTIC', 1),
(12, 'Checked name, email, and description consistency.', 50, NULL, 'Checked alignment of name/description with selected category.', 50, '2026-01-02 18:46:14.000000', 'Assessed grammar, clarity, tone, and content.', 50, NULL, 'Checked format validity and brand alignment.', 50, NULL, 'Evaluated address clarity and standardized format.', 50, 'The name \"Stoon Barber\" is clear, professional, and', 90, NULL, 57, 'AI', 1),
(13, 'Checked name, email, and description consistency.', 50, NULL, 'Checked alignment of name/description with selected category.', 50, '2026-01-02 18:55:56.000000', 'Assessed grammar, clarity, tone, and content.', 50, NULL, 'Checked format validity and brand alignment.', 50, NULL, 'Evaluated address clarity and standardized format.', 50, 'The business name is exceptionally clear, immediately communicating its services and target', 98, NULL, 58, 'AI', 1),
(14, 'Checked name, email, and description consistency.', 50, NULL, 'Checked alignment of name/description with selected category.', 50, '2026-01-02 19:03:03.000000', 'Assessed grammar, clarity, tone, and content.', 50, NULL, 'Checked format validity and brand alignment.', 50, NULL, 'Full street address with city and country.', 95, 'Clear and descriptive business name.', 95, NULL, 65, 'AI', 1),
(15, 'Checked name, email, and description consistency.', 50, NULL, 'Checked alignment of name/description with selected category.', 50, '2026-01-02 19:08:01.000000', 'Assessed grammar, clarity, tone, and content.', 50, NULL, 'Checked format validity and brand alignment.', 50, NULL, 'Full street, city, and country provided.', 98, 'Name is provided and not gibberish.', 95, NULL, 65, 'AI', 1),
(16, 'Checked name, email, and description consistency.', 50, NULL, 'Checked alignment of name/description with selected category.', 50, '2026-01-02 19:09:27.000000', 'Assessed grammar, clarity, tone, and content.', 50, NULL, 'Checked format validity and brand alignment.', 50, NULL, 'Evaluated address clarity and standardized format.', 50, 'Name is provided and not empty.', 95, NULL, 57, 'AI', 1),
(17, 'Checked name, email, and description consistency.', 50, NULL, 'test', 98, '2026-01-02 19:12:37.000000', 'test', 95, NULL, 'test', 98, NULL, 'test', 98, 'test', 95, NULL, 89, 'AI', 1),
(18, 'Assessed consistency between name, email, description, location, category.', 90, NULL, 'Category appears consistent with name/description.', 90, '2026-01-02 19:41:07.000000', 'Checked length, clarity, category/city relevance.', 75, NULL, 'Valid format.', 100, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 65, 'Checked length, characters, alignment with category.', 100, NULL, 87, 'HEURISTIC', 1),
(19, '3+ images (4 images).\nAI Overall: 96/100 — Excellent profile with strong scores across all categories, particularly in branding and location.', 98, NULL, 'Matches business (barber).', 98, '2026-01-02 20:06:37.000000', 'Describes services/business.', 95, NULL, 'Valid email with a custom domain (stoonbarber.com).', 98, NULL, 'Has street, city, and country.', 98, 'Name exists and is not empty.', 95, NULL, 97, 'AI', 1),
(20, 'Assessed consistency between name, email, description, location, category.', 60, 'Secure a domain matching your brand, use a domain email (e.g., info@stoonproductionstudio.com), create a simple logo and tagline, keep the same name across platforms.', 'Category does not match provided name/description.\nSuggestion: Consider changing category to match your activity (e.g., Barber / Salon).', 25, '2026-04-22 00:54:52.662036', 'Checked length, clarity, category/city relevance.', 55, 'Write 3-5 sentences covering: what you do (Health Care), who you serve in Tunisia, your strengths, services list, and a simple call-to-action.', 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.', 85, 'Checked length, characters, alignment with category.', 95, NULL, 68, 'HEURISTIC', 2),
(21, 'Assessed consistency between name, email, description, location, category.', 50, 'Secure a domain matching your brand, use a domain email (e.g., info@hamas.com), create a simple logo and tagline, keep the same name across platforms.', 'Category does not match provided name/description.\nSuggestion: Consider changing category to match your activity (e.g., General Services).', 25, '2026-04-25 20:49:37.061618', 'Checked length, clarity, category/city relevance.', 40, 'Write 3-5 sentences covering: what you do (Legal Services), who you serve in nabeul, your strengths, services list, and a simple call-to-action.', 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 45, 'Checked length, characters, alignment with category.', 95, NULL, 58, 'HEURISTIC', 17),
(22, 'Assessed consistency between name, email, description, location, category.', 50, 'Secure a domain matching your brand, use a domain email (e.g., info@hamas.com), create a simple logo and tagline, keep the same name across platforms.', 'Category does not match provided name/description.\nSuggestion: Consider changing category to match your activity (e.g., General Services).', 25, '2026-04-25 20:50:39.901373', 'Checked length, clarity, category/city relevance.', 40, 'Write 3-5 sentences covering: what you do (Legal Services), who you serve in nabeul, your strengths, services list, and a simple call-to-action.', 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 45, 'Checked length, characters, alignment with category.', 95, NULL, 58, 'HEURISTIC', 17),
(23, 'Assessed consistency between name, email, description, location, category.', 50, 'Secure a domain matching your brand, use a domain email (e.g., info@hamas.com), create a simple logo and tagline, keep the same name across platforms.', 'Category does not match provided name/description.\nSuggestion: Consider changing category to match your activity (e.g., General Services).', 25, '2026-04-25 20:51:15.644171', 'Checked length, clarity, category/city relevance.', 40, 'Write 3-5 sentences covering: what you do (Legal Services), who you serve in nabeul, your strengths, services list, and a simple call-to-action.', 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 45, 'Checked length, characters, alignment with category.', 95, NULL, 58, 'HEURISTIC', 17),
(24, 'Assessed consistency between name, email, description, location, category.', 50, 'Secure a domain matching your brand, use a domain email (e.g., info@hamas.com), create a simple logo and tagline, keep the same name across platforms.', 'Category does not match provided name/description.\nSuggestion: Consider changing category to match your activity (e.g., General Services).', 25, '2026-04-25 20:51:25.371858', 'Checked length, clarity, category/city relevance.', 40, 'Write 3-5 sentences covering: what you do (Legal Services), who you serve in nabeul, your strengths, services list, and a simple call-to-action.', 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 45, 'Checked length, characters, alignment with category.', 95, NULL, 58, 'HEURISTIC', 17),
(25, 'Assessed consistency between name, email, description, location, category.', 90, NULL, 'Category appears consistent with name/description.', 75, '2026-04-25 20:51:50.117724', 'Checked length, clarity, category/city relevance.', 80, NULL, 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 45, 'Checked length, characters, alignment with category.', 95, NULL, 79, 'HEURISTIC', 17),
(26, 'Assessed consistency between name, email, description, location, category.', 90, NULL, 'Category appears consistent with name/description.', 75, '2026-04-25 20:52:52.953847', 'Checked length, clarity, category/city relevance.', 80, NULL, 'Valid format.', 90, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 45, 'Checked length, characters, alignment with category.', 95, NULL, 79, 'HEURISTIC', 17),
(27, 'Assessed consistency between name, email, description, location, category.', 90, NULL, 'Category appears consistent with name/description.', 90, '2026-04-26 00:45:04.561249', 'Checked length, clarity, category/city relevance.', 75, NULL, 'Valid format.', 100, NULL, 'Checked number, street type, postal code, city formatting.\nSuggestion: Use format: \'123 Rue de Paris, 75001 Paris, FR\'. Include street number, type, postal code, city, country.', 65, 'Checked length, characters, alignment with category.', 100, NULL, 87, 'HEURISTIC', 1);

-- --------------------------------------------------------

--
-- Table structure for table `business_images`
--

CREATE TABLE `business_images` (
  `id` bigint NOT NULL,
  `display_order` int DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `uploaded_at` datetime(6) NOT NULL,
  `business_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_images`
--

INSERT INTO `business_images` (`id`, `display_order`, `image_url`, `uploaded_at`, `business_id`) VALUES
(1, 1, 'https://images.pexels.com/photos/1813272/pexels-photo-1813272.jpeg?cs=srgb&dl=pexels-thgusstavo-1813272.jpg&fm=jpg', '2025-11-25 20:21:14.000000', 1),
(2, 0, 'https://img.freepik.com/free-photo/barber-styling-beard-man_23-2147778882.jpg?semt=ais_hybrid&w=740&q=80', '2025-11-25 20:21:14.000000', 2),
(3, 3, 'https://images.pexels.com/photos/3998421/pexels-photo-3998421.jpeg', '2025-11-25 20:22:00.000000', 1),
(4, 2, 'https://images.pexels.com/photos/1319460/pexels-photo-1319460.jpeg', '2025-11-25 20:23:00.000000', 1),
(5, 0, 'https://images.pexels.com/photos/897263/pexels-photo-897263.jpeg', '2025-11-25 20:24:00.000000', 1),
(6, 1, 'https://images.pexels.com/photos/1570807/pexels-photo-1570807.jpeg', '2025-11-26 20:40:00.000000', 2),
(7, 2, 'https://images.pexels.com/photos/3992876/pexels-photo-3992876.jpeg', '2025-11-26 20:41:00.000000', 2),
(8, 0, 'https://images.pexels.com/photos/941861/pexels-photo-941861.jpeg', '2025-10-15 15:00:00.000000', 3),
(9, 1, 'https://images.pexels.com/photos/1579739/pexels-photo-1579739.jpeg', '2025-10-15 15:01:00.000000', 3),
(10, 2, 'https://images.pexels.com/photos/1438672/pexels-photo-1438672.jpeg', '2025-10-15 15:02:00.000000', 3),
(11, 3, 'https://images.pexels.com/photos/2147491/pexels-photo-2147491.jpeg', '2025-10-15 15:03:00.000000', 3),
(12, 4, 'https://images.pexels.com/photos/1251198/pexels-photo-1251198.jpeg', '2025-10-15 15:04:00.000000', 3),
(13, 0, 'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg', '2025-09-20 09:30:00.000000', 4),
(14, 1, 'https://images.pexels.com/photos/1449773/pexels-photo-1449773.jpeg', '2025-09-20 09:31:00.000000', 4),
(15, 2, 'https://images.pexels.com/photos/8879576/pexels-photo-8879576.jpeg', '2025-09-20 09:32:00.000000', 4),
(16, 3, 'https://images.pexels.com/photos/4916237/pexels-photo-4916237.jpeg', '2025-09-20 09:33:00.000000', 4),
(17, 0, 'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg', '2025-11-01 11:45:00.000000', 5),
(18, 1, 'https://images.pexels.com/photos/3065209/pexels-photo-3065209.jpeg', '2025-11-01 11:46:00.000000', 5),
(19, 2, 'https://images.pexels.com/photos/3065171/pexels-photo-3065171.jpeg', '2025-11-01 11:47:00.000000', 5),
(20, 3, 'https://images.pexels.com/photos/3992870/pexels-photo-3992870.jpeg', '2025-11-01 11:48:00.000000', 5),
(21, 4, 'https://images.pexels.com/photos/3993446/pexels-photo-3993446.jpeg', '2025-11-01 11:49:00.000000', 5),
(22, 0, 'https://images.pexels.com/photos/897263/pexels-photo-897263.jpeg', '2025-08-10 10:30:00.000000', 6),
(23, 1, 'https://images.pexels.com/photos/1319459/pexels-photo-1319459.jpeg', '2025-08-10 10:31:00.000000', 6),
(24, 2, 'https://images.pexels.com/photos/1805600/pexels-photo-1805600.jpeg', '2025-08-10 10:32:00.000000', 6),
(25, 0, 'https://images.pexels.com/photos/2098085/pexels-photo-2098085.jpeg', '2025-07-05 17:00:00.000000', 7),
(26, 1, 'https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg', '2025-07-05 17:01:00.000000', 7),
(27, 2, 'https://images.pexels.com/photos/1907227/pexels-photo-1907227.jpeg', '2025-07-05 17:02:00.000000', 7),
(28, 3, 'https://images.pexels.com/photos/357756/pexels-photo-357756.jpeg', '2025-07-05 17:03:00.000000', 7),
(29, 0, 'https://images.pexels.com/photos/1954524/pexels-photo-1954524.jpeg', '2025-06-12 13:30:00.000000', 8),
(30, 1, 'https://images.pexels.com/photos/703012/pexels-photo-703012.jpeg', '2025-06-12 13:31:00.000000', 8),
(31, 2, 'https://images.pexels.com/photos/3822668/pexels-photo-3822668.jpeg', '2025-06-12 13:32:00.000000', 8),
(32, 3, 'https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg', '2025-06-12 13:33:00.000000', 8),
(33, 4, 'https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg', '2025-06-12 13:34:00.000000', 8),
(34, 0, 'https://images.pexels.com/photos/1653877/pexels-photo-1653877.jpeg', '2025-05-18 15:30:00.000000', 9),
(35, 1, 'https://images.pexels.com/photos/2147491/pexels-photo-2147491.jpeg', '2025-05-18 15:31:00.000000', 9),
(36, 2, 'https://images.pexels.com/photos/365459/pexels-photo-365459.jpeg', '2025-05-18 15:32:00.000000', 9),
(37, 0, 'https://images.pexels.com/photos/3757657/pexels-photo-3757657.jpeg', '2025-04-22 12:00:00.000000', 10),
(38, 1, 'https://images.pexels.com/photos/3865618/pexels-photo-3865618.jpeg', '2025-04-22 12:01:00.000000', 10),
(39, 2, 'https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg', '2025-04-22 12:02:00.000000', 10),
(40, 3, 'https://images.pexels.com/photos/3865619/pexels-photo-3865619.jpeg', '2025-04-22 12:03:00.000000', 10),
(41, 0, 'https://images.pexels.com/photos/3845653/pexels-photo-3845653.jpeg', '2025-03-15 09:30:00.000000', 11),
(42, 1, 'https://images.pexels.com/photos/305565/pexels-photo-305565.jpeg', '2025-03-15 09:31:00.000000', 11),
(43, 0, 'https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg', '2025-02-10 14:30:00.000000', 12),
(44, 1, 'https://images.pexels.com/photos/13065690/pexels-photo-13065690.jpeg', '2025-02-10 14:31:00.000000', 12),
(45, 2, 'https://images.pexels.com/photos/279949/pexels-photo-279949.jpeg', '2025-02-10 14:32:00.000000', 12),
(46, 0, 'https://images.pexels.com/photos/1024966/pexels-photo-1024966.jpeg', '2025-01-20 11:30:00.000000', 13),
(47, 1, 'https://images.pexels.com/photos/1648387/pexels-photo-1648387.jpeg', '2025-01-20 11:31:00.000000', 13),
(48, 2, 'https://images.pexels.com/photos/3760809/pexels-photo-3760809.jpeg', '2025-01-20 11:32:00.000000', 13),
(49, 3, 'https://images.pexels.com/photos/1446161/pexels-photo-1446161.jpeg', '2025-01-20 11:33:00.000000', 13),
(50, 0, 'https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg', '2025-12-01 14:30:00.000000', 14),
(51, 1, 'https://images.pexels.com/photos/3997374/pexels-photo-3997374.jpeg', '2025-12-01 14:31:00.000000', 14),
(52, 2, 'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg', '2025-12-01 14:32:00.000000', 14),
(53, 3, 'https://images.pexels.com/photos/1477900/pexels-photo-1477900.jpeg', '2025-12-01 14:33:00.000000', 14),
(54, 4, 'https://images.pexels.com/photos/1615798/pexels-photo-1615798.jpeg', '2025-12-01 14:34:00.000000', 14),
(55, 0, 'https://images.pexels.com/photos/5731890/pexels-photo-5731890.jpeg', '2025-11-15 09:30:00.000000', 15),
(56, 1, 'https://images.pexels.com/photos/7210754/pexels-photo-7210754.jpeg', '2025-11-15 09:31:00.000000', 15),
(57, 2, 'https://images.pexels.com/photos/4587998/pexels-photo-4587998.jpeg', '2025-11-15 09:32:00.000000', 15),
(59, 0, 'https://res.cloudinary.com/duvougrqx/image/upload/v1777150262/Bookify/businesses/StoonProd-business-17-1777150256798.jpg', '2026-04-25 20:51:04.064465', 17),
(60, 1, 'https://res.cloudinary.com/duvougrqx/image/upload/v1777150270/Bookify/businesses/StoonProd-business-17-1777150268289.jpg', '2026-04-25 20:51:11.059458', 17),
(61, 2, 'https://res.cloudinary.com/duvougrqx/image/upload/v1777150301/Bookify/businesses/StoonProd-business-17-1777150299001.jpg', '2026-04-25 20:51:41.769855', 17);

-- --------------------------------------------------------

--
-- Table structure for table `business_invite_tokens`
--

CREATE TABLE `business_invite_tokens` (
  `id` bigint NOT NULL,
  `assigned_email` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `raw_token` varchar(8) DEFAULT NULL,
  `status` enum('ACTIVE','EXPIRED','REVOKED','USED') NOT NULL,
  `token_hash` varchar(64) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `used_at` datetime(6) DEFAULT NULL,
  `created_by_admin_id` bigint DEFAULT NULL,
  `used_by_user_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `business_invite_tokens`
--

INSERT INTO `business_invite_tokens` (`id`, `assigned_email`, `created_at`, `expires_at`, `raw_token`, `status`, `token_hash`, `updated_at`, `used_at`, `created_by_admin_id`, `used_by_user_id`) VALUES
(1, NULL, '2026-05-04 18:41:40.262806', NULL, '752826', 'ACTIVE', 'b4d54eec74fc032ec3d9ce81ca4815b7ee307a58e720a4f3db9516191184ebd1', NULL, NULL, NULL, NULL),
(2, NULL, '2026-05-04 18:41:40.282062', NULL, '182254', 'ACTIVE', '5fcf9f0a35afdaf41a62599ecaf15be986c427d09abf9a839156bec73595454d', NULL, NULL, NULL, NULL),
(3, NULL, '2026-05-04 18:41:40.284038', NULL, '736926', 'ACTIVE', 'd57ae4e26a0f96b605a363d5a1a81de99605e1db838fc88a95885dd086fc3dde', NULL, NULL, NULL, NULL),
(4, NULL, '2026-05-04 18:41:40.285364', NULL, '708902', 'ACTIVE', 'beb4e335fdacd65038b682808de95a74f7798c8af970eab931aa938546753922', NULL, NULL, NULL, NULL),
(5, NULL, '2026-05-04 18:41:40.288090', NULL, '516642', 'ACTIVE', '29f8639037d60e7a51e7cd3a0b757ce637093921a682ee702ce099685c7d8b23', NULL, NULL, NULL, NULL),
(6, NULL, '2026-05-04 18:41:40.290894', NULL, '450730', 'ACTIVE', 'c1d029480d6e3f3dfadc5ef8b768cc9a248c2be56113496ec2312b84f9e9d38c', NULL, NULL, NULL, NULL),
(7, NULL, '2026-05-04 18:41:40.292405', NULL, '547854', 'ACTIVE', '14566b9c206f3bc0c4a2644e451f68697d7ab3c1865430c883b3efd12fcb3a73', NULL, NULL, NULL, NULL),
(8, NULL, '2026-05-04 18:41:40.293722', NULL, '967912', 'ACTIVE', 'eddf6f4c3597cc5a761b2a69c8c968186dcb85e6b279e37b54c14629d75f54cc', NULL, NULL, NULL, NULL),
(9, NULL, '2026-05-04 18:41:40.294837', NULL, '182443', 'ACTIVE', '3ec4b3491f4d35833c589c5a17399b9862b216dc2fc10d3421d869c0ea32aab9', NULL, NULL, NULL, NULL),
(10, NULL, '2026-05-04 18:41:40.296282', NULL, '544843', 'ACTIVE', '4c161f632b012665ba280bac648728f62342385261253a47222fe572c64f5866', NULL, NULL, NULL, NULL),
(11, NULL, '2026-05-09 02:34:56.538596', NULL, '197258', 'ACTIVE', 'd922dd529e3ff136fe24df331029d9b1f089027c4532cec4798aeeb8b40c000d', NULL, NULL, NULL, NULL),
(12, NULL, '2026-05-09 02:34:56.546933', NULL, '607113', 'ACTIVE', 'a10ceaf6d4f0bbaaac1c09eee1d91be8378df53b62ffc9298f96a4c820147fa6', NULL, NULL, NULL, NULL),
(13, NULL, '2026-05-09 02:34:56.549842', NULL, '429355', 'ACTIVE', 'e3c1ca6ee39f1f780536a4b4b9762b0aaa460dc931d7abe43118489430278442', NULL, NULL, NULL, NULL),
(14, NULL, '2026-05-09 02:34:56.551611', NULL, '699995', 'ACTIVE', '913e9ae11f3359ee7563abb19db3800377dd0b64054dc3c65fbec5a8d6dbd687', NULL, NULL, NULL, NULL),
(15, NULL, '2026-05-09 02:34:56.553229', NULL, '893230', 'ACTIVE', '2b93eb168e29942582acca16495ae39823f68750157a89c31392ba618bce681b', NULL, NULL, NULL, NULL),
(16, NULL, '2026-05-09 02:34:56.555147', NULL, '438275', 'ACTIVE', '2dc440d59f628d10f6f8f0c9cfce65dec2307d0cb9b131e91c9f597f6a42b6ba', NULL, NULL, NULL, NULL),
(17, NULL, '2026-05-09 02:34:56.557797', NULL, '340762', 'ACTIVE', 'ff88924397d3a2e0a5dc87236c7bd9ce6e230d392cc0c39231d0bd72012fcff3', NULL, NULL, NULL, NULL),
(18, NULL, '2026-05-09 02:34:56.559077', NULL, '679301', 'ACTIVE', 'e98cabc07c75d4c9ab92b87ad304ec9db4df6301d09a4a755c4c05abaed26899', NULL, NULL, NULL, NULL),
(19, NULL, '2026-05-09 02:34:56.560982', NULL, '662940', 'ACTIVE', 'c6705d618e0d1cf3c15053258d8b89ae6d196754cbd78bdd878f029e589513ee', NULL, NULL, NULL, NULL),
(20, NULL, '2026-05-09 02:34:56.562982', NULL, '771152', 'ACTIVE', '167bab9d5d38635fd709e4a44b383169c78b53e14572cefe0f0e284702eb67bf', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `business_ratings`
--

CREATE TABLE `business_ratings` (
  `id` bigint NOT NULL,
  `business_id` bigint NOT NULL,
  `client_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `business_ratings`
--

INSERT INTO `business_ratings` (`id`, `business_id`, `client_id`) VALUES
(1, 1, 16),
(2, 1, 17),
(3, 1, 18),
(4, 1, 19),
(5, 3, 20),
(6, 3, 21),
(7, 3, 22),
(8, 3, 23),
(9, 4, 24),
(10, 4, 25),
(11, 4, 16),
(12, 5, 17),
(13, 5, 18),
(14, 5, 19),
(15, 6, 20),
(16, 6, 21),
(17, 6, 22),
(18, 7, 23),
(19, 7, 24),
(20, 7, 25),
(21, 8, 16),
(22, 8, 17),
(23, 8, 18),
(24, 9, 19),
(25, 9, 20),
(26, 9, 21),
(27, 10, 22),
(28, 10, 23),
(29, 10, 24),
(30, 11, 25),
(31, 11, 16),
(32, 11, 17),
(33, 12, 18),
(34, 12, 19),
(35, 12, 20),
(36, 13, 21),
(37, 13, 22),
(38, 13, 23),
(39, 14, 24),
(40, 14, 25),
(41, 14, 16),
(42, 15, 17),
(43, 15, 18),
(44, 15, 19),
(46, 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `cancellation_reason_templates`
--

CREATE TABLE `cancellation_reason_templates` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `reason` varchar(500) NOT NULL,
  `business_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `created_by` bigint NOT NULL,
  `icon` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `created_at`, `description`, `name`, `updated_at`, `created_by`, `icon`) VALUES
(1, '2025-11-25 20:11:12.000000', 'Food and dining establishments', 'Restaurants', NULL, 4, '🍽️'),
(2, '2025-11-25 20:12:36.000000', 'cuts , barber and dining establishments.', 'barber', '2026-01-03 19:59:48.000000', 4, '✂️'),
(3, '2025-10-10 10:00:00.000000', 'Beauty salons, hair styling, spas, and wellness centers', 'Beauty & Hairstyling', NULL, 4, '💇'),
(4, '2025-10-10 10:05:00.000000', 'Fitness centers, gyms, yoga studios, and personal training', 'Fitness & Wellness', NULL, 4, '💪'),
(5, '2025-10-10 10:10:00.000000', 'Medical clinics, dental offices, and healthcare providers', 'Health Care', NULL, 4, '🏥'),
(6, '2025-10-10 10:15:00.000000', 'Auto repair shops, car washes, and maintenance services', 'Automotive', NULL, 4, '🚗'),
(7, '2025-10-10 10:20:00.000000', 'Photography studios, videography, and event coverage', 'Photography', NULL, 4, '📸'),
(8, '2025-10-10 10:25:00.000000', 'Massage therapy, physiotherapy, and body treatments', 'Massage & Therapy', NULL, 4, '💆'),
(9, '2025-10-10 10:30:00.000000', 'Nail salons, manicure, pedicure, and nail art', 'Nail Salon', NULL, 4, '💅'),
(10, '2025-10-10 10:35:00.000000', 'for buisnesses without category added yet', 'OTHER', '2026-01-03 19:59:39.000000', 4, '🎨'),
(11, '2025-10-10 10:40:00.000000', 'Pet grooming, veterinary clinics, and pet care', 'Pet Services', NULL, 4, '🐾'),
(12, '2025-10-10 10:45:00.000000', 'Language schools, tutoring, and educational services', 'Education & Tutoring', NULL, 4, '📚'),
(13, '2025-10-10 10:50:00.000000', 'Music lessons, dance classes, and performing arts', 'Music & Dance', NULL, 4, '🎵'),
(14, '2025-10-10 10:55:00.000000', 'Legal consulting, law firms, and legal services', 'Legal Services', NULL, 4, '⚖️'),
(15, '2025-10-10 11:00:00.000000', 'Accounting, tax preparation, and financial consulting', 'Financial Services', NULL, 4, '💰'),
(16, '2025-10-10 11:05:00.000000', 'Event planning, wedding planning, and coordination', 'Event Planning', NULL, 4, '🎉'),
(17, '2025-10-10 11:10:00.000000', 'Home cleaning, office cleaning, and maintenance', 'Cleaning Services', NULL, 4, '🧹'),
(18, '2025-10-10 11:15:00.000000', 'Plumbing, electrical, carpentry, and home repairs', 'Home Services', NULL, 4, '🔧'),
(19, '2025-10-10 11:20:00.000000', 'Hotels, bed & breakfast, and accommodation', 'Accommodation', NULL, 4, '🏨'),
(20, '2025-10-10 11:25:00.000000', 'Travel agencies, tour guides, and tourism services', 'Travel & Tourism', NULL, 4, '✈️');

-- --------------------------------------------------------

--
-- Table structure for table `industry_feedback_submissions`
--

CREATE TABLE `industry_feedback_submissions` (
  `id` bigint NOT NULL,
  `contact_email` varchar(320) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `industry_name` varchar(150) NOT NULL,
  `phone_number` varchar(30) NOT NULL,
  `source_category_name` varchar(150) DEFAULT NULL,
  `source_slug` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `method` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transaction_ref` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `booking_id` bigint DEFAULT NULL,
  `subscription_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profile_alert_states`
--

CREATE TABLE `profile_alert_states` (
  `id` bigint NOT NULL,
  `alert_key` varchar(100) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `last_sent_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profile_resolution_audits`
--

CREATE TABLE `profile_resolution_audits` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `failure_reason` varchar(512) DEFAULT NULL,
  `snapshot_stale` bit(1) NOT NULL,
  `source_used` varchar(32) NOT NULL,
  `user_id` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profile_snapshot_sync_runs`
--

CREATE TABLE `profile_snapshot_sync_runs` (
  `id` bigint NOT NULL,
  `alert_sent_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `ended_at` datetime(6) DEFAULT NULL,
  `error_summary` longtext,
  `failed_count` int NOT NULL,
  `source_updated_through` datetime(6) DEFAULT NULL,
  `started_at` datetime(6) NOT NULL,
  `status` varchar(32) NOT NULL,
  `synced_count` int NOT NULL,
  `triggered_by` varchar(32) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `profile_snapshot_sync_runs`
--

INSERT INTO `profile_snapshot_sync_runs` (`id`, `alert_sent_at`, `created_at`, `ended_at`, `error_summary`, `failed_count`, `source_updated_through`, `started_at`, `status`, `synced_count`, `triggered_by`, `updated_at`) VALUES
(1, NULL, '2026-05-04 18:30:00.000000', '2026-05-04 18:30:00.000000', NULL, 0, '2026-05-04 18:25:07.247000', '2026-05-04 18:30:00.000000', 'SUCCESS', 13, 'cron', '2026-05-04 18:30:00.000000'),
(2, NULL, '2026-05-04 18:45:00.000000', '2026-05-04 18:45:00.000000', NULL, 0, '2026-05-04 18:40:06.649000', '2026-05-04 18:45:00.000000', 'SUCCESS', 13, 'cron', '2026-05-04 18:45:00.000000'),
(3, NULL, '2026-05-04 19:00:00.000000', '2026-05-04 19:00:00.000000', NULL, 0, '2026-05-04 18:55:04.353000', '2026-05-04 19:00:00.000000', 'SUCCESS', 13, 'cron', '2026-05-04 19:00:00.000000'),
(4, NULL, '2026-05-04 19:15:00.000000', '2026-05-04 19:15:00.000000', NULL, 0, '2026-05-04 19:10:04.013000', '2026-05-04 19:15:00.000000', 'SUCCESS', 13, 'cron', '2026-05-04 19:15:00.000000'),
(5, NULL, '2026-05-04 19:30:00.000000', '2026-05-04 19:30:00.000000', NULL, 0, '2026-05-04 19:25:04.211000', '2026-05-04 19:30:00.000000', 'SUCCESS', 14, 'cron', '2026-05-04 19:30:00.000000'),
(6, NULL, '2026-05-04 19:45:00.000000', '2026-05-04 19:45:00.000000', NULL, 0, '2026-05-04 19:40:04.202000', '2026-05-04 19:45:00.000000', 'SUCCESS', 14, 'cron', '2026-05-04 19:45:00.000000'),
(7, NULL, '2026-05-04 20:00:00.000000', '2026-05-04 20:00:00.000000', NULL, 0, '2026-05-04 19:55:05.281000', '2026-05-04 20:00:00.000000', 'SUCCESS', 14, 'cron', '2026-05-04 20:00:00.000000'),
(8, NULL, '2026-05-04 20:15:00.000000', '2026-05-04 20:15:00.000000', NULL, 0, '2026-05-04 20:10:05.249000', '2026-05-04 20:15:00.000000', 'SUCCESS', 14, 'cron', '2026-05-04 20:15:00.000000'),
(9, NULL, '2026-05-04 20:30:00.000000', '2026-05-04 20:30:00.000000', NULL, 0, '2026-05-04 20:25:04.360000', '2026-05-04 20:30:00.000000', 'SUCCESS', 14, 'cron', '2026-05-04 20:30:00.000000'),
(10, NULL, '2026-05-08 23:30:00.000000', '2026-05-08 23:30:00.000000', NULL, 0, '2026-05-05 06:00:06.459000', '2026-05-08 23:30:00.000000', 'SUCCESS', 14, 'cron', '2026-05-08 23:30:00.000000'),
(11, NULL, '2026-05-08 23:45:00.000000', '2026-05-08 23:45:01.000000', NULL, 0, '2026-05-08 23:40:06.485000', '2026-05-08 23:45:00.000000', 'SUCCESS', 14, 'cron', '2026-05-08 23:45:01.000000'),
(12, NULL, '2026-05-09 00:00:00.000000', '2026-05-09 00:00:01.000000', NULL, 0, '2026-05-08 23:55:05.690000', '2026-05-09 00:00:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 00:00:01.000000'),
(13, NULL, '2026-05-09 00:15:00.000000', '2026-05-09 00:15:00.000000', NULL, 0, '2026-05-09 00:10:07.873000', '2026-05-09 00:15:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 00:15:00.000000'),
(14, NULL, '2026-05-09 00:30:00.000000', '2026-05-09 00:30:01.000000', NULL, 0, '2026-05-09 00:25:05.709000', '2026-05-09 00:30:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 00:30:01.000000'),
(15, NULL, '2026-05-09 00:45:00.000000', '2026-05-09 00:45:00.000000', NULL, 0, '2026-05-09 00:40:07.027000', '2026-05-09 00:45:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 00:45:00.000000'),
(16, NULL, '2026-05-09 01:00:00.000000', '2026-05-09 01:00:30.000000', 'getaddrinfo ENOTFOUND ac-1drdbfa-shard-00-01.r8tcyqv.mongodb.net', 1, NULL, '2026-05-09 01:00:00.000000', 'FAILED', 0, 'cron', '2026-05-09 01:00:30.000000'),
(17, NULL, '2026-05-09 01:15:00.000000', '2026-05-09 01:15:01.000000', NULL, 0, '2026-05-09 01:10:05.987000', '2026-05-09 01:15:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 01:15:01.000000'),
(18, NULL, '2026-05-09 01:30:00.000000', '2026-05-09 01:30:00.000000', NULL, 0, '2026-05-09 01:25:07.304000', '2026-05-09 01:30:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 01:30:00.000000'),
(19, NULL, '2026-05-09 01:45:00.000000', '2026-05-09 01:45:00.000000', NULL, 0, '2026-05-09 01:40:04.769000', '2026-05-09 01:45:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 01:45:00.000000'),
(20, NULL, '2026-05-09 02:00:00.000000', '2026-05-09 02:00:00.000000', NULL, 0, '2026-05-09 01:55:04.263000', '2026-05-09 02:00:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 02:00:00.000000'),
(21, NULL, '2026-05-09 02:15:00.000000', '2026-05-09 02:15:00.000000', NULL, 0, '2026-05-09 02:10:05.080000', '2026-05-09 02:15:00.000000', 'SUCCESS', 14, 'cron', '2026-05-09 02:15:00.000000'),
(22, NULL, '2026-05-09 02:30:00.000000', '2026-05-09 02:30:00.000000', NULL, 0, '2026-05-09 02:25:05.508000', '2026-05-09 02:30:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 02:30:00.000000'),
(23, NULL, '2026-05-09 02:45:00.000000', '2026-05-09 02:45:00.000000', NULL, 0, '2026-05-09 02:40:05.364000', '2026-05-09 02:45:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 02:45:00.000000'),
(24, NULL, '2026-05-09 03:00:00.000000', '2026-05-09 03:00:00.000000', NULL, 0, '2026-05-09 02:55:05.246000', '2026-05-09 03:00:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 03:00:00.000000'),
(25, NULL, '2026-05-09 03:15:00.000000', '2026-05-09 03:15:01.000000', NULL, 0, '2026-05-09 03:10:05.419000', '2026-05-09 03:15:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 03:15:01.000000'),
(26, NULL, '2026-05-09 03:30:00.000000', '2026-05-09 03:30:01.000000', NULL, 0, '2026-05-09 03:25:05.772000', '2026-05-09 03:30:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 03:30:01.000000'),
(27, NULL, '2026-05-09 03:45:00.000000', '2026-05-09 03:45:01.000000', NULL, 0, '2026-05-09 03:40:05.413000', '2026-05-09 03:45:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 03:45:01.000000'),
(28, NULL, '2026-05-09 09:45:00.000000', '2026-05-09 09:45:00.000000', NULL, 0, '2026-05-09 09:40:05.815000', '2026-05-09 09:45:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 09:45:00.000000'),
(29, NULL, '2026-05-09 10:00:00.000000', '2026-05-09 10:00:00.000000', NULL, 0, '2026-05-09 09:55:05.566000', '2026-05-09 10:00:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 10:00:00.000000'),
(30, NULL, '2026-05-09 10:15:00.000000', '2026-05-09 10:15:00.000000', NULL, 0, '2026-05-09 10:10:05.386000', '2026-05-09 10:15:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 10:15:00.000000'),
(31, NULL, '2026-05-09 10:30:00.000000', '2026-05-09 10:30:00.000000', NULL, 0, '2026-05-09 10:25:05.230000', '2026-05-09 10:30:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 10:30:00.000000'),
(32, NULL, '2026-05-09 10:45:00.000000', '2026-05-09 10:45:00.000000', NULL, 0, '2026-05-09 10:40:06.213000', '2026-05-09 10:45:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 10:45:00.000000'),
(33, NULL, '2026-05-09 11:00:00.000000', '2026-05-09 11:00:00.000000', NULL, 0, '2026-05-09 10:55:06.239000', '2026-05-09 11:00:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 11:00:00.000000'),
(34, NULL, '2026-05-09 11:15:00.000000', '2026-05-09 11:15:00.000000', NULL, 0, '2026-05-09 11:10:06.415000', '2026-05-09 11:15:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 11:15:00.000000'),
(35, NULL, '2026-05-09 11:30:00.000000', '2026-05-09 11:30:01.000000', NULL, 0, '2026-05-09 11:25:06.348000', '2026-05-09 11:30:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 11:30:01.000000'),
(36, NULL, '2026-05-09 11:45:00.000000', '2026-05-09 11:45:00.000000', NULL, 0, '2026-05-09 11:40:09.578000', '2026-05-09 11:45:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 11:45:00.000000'),
(37, NULL, '2026-05-09 12:00:00.000000', '2026-05-09 12:00:00.000000', NULL, 0, '2026-05-09 11:55:06.749000', '2026-05-09 12:00:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 12:00:00.000000'),
(38, NULL, '2026-05-09 12:15:00.000000', '2026-05-09 12:15:00.000000', NULL, 0, '2026-05-09 12:10:06.392000', '2026-05-09 12:15:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 12:15:00.000000'),
(39, NULL, '2026-05-09 12:30:00.000000', '2026-05-09 12:30:00.000000', NULL, 0, '2026-05-09 12:25:06.031000', '2026-05-09 12:30:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 12:30:00.000000'),
(40, NULL, '2026-05-09 12:45:00.000000', '2026-05-09 12:45:00.000000', NULL, 0, '2026-05-09 12:40:06.503000', '2026-05-09 12:45:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 12:45:00.000000'),
(41, NULL, '2026-05-09 13:00:00.000000', '2026-05-09 13:00:01.000000', NULL, 0, '2026-05-09 12:55:06.519000', '2026-05-09 13:00:00.000000', 'SUCCESS', 15, 'cron', '2026-05-09 13:00:01.000000');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` bigint NOT NULL,
  `comment` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `date` date NOT NULL,
  `score` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `comment`, `created_at`, `date`, `score`) VALUES
(1, 'Excellent service! The barber really knows what he is doing. Very professional and friendly. ', '2025-12-10 11:00:00.000000', '2025-12-10', 1),
(2, 'Good haircut but had to wait 20 minutes even with an appointment. ', '2025-12-12 14:30:00.000000', '2025-12-12', 4),
(3, 'Best barbershop in Paris! Always consistent quality.  Highly recommend.', '2025-12-15 16:00:00.000000', '2025-12-15', 5),
(4, 'My son loved his haircut! The staff was very patient with children.', '2025-12-18 10:00:00.000000', '2025-12-18', 2),
(5, 'Amazing food! The pasta was homemade and delicious. Great wine selection too.', '2025-11-20 20:30:00.000000', '2025-11-20', 5),
(6, 'Good Italian restaurant but a bit pricey. Service was excellent though.', '2025-12-05 21:00:00.000000', '2025-12-05', 4),
(7, 'The pizza was incredible! Best I have had outside of Italy.', '2025-12-10 19:30:00.000000', '2025-12-10', 5),
(8, 'Nice atmosphere and authentic taste. Will definitely come back.', '2025-12-18 20:00:00.000000', '2025-12-18', 4),
(9, 'Authentic Tunisian cuisine. The couscous was fantastic.  Friendly staff and nice ambiance.', '2025-11-25 21:00:00.000000', '2025-11-25', 5),
(10, 'Traditional recipes that taste like home. Highly recommended for authentic experience.', '2025-12-08 20:30:00.000000', '2025-12-08', 2),
(11, 'Good food but service was a bit slow. Worth the wait though.', '2025-12-15 19:00:00.000000', '2025-12-15', 4),
(12, 'Great experience!  Loved my hair color.  The stylist was very skilled and listened to exactly what I wanted.', '2025-12-12 16:00:00.000000', '2025-12-12', 5),
(13, 'Professional salon with high-quality products. A bit expensive but worth it. ', '2025-12-16 17:00:00.000000', '2025-12-16', 2),
(14, 'Best balayage I have ever had! The staff is talented and friendly.', '2025-12-20 15:30:00.000000', '2025-12-20', 5),
(15, 'Perfect haircut every time. These guys are pros! ', '2025-11-20 11:00:00.000000', '2025-11-20', 5),
(16, 'Great atmosphere and skilled barbers. The complimentary coffee is a nice touch. ', '2025-12-05 12:00:00.000000', '2025-12-05', 2),
(17, 'Good service but prices have gone up recently. ', '2025-12-18 14:00:00.000000', '2025-12-18', 4),
(18, 'Outstanding sushi! Fresh fish and authentic Japanese flavors. ', '2025-11-28 21:00:00.000000', '2025-11-28', 5),
(19, 'The omakase experience was incredible. Chef is very talented.', '2025-12-08 22:00:00.000000', '2025-12-08', 3),
(20, 'Good ramen but portions could be bigger for the price.', '2025-12-15 20:00:00.000000', '2025-12-15', 4),
(21, 'Amazing personal trainer! Helped me reach my fitness goals.', '2025-11-30 09:00:00.000000', '2025-11-30', 5),
(22, 'Great yoga classes.  The instructor is patient and knowledgeable.', '2025-12-10 08:00:00.000000', '2025-12-10', 3),
(23, 'Good gym with modern equipment. Gets crowded during peak hours.', '2025-12-18 18:00:00.000000', '2025-12-18', 4),
(24, 'Authentic Neapolitan pizza!  The wood-fired oven makes all the difference.', '2025-12-02 20:00:00.000000', '2025-12-02', 5),
(25, 'Family-friendly atmosphere. Kids loved the pizza. ', '2025-12-12 19:00:00.000000', '2025-12-12', 5),
(26, 'Good pizza but nothing extraordinary. Decent prices though.', '2025-12-19 18:30:00.000000', '2025-12-19', 3),
(27, 'Most relaxing massage I have ever had. Tranquil environment.', '2025-12-05 15:00:00.000000', '2025-12-05', 5),
(28, 'Excellent facial treatment. My skin feels amazing! ', '2025-12-14 16:00:00.000000', '2025-12-14', 5),
(29, 'Good spa but appointment times could be more flexible.', '2025-12-20 14:00:00.000000', '2025-12-20', 4),
(30, 'Professional and painless dental cleaning. Highly recommend Dr. Martin.', '2025-11-25 10:00:00.000000', '2025-11-25', 5),
(31, 'Great teeth whitening results!  Staff is very friendly.', '2025-12-08 11:00:00.000000', '2025-12-08', 5),
(32, 'Good dental care but waiting room could be more comfortable.', '2025-12-17 09:00:00.000000', '2025-12-17', 4),
(33, 'Fast and reliable service. They fixed my brakes quickly.', '2025-12-01 16:00:00.000000', '2025-12-01', 5),
(34, 'Honest mechanics who do not overcharge. Will come back. ', '2025-12-10 15:00:00.000000', '2025-12-10', 5),
(35, 'Good service but took longer than estimated. ', '2025-12-18 14:00:00.000000', '2025-12-18', 4),
(36, 'Our wedding photos are absolutely stunning! Worth every penny.', '2025-11-15 12:00:00.000000', '2025-11-15', 5),
(37, 'Professional photographer with great creative vision. ', '2025-12-05 13:00:00.000000', '2025-12-05', 5),
(38, 'Good family portraits.  Could have been faster though.', '2025-12-15 11:00:00.000000', '2025-12-15', 4),
(39, 'Best manicure ever! The nail art is gorgeous. ', '2025-12-08 16:00:00.000000', '2025-12-08', 5),
(40, 'Very clean salon with professional staff. Gel nails lasted 3 weeks! ', '2025-12-16 17:00:00.000000', '2025-12-16', 5),
(41, 'Good pedicure but a bit expensive for what you get.', '2025-12-20 15:00:00.000000', '2025-12-20', 4),
(42, 'My dog looks amazing! The groomers are patient and gentle.', '2025-12-03 10:00:00.000000', '2025-12-03', 5),
(43, 'Excellent pet grooming service. My cat actually enjoyed it!', '2025-12-12 11:00:00.000000', '2025-12-12', 5),
(44, 'Good grooming but wish they had more appointment slots available.', '2025-12-19 10:00:00.000000', '2025-12-19', 4),
(45, 'this was stoon testing', '2025-12-28 22:39:14.000000', '2025-12-29', 5),
(46, NULL, '2025-12-28 22:40:10.000000', '2025-12-29', 5);

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `price_per_hour` decimal(10,2) NOT NULL,
  `status` enum('AVAILABLE','HOLIDAY','MAINTENANCE','OUT_OF_ORDER') COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `business_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `resource_availabilities`
--

CREATE TABLE `resource_availabilities` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `date` date NOT NULL,
  `end_time` time(6) NOT NULL,
  `start_time` time(6) NOT NULL,
  `status` enum('AVAILABLE','HOLIDAY','MAINTENANCE','OUT_OF_ORDER') COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `resource_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `resource_ratings`
--

CREATE TABLE `resource_ratings` (
  `id` bigint NOT NULL,
  `client_id` bigint NOT NULL,
  `resource_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `resource_reservations`
--

CREATE TABLE `resource_reservations` (
  `id` bigint NOT NULL,
  `client_id` bigint NOT NULL,
  `resource_availability_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint NOT NULL,
  `business_rating` int DEFAULT NULL,
  `comment` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `rating` int NOT NULL,
  `response` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tenant_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `booking_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `id` bigint NOT NULL,
  `active` bit(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `duration_minutes` int NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `tenant_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `business_id` bigint NOT NULL,
  `created_by` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`id`, `active`, `created_at`, `description`, `duration_minutes`, `image_url`, `name`, `price`, `tenant_id`, `updated_at`, `business_id`, `created_by`) VALUES
(1, b'1', '2025-11-25 20:32:19.000000', 'Basic cut', 30, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMOP5LizXxUSD4y4YF2HW6HyG3xTiOKnLb8g&s', 'Haircut', 6.00, NULL, NULL, 1, 1),
(6, b'1', '2025-11-25 23:47:48.000000', 'Full hair coloring or highlights', 60, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUoPcLKKLTG5n9l4LpDZoCX1Ddpe-FTGHo4A&s', 'Hair Coloring', 50.00, NULL, '2026-01-02 23:39:58.000000', 1, 2),
(7, b'1', '2025-11-26 02:04:13.000000', 'Classic shave with hot towel treatment', 15, 'https://images.squarespace-cdn.com/content/v1/6499daf94cf67b3cc46ceb7c/15abf3c3-8b87-4aad-8f2f-ff6748cd353b/hot+towel+shave+dublin.jpg', 'Hot Towel Shave', 7.00, NULL, '2026-01-01 21:19:13.000000', 1, 2),
(8, b'1', '2025-11-26 02:12:29.000000', 'Gentle haircut for children under 12', 20, 'https://i0.wp.com/mancaveformen.com/wp-content/uploads/2024/07/Kids-Haircuts-Coral-Gables-Florida-Best-Haircuts-Coral-Gables.jpeg?resize=600%2C600', 'Kids Haircut', 3.00, NULL, '2026-01-01 21:20:00.000000', 1, 2),
(9, b'1', '2025-11-26 02:13:04.000000', 'Shampoo, conditioner, and full styling', 25, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTruToe50QbCP2q4B3KlU6txv2ChbfeLVGQSw&s', 'Hair Wash & Style', 5.00, NULL, NULL, 1, 5),
(10, b'1', '2025-10-15 15:00:00.000000', 'Fresh house-made pasta with choice of sauce', 45, 'https://images.pexels.com/photos/1438672/pexels-photo-1438672.jpeg', 'Pasta Dish', 14.00, NULL, NULL, 3, 8),
(11, b'1', '2025-10-15 15:05:00.000000', 'Wood-fired Margherita pizza with fresh mozzarella', 30, 'https://images.pexels.com/photos/2147491/pexels-photo-2147491.jpeg', 'Pizza Margherita', 12.00, NULL, NULL, 3, 8),
(12, b'1', '2025-10-15 15:10:00.000000', 'Classic Italian tiramisu dessert', 15, 'https://images.pexels.com/photos/6210874/pexels-photo-6210874.jpeg', 'Tiramisu', 7.00, NULL, NULL, 3, 8),
(13, b'1', '2025-09-20 10:00:00.000000', 'Traditional Tunisian couscous with lamb and vegetables', 60, 'https://images.pexels.com/photos/8879576/pexels-photo-8879576.jpeg', 'Couscous', 16.00, NULL, NULL, 4, 9),
(14, b'1', '2025-09-20 10:05:00.000000', 'Crispy Tunisian brik with egg and tuna', 20, 'https://images.pexels.com/photos/4916237/pexels-photo-4916237.jpeg', 'Brik', 5.00, NULL, NULL, 4, 9),
(15, b'1', '2025-09-20 10:10:00.000000', 'Grilled Mediterranean sea bass with herbs', 50, 'https://images.pexels.com/photos/262959/pexels-photo-262959.jpeg', 'Grilled Fish', 20.00, NULL, NULL, 4, 9),
(16, b'1', '2025-11-01 12:00:00.000000', 'Premium balayage hair coloring technique', 120, 'https://images.pexels.com/photos/3065171/pexels-photo-3065171.jpeg', 'Balayage', 85.00, NULL, NULL, 5, 10),
(17, b'1', '2025-11-01 12:05:00.000000', 'Brazilian keratin treatment for smooth hair', 150, 'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg', 'Keratin Treatment', 120.00, NULL, NULL, 5, 10),
(18, b'1', '2025-11-01 12:10:00.000000', 'Complete bridal hair and makeup package', 180, 'https://images.pexels.com/photos/3065209/pexels-photo-3065209.jpeg', 'Bridal Package', 200.00, NULL, NULL, 5, 10),
(19, b'1', '2025-11-01 12:15:00.000000', 'Women haircut with styling', 45, 'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg', 'Women Haircut', 35.00, NULL, NULL, 5, 10),
(20, b'1', '2025-08-10 11:00:00.000000', 'Classic gentleman haircut', 40, 'https://images.pexels.com/photos/897263/pexels-photo-897263.jpeg', 'Classic Cut', 12.00, NULL, NULL, 6, 11),
(21, b'1', '2025-08-10 11:05:00.000000', 'Straight razor shave with hot towel', 30, 'https://images.pexels.com/photos/1570807/pexels-photo-1570807.jpeg', 'Straight Razor Shave', 15.00, NULL, NULL, 6, 11),
(22, b'1', '2025-08-10 11:10:00.000000', 'Beard trim and shaping', 20, 'https://images.pexels.com/photos/1570807/pexels-photo-1570807.jpeg', 'Beard Trim', 8.00, NULL, NULL, 6, 11),
(23, b'1', '2025-08-10 11:15:00.000000', 'Modern fade haircut', 35, 'https://images.pexels.com/photos/1805600/pexels-photo-1805600.jpeg', 'Fade Cut', 14.00, NULL, NULL, 6, 11),
(24, b'1', '2025-07-05 17:30:00.000000', 'Assorted fresh sushi and sashimi platter', 30, 'https://images.pexels.com/photos/2098085/pexels-photo-2098085.jpeg', 'Sushi Platter', 28.00, NULL, NULL, 7, 12),
(25, b'1', '2025-07-05 17:35:00.000000', 'Traditional Japanese ramen with pork', 40, 'https://images.pexels.com/photos/1907227/pexels-photo-1907227.jpeg', 'Ramen', 15.00, NULL, NULL, 7, 12),
(26, b'1', '2025-07-05 17:40:00.000000', 'Chef selection omakase experience', 90, 'https://images.pexels.com/photos/2635038/pexels-photo-2635038.jpeg', 'Omakase', 85.00, NULL, NULL, 7, 12),
(27, b'1', '2025-06-12 14:00:00.000000', 'One-on-one personal training session', 60, 'https://images.pexels.com/photos/1954524/pexels-photo-1954524.jpeg', 'Personal Training', 45.00, NULL, NULL, 8, 13),
(28, b'1', '2025-06-12 14:05:00.000000', 'Group yoga class for all levels', 60, 'https://images.pexels.com/photos/3822668/pexels-photo-3822668.jpeg', 'Yoga Class', 15.00, NULL, NULL, 8, 13),
(29, b'1', '2025-06-12 14:10:00.000000', 'High-intensity interval training class', 45, 'https://images.pexels.com/photos/703012/pexels-photo-703012.jpeg', 'HIIT Class', 18.00, NULL, NULL, 8, 13),
(30, b'1', '2025-06-12 14:15:00.000000', 'Pilates mat class', 60, 'https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg', 'Pilates Class', 16.00, NULL, NULL, 8, 13),
(31, b'1', '2025-05-18 16:00:00.000000', 'Classic Neapolitan pizza', 25, 'https://images.pexels.com/photos/2147491/pexels-photo-2147491.jpeg', 'Napoletana Pizza', 13.00, NULL, NULL, 9, 14),
(32, b'1', '2025-05-18 16:05:00.000000', 'Four cheese pizza', 25, 'https://images.pexels.com/photos/365459/pexels-photo-365459.jpeg', 'Quattro Formaggi', 15.00, NULL, NULL, 9, 14),
(33, b'1', '2025-05-18 16:10:00.000000', 'Calzone filled with ham and cheese', 30, 'https://images.pexels.com/photos/2147491/pexels-photo-2147491.jpeg', 'Calzone', 12.00, NULL, NULL, 9, 14),
(34, b'1', '2025-04-22 12:00:00.000000', 'Swedish relaxation massage', 60, 'https://images.pexels.com/photos/3757657/pexels-photo-3757657.jpeg', 'Swedish Massage', 70.00, NULL, NULL, 10, 15),
(35, b'1', '2025-04-22 12:05:00.000000', 'Deep tissue therapeutic massage', 75, 'https://images.pexels.com/photos/3865618/pexels-photo-3865618.jpeg', 'Deep Tissue Massage', 85.00, NULL, NULL, 10, 15),
(36, b'1', '2025-04-22 12:10:00.000000', 'Facial treatment with organic products', 60, 'https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg', 'Organic Facial', 65.00, NULL, NULL, 10, 15),
(37, b'1', '2025-04-22 12:15:00.000000', 'Hot stone massage therapy', 90, 'https://images.pexels.com/photos/3865618/pexels-photo-3865618.jpeg', 'Hot Stone Massage', 95.00, NULL, NULL, 10, 15),
(38, b'1', '2025-03-15 10:00:00.000000', 'General dental checkup and cleaning', 45, 'https://images.pexels.com/photos/3845653/pexels-photo-3845653.jpeg', 'Dental Checkup', 80.00, NULL, NULL, 11, 16),
(39, b'1', '2025-03-15 10:05:00.000000', 'Teeth whitening treatment', 60, 'https://images.pexels.com/photos/305565/pexels-photo-305565.jpeg', 'Teeth Whitening', 250.00, NULL, NULL, 11, 16),
(40, b'1', '2025-03-15 10:10:00.000000', 'Dental filling for cavity', 30, 'https://images.pexels.com/photos/3845653/pexels-photo-3845653.jpeg', 'Dental Filling', 120.00, NULL, NULL, 11, 16),
(41, b'1', '2025-02-10 15:00:00.000000', 'Standard oil change service', 30, 'https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg', 'Oil Change', 45.00, NULL, NULL, 12, 17),
(42, b'1', '2025-02-10 15:05:00.000000', 'Brake pad replacement', 90, 'https://images.pexels.com/photos/13065690/pexels-photo-13065690.jpeg', 'Brake Service', 180.00, NULL, NULL, 12, 17),
(43, b'1', '2025-02-10 15:10:00.000000', 'Engine diagnostic scan', 45, 'https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg', 'Engine Diagnostic', 85.00, NULL, NULL, 12, 17),
(44, b'1', '2025-02-10 15:15:00.000000', 'Tire rotation and balancing', 45, 'https://images.pexels.com/photos/13065690/pexels-photo-13065690.jpeg', 'Tire Service', 65.00, NULL, NULL, 12, 17),
(45, b'1', '2025-01-20 11:00:00.000000', 'Wedding photography full day coverage', 480, 'https://images.pexels.com/photos/1024966/pexels-photo-1024966.jpeg', 'Wedding Photography', 1500.00, NULL, NULL, 13, 18),
(46, b'1', '2025-01-20 11:05:00.000000', 'Family portrait session', 60, 'https://images.pexels.com/photos/1648387/pexels-photo-1648387.jpeg', 'Family Portraits', 200.00, NULL, NULL, 13, 18),
(47, b'1', '2025-01-20 11:10:00.000000', 'Corporate headshots', 30, 'https://images.pexels.com/photos/3760809/pexels-photo-3760809.jpeg', 'Corporate Headshots', 150.00, NULL, NULL, 13, 18),
(48, b'1', '2025-12-01 14:00:00.000000', 'Classic manicure with polish', 45, 'https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg', 'Manicure', 30.00, NULL, NULL, 14, 19),
(49, b'1', '2025-12-01 14:05:00.000000', 'Spa pedicure with massage', 60, 'https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg', 'Pedicure', 40.00, NULL, NULL, 14, 19),
(50, b'1', '2025-12-01 14:10:00.000000', 'Gel nails with design', 75, 'https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg', 'Gel Nails', 55.00, NULL, NULL, 14, 19),
(51, b'1', '2025-12-01 14:15:00.000000', 'Acrylic nail extensions', 90, 'https://images.pexels.com/photos/3997379/pexels-photo-3997379.jpeg', 'Acrylic Nails', 65.00, NULL, NULL, 14, 19),
(52, b'1', '2025-11-15 09:00:00.000000', 'Full dog grooming with bath and haircut', 90, 'https://images.pexels.com/photos/5731890/pexels-photo-5731890.jpeg', 'Dog Grooming', 60.00, NULL, NULL, 15, 20),
(53, b'1', '2025-11-15 09:05:00.000000', 'Cat grooming and styling', 60, 'https://images.pexels.com/photos/7210754/pexels-photo-7210754.jpeg', 'Cat Grooming', 50.00, NULL, NULL, 15, 20),
(54, b'1', '2025-11-15 09:10:00.000000', 'Nail trimming for pets', 20, 'https://images.pexels.com/photos/5731890/pexels-photo-5731890.jpeg', 'Pet Nail Trim', 20.00, NULL, NULL, 15, 20),
(56, b'1', '2026-01-01 21:53:10.000000', 'Quick refresh of fades and edges between full haircuts', 15, 'https://www.artistbarber.com/uploads/stores/304/2ecbab70-46c2-410f-a21d-4168c09576ec_original.jpg', 'Fade Touch-Up', 3.00, NULL, NULL, 1, 2),
(57, b'1', '2026-04-24 15:32:57.008825', 'test', 30, 'https://www.saltgrooming.com/cdn/shop/articles/haircut-clippers_54d401f5-2c6f-4064-a5f7-e3546f7860ea_1200x.png?v=1719220336', 'test', 22.00, NULL, NULL, 1, 1),
(58, b'1', '2026-04-24 15:34:00.930400', 'test', 30, 'https://www.saltgrooming.com/cdn/shop/articles/haircut-clippers_54d401f5-2c6f-4064-a5f7-e3546f7860ea_1200x.png?v=1719220336', 'test1', 32.00, NULL, NULL, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `service_bookings`
--

CREATE TABLE `service_bookings` (
  `id` bigint NOT NULL,
  `client_id` bigint DEFAULT NULL,
  `service_id` bigint NOT NULL,
  `staff_id` bigint DEFAULT NULL,
  `business_client_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service_bookings`
--

INSERT INTO `service_bookings` (`id`, `client_id`, `service_id`, `staff_id`, `business_client_id`) VALUES
(1, 3, 1, 2, NULL),
(2, 16, 1, 2, NULL),
(3, 7, 8, 2, NULL),
(4, 17, 7, 2, NULL),
(5, 18, 1, 5, NULL),
(6, 19, 1, 5, NULL),
(7, 20, 6, 5, NULL),
(8, 21, 1, 26, NULL),
(9, 22, 7, 26, NULL),
(10, 23, 1, 2, NULL),
(11, 24, 8, 2, NULL),
(12, 25, 1, 2, NULL),
(13, 16, 1, 2, NULL),
(14, 17, 7, 5, NULL),
(15, 18, 1, 26, NULL),
(16, 19, 1, 2, NULL),
(17, 20, 1, 2, NULL),
(18, 21, 1, 5, NULL),
(19, 22, 9, 5, NULL),
(20, 3, 1, 2, NULL),
(21, 23, 1, 26, NULL),
(22, 24, 7, 26, NULL),
(23, 25, 1, 2, NULL),
(24, 16, 8, 2, NULL),
(25, 17, 7, 5, NULL),
(26, 18, 1, 2, NULL),
(27, 19, 6, 5, NULL),
(31, NULL, 1, 2, 1),
(32, NULL, 56, 2, 1),
(33, 3, 56, 2, NULL),
(36, 3, 56, 2, NULL),
(38, 3, 23, 28, NULL),
(39, 3, 38, 24, NULL),
(40, 24, 40, 24, NULL),
(41, 1, 39, 24, NULL),
(42, 33, 38, 24, NULL),
(167, 3, 1, 2, NULL),
(216, 3, 8, 2, NULL),
(217, 3, 56, 2, NULL),
(218, 3, 56, 2, NULL),
(219, 3, 56, 2, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `service_booking_occupancy`
--

CREATE TABLE `service_booking_occupancy` (
  `id` bigint NOT NULL,
  `booking_id` bigint NOT NULL,
  `date` date NOT NULL,
  `slot_index` int NOT NULL,
  `staff_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `service_booking_occupancy`
--

INSERT INTO `service_booking_occupancy` (`id`, `booking_id`, `date`, `slot_index`, `staff_id`) VALUES
(7921, 167, '2026-05-14', 660, 2),
(7922, 167, '2026-05-14', 661, 2),
(7923, 167, '2026-05-14', 662, 2),
(7924, 167, '2026-05-14', 663, 2),
(7925, 167, '2026-05-14', 664, 2),
(7926, 167, '2026-05-14', 665, 2),
(7927, 167, '2026-05-14', 666, 2),
(7928, 167, '2026-05-14', 667, 2),
(7929, 167, '2026-05-14', 668, 2),
(7930, 167, '2026-05-14', 669, 2),
(7931, 167, '2026-05-14', 670, 2),
(7932, 167, '2026-05-14', 671, 2),
(7933, 167, '2026-05-14', 672, 2),
(7934, 167, '2026-05-14', 673, 2),
(7935, 167, '2026-05-14', 674, 2),
(7936, 167, '2026-05-14', 675, 2),
(7937, 167, '2026-05-14', 676, 2),
(7938, 167, '2026-05-14', 677, 2),
(7939, 167, '2026-05-14', 678, 2),
(7940, 167, '2026-05-14', 679, 2),
(7941, 167, '2026-05-14', 680, 2),
(7942, 167, '2026-05-14', 681, 2),
(7943, 167, '2026-05-14', 682, 2),
(7944, 167, '2026-05-14', 683, 2),
(7945, 167, '2026-05-14', 684, 2),
(7946, 167, '2026-05-14', 685, 2),
(7947, 167, '2026-05-14', 686, 2),
(7948, 167, '2026-05-14', 687, 2),
(7949, 167, '2026-05-14', 688, 2),
(7950, 167, '2026-05-14', 689, 2),
(11031, 217, '2026-05-23', 600, 2),
(11032, 217, '2026-05-23', 601, 2),
(11033, 217, '2026-05-23', 602, 2),
(11034, 217, '2026-05-23', 603, 2),
(11035, 217, '2026-05-23', 604, 2),
(11036, 217, '2026-05-23', 605, 2),
(11037, 217, '2026-05-23', 606, 2),
(11038, 217, '2026-05-23', 607, 2),
(11039, 217, '2026-05-23', 608, 2),
(11040, 217, '2026-05-23', 609, 2),
(11041, 217, '2026-05-23', 610, 2),
(11042, 217, '2026-05-23', 611, 2),
(11043, 217, '2026-05-23', 612, 2),
(11044, 217, '2026-05-23', 613, 2),
(11045, 217, '2026-05-23', 614, 2),
(11046, 218, '2026-05-22', 600, 2),
(11047, 218, '2026-05-22', 601, 2),
(11048, 218, '2026-05-22', 602, 2),
(11049, 218, '2026-05-22', 603, 2),
(11050, 218, '2026-05-22', 604, 2),
(11051, 218, '2026-05-22', 605, 2),
(11052, 218, '2026-05-22', 606, 2),
(11053, 218, '2026-05-22', 607, 2),
(11054, 218, '2026-05-22', 608, 2),
(11055, 218, '2026-05-22', 609, 2),
(11056, 218, '2026-05-22', 610, 2),
(11057, 218, '2026-05-22', 611, 2),
(11058, 218, '2026-05-22', 612, 2),
(11059, 218, '2026-05-22', 613, 2),
(11060, 218, '2026-05-22', 614, 2),
(11061, 219, '2026-05-27', 600, 2),
(11062, 219, '2026-05-27', 601, 2),
(11063, 219, '2026-05-27', 602, 2),
(11064, 219, '2026-05-27', 603, 2),
(11065, 219, '2026-05-27', 604, 2),
(11066, 219, '2026-05-27', 605, 2),
(11067, 219, '2026-05-27', 606, 2),
(11068, 219, '2026-05-27', 607, 2),
(11069, 219, '2026-05-27', 608, 2),
(11070, 219, '2026-05-27', 609, 2),
(11071, 219, '2026-05-27', 610, 2),
(11072, 219, '2026-05-27', 611, 2),
(11073, 219, '2026-05-27', 612, 2),
(11074, 219, '2026-05-27', 613, 2),
(11075, 219, '2026-05-27', 614, 2),
(13116, 20, '2026-05-21', 630, 2),
(13117, 20, '2026-05-21', 631, 2),
(13118, 20, '2026-05-21', 632, 2),
(13119, 20, '2026-05-21', 633, 2),
(13120, 20, '2026-05-21', 634, 2),
(13121, 20, '2026-05-21', 635, 2),
(13122, 20, '2026-05-21', 636, 2),
(13123, 20, '2026-05-21', 637, 2),
(13124, 20, '2026-05-21', 638, 2),
(13125, 20, '2026-05-21', 639, 2),
(13126, 20, '2026-05-21', 640, 2),
(13127, 20, '2026-05-21', 641, 2),
(13128, 20, '2026-05-21', 642, 2),
(13129, 20, '2026-05-21', 643, 2),
(13130, 20, '2026-05-21', 644, 2),
(13131, 20, '2026-05-21', 645, 2),
(13132, 20, '2026-05-21', 646, 2),
(13133, 20, '2026-05-21', 647, 2),
(13134, 20, '2026-05-21', 648, 2),
(13135, 20, '2026-05-21', 649, 2),
(13136, 20, '2026-05-21', 650, 2),
(13137, 20, '2026-05-21', 651, 2),
(13138, 20, '2026-05-21', 652, 2),
(13139, 20, '2026-05-21', 653, 2),
(13140, 20, '2026-05-21', 654, 2),
(13141, 20, '2026-05-21', 655, 2),
(13142, 20, '2026-05-21', 656, 2),
(13143, 20, '2026-05-21', 657, 2),
(13144, 20, '2026-05-21', 658, 2),
(13145, 20, '2026-05-21', 659, 2);

-- --------------------------------------------------------

--
-- Table structure for table `service_ratings`
--

CREATE TABLE `service_ratings` (
  `id` bigint NOT NULL,
  `client_id` bigint NOT NULL,
  `service_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service_ratings`
--

INSERT INTO `service_ratings` (`id`, `client_id`, `service_id`) VALUES
(45, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `service_staff`
--

CREATE TABLE `service_staff` (
  `service_id` bigint NOT NULL,
  `staff_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service_staff`
--

INSERT INTO `service_staff` (`service_id`, `staff_id`) VALUES
(8, 5),
(6, 5),
(1, 2),
(1, 5),
(6, 5),
(7, 5),
(9, 5),
(1, 26),
(7, 26),
(8, 26),
(10, 16),
(11, 16),
(12, 16),
(10, 30),
(11, 30),
(12, 30),
(13, 17),
(14, 17),
(15, 17),
(16, 18),
(17, 18),
(19, 18),
(16, 27),
(18, 27),
(19, 27),
(20, 19),
(21, 19),
(22, 19),
(20, 28),
(22, 28),
(23, 28),
(24, 20),
(25, 20),
(26, 20),
(27, 21),
(29, 21),
(27, 29),
(28, 29),
(30, 29),
(31, 22),
(32, 22),
(33, 22),
(34, 23),
(35, 23),
(36, 23),
(37, 23),
(38, 24),
(39, 24),
(40, 24),
(41, 25),
(42, 25),
(43, 25),
(44, 25),
(8, 2),
(56, 2),
(58, 2);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `default_end_time` time(6) DEFAULT NULL,
  `default_start_time` time(6) DEFAULT NULL,
  `start_working_at` date DEFAULT NULL,
  `id` bigint NOT NULL,
  `business_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`default_end_time`, `default_start_time`, `start_working_at`, `id`, `business_id`) VALUES
('17:00:00.000000', '09:00:00.000000', '2026-04-26', 1, 1),
('17:00:00.000000', '08:00:00.000000', '2025-11-27', 2, 1),
('17:30:00.000000', '08:00:00.000000', '2025-11-26', 5, 1),
('22:00:00.000000', '14:00:00.000000', '2024-10-20', 16, 3),
('23:00:00.000000', '15:00:00.000000', '2024-09-25', 17, 4),
('18:00:00.000000', '09:00:00.000000', '2024-11-05', 18, 5),
('18:30:00.000000', '09:00:00.000000', '2024-08-15', 19, 6),
('23:30:00.000000', '15:00:00.000000', '2024-07-10', 20, 7),
('20:00:00.000000', '07:00:00.000000', '2024-06-20', 21, 8),
('23:00:00.000000', '16:00:00.000000', '2024-05-25', 22, 9),
('19:00:00.000000', '10:00:00.000000', '2024-04-28', 23, 10),
('17:00:00.000000', '08:00:00.000000', '2024-03-20', 24, 11),
('17:00:00.000000', '08:00:00.000000', '2024-02-15', 25, 12),
('18:00:00.000000', '09:00:00.000000', '2025-11-26', 26, 1),
('17:30:00.000000', '08:30:00.000000', '2025-11-27', 27, 5),
('18:00:00.000000', '09:00:00.000000', '2025-11-28', 28, 6),
('16:00:00.000000', '07:00:00.000000', '2025-11-29', 29, 8),
('22:00:00.000000', '14:00:00.000000', '2025-11-30', 30, 3),
('17:00:00.000000', '09:00:00.000000', '2026-05-08', 33, 17);

-- --------------------------------------------------------

--
-- Table structure for table `staff_availabilities`
--

CREATE TABLE `staff_availabilities` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `date` date NOT NULL,
  `end_time` time(6) NOT NULL,
  `start_time` time(6) NOT NULL,
  `status` enum('AVAILABLE','CLOSED','SICK','VACATION','DAY_OFF','UNAVAILABLE') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `staff_id` bigint NOT NULL,
  `user_edited` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_availabilities`
--

INSERT INTO `staff_availabilities` (`id`, `created_at`, `date`, `end_time`, `start_time`, `status`, `updated_at`, `staff_id`, `user_edited`) VALUES
(32, '2025-11-27 00:21:47.000000', '2025-11-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(33, '2025-11-27 00:21:47.000000', '2025-11-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(34, '2025-11-27 00:21:47.000000', '2025-11-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(35, '2025-11-27 00:21:47.000000', '2025-11-30', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 2, b'0'),
(36, '2025-11-27 00:21:47.000000', '2025-12-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 2, b'0'),
(37, '2025-11-27 00:21:47.000000', '2025-12-02', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 2, b'0'),
(38, '2025-11-27 00:21:47.000000', '2025-12-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(39, '2025-11-27 00:21:47.000000', '2025-12-04', '17:00:00.000000', '08:00:00.000000', 'SICK', '2025-11-27 00:22:15.000000', 2, b'0'),
(40, '2025-11-27 00:21:47.000000', '2025-12-05', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(41, '2025-11-27 00:21:47.000000', '2025-12-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(42, '2025-11-27 00:21:47.000000', '2025-12-07', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 2, b'0'),
(43, '2025-11-27 00:21:47.000000', '2025-12-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 2, b'0'),
(44, '2025-11-27 00:21:47.000000', '2025-12-09', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 2, b'0'),
(45, '2025-11-27 00:21:47.000000', '2025-12-10', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(46, '2025-11-27 00:21:47.000000', '2025-12-11', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(47, '2025-11-27 00:21:47.000000', '2025-12-12', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(48, '2025-11-27 00:21:47.000000', '2025-12-13', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(49, '2025-11-27 00:21:47.000000', '2025-12-14', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 2, b'0'),
(50, '2025-11-27 00:21:47.000000', '2025-12-15', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 2, b'0'),
(51, '2025-11-27 00:21:47.000000', '2025-12-16', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 2, b'0'),
(52, '2025-11-27 00:21:47.000000', '2025-12-17', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(53, '2025-11-27 00:21:47.000000', '2025-12-18', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(54, '2025-11-27 00:21:47.000000', '2025-12-19', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(55, '2025-11-27 00:21:47.000000', '2025-12-20', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(56, '2025-11-27 00:21:47.000000', '2025-12-21', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 2, b'0'),
(57, '2025-11-27 00:21:47.000000', '2025-12-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 2, b'0'),
(58, '2025-11-27 00:21:47.000000', '2025-12-23', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 2, b'0'),
(59, '2025-11-27 00:21:47.000000', '2025-12-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(60, '2025-11-27 00:21:47.000000', '2025-12-25', '16:00:00.392000', '10:00:00.344000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(61, '2025-11-27 00:21:47.000000', '2025-12-26', '15:00:00.872000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(62, '2025-11-27 00:21:47.000000', '2025-12-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 2, b'0'),
(63, '2025-11-27 00:21:47.000000', '2025-11-27', '17:30:00.000000', '08:00:00.000000', 'VACATION', '2025-11-27 00:22:15.000000', 5, b'0'),
(64, '2025-11-27 00:21:47.000000', '2025-11-28', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(65, '2025-11-27 00:21:47.000000', '2025-11-29', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(66, '2025-11-27 00:21:47.000000', '2025-11-30', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 5, b'0'),
(67, '2025-11-27 00:21:47.000000', '2025-12-01', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 5, b'0'),
(68, '2025-11-27 00:21:47.000000', '2025-12-02', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 5, b'0'),
(69, '2025-11-27 00:21:47.000000', '2025-12-03', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(70, '2025-11-27 00:21:47.000000', '2025-12-04', '17:30:00.000000', '08:00:00.000000', 'DAY_OFF', '2025-11-27 23:24:07.000000', 5, b'1'),
(71, '2025-11-27 00:21:47.000000', '2025-12-05', '17:30:00.000000', '08:00:00.000000', 'VACATION', '2025-11-27 00:22:15.000000', 5, b'0'),
(72, '2025-11-27 00:21:47.000000', '2025-12-06', '17:30:00.000000', '08:00:00.000000', 'UNAVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(73, '2025-11-27 00:21:47.000000', '2025-12-07', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 5, b'0'),
(74, '2025-11-27 00:21:47.000000', '2025-12-08', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 5, b'0'),
(75, '2025-11-27 00:21:47.000000', '2025-12-09', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 5, b'0'),
(76, '2025-11-27 00:21:47.000000', '2025-12-10', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(77, '2025-11-27 00:21:47.000000', '2025-12-11', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(78, '2025-11-27 00:21:47.000000', '2025-12-12', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(79, '2025-11-27 00:21:47.000000', '2025-12-13', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(80, '2025-11-27 00:21:47.000000', '2025-12-14', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 5, b'0'),
(81, '2025-11-27 00:21:47.000000', '2025-12-15', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 5, b'0'),
(82, '2025-11-27 00:21:47.000000', '2025-12-16', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 5, b'0'),
(83, '2025-11-27 00:21:47.000000', '2025-12-17', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(84, '2025-11-27 00:21:47.000000', '2025-12-18', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(85, '2025-11-27 00:21:47.000000', '2025-12-19', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(86, '2025-11-27 00:21:47.000000', '2025-12-20', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(87, '2025-11-27 00:21:47.000000', '2025-12-21', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 00:22:15.000000', 5, b'0'),
(88, '2025-11-27 00:21:47.000000', '2025-12-22', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 02:15:53.000000', 5, b'0'),
(89, '2025-11-27 00:21:47.000000', '2025-12-23', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-11-27 02:15:53.000000', 5, b'0'),
(90, '2025-11-27 00:21:47.000000', '2025-12-24', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(91, '2025-11-27 00:21:47.000000', '2025-12-25', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(92, '2025-11-27 00:21:48.000000', '2025-12-26', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(93, '2025-11-27 00:21:48.000000', '2025-12-27', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-11-27 00:22:15.000000', 5, b'0'),
(94, '2025-11-28 01:00:00.000000', '2025-12-28', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 01:30:27.000000', 2, b'0'),
(95, '2025-11-28 01:00:00.000000', '2025-12-28', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 01:30:27.000000', 5, b'0'),
(96, '2025-12-24 01:30:27.000000', '2025-12-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:42.000000', 2, b'0'),
(97, '2025-12-24 01:30:27.000000', '2025-12-30', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:42.000000', 2, b'0'),
(98, '2025-12-24 01:30:27.000000', '2025-12-31', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:42.000000', 2, b'0'),
(99, '2025-12-24 01:30:27.000000', '2026-01-01', '18:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-01 16:35:10.000000', 2, b'1'),
(100, '2025-12-24 01:30:27.000000', '2026-01-02', '17:00:00.000000', '09:00:00.361000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(101, '2025-12-24 01:30:27.000000', '2026-01-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(102, '2025-12-24 01:30:27.000000', '2026-01-04', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 2, b'0'),
(103, '2025-12-24 01:30:27.000000', '2026-01-05', '17:00:00.000000', '08:00:00.000000', 'SICK', '2025-12-24 18:06:43.000000', 2, b'0'),
(104, '2025-12-24 01:30:27.000000', '2026-01-06', '15:00:00.000000', '10:00:00.000000', 'VACATION', '2026-01-02 23:38:54.000000', 2, b'1'),
(105, '2025-12-24 01:30:27.000000', '2026-01-07', '17:00:00.000000', '08:00:00.000000', 'VACATION', '2026-01-02 23:38:54.000000', 2, b'1'),
(106, '2025-12-24 01:30:27.000000', '2026-01-08', '17:00:00.000000', '08:00:00.000000', 'VACATION', '2026-01-02 23:38:54.000000', 2, b'1'),
(107, '2025-12-24 01:30:27.000000', '2026-01-09', '17:00:00.000000', '08:00:00.000000', 'DAY_OFF', '2025-12-24 18:06:43.000000', 2, b'0'),
(108, '2025-12-24 01:30:27.000000', '2026-01-10', '17:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-01-01 16:39:34.000000', 2, b'1'),
(109, '2025-12-24 01:30:27.000000', '2026-01-11', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 2, b'0'),
(110, '2025-12-24 01:30:27.000000', '2026-01-12', '17:00:00.000000', '08:00:00.000000', 'VACATION', '2025-12-24 18:06:43.000000', 2, b'0'),
(111, '2025-12-24 01:30:27.000000', '2026-01-13', '15:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-01-01 16:46:41.000000', 2, b'1'),
(112, '2025-12-24 01:30:27.000000', '2026-01-14', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(113, '2025-12-24 01:30:27.000000', '2026-01-15', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(114, '2025-12-24 01:30:27.000000', '2026-01-16', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(115, '2025-12-24 01:30:27.000000', '2026-01-17', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(116, '2025-12-24 01:30:27.000000', '2026-01-18', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 2, b'0'),
(117, '2025-12-24 01:30:27.000000', '2026-01-19', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(118, '2025-12-24 01:30:27.000000', '2026-01-20', '17:00:00.000000', '08:00:00.000000', 'DAY_OFF', '2025-12-31 18:42:46.000000', 2, b'1'),
(119, '2025-12-24 01:30:27.000000', '2026-01-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(120, '2025-12-24 01:30:27.000000', '2026-01-22', '17:00:00.000000', '08:00:00.000000', 'UNAVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(121, '2025-12-24 01:30:27.000000', '2026-01-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(122, '2025-12-24 01:30:27.000000', '2026-01-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 2, b'0'),
(123, '2025-12-24 01:30:27.000000', '2025-12-29', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(124, '2025-12-24 01:30:27.000000', '2025-12-30', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 5, b'0'),
(125, '2025-12-24 01:30:27.000000', '2025-12-31', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(126, '2025-12-24 01:30:27.000000', '2026-01-01', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(127, '2025-12-24 01:30:27.000000', '2026-01-02', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(128, '2025-12-24 01:30:27.000000', '2026-01-03', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(129, '2025-12-24 01:30:27.000000', '2026-01-04', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 5, b'0'),
(130, '2025-12-24 01:30:27.000000', '2026-01-05', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(131, '2025-12-24 01:30:27.000000', '2026-01-06', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 5, b'0'),
(132, '2025-12-24 01:30:27.000000', '2026-01-07', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(133, '2025-12-24 01:30:27.000000', '2026-01-08', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(134, '2025-12-24 01:30:27.000000', '2026-01-09', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(135, '2025-12-24 01:30:27.000000', '2026-01-10', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(136, '2025-12-24 01:30:27.000000', '2026-01-11', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 5, b'0'),
(137, '2025-12-24 01:30:27.000000', '2026-01-12', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(138, '2025-12-24 01:30:27.000000', '2026-01-13', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 5, b'0'),
(139, '2025-12-24 01:30:27.000000', '2026-01-14', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(140, '2025-12-24 01:30:27.000000', '2026-01-15', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(141, '2025-12-24 01:30:27.000000', '2026-01-16', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(142, '2025-12-24 01:30:27.000000', '2026-01-17', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(143, '2025-12-24 01:30:27.000000', '2026-01-18', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 5, b'0'),
(144, '2025-12-24 01:30:27.000000', '2026-01-19', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(145, '2025-12-24 01:30:27.000000', '2026-01-20', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-24 18:06:43.000000', 5, b'0'),
(146, '2025-12-24 01:30:27.000000', '2026-01-21', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(147, '2025-12-24 01:30:27.000000', '2026-01-22', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(148, '2025-12-24 01:30:27.000000', '2026-01-23', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(149, '2025-12-24 01:30:27.000000', '2026-01-24', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:43.000000', 5, b'0'),
(150, '2025-12-24 18:06:43.000000', '2025-12-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(151, '2025-12-24 18:06:43.000000', '2025-12-25', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(152, '2025-12-24 18:06:43.000000', '2025-12-26', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(153, '2025-12-24 18:06:43.000000', '2025-12-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(154, '2025-12-24 18:06:43.000000', '2025-12-28', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(155, '2025-12-24 18:06:43.000000', '2025-12-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(156, '2025-12-24 18:06:43.000000', '2025-12-30', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(157, '2025-12-24 18:06:43.000000', '2025-12-31', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(158, '2025-12-24 18:06:43.000000', '2026-01-01', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(159, '2025-12-24 18:06:43.000000', '2026-01-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(160, '2025-12-24 18:06:43.000000', '2026-01-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(161, '2025-12-24 18:06:43.000000', '2026-01-04', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(162, '2025-12-24 18:06:43.000000', '2026-01-05', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(163, '2025-12-24 18:06:43.000000', '2026-01-06', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(164, '2025-12-24 18:06:43.000000', '2026-01-07', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(165, '2025-12-24 18:06:43.000000', '2026-01-08', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(166, '2025-12-24 18:06:43.000000', '2026-01-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(167, '2025-12-24 18:06:43.000000', '2026-01-10', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(168, '2025-12-24 18:06:43.000000', '2026-01-11', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(169, '2025-12-24 18:06:43.000000', '2026-01-12', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(170, '2025-12-24 18:06:43.000000', '2026-01-13', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(171, '2025-12-24 18:06:43.000000', '2026-01-14', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(172, '2025-12-24 18:06:43.000000', '2026-01-15', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(173, '2025-12-24 18:06:43.000000', '2026-01-16', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(174, '2025-12-24 18:06:43.000000', '2026-01-17', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(175, '2025-12-24 18:06:43.000000', '2026-01-18', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(176, '2025-12-24 18:06:43.000000', '2026-01-19', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(177, '2025-12-24 18:06:43.000000', '2026-01-20', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 26, b'0'),
(178, '2025-12-24 18:06:43.000000', '2026-01-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(179, '2025-12-24 18:06:43.000000', '2026-01-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(180, '2025-12-24 18:06:43.000000', '2026-01-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(181, '2025-12-24 18:06:43.000000', '2026-01-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 26, b'0'),
(182, '2025-12-24 18:06:43.000000', '2025-12-24', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(183, '2025-12-24 18:06:43.000000', '2025-12-25', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(184, '2025-12-24 18:06:43.000000', '2025-12-26', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(185, '2025-12-24 18:06:43.000000', '2025-12-27', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(186, '2025-12-24 18:06:43.000000', '2025-12-28', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(187, '2025-12-24 18:06:43.000000', '2025-12-29', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(188, '2025-12-24 18:06:43.000000', '2025-12-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(189, '2025-12-24 18:06:43.000000', '2025-12-31', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(190, '2025-12-24 18:06:43.000000', '2026-01-01', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(191, '2025-12-24 18:06:43.000000', '2026-01-02', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(192, '2025-12-24 18:06:43.000000', '2026-01-03', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(193, '2025-12-24 18:06:43.000000', '2026-01-04', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(194, '2025-12-24 18:06:43.000000', '2026-01-05', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(195, '2025-12-24 18:06:43.000000', '2026-01-06', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(196, '2025-12-24 18:06:43.000000', '2026-01-07', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(197, '2025-12-24 18:06:43.000000', '2026-01-08', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(198, '2025-12-24 18:06:43.000000', '2026-01-09', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(199, '2025-12-24 18:06:43.000000', '2026-01-10', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(200, '2025-12-24 18:06:43.000000', '2026-01-11', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(201, '2025-12-24 18:06:43.000000', '2026-01-12', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(202, '2025-12-24 18:06:43.000000', '2026-01-13', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(203, '2025-12-24 18:06:43.000000', '2026-01-14', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(204, '2025-12-24 18:06:43.000000', '2026-01-15', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(205, '2025-12-24 18:06:43.000000', '2026-01-16', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(206, '2025-12-24 18:06:43.000000', '2026-01-17', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(207, '2025-12-24 18:06:43.000000', '2026-01-18', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(208, '2025-12-24 18:06:43.000000', '2026-01-19', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 16, b'0'),
(209, '2025-12-24 18:06:43.000000', '2026-01-20', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(210, '2025-12-24 18:06:43.000000', '2026-01-21', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(211, '2025-12-24 18:06:43.000000', '2026-01-22', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(212, '2025-12-24 18:06:43.000000', '2026-01-23', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(213, '2025-12-24 18:06:43.000000', '2026-01-24', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 16, b'0'),
(214, '2025-12-24 18:06:43.000000', '2025-12-24', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(215, '2025-12-24 18:06:43.000000', '2025-12-25', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(216, '2025-12-24 18:06:43.000000', '2025-12-26', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 30, b'0'),
(217, '2025-12-24 18:06:43.000000', '2025-12-27', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 30, b'0'),
(218, '2025-12-24 18:06:43.000000', '2025-12-28', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 30, b'0'),
(219, '2025-12-24 18:06:43.000000', '2025-12-29', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:00.000000', 30, b'0'),
(220, '2025-12-24 18:06:43.000000', '2025-12-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:00.000000', 30, b'0'),
(221, '2025-12-24 18:06:43.000000', '2025-12-31', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(222, '2025-12-24 18:06:43.000000', '2026-01-01', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(223, '2025-12-24 18:06:43.000000', '2026-01-02', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(224, '2025-12-24 18:06:43.000000', '2026-01-03', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(225, '2025-12-24 18:06:43.000000', '2026-01-04', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 30, b'0'),
(226, '2025-12-24 18:06:43.000000', '2026-01-05', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 30, b'0'),
(227, '2025-12-24 18:06:43.000000', '2026-01-06', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(228, '2025-12-24 18:06:43.000000', '2026-01-07', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(229, '2025-12-24 18:06:43.000000', '2026-01-08', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(230, '2025-12-24 18:06:43.000000', '2026-01-09', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(231, '2025-12-24 18:06:43.000000', '2026-01-10', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(232, '2025-12-24 18:06:43.000000', '2026-01-11', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 30, b'0'),
(233, '2025-12-24 18:06:43.000000', '2026-01-12', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 30, b'0'),
(234, '2025-12-24 18:06:43.000000', '2026-01-13', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(235, '2025-12-24 18:06:43.000000', '2026-01-14', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(236, '2025-12-24 18:06:43.000000', '2026-01-15', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(237, '2025-12-24 18:06:43.000000', '2026-01-16', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(238, '2025-12-24 18:06:43.000000', '2026-01-17', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(239, '2025-12-24 18:06:43.000000', '2026-01-18', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 30, b'0'),
(240, '2025-12-24 18:06:43.000000', '2026-01-19', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 30, b'0'),
(241, '2025-12-24 18:06:43.000000', '2026-01-20', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(242, '2025-12-24 18:06:43.000000', '2026-01-21', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(243, '2025-12-24 18:06:43.000000', '2026-01-22', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(244, '2025-12-24 18:06:43.000000', '2026-01-23', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(245, '2025-12-24 18:06:43.000000', '2026-01-24', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 30, b'0'),
(246, '2025-12-24 18:06:43.000000', '2025-12-24', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(247, '2025-12-24 18:06:43.000000', '2025-12-25', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(248, '2025-12-24 18:06:43.000000', '2025-12-26', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(249, '2025-12-24 18:06:43.000000', '2025-12-27', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(250, '2025-12-24 18:06:43.000000', '2025-12-28', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 17, b'0'),
(251, '2025-12-24 18:06:43.000000', '2025-12-29', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(252, '2025-12-24 18:06:43.000000', '2025-12-30', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(253, '2025-12-24 18:06:43.000000', '2025-12-31', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(254, '2025-12-24 18:06:43.000000', '2026-01-01', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(255, '2025-12-24 18:06:43.000000', '2026-01-02', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(256, '2025-12-24 18:06:43.000000', '2026-01-03', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(257, '2025-12-24 18:06:43.000000', '2026-01-04', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 17, b'0'),
(258, '2025-12-24 18:06:43.000000', '2026-01-05', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(259, '2025-12-24 18:06:43.000000', '2026-01-06', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(260, '2025-12-24 18:06:43.000000', '2026-01-07', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(261, '2025-12-24 18:06:43.000000', '2026-01-08', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(262, '2025-12-24 18:06:43.000000', '2026-01-09', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(263, '2025-12-24 18:06:43.000000', '2026-01-10', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(264, '2025-12-24 18:06:43.000000', '2026-01-11', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 17, b'0'),
(265, '2025-12-24 18:06:43.000000', '2026-01-12', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(266, '2025-12-24 18:06:43.000000', '2026-01-13', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(267, '2025-12-24 18:06:43.000000', '2026-01-14', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(268, '2025-12-24 18:06:43.000000', '2026-01-15', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(269, '2025-12-24 18:06:43.000000', '2026-01-16', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(270, '2025-12-24 18:06:43.000000', '2026-01-17', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(271, '2025-12-24 18:06:43.000000', '2026-01-18', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 17, b'0'),
(272, '2025-12-24 18:06:43.000000', '2026-01-19', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(273, '2025-12-24 18:06:43.000000', '2026-01-20', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(274, '2025-12-24 18:06:43.000000', '2026-01-21', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(275, '2025-12-24 18:06:43.000000', '2026-01-22', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(276, '2025-12-24 18:06:43.000000', '2026-01-23', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(277, '2025-12-24 18:06:43.000000', '2026-01-24', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 17, b'0'),
(278, '2025-12-24 18:06:43.000000', '2025-12-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(279, '2025-12-24 18:06:43.000000', '2025-12-25', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(280, '2025-12-24 18:06:43.000000', '2025-12-26', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(281, '2025-12-24 18:06:43.000000', '2025-12-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(282, '2025-12-24 18:06:43.000000', '2025-12-28', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 18, b'0'),
(283, '2025-12-24 18:06:43.000000', '2025-12-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(284, '2025-12-24 18:06:43.000000', '2025-12-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(285, '2025-12-24 18:06:43.000000', '2025-12-31', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(286, '2025-12-24 18:06:43.000000', '2026-01-01', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(287, '2025-12-24 18:06:43.000000', '2026-01-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(288, '2025-12-24 18:06:43.000000', '2026-01-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(289, '2025-12-24 18:06:43.000000', '2026-01-04', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 18, b'0'),
(290, '2025-12-24 18:06:43.000000', '2026-01-05', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(291, '2025-12-24 18:06:43.000000', '2026-01-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(292, '2025-12-24 18:06:43.000000', '2026-01-07', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(293, '2025-12-24 18:06:43.000000', '2026-01-08', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(294, '2025-12-24 18:06:43.000000', '2026-01-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(295, '2025-12-24 18:06:43.000000', '2026-01-10', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(296, '2025-12-24 18:06:43.000000', '2026-01-11', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 18, b'0'),
(297, '2025-12-24 18:06:43.000000', '2026-01-12', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(298, '2025-12-24 18:06:43.000000', '2026-01-13', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(299, '2025-12-24 18:06:43.000000', '2026-01-14', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(300, '2025-12-24 18:06:43.000000', '2026-01-15', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(301, '2025-12-24 18:06:43.000000', '2026-01-16', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(302, '2025-12-24 18:06:43.000000', '2026-01-17', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(303, '2025-12-24 18:06:43.000000', '2026-01-18', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 18, b'0'),
(304, '2025-12-24 18:06:43.000000', '2026-01-19', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(305, '2025-12-24 18:06:43.000000', '2026-01-20', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(306, '2025-12-24 18:06:43.000000', '2026-01-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(307, '2025-12-24 18:06:43.000000', '2026-01-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(308, '2025-12-24 18:06:43.000000', '2026-01-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(309, '2025-12-24 18:06:43.000000', '2026-01-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 18, b'0'),
(310, '2025-12-24 18:06:43.000000', '2025-12-24', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(311, '2025-12-24 18:06:43.000000', '2025-12-25', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(312, '2025-12-24 18:06:43.000000', '2025-12-26', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(313, '2025-12-24 18:06:43.000000', '2025-12-27', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(314, '2025-12-24 18:06:43.000000', '2025-12-28', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 27, b'0'),
(315, '2025-12-24 18:06:43.000000', '2025-12-29', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(316, '2025-12-24 18:06:43.000000', '2025-12-30', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(317, '2025-12-24 18:06:43.000000', '2025-12-31', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(318, '2025-12-24 18:06:43.000000', '2026-01-01', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(319, '2025-12-24 18:06:43.000000', '2026-01-02', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(320, '2025-12-24 18:06:43.000000', '2026-01-03', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(321, '2025-12-24 18:06:43.000000', '2026-01-04', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 27, b'0'),
(322, '2025-12-24 18:06:43.000000', '2026-01-05', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(323, '2025-12-24 18:06:43.000000', '2026-01-06', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(324, '2025-12-24 18:06:43.000000', '2026-01-07', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(325, '2025-12-24 18:06:43.000000', '2026-01-08', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(326, '2025-12-24 18:06:43.000000', '2026-01-09', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(327, '2025-12-24 18:06:43.000000', '2026-01-10', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(328, '2025-12-24 18:06:43.000000', '2026-01-11', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2025-12-26 01:00:01.000000', 27, b'0'),
(329, '2025-12-24 18:06:43.000000', '2026-01-12', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(330, '2025-12-24 18:06:43.000000', '2026-01-13', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(331, '2025-12-24 18:06:43.000000', '2026-01-14', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(332, '2025-12-24 18:06:43.000000', '2026-01-15', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:01.000000', 27, b'0'),
(333, '2025-12-24 18:06:43.000000', '2026-01-16', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(334, '2025-12-24 18:06:43.000000', '2026-01-17', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(335, '2025-12-24 18:06:43.000000', '2026-01-18', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 27, b'0'),
(336, '2025-12-24 18:06:43.000000', '2026-01-19', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(337, '2025-12-24 18:06:43.000000', '2026-01-20', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(338, '2025-12-24 18:06:43.000000', '2026-01-21', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(339, '2025-12-24 18:06:43.000000', '2026-01-22', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(340, '2025-12-24 18:06:43.000000', '2026-01-23', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(341, '2025-12-24 18:06:43.000000', '2026-01-24', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 27, b'0'),
(342, '2025-12-24 18:06:43.000000', '2025-12-24', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(343, '2025-12-24 18:06:43.000000', '2025-12-25', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(344, '2025-12-24 18:06:43.000000', '2025-12-26', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(345, '2025-12-24 18:06:43.000000', '2025-12-27', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(346, '2025-12-24 18:06:43.000000', '2025-12-28', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(347, '2025-12-24 18:06:43.000000', '2025-12-29', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(348, '2025-12-24 18:06:43.000000', '2025-12-30', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(349, '2025-12-24 18:06:43.000000', '2025-12-31', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(350, '2025-12-24 18:06:43.000000', '2026-01-01', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(351, '2025-12-24 18:06:43.000000', '2026-01-02', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(352, '2025-12-24 18:06:43.000000', '2026-01-03', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(353, '2025-12-24 18:06:43.000000', '2026-01-04', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(354, '2025-12-24 18:06:43.000000', '2026-01-05', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(355, '2025-12-24 18:06:43.000000', '2026-01-06', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(356, '2025-12-24 18:06:43.000000', '2026-01-07', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(357, '2025-12-24 18:06:43.000000', '2026-01-08', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(358, '2025-12-24 18:06:43.000000', '2026-01-09', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(359, '2025-12-24 18:06:43.000000', '2026-01-10', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(360, '2025-12-24 18:06:43.000000', '2026-01-11', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(361, '2025-12-24 18:06:43.000000', '2026-01-12', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(362, '2025-12-24 18:06:43.000000', '2026-01-13', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(363, '2025-12-24 18:06:43.000000', '2026-01-14', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(364, '2025-12-24 18:06:43.000000', '2026-01-15', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(365, '2025-12-24 18:06:43.000000', '2026-01-16', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(366, '2025-12-24 18:06:43.000000', '2026-01-17', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(367, '2025-12-24 18:06:43.000000', '2026-01-18', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(368, '2025-12-24 18:06:43.000000', '2026-01-19', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 19, b'0'),
(369, '2025-12-24 18:06:43.000000', '2026-01-20', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(370, '2025-12-24 18:06:43.000000', '2026-01-21', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(371, '2025-12-24 18:06:43.000000', '2026-01-22', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(372, '2025-12-24 18:06:43.000000', '2026-01-23', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(373, '2025-12-24 18:06:43.000000', '2026-01-24', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 19, b'0'),
(374, '2025-12-24 18:06:43.000000', '2025-12-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(375, '2025-12-24 18:06:43.000000', '2025-12-25', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(376, '2025-12-24 18:06:43.000000', '2025-12-26', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(377, '2025-12-24 18:06:43.000000', '2025-12-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(378, '2025-12-24 18:06:43.000000', '2025-12-28', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0'),
(379, '2025-12-24 18:06:43.000000', '2025-12-29', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0'),
(380, '2025-12-24 18:06:43.000000', '2025-12-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(381, '2025-12-24 18:06:43.000000', '2025-12-31', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(382, '2025-12-24 18:06:43.000000', '2026-01-01', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(383, '2025-12-24 18:06:43.000000', '2026-01-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(384, '2025-12-24 18:06:43.000000', '2026-01-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(385, '2025-12-24 18:06:43.000000', '2026-01-04', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0'),
(386, '2025-12-24 18:06:43.000000', '2026-01-05', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0'),
(387, '2025-12-24 18:06:43.000000', '2026-01-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(388, '2025-12-24 18:06:43.000000', '2026-01-07', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(389, '2025-12-24 18:06:43.000000', '2026-01-08', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(390, '2025-12-24 18:06:43.000000', '2026-01-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(391, '2025-12-24 18:06:43.000000', '2026-01-10', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(392, '2025-12-24 18:06:43.000000', '2026-01-11', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0');
INSERT INTO `staff_availabilities` (`id`, `created_at`, `date`, `end_time`, `start_time`, `status`, `updated_at`, `staff_id`, `user_edited`) VALUES
(393, '2025-12-24 18:06:43.000000', '2026-01-12', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0'),
(394, '2025-12-24 18:06:43.000000', '2026-01-13', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(395, '2025-12-24 18:06:43.000000', '2026-01-14', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(396, '2025-12-24 18:06:43.000000', '2026-01-15', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(397, '2025-12-24 18:06:43.000000', '2026-01-16', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(398, '2025-12-24 18:06:43.000000', '2026-01-17', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(399, '2025-12-24 18:06:43.000000', '2026-01-18', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0'),
(400, '2025-12-24 18:06:43.000000', '2026-01-19', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 28, b'0'),
(401, '2025-12-24 18:06:43.000000', '2026-01-20', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(402, '2025-12-24 18:06:43.000000', '2026-01-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(403, '2025-12-24 18:06:43.000000', '2026-01-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(404, '2025-12-24 18:06:43.000000', '2026-01-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(405, '2025-12-24 18:06:43.000000', '2026-01-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 28, b'0'),
(406, '2025-12-24 18:06:43.000000', '2025-12-24', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(407, '2025-12-24 18:06:43.000000', '2025-12-25', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(408, '2025-12-24 18:06:43.000000', '2025-12-26', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(409, '2025-12-24 18:06:43.000000', '2025-12-27', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(410, '2025-12-24 18:06:43.000000', '2025-12-28', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(411, '2025-12-24 18:06:43.000000', '2025-12-29', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(412, '2025-12-24 18:06:43.000000', '2025-12-30', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(413, '2025-12-24 18:06:43.000000', '2025-12-31', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(414, '2025-12-24 18:06:43.000000', '2026-01-01', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(415, '2025-12-24 18:06:43.000000', '2026-01-02', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(416, '2025-12-24 18:06:43.000000', '2026-01-03', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(417, '2025-12-24 18:06:43.000000', '2026-01-04', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(418, '2025-12-24 18:06:43.000000', '2026-01-05', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(419, '2025-12-24 18:06:43.000000', '2026-01-06', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(420, '2025-12-24 18:06:43.000000', '2026-01-07', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(421, '2025-12-24 18:06:43.000000', '2026-01-08', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(422, '2025-12-24 18:06:43.000000', '2026-01-09', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(423, '2025-12-24 18:06:43.000000', '2026-01-10', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(424, '2025-12-24 18:06:43.000000', '2026-01-11', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(425, '2025-12-24 18:06:43.000000', '2026-01-12', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(426, '2025-12-24 18:06:43.000000', '2026-01-13', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(427, '2025-12-24 18:06:43.000000', '2026-01-14', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(428, '2025-12-24 18:06:43.000000', '2026-01-15', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(429, '2025-12-24 18:06:43.000000', '2026-01-16', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(430, '2025-12-24 18:06:43.000000', '2026-01-17', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(431, '2025-12-24 18:06:43.000000', '2026-01-18', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(432, '2025-12-24 18:06:43.000000', '2026-01-19', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(433, '2025-12-24 18:06:43.000000', '2026-01-20', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 20, b'0'),
(434, '2025-12-24 18:06:43.000000', '2026-01-21', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(435, '2025-12-24 18:06:43.000000', '2026-01-22', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(436, '2025-12-24 18:06:43.000000', '2026-01-23', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(437, '2025-12-24 18:06:43.000000', '2026-01-24', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 20, b'0'),
(438, '2025-12-24 18:06:43.000000', '2025-12-24', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(439, '2025-12-24 18:06:43.000000', '2025-12-25', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(440, '2025-12-24 18:06:43.000000', '2025-12-26', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(441, '2025-12-24 18:06:43.000000', '2025-12-27', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(442, '2025-12-24 18:06:43.000000', '2025-12-28', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(443, '2025-12-24 18:06:43.000000', '2025-12-29', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(444, '2025-12-24 18:06:43.000000', '2025-12-30', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(445, '2025-12-24 18:06:43.000000', '2025-12-31', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(446, '2025-12-24 18:06:43.000000', '2026-01-01', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(447, '2025-12-24 18:06:43.000000', '2026-01-02', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(448, '2025-12-24 18:06:43.000000', '2026-01-03', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(449, '2025-12-24 18:06:43.000000', '2026-01-04', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(450, '2025-12-24 18:06:43.000000', '2026-01-05', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(451, '2025-12-24 18:06:43.000000', '2026-01-06', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(452, '2025-12-24 18:06:43.000000', '2026-01-07', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(453, '2025-12-24 18:06:43.000000', '2026-01-08', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(454, '2025-12-24 18:06:43.000000', '2026-01-09', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(455, '2025-12-24 18:06:43.000000', '2026-01-10', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(456, '2025-12-24 18:06:43.000000', '2026-01-11', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(457, '2025-12-24 18:06:43.000000', '2026-01-12', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(458, '2025-12-24 18:06:43.000000', '2026-01-13', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(459, '2025-12-24 18:06:43.000000', '2026-01-14', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(460, '2025-12-24 18:06:43.000000', '2026-01-15', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(461, '2025-12-24 18:06:43.000000', '2026-01-16', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(462, '2025-12-24 18:06:43.000000', '2026-01-17', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(463, '2025-12-24 18:06:43.000000', '2026-01-18', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(464, '2025-12-24 18:06:43.000000', '2026-01-19', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(465, '2025-12-24 18:06:43.000000', '2026-01-20', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(466, '2025-12-24 18:06:43.000000', '2026-01-21', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(467, '2025-12-24 18:06:43.000000', '2026-01-22', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(468, '2025-12-24 18:06:43.000000', '2026-01-23', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 21, b'0'),
(469, '2025-12-24 18:06:43.000000', '2026-01-24', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 21, b'0'),
(470, '2025-12-24 18:06:43.000000', '2025-12-24', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(471, '2025-12-24 18:06:43.000000', '2025-12-25', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(472, '2025-12-24 18:06:43.000000', '2025-12-26', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(473, '2025-12-24 18:06:43.000000', '2025-12-27', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(474, '2025-12-24 18:06:43.000000', '2025-12-28', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(475, '2025-12-24 18:06:43.000000', '2025-12-29', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(476, '2025-12-24 18:06:43.000000', '2025-12-30', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(477, '2025-12-24 18:06:43.000000', '2025-12-31', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(478, '2025-12-24 18:06:43.000000', '2026-01-01', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(479, '2025-12-24 18:06:43.000000', '2026-01-02', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(480, '2025-12-24 18:06:43.000000', '2026-01-03', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(481, '2025-12-24 18:06:43.000000', '2026-01-04', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(482, '2025-12-24 18:06:43.000000', '2026-01-05', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(483, '2025-12-24 18:06:43.000000', '2026-01-06', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(484, '2025-12-24 18:06:43.000000', '2026-01-07', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(485, '2025-12-24 18:06:43.000000', '2026-01-08', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(486, '2025-12-24 18:06:43.000000', '2026-01-09', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(487, '2025-12-24 18:06:43.000000', '2026-01-10', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(488, '2025-12-24 18:06:43.000000', '2026-01-11', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(489, '2025-12-24 18:06:43.000000', '2026-01-12', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(490, '2025-12-24 18:06:43.000000', '2026-01-13', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(491, '2025-12-24 18:06:43.000000', '2026-01-14', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(492, '2025-12-24 18:06:43.000000', '2026-01-15', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(493, '2025-12-24 18:06:43.000000', '2026-01-16', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(494, '2025-12-24 18:06:43.000000', '2026-01-17', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(495, '2025-12-24 18:06:43.000000', '2026-01-18', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(496, '2025-12-24 18:06:43.000000', '2026-01-19', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(497, '2025-12-24 18:06:43.000000', '2026-01-20', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(498, '2025-12-24 18:06:43.000000', '2026-01-21', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(499, '2025-12-24 18:06:43.000000', '2026-01-22', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(500, '2025-12-24 18:06:43.000000', '2026-01-23', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 29, b'0'),
(501, '2025-12-24 18:06:43.000000', '2026-01-24', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 29, b'0'),
(502, '2025-12-24 18:06:43.000000', '2025-12-24', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(503, '2025-12-24 18:06:43.000000', '2025-12-25', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(504, '2025-12-24 18:06:43.000000', '2025-12-26', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(505, '2025-12-24 18:06:43.000000', '2025-12-27', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(506, '2025-12-24 18:06:43.000000', '2025-12-28', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 22, b'0'),
(507, '2025-12-24 18:06:43.000000', '2025-12-29', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 22, b'0'),
(508, '2025-12-24 18:06:43.000000', '2025-12-30', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(509, '2025-12-24 18:06:43.000000', '2025-12-31', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(510, '2025-12-24 18:06:43.000000', '2026-01-01', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(511, '2025-12-24 18:06:43.000000', '2026-01-02', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(512, '2025-12-24 18:06:43.000000', '2026-01-03', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(513, '2025-12-24 18:06:43.000000', '2026-01-04', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 22, b'0'),
(514, '2025-12-24 18:06:43.000000', '2026-01-05', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:02.000000', 22, b'0'),
(515, '2025-12-24 18:06:43.000000', '2026-01-06', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:02.000000', 22, b'0'),
(516, '2025-12-24 18:06:43.000000', '2026-01-07', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(517, '2025-12-24 18:06:43.000000', '2026-01-08', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(518, '2025-12-24 18:06:43.000000', '2026-01-09', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(519, '2025-12-24 18:06:43.000000', '2026-01-10', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(520, '2025-12-24 18:06:43.000000', '2026-01-11', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 22, b'0'),
(521, '2025-12-24 18:06:43.000000', '2026-01-12', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 22, b'0'),
(522, '2025-12-24 18:06:43.000000', '2026-01-13', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(523, '2025-12-24 18:06:43.000000', '2026-01-14', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(524, '2025-12-24 18:06:43.000000', '2026-01-15', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(525, '2025-12-24 18:06:43.000000', '2026-01-16', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(526, '2025-12-24 18:06:43.000000', '2026-01-17', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(527, '2025-12-24 18:06:43.000000', '2026-01-18', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 22, b'0'),
(528, '2025-12-24 18:06:43.000000', '2026-01-19', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 22, b'0'),
(529, '2025-12-24 18:06:43.000000', '2026-01-20', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(530, '2025-12-24 18:06:43.000000', '2026-01-21', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(531, '2025-12-24 18:06:43.000000', '2026-01-22', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(532, '2025-12-24 18:06:43.000000', '2026-01-23', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(533, '2025-12-24 18:06:43.000000', '2026-01-24', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 22, b'0'),
(534, '2025-12-24 18:06:43.000000', '2025-12-24', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(535, '2025-12-24 18:06:43.000000', '2025-12-25', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(536, '2025-12-24 18:06:43.000000', '2025-12-26', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(537, '2025-12-24 18:06:43.000000', '2025-12-27', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(538, '2025-12-24 18:06:43.000000', '2025-12-28', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 23, b'0'),
(539, '2025-12-24 18:06:43.000000', '2025-12-29', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(540, '2025-12-24 18:06:43.000000', '2025-12-30', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(541, '2025-12-24 18:06:43.000000', '2025-12-31', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(542, '2025-12-24 18:06:43.000000', '2026-01-01', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(543, '2025-12-24 18:06:43.000000', '2026-01-02', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(544, '2025-12-24 18:06:43.000000', '2026-01-03', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(545, '2025-12-24 18:06:43.000000', '2026-01-04', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 23, b'0'),
(546, '2025-12-24 18:06:43.000000', '2026-01-05', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(547, '2025-12-24 18:06:43.000000', '2026-01-06', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(548, '2025-12-24 18:06:43.000000', '2026-01-07', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(549, '2025-12-24 18:06:43.000000', '2026-01-08', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(550, '2025-12-24 18:06:43.000000', '2026-01-09', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(551, '2025-12-24 18:06:43.000000', '2026-01-10', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(552, '2025-12-24 18:06:43.000000', '2026-01-11', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 23, b'0'),
(553, '2025-12-24 18:06:43.000000', '2026-01-12', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(554, '2025-12-24 18:06:43.000000', '2026-01-13', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(555, '2025-12-24 18:06:43.000000', '2026-01-14', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(556, '2025-12-24 18:06:43.000000', '2026-01-15', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(557, '2025-12-24 18:06:43.000000', '2026-01-16', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(558, '2025-12-24 18:06:43.000000', '2026-01-17', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(559, '2025-12-24 18:06:43.000000', '2026-01-18', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 23, b'0'),
(560, '2025-12-24 18:06:43.000000', '2026-01-19', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(561, '2025-12-24 18:06:43.000000', '2026-01-20', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(562, '2025-12-24 18:06:43.000000', '2026-01-21', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(563, '2025-12-24 18:06:44.000000', '2026-01-22', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(564, '2025-12-24 18:06:44.000000', '2026-01-23', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(565, '2025-12-24 18:06:44.000000', '2026-01-24', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 23, b'0'),
(566, '2025-12-24 18:06:44.000000', '2025-12-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(567, '2025-12-24 18:06:44.000000', '2025-12-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(568, '2025-12-24 18:06:44.000000', '2025-12-26', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(569, '2025-12-24 18:06:44.000000', '2025-12-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(570, '2025-12-24 18:06:44.000000', '2025-12-28', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 24, b'0'),
(571, '2025-12-24 18:06:44.000000', '2025-12-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(572, '2025-12-24 18:06:44.000000', '2025-12-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(573, '2025-12-24 18:06:44.000000', '2025-12-31', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(574, '2025-12-24 18:06:44.000000', '2026-01-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(575, '2025-12-24 18:06:44.000000', '2026-01-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(576, '2025-12-24 18:06:44.000000', '2026-01-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(577, '2025-12-24 18:06:44.000000', '2026-01-04', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 24, b'0'),
(578, '2025-12-24 18:06:44.000000', '2026-01-05', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(579, '2025-12-24 18:06:44.000000', '2026-01-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(580, '2025-12-24 18:06:44.000000', '2026-01-07', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(581, '2025-12-24 18:06:44.000000', '2026-01-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(582, '2025-12-24 18:06:44.000000', '2026-01-09', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(583, '2025-12-24 18:06:44.000000', '2026-01-10', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(584, '2025-12-24 18:06:44.000000', '2026-01-11', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 24, b'0'),
(585, '2025-12-24 18:06:44.000000', '2026-01-12', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(586, '2025-12-24 18:06:44.000000', '2026-01-13', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(587, '2025-12-24 18:06:44.000000', '2026-01-14', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(588, '2025-12-24 18:06:44.000000', '2026-01-15', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(589, '2025-12-24 18:06:44.000000', '2026-01-16', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(590, '2025-12-24 18:06:44.000000', '2026-01-17', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(591, '2025-12-24 18:06:44.000000', '2026-01-18', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 24, b'0'),
(592, '2025-12-24 18:06:44.000000', '2026-01-19', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(593, '2025-12-24 18:06:44.000000', '2026-01-20', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(594, '2025-12-24 18:06:44.000000', '2026-01-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(595, '2025-12-24 18:06:44.000000', '2026-01-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(596, '2025-12-24 18:06:44.000000', '2026-01-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(597, '2025-12-24 18:06:44.000000', '2026-01-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 24, b'0'),
(598, '2025-12-24 18:06:44.000000', '2025-12-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(599, '2025-12-24 18:06:44.000000', '2025-12-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(600, '2025-12-24 18:06:44.000000', '2025-12-26', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(601, '2025-12-24 18:06:44.000000', '2025-12-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(602, '2025-12-24 18:06:44.000000', '2025-12-28', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(603, '2025-12-24 18:06:44.000000', '2025-12-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(604, '2025-12-24 18:06:44.000000', '2025-12-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(605, '2025-12-24 18:06:44.000000', '2025-12-31', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(606, '2025-12-24 18:06:44.000000', '2026-01-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(607, '2025-12-24 18:06:44.000000', '2026-01-02', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(608, '2025-12-24 18:06:44.000000', '2026-01-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(609, '2025-12-24 18:06:44.000000', '2026-01-04', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(610, '2025-12-24 18:06:44.000000', '2026-01-05', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(611, '2025-12-24 18:06:44.000000', '2026-01-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(612, '2025-12-24 18:06:44.000000', '2026-01-07', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(613, '2025-12-24 18:06:44.000000', '2026-01-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(614, '2025-12-24 18:06:44.000000', '2026-01-09', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(615, '2025-12-24 18:06:44.000000', '2026-01-10', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(616, '2025-12-24 18:06:44.000000', '2026-01-11', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(617, '2025-12-24 18:06:44.000000', '2026-01-12', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(618, '2025-12-24 18:06:44.000000', '2026-01-13', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(619, '2025-12-24 18:06:44.000000', '2026-01-14', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(620, '2025-12-24 18:06:44.000000', '2026-01-15', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(621, '2025-12-24 18:06:44.000000', '2026-01-16', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(622, '2025-12-24 18:06:44.000000', '2026-01-17', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(623, '2025-12-24 18:06:44.000000', '2026-01-18', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(624, '2025-12-24 18:06:44.000000', '2026-01-19', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(625, '2025-12-24 18:06:44.000000', '2026-01-20', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(626, '2025-12-24 18:06:44.000000', '2026-01-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(627, '2025-12-24 18:06:44.000000', '2026-01-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(628, '2025-12-24 18:06:44.000000', '2026-01-23', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-26 01:00:03.000000', 25, b'0'),
(629, '2025-12-24 18:06:44.000000', '2026-01-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-26 01:00:03.000000', 25, b'0'),
(630, '2025-12-24 01:30:27.000000', '2025-12-31', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-24 18:06:42.000000', 2, b'0'),
(631, '2025-12-26 01:00:00.000000', '2026-01-25', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-29 01:00:00.000000', 5, b'0'),
(632, '2025-12-26 01:00:00.000000', '2026-01-26', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:00.000000', 5, b'0'),
(633, '2025-12-26 01:00:00.000000', '2026-01-25', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-29 01:00:00.000000', 26, b'0'),
(634, '2025-12-26 01:00:00.000000', '2026-01-26', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:00.000000', 26, b'0'),
(635, '2025-12-26 01:00:00.000000', '2026-01-25', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-29 01:00:00.000000', 16, b'0'),
(636, '2025-12-26 01:00:00.000000', '2026-01-26', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-29 01:00:00.000000', 16, b'0'),
(637, '2025-12-26 01:00:01.000000', '2026-01-25', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-29 01:00:00.000000', 30, b'0'),
(638, '2025-12-26 01:00:01.000000', '2026-01-26', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2025-12-29 01:00:00.000000', 30, b'0'),
(639, '2025-12-26 01:00:01.000000', '2026-01-25', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 17, b'0'),
(640, '2025-12-26 01:00:01.000000', '2026-01-26', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 17, b'0'),
(641, '2025-12-26 01:00:01.000000', '2026-01-25', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 18, b'0'),
(642, '2025-12-26 01:00:01.000000', '2026-01-26', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 18, b'0'),
(643, '2025-12-26 01:00:02.000000', '2026-01-25', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 27, b'0'),
(644, '2025-12-26 01:00:02.000000', '2026-01-26', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 27, b'0'),
(645, '2025-12-26 01:00:02.000000', '2026-01-25', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 19, b'0'),
(646, '2025-12-26 01:00:02.000000', '2026-01-26', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 19, b'0'),
(647, '2025-12-26 01:00:02.000000', '2026-01-25', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 28, b'0'),
(648, '2025-12-26 01:00:02.000000', '2026-01-26', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 28, b'0'),
(649, '2025-12-26 01:00:02.000000', '2026-01-25', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 20, b'0'),
(650, '2025-12-26 01:00:02.000000', '2026-01-26', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 20, b'0'),
(651, '2025-12-26 01:00:02.000000', '2026-01-25', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 21, b'0'),
(652, '2025-12-26 01:00:02.000000', '2026-01-26', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 21, b'0'),
(653, '2025-12-26 01:00:02.000000', '2026-01-25', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 29, b'0'),
(654, '2025-12-26 01:00:02.000000', '2026-01-26', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 29, b'0'),
(655, '2025-12-26 01:00:03.000000', '2026-01-25', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 22, b'0'),
(656, '2025-12-26 01:00:03.000000', '2026-01-26', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 22, b'0'),
(657, '2025-12-26 01:00:03.000000', '2026-01-25', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 23, b'0'),
(658, '2025-12-26 01:00:03.000000', '2026-01-26', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 23, b'0'),
(659, '2025-12-26 01:00:03.000000', '2026-01-25', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 24, b'0'),
(660, '2025-12-26 01:00:03.000000', '2026-01-26', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 24, b'0'),
(661, '2025-12-26 01:00:03.000000', '2026-01-25', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2025-12-29 01:00:01.000000', 25, b'0'),
(662, '2025-12-26 01:00:03.000000', '2026-01-26', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2025-12-29 01:00:01.000000', 25, b'0'),
(663, '2025-12-29 01:00:00.000000', '2026-01-27', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-01-04 01:00:00.000000', 5, b'0'),
(664, '2025-12-29 01:00:00.000000', '2026-01-28', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 5, b'0'),
(665, '2025-12-29 01:00:00.000000', '2026-01-29', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 5, b'0'),
(666, '2025-12-29 01:00:00.000000', '2026-01-27', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-01-04 01:00:00.000000', 26, b'0'),
(667, '2025-12-29 01:00:00.000000', '2026-01-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 26, b'0'),
(668, '2025-12-29 01:00:00.000000', '2026-01-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 26, b'0'),
(669, '2025-12-29 01:00:00.000000', '2026-01-27', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 16, b'0'),
(670, '2025-12-29 01:00:00.000000', '2026-01-28', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 16, b'0'),
(671, '2025-12-29 01:00:00.000000', '2026-01-29', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 16, b'0'),
(672, '2025-12-29 01:00:00.000000', '2026-01-27', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 30, b'0'),
(673, '2025-12-29 01:00:00.000000', '2026-01-28', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 30, b'0'),
(674, '2025-12-29 01:00:00.000000', '2026-01-29', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 30, b'0'),
(675, '2025-12-29 01:00:01.000000', '2026-01-27', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 17, b'0'),
(676, '2025-12-29 01:00:01.000000', '2026-01-28', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 17, b'0'),
(677, '2025-12-29 01:00:01.000000', '2026-01-29', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 17, b'0'),
(678, '2025-12-29 01:00:01.000000', '2026-01-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 18, b'0'),
(679, '2025-12-29 01:00:01.000000', '2026-01-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 18, b'0'),
(680, '2025-12-29 01:00:01.000000', '2026-01-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:00.000000', 18, b'0'),
(681, '2025-12-29 01:00:01.000000', '2026-01-27', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 27, b'0'),
(682, '2025-12-29 01:00:01.000000', '2026-01-28', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 27, b'0'),
(683, '2025-12-29 01:00:01.000000', '2026-01-29', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 27, b'0'),
(684, '2025-12-29 01:00:01.000000', '2026-01-27', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 19, b'0'),
(685, '2025-12-29 01:00:01.000000', '2026-01-28', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 19, b'0'),
(686, '2025-12-29 01:00:01.000000', '2026-01-29', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 19, b'0'),
(687, '2025-12-29 01:00:01.000000', '2026-01-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 28, b'0'),
(688, '2025-12-29 01:00:01.000000', '2026-01-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 28, b'0'),
(689, '2025-12-29 01:00:01.000000', '2026-01-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 28, b'0'),
(690, '2025-12-29 01:00:01.000000', '2026-01-27', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-01-04 01:00:01.000000', 20, b'0'),
(691, '2025-12-29 01:00:01.000000', '2026-01-28', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 20, b'0'),
(692, '2025-12-29 01:00:01.000000', '2026-01-29', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 20, b'0'),
(693, '2025-12-29 01:00:01.000000', '2026-01-27', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 21, b'0'),
(694, '2025-12-29 01:00:01.000000', '2026-01-28', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 21, b'0'),
(695, '2025-12-29 01:00:01.000000', '2026-01-29', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 21, b'0'),
(696, '2025-12-29 01:00:01.000000', '2026-01-27', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 29, b'0'),
(697, '2025-12-29 01:00:01.000000', '2026-01-28', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 29, b'0'),
(698, '2025-12-29 01:00:01.000000', '2026-01-29', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 29, b'0'),
(699, '2025-12-29 01:00:01.000000', '2026-01-27', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 22, b'0'),
(700, '2025-12-29 01:00:01.000000', '2026-01-28', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 22, b'0'),
(701, '2025-12-29 01:00:01.000000', '2026-01-29', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 22, b'0'),
(702, '2025-12-29 01:00:01.000000', '2026-01-27', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 23, b'0'),
(703, '2025-12-29 01:00:01.000000', '2026-01-28', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 23, b'0'),
(704, '2025-12-29 01:00:01.000000', '2026-01-29', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 23, b'0'),
(705, '2025-12-29 01:00:01.000000', '2026-01-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 24, b'0'),
(706, '2025-12-29 01:00:01.000000', '2026-01-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 24, b'0'),
(707, '2025-12-29 01:00:01.000000', '2026-01-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 24, b'0'),
(708, '2025-12-29 01:00:01.000000', '2026-01-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 25, b'0'),
(709, '2025-12-29 01:00:01.000000', '2026-01-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 25, b'0'),
(710, '2025-12-29 01:00:01.000000', '2026-01-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-01-04 01:00:01.000000', 25, b'0'),
(807, '2026-01-04 01:00:00.000000', '2026-01-25', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(808, '2026-01-04 01:00:00.000000', '2026-01-26', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(809, '2026-01-04 01:00:00.000000', '2026-01-27', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(810, '2026-01-04 01:00:00.000000', '2026-01-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(811, '2026-01-04 01:00:00.000000', '2026-01-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(812, '2026-01-04 01:00:00.000000', '2026-01-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(813, '2026-01-04 01:00:00.000000', '2026-01-31', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(814, '2026-01-04 01:00:00.000000', '2026-02-01', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(815, '2026-01-04 01:00:00.000000', '2026-02-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(816, '2026-01-04 01:00:00.000000', '2026-02-03', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(817, '2026-01-04 01:00:00.000000', '2026-02-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(818, '2026-01-04 01:00:00.000000', '2026-01-30', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(819, '2026-01-04 01:00:00.000000', '2026-01-31', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(820, '2026-01-04 01:00:00.000000', '2026-02-01', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(821, '2026-01-04 01:00:00.000000', '2026-02-02', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(822, '2026-01-04 01:00:00.000000', '2026-02-03', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(823, '2026-01-04 01:00:00.000000', '2026-02-04', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(824, '2026-01-04 01:00:00.000000', '2026-01-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(825, '2026-01-04 01:00:00.000000', '2026-01-31', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(826, '2026-01-04 01:00:00.000000', '2026-02-01', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(827, '2026-01-04 01:00:00.000000', '2026-02-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(828, '2026-01-04 01:00:00.000000', '2026-02-03', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(829, '2026-01-04 01:00:00.000000', '2026-02-04', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(830, '2026-01-04 01:00:00.000000', '2026-01-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(831, '2026-01-04 01:00:00.000000', '2026-01-31', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(832, '2026-01-04 01:00:00.000000', '2026-02-01', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 16, b'0'),
(833, '2026-01-04 01:00:00.000000', '2026-02-02', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 16, b'0'),
(834, '2026-01-04 01:00:00.000000', '2026-02-03', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(835, '2026-01-04 01:00:00.000000', '2026-02-04', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(836, '2026-01-04 01:00:00.000000', '2026-01-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(837, '2026-01-04 01:00:00.000000', '2026-01-31', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(838, '2026-01-04 01:00:00.000000', '2026-02-01', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 30, b'0'),
(839, '2026-01-04 01:00:00.000000', '2026-02-02', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 30, b'0'),
(840, '2026-01-04 01:00:00.000000', '2026-02-03', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(841, '2026-01-04 01:00:00.000000', '2026-02-04', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(842, '2026-01-04 01:00:00.000000', '2026-01-30', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(843, '2026-01-04 01:00:00.000000', '2026-01-31', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(844, '2026-01-04 01:00:00.000000', '2026-02-01', '23:00:00.000000', '15:00:00.000000', 'CLOSED', NULL, 17, b'0'),
(845, '2026-01-04 01:00:00.000000', '2026-02-02', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(846, '2026-01-04 01:00:00.000000', '2026-02-03', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(847, '2026-01-04 01:00:00.000000', '2026-02-04', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(848, '2026-01-04 01:00:00.000000', '2026-01-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(849, '2026-01-04 01:00:00.000000', '2026-01-31', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(850, '2026-01-04 01:00:00.000000', '2026-02-01', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 18, b'0'),
(851, '2026-01-04 01:00:00.000000', '2026-02-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(852, '2026-01-04 01:00:00.000000', '2026-02-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(853, '2026-01-04 01:00:00.000000', '2026-02-04', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(854, '2026-01-04 01:00:01.000000', '2026-01-30', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(855, '2026-01-04 01:00:01.000000', '2026-01-31', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(856, '2026-01-04 01:00:01.000000', '2026-02-01', '17:30:00.000000', '08:30:00.000000', 'CLOSED', NULL, 27, b'0'),
(857, '2026-01-04 01:00:01.000000', '2026-02-02', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0');
INSERT INTO `staff_availabilities` (`id`, `created_at`, `date`, `end_time`, `start_time`, `status`, `updated_at`, `staff_id`, `user_edited`) VALUES
(858, '2026-01-04 01:00:01.000000', '2026-02-03', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(859, '2026-01-04 01:00:01.000000', '2026-02-04', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(860, '2026-01-04 01:00:01.000000', '2026-01-30', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(861, '2026-01-04 01:00:01.000000', '2026-01-31', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(862, '2026-01-04 01:00:01.000000', '2026-02-01', '18:30:00.000000', '09:00:00.000000', 'CLOSED', NULL, 19, b'0'),
(863, '2026-01-04 01:00:01.000000', '2026-02-02', '18:30:00.000000', '09:00:00.000000', 'CLOSED', NULL, 19, b'0'),
(864, '2026-01-04 01:00:01.000000', '2026-02-03', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(865, '2026-01-04 01:00:01.000000', '2026-02-04', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(866, '2026-01-04 01:00:01.000000', '2026-01-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(867, '2026-01-04 01:00:01.000000', '2026-01-31', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(868, '2026-01-04 01:00:01.000000', '2026-02-01', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 28, b'0'),
(869, '2026-01-04 01:00:01.000000', '2026-02-02', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 28, b'0'),
(870, '2026-01-04 01:00:01.000000', '2026-02-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(871, '2026-01-04 01:00:01.000000', '2026-02-04', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(872, '2026-01-04 01:00:01.000000', '2026-01-30', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(873, '2026-01-04 01:00:01.000000', '2026-01-31', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(874, '2026-01-04 01:00:01.000000', '2026-02-01', '23:30:00.000000', '15:00:00.000000', 'CLOSED', NULL, 20, b'0'),
(875, '2026-01-04 01:00:01.000000', '2026-02-02', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(876, '2026-01-04 01:00:01.000000', '2026-02-03', '23:30:00.000000', '15:00:00.000000', 'CLOSED', NULL, 20, b'0'),
(877, '2026-01-04 01:00:01.000000', '2026-02-04', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(878, '2026-01-04 01:00:01.000000', '2026-01-30', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(879, '2026-01-04 01:00:01.000000', '2026-01-31', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(880, '2026-01-04 01:00:01.000000', '2026-02-01', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(881, '2026-01-04 01:00:01.000000', '2026-02-02', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(882, '2026-01-04 01:00:01.000000', '2026-02-03', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(883, '2026-01-04 01:00:01.000000', '2026-02-04', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(884, '2026-01-04 01:00:01.000000', '2026-01-30', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(885, '2026-01-04 01:00:01.000000', '2026-01-31', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(886, '2026-01-04 01:00:01.000000', '2026-02-01', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(887, '2026-01-04 01:00:01.000000', '2026-02-02', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(888, '2026-01-04 01:00:01.000000', '2026-02-03', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(889, '2026-01-04 01:00:01.000000', '2026-02-04', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(890, '2026-01-04 01:00:01.000000', '2026-01-30', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(891, '2026-01-04 01:00:01.000000', '2026-01-31', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(892, '2026-01-04 01:00:01.000000', '2026-02-01', '23:00:00.000000', '16:00:00.000000', 'CLOSED', NULL, 22, b'0'),
(893, '2026-01-04 01:00:01.000000', '2026-02-02', '23:00:00.000000', '16:00:00.000000', 'CLOSED', NULL, 22, b'0'),
(894, '2026-01-04 01:00:01.000000', '2026-02-03', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(895, '2026-01-04 01:00:01.000000', '2026-02-04', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(896, '2026-01-04 01:00:01.000000', '2026-01-30', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(897, '2026-01-04 01:00:01.000000', '2026-01-31', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(898, '2026-01-04 01:00:01.000000', '2026-02-01', '19:00:00.000000', '10:00:00.000000', 'CLOSED', NULL, 23, b'0'),
(899, '2026-01-04 01:00:01.000000', '2026-02-02', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(900, '2026-01-04 01:00:01.000000', '2026-02-03', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(901, '2026-01-04 01:00:01.000000', '2026-02-04', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(902, '2026-01-04 01:00:01.000000', '2026-01-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(903, '2026-01-04 01:00:01.000000', '2026-01-31', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(904, '2026-01-04 01:00:01.000000', '2026-02-01', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 24, b'0'),
(905, '2026-01-04 01:00:01.000000', '2026-02-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(906, '2026-01-04 01:00:01.000000', '2026-02-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(907, '2026-01-04 01:00:01.000000', '2026-02-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(908, '2026-01-04 01:00:01.000000', '2026-01-30', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(909, '2026-01-04 01:00:01.000000', '2026-01-31', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(910, '2026-01-04 01:00:01.000000', '2026-02-01', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(911, '2026-01-04 01:00:01.000000', '2026-02-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(912, '2026-01-04 01:00:01.000000', '2026-02-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(913, '2026-01-04 01:00:01.000000', '2026-02-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(914, '2026-04-21 18:44:38.005545', '2026-04-21', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(915, '2026-04-21 18:44:38.018181', '2026-04-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(916, '2026-04-21 18:44:38.021014', '2026-04-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(917, '2026-04-21 18:44:38.022977', '2026-04-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(918, '2026-04-21 18:44:38.024603', '2026-04-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(919, '2026-04-21 18:44:38.026519', '2026-04-26', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(920, '2026-04-21 18:44:38.028545', '2026-04-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.079866', 2, b'0'),
(921, '2026-04-21 18:44:38.031093', '2026-04-28', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.081486', 2, b'0'),
(922, '2026-04-21 18:44:38.032588', '2026-04-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.083104', 2, b'0'),
(923, '2026-04-21 18:44:38.034065', '2026-04-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.084933', 2, b'0'),
(924, '2026-04-21 18:44:38.035439', '2026-05-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.086523', 2, b'0'),
(925, '2026-04-21 18:44:38.037256', '2026-05-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.088091', 2, b'0'),
(926, '2026-04-21 18:44:38.038769', '2026-05-03', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.089678', 2, b'0'),
(927, '2026-04-21 18:44:38.040217', '2026-05-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.091286', 2, b'0'),
(928, '2026-04-21 18:44:38.041768', '2026-05-05', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.092996', 2, b'0'),
(929, '2026-04-21 18:44:38.043197', '2026-05-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.094579', 2, b'0'),
(930, '2026-04-21 18:44:38.044527', '2026-05-07', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.096187', 2, b'0'),
(931, '2026-04-21 18:44:38.045872', '2026-05-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.097650', 2, b'0'),
(932, '2026-04-21 18:44:38.047022', '2026-05-09', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.099017', 2, b'0'),
(933, '2026-04-21 18:44:38.048297', '2026-05-10', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.100344', 2, b'0'),
(934, '2026-04-21 18:44:38.049508', '2026-05-11', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.101712', 2, b'0'),
(935, '2026-04-21 18:44:38.050788', '2026-05-12', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.103482', 2, b'0'),
(936, '2026-04-21 18:44:38.052206', '2026-05-13', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.105110', 2, b'0'),
(937, '2026-04-21 18:44:38.053405', '2026-05-14', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.106905', 2, b'0'),
(938, '2026-04-21 18:44:38.054693', '2026-05-15', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.108402', 2, b'0'),
(939, '2026-04-21 18:44:38.056103', '2026-05-16', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.109944', 2, b'0'),
(940, '2026-04-21 18:44:38.057357', '2026-05-17', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.111470', 2, b'0'),
(941, '2026-04-21 18:44:38.058493', '2026-05-18', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.113238', 2, b'0'),
(942, '2026-04-21 18:44:38.059632', '2026-05-19', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.115334', 2, b'0'),
(943, '2026-04-21 18:44:38.060794', '2026-05-20', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.117331', 2, b'0'),
(944, '2026-04-21 18:44:38.062028', '2026-05-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.119264', 2, b'0'),
(945, '2026-04-21 18:44:38.063569', '2026-04-21', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(946, '2026-04-21 18:44:38.064872', '2026-04-22', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(947, '2026-04-21 18:44:38.066308', '2026-04-23', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(948, '2026-04-21 18:44:38.067403', '2026-04-24', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(949, '2026-04-21 18:44:38.068743', '2026-04-25', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(950, '2026-04-21 18:44:38.069939', '2026-04-26', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(951, '2026-04-21 18:44:38.071067', '2026-04-27', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.136468', 5, b'0'),
(952, '2026-04-21 18:44:38.072478', '2026-04-28', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.140003', 5, b'0'),
(953, '2026-04-21 18:44:38.073742', '2026-04-29', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.142373', 5, b'0'),
(954, '2026-04-21 18:44:38.075247', '2026-04-30', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.144841', 5, b'0'),
(955, '2026-04-21 18:44:38.076366', '2026-05-01', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.147756', 5, b'0'),
(956, '2026-04-21 18:44:38.077442', '2026-05-02', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.149976', 5, b'0'),
(957, '2026-04-21 18:44:38.078706', '2026-05-03', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.151893', 5, b'0'),
(958, '2026-04-21 18:44:38.079918', '2026-05-04', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.153639', 5, b'0'),
(959, '2026-04-21 18:44:38.081188', '2026-05-05', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.155607', 5, b'0'),
(960, '2026-04-21 18:44:38.082449', '2026-05-06', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.157539', 5, b'0'),
(961, '2026-04-21 18:44:38.083492', '2026-05-07', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.159694', 5, b'0'),
(962, '2026-04-21 18:44:38.084749', '2026-05-08', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.161330', 5, b'0'),
(963, '2026-04-21 18:44:38.086133', '2026-05-09', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.162908', 5, b'0'),
(964, '2026-04-21 18:44:38.087255', '2026-05-10', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.164418', 5, b'0'),
(965, '2026-04-21 18:44:38.088731', '2026-05-11', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.166128', 5, b'0'),
(966, '2026-04-21 18:44:38.089906', '2026-05-12', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.167940', 5, b'0'),
(967, '2026-04-21 18:44:38.090919', '2026-05-13', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.169593', 5, b'0'),
(968, '2026-04-21 18:44:38.092383', '2026-05-14', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.173071', 5, b'0'),
(969, '2026-04-21 18:44:38.093556', '2026-05-15', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.176033', 5, b'0'),
(970, '2026-04-21 18:44:38.094642', '2026-05-16', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.178799', 5, b'0'),
(971, '2026-04-21 18:44:38.095663', '2026-05-17', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.181440', 5, b'0'),
(972, '2026-04-21 18:44:38.096693', '2026-05-18', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.184257', 5, b'0'),
(973, '2026-04-21 18:44:38.097778', '2026-05-19', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.188018', 5, b'0'),
(974, '2026-04-21 18:44:38.098825', '2026-05-20', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.192106', 5, b'0'),
(975, '2026-04-21 18:44:38.099963', '2026-05-21', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.195253', 5, b'0'),
(976, '2026-04-21 18:44:38.101007', '2026-04-21', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(977, '2026-04-21 18:44:38.102082', '2026-04-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(978, '2026-04-21 18:44:38.103035', '2026-04-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(979, '2026-04-21 18:44:38.103970', '2026-04-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(980, '2026-04-21 18:44:38.104915', '2026-04-25', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(981, '2026-04-21 18:44:38.105971', '2026-04-26', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(982, '2026-04-21 18:44:38.107115', '2026-04-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.208891', 26, b'0'),
(983, '2026-04-21 18:44:38.108170', '2026-04-28', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.210826', 26, b'0'),
(984, '2026-04-21 18:44:38.109228', '2026-04-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.213040', 26, b'0'),
(985, '2026-04-21 18:44:38.110158', '2026-04-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.214701', 26, b'0'),
(986, '2026-04-21 18:44:38.111199', '2026-05-01', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.216193', 26, b'0'),
(987, '2026-04-21 18:44:38.112134', '2026-05-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.217704', 26, b'0'),
(988, '2026-04-21 18:44:38.113264', '2026-05-03', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.220496', 26, b'0'),
(989, '2026-04-21 18:44:38.114398', '2026-05-04', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.223270', 26, b'0'),
(990, '2026-04-21 18:44:38.115512', '2026-05-05', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.226297', 26, b'0'),
(991, '2026-04-21 18:44:38.116511', '2026-05-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.228362', 26, b'0'),
(992, '2026-04-21 18:44:38.117502', '2026-05-07', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.230421', 26, b'0'),
(993, '2026-04-21 18:44:38.118885', '2026-05-08', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.231869', 26, b'0'),
(994, '2026-04-21 18:44:38.120109', '2026-05-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.233826', 26, b'0'),
(995, '2026-04-21 18:44:38.121127', '2026-05-10', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.235737', 26, b'0'),
(996, '2026-04-21 18:44:38.122135', '2026-05-11', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.238836', 26, b'0'),
(997, '2026-04-21 18:44:38.123129', '2026-05-12', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.242081', 26, b'0'),
(998, '2026-04-21 18:44:38.124089', '2026-05-13', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.246020', 26, b'0'),
(999, '2026-04-21 18:44:38.124988', '2026-05-14', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.251143', 26, b'0'),
(1000, '2026-04-21 18:44:38.125979', '2026-05-15', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.255899', 26, b'0'),
(1001, '2026-04-21 18:44:38.126887', '2026-05-16', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.258091', 26, b'0'),
(1002, '2026-04-21 18:44:38.127775', '2026-05-17', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.260321', 26, b'0'),
(1003, '2026-04-21 18:44:38.128682', '2026-05-18', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.262292', 26, b'0'),
(1004, '2026-04-21 18:44:38.129708', '2026-05-19', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.263924', 26, b'0'),
(1005, '2026-04-21 18:44:38.130753', '2026-05-20', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.265152', 26, b'0'),
(1006, '2026-04-21 18:44:38.132090', '2026-05-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.266428', 26, b'0'),
(1007, '2026-04-21 18:44:38.135012', '2026-04-21', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1008, '2026-04-21 18:44:38.136203', '2026-04-22', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1009, '2026-04-21 18:44:38.137269', '2026-04-23', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1010, '2026-04-21 18:44:38.138297', '2026-04-24', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1011, '2026-04-21 18:44:38.139288', '2026-04-25', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1012, '2026-04-21 18:44:38.140331', '2026-04-26', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 16, b'0'),
(1013, '2026-04-21 18:44:38.141454', '2026-04-27', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.155277', 16, b'0'),
(1014, '2026-04-21 18:44:38.142578', '2026-04-28', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.280131', 16, b'0'),
(1015, '2026-04-21 18:44:38.143704', '2026-04-29', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.281528', 16, b'0'),
(1016, '2026-04-21 18:44:38.144872', '2026-04-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.282617', 16, b'0'),
(1017, '2026-04-21 18:44:38.146225', '2026-05-01', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.283674', 16, b'0'),
(1018, '2026-04-21 18:44:38.147341', '2026-05-02', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.284742', 16, b'0'),
(1019, '2026-04-21 18:44:38.148533', '2026-05-03', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.285797', 16, b'0'),
(1020, '2026-04-21 18:44:38.149617', '2026-05-04', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.155277', 16, b'0'),
(1021, '2026-04-21 18:44:38.151112', '2026-05-05', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.287835', 16, b'0'),
(1022, '2026-04-21 18:44:38.152441', '2026-05-06', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.288987', 16, b'0'),
(1023, '2026-04-21 18:44:38.155524', '2026-05-07', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.290141', 16, b'0'),
(1024, '2026-04-21 18:44:38.157080', '2026-05-08', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.291356', 16, b'0'),
(1025, '2026-04-21 18:44:38.159369', '2026-05-09', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.292413', 16, b'0'),
(1026, '2026-04-21 18:44:38.160484', '2026-05-10', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.293679', 16, b'0'),
(1027, '2026-04-21 18:44:38.161826', '2026-05-11', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.155277', 16, b'0'),
(1028, '2026-04-21 18:44:38.163458', '2026-05-12', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.295369', 16, b'0'),
(1029, '2026-04-21 18:44:38.164684', '2026-05-13', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.296746', 16, b'0'),
(1030, '2026-04-21 18:44:38.166049', '2026-05-14', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.298263', 16, b'0'),
(1031, '2026-04-21 18:44:38.167643', '2026-05-15', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.299169', 16, b'0'),
(1032, '2026-04-21 18:44:38.169099', '2026-05-16', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.300307', 16, b'0'),
(1033, '2026-04-21 18:44:38.170423', '2026-05-17', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.301341', 16, b'0'),
(1034, '2026-04-21 18:44:38.171982', '2026-05-18', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.155277', 16, b'0'),
(1035, '2026-04-21 18:44:38.173092', '2026-05-19', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.302947', 16, b'0'),
(1036, '2026-04-21 18:44:38.174067', '2026-05-20', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.303878', 16, b'0'),
(1037, '2026-04-21 18:44:38.175046', '2026-05-21', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.305297', 16, b'0'),
(1038, '2026-04-21 18:44:38.176001', '2026-04-21', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1039, '2026-04-21 18:44:38.176819', '2026-04-22', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1040, '2026-04-21 18:44:38.177729', '2026-04-23', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1041, '2026-04-21 18:44:38.178807', '2026-04-24', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1042, '2026-04-21 18:44:38.180154', '2026-04-25', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1043, '2026-04-21 18:44:38.181042', '2026-04-26', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 30, b'0'),
(1044, '2026-04-21 18:44:38.182000', '2026-04-27', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.313854', 30, b'0'),
(1045, '2026-04-21 18:44:38.182785', '2026-04-28', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.314936', 30, b'0'),
(1046, '2026-04-21 18:44:38.183640', '2026-04-29', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.316071', 30, b'0'),
(1047, '2026-04-21 18:44:38.184642', '2026-04-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.317050', 30, b'0'),
(1048, '2026-04-21 18:44:38.185922', '2026-05-01', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.318044', 30, b'0'),
(1049, '2026-04-21 18:44:38.186970', '2026-05-02', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.319245', 30, b'0'),
(1050, '2026-04-21 18:44:38.187888', '2026-05-03', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.320415', 30, b'0'),
(1051, '2026-04-21 18:44:38.188709', '2026-05-04', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.321680', 30, b'0'),
(1052, '2026-04-21 18:44:38.189497', '2026-05-05', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.322982', 30, b'0'),
(1053, '2026-04-21 18:44:38.190345', '2026-05-06', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.324105', 30, b'0'),
(1054, '2026-04-21 18:44:38.191225', '2026-05-07', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.325223', 30, b'0'),
(1055, '2026-04-21 18:44:38.192047', '2026-05-08', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.327048', 30, b'0'),
(1056, '2026-04-21 18:44:38.192874', '2026-05-09', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.328257', 30, b'0'),
(1057, '2026-04-21 18:44:38.193688', '2026-05-10', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.329432', 30, b'0'),
(1058, '2026-04-21 18:44:38.194590', '2026-05-11', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.330555', 30, b'0'),
(1059, '2026-04-21 18:44:38.195445', '2026-05-12', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.331642', 30, b'0'),
(1060, '2026-04-21 18:44:38.196278', '2026-05-13', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.332717', 30, b'0'),
(1061, '2026-04-21 18:44:38.197054', '2026-05-14', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.333785', 30, b'0'),
(1062, '2026-04-21 18:44:38.197980', '2026-05-15', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.334904', 30, b'0'),
(1063, '2026-04-21 18:44:38.198930', '2026-05-16', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.336044', 30, b'0'),
(1064, '2026-04-21 18:44:38.199749', '2026-05-17', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.337309', 30, b'0'),
(1065, '2026-04-21 18:44:38.200541', '2026-05-18', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.338790', 30, b'0'),
(1066, '2026-04-21 18:44:38.201415', '2026-05-19', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.339919', 30, b'0'),
(1067, '2026-04-21 18:44:38.202300', '2026-05-20', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.341718', 30, b'0'),
(1068, '2026-04-21 18:44:38.203186', '2026-05-21', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.342717', 30, b'0'),
(1069, '2026-04-21 18:44:38.204865', '2026-04-21', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1070, '2026-04-21 18:44:38.205698', '2026-04-22', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1071, '2026-04-21 18:44:38.206512', '2026-04-23', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1072, '2026-04-21 18:44:38.207338', '2026-04-24', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.157172', 17, b'0'),
(1073, '2026-04-21 18:44:38.208210', '2026-04-25', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1074, '2026-04-21 18:44:38.209243', '2026-04-26', '23:00:00.000000', '15:00:00.000000', 'CLOSED', NULL, 17, b'0'),
(1075, '2026-04-21 18:44:38.210160', '2026-04-27', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.352645', 17, b'0'),
(1076, '2026-04-21 18:44:38.211196', '2026-04-28', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.353945', 17, b'0'),
(1077, '2026-04-21 18:44:38.212380', '2026-04-29', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.354899', 17, b'0'),
(1078, '2026-04-21 18:44:38.214237', '2026-04-30', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.355721', 17, b'0'),
(1079, '2026-04-21 18:44:38.215214', '2026-05-01', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.157172', 17, b'0'),
(1080, '2026-04-21 18:44:38.216148', '2026-05-02', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.357416', 17, b'0'),
(1081, '2026-04-21 18:44:38.216926', '2026-05-03', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.358406', 17, b'0'),
(1082, '2026-04-21 18:44:38.217924', '2026-05-04', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.359275', 17, b'0'),
(1083, '2026-04-21 18:44:38.218733', '2026-05-05', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.360477', 17, b'0'),
(1084, '2026-04-21 18:44:38.219549', '2026-05-06', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.361441', 17, b'0'),
(1085, '2026-04-21 18:44:38.220486', '2026-05-07', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.362562', 17, b'0'),
(1086, '2026-04-21 18:44:38.221364', '2026-05-08', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.157172', 17, b'0'),
(1087, '2026-04-21 18:44:38.222292', '2026-05-09', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.363889', 17, b'0'),
(1088, '2026-04-21 18:44:38.223207', '2026-05-10', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.364928', 17, b'0'),
(1089, '2026-04-21 18:44:38.224101', '2026-05-11', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.366057', 17, b'0'),
(1090, '2026-04-21 18:44:38.225006', '2026-05-12', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.366827', 17, b'0'),
(1091, '2026-04-21 18:44:38.226032', '2026-05-13', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.367656', 17, b'0'),
(1092, '2026-04-21 18:44:38.226942', '2026-05-14', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.368387', 17, b'0'),
(1093, '2026-04-21 18:44:38.227935', '2026-05-15', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.157172', 17, b'0'),
(1094, '2026-04-21 18:44:38.228887', '2026-05-16', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.369900', 17, b'0'),
(1095, '2026-04-21 18:44:38.230016', '2026-05-17', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.370930', 17, b'0'),
(1096, '2026-04-21 18:44:38.230971', '2026-05-18', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.371938', 17, b'0'),
(1097, '2026-04-21 18:44:38.232366', '2026-05-19', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.372956', 17, b'0'),
(1098, '2026-04-21 18:44:38.233589', '2026-05-20', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.373813', 17, b'0'),
(1099, '2026-04-21 18:44:38.234559', '2026-05-21', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.374710', 17, b'0'),
(1100, '2026-04-21 18:44:38.236408', '2026-04-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1101, '2026-04-21 18:44:38.237360', '2026-04-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1102, '2026-04-21 18:44:38.238588', '2026-04-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1103, '2026-04-21 18:44:38.240908', '2026-04-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1104, '2026-04-21 18:44:38.241859', '2026-04-25', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1105, '2026-04-21 18:44:38.242783', '2026-04-26', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 18, b'0'),
(1106, '2026-04-21 18:44:38.243707', '2026-04-27', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.159520', 18, b'0'),
(1107, '2026-04-21 18:44:38.244633', '2026-04-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.382184', 18, b'0'),
(1108, '2026-04-21 18:44:38.245544', '2026-04-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.383040', 18, b'0'),
(1109, '2026-04-21 18:44:38.246880', '2026-04-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.383897', 18, b'0'),
(1110, '2026-04-21 18:44:38.248342', '2026-05-01', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.384733', 18, b'0'),
(1111, '2026-04-21 18:44:38.249175', '2026-05-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.385549', 18, b'0'),
(1112, '2026-04-21 18:44:38.250228', '2026-05-03', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.386482', 18, b'0'),
(1113, '2026-04-21 18:44:38.251194', '2026-05-04', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.159520', 18, b'0'),
(1114, '2026-04-21 18:44:38.252277', '2026-05-05', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.387971', 18, b'0'),
(1115, '2026-04-21 18:44:38.253503', '2026-05-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.389044', 18, b'0'),
(1116, '2026-04-21 18:44:38.254487', '2026-05-07', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.389897', 18, b'0'),
(1117, '2026-04-21 18:44:38.255504', '2026-05-08', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.390615', 18, b'0'),
(1118, '2026-04-21 18:44:38.256436', '2026-05-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.391801', 18, b'0'),
(1119, '2026-04-21 18:44:38.257332', '2026-05-10', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.392632', 18, b'0'),
(1120, '2026-04-21 18:44:38.258168', '2026-05-11', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.159520', 18, b'0'),
(1121, '2026-04-21 18:44:38.259067', '2026-05-12', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.394450', 18, b'0'),
(1122, '2026-04-21 18:44:38.259932', '2026-05-13', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.395597', 18, b'0'),
(1123, '2026-04-21 18:44:38.261331', '2026-05-14', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.396961', 18, b'0'),
(1124, '2026-04-21 18:44:38.262352', '2026-05-15', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.397771', 18, b'0'),
(1125, '2026-04-21 18:44:38.263474', '2026-05-16', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.398654', 18, b'0'),
(1126, '2026-04-21 18:44:38.264805', '2026-05-17', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.399592', 18, b'0'),
(1127, '2026-04-21 18:44:38.265891', '2026-05-18', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.159520', 18, b'0'),
(1128, '2026-04-21 18:44:38.266756', '2026-05-19', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.401109', 18, b'0'),
(1129, '2026-04-21 18:44:38.267635', '2026-05-20', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.402141', 18, b'0'),
(1130, '2026-04-21 18:44:38.268619', '2026-05-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.402988', 18, b'0'),
(1131, '2026-04-21 18:44:38.269494', '2026-04-21', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1132, '2026-04-21 18:44:38.270599', '2026-04-22', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1133, '2026-04-21 18:44:38.271485', '2026-04-23', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1134, '2026-04-21 18:44:38.272356', '2026-04-24', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1135, '2026-04-21 18:44:38.273177', '2026-04-25', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1136, '2026-04-21 18:44:38.273979', '2026-04-26', '17:30:00.000000', '08:30:00.000000', 'CLOSED', NULL, 27, b'0'),
(1137, '2026-04-21 18:44:38.274706', '2026-04-27', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.410594', 27, b'0'),
(1138, '2026-04-21 18:44:38.275525', '2026-04-28', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.411822', 27, b'0'),
(1139, '2026-04-21 18:44:38.276384', '2026-04-29', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.413190', 27, b'0'),
(1140, '2026-04-21 18:44:38.277339', '2026-04-30', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.414011', 27, b'0'),
(1141, '2026-04-21 18:44:38.278434', '2026-05-01', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.414844', 27, b'0'),
(1142, '2026-04-21 18:44:38.279466', '2026-05-02', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.415758', 27, b'0'),
(1143, '2026-04-21 18:44:38.280375', '2026-05-03', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2026-04-27 01:23:02.416629', 27, b'0'),
(1144, '2026-04-21 18:44:38.281308', '2026-05-04', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.417505', 27, b'0'),
(1145, '2026-04-21 18:44:38.282241', '2026-05-05', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.418379', 27, b'0'),
(1146, '2026-04-21 18:44:38.283025', '2026-05-06', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.419196', 27, b'0'),
(1147, '2026-04-21 18:44:38.284243', '2026-05-07', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.420117', 27, b'0'),
(1148, '2026-04-21 18:44:38.285146', '2026-05-08', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.421044', 27, b'0'),
(1149, '2026-04-21 18:44:38.286108', '2026-05-09', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.421971', 27, b'0'),
(1150, '2026-04-21 18:44:38.287301', '2026-05-10', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2026-04-27 01:23:02.422722', 27, b'0'),
(1151, '2026-04-21 18:44:38.288365', '2026-05-11', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.423581', 27, b'0'),
(1152, '2026-04-21 18:44:38.289213', '2026-05-12', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.424424', 27, b'0'),
(1153, '2026-04-21 18:44:38.290008', '2026-05-13', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.425181', 27, b'0'),
(1154, '2026-04-21 18:44:38.290747', '2026-05-14', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.425867', 27, b'0'),
(1155, '2026-04-21 18:44:38.291572', '2026-05-15', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.426689', 27, b'0'),
(1156, '2026-04-21 18:44:38.292482', '2026-05-16', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.427450', 27, b'0'),
(1157, '2026-04-21 18:44:38.293218', '2026-05-17', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2026-04-27 01:23:02.428631', 27, b'0'),
(1158, '2026-04-21 18:44:38.293981', '2026-05-18', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.429817', 27, b'0'),
(1159, '2026-04-21 18:44:38.294819', '2026-05-19', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.430505', 27, b'0'),
(1160, '2026-04-21 18:44:38.295604', '2026-05-20', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.431269', 27, b'0'),
(1161, '2026-04-21 18:44:38.296478', '2026-05-21', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.432148', 27, b'0'),
(1162, '2026-04-21 18:44:38.298400', '2026-04-21', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1163, '2026-04-21 18:44:38.299386', '2026-04-22', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1164, '2026-04-21 18:44:38.300342', '2026-04-23', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1165, '2026-04-21 18:44:38.301181', '2026-04-24', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1166, '2026-04-21 18:44:38.301962', '2026-04-25', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1167, '2026-04-21 18:44:38.302710', '2026-04-26', '18:30:00.000000', '09:00:00.000000', 'CLOSED', NULL, 19, b'0'),
(1168, '2026-04-21 18:44:38.303435', '2026-04-27', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.161949', 19, b'0'),
(1169, '2026-04-21 18:44:38.304629', '2026-04-28', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.440936', 19, b'0'),
(1170, '2026-04-21 18:44:38.305930', '2026-04-29', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.441951', 19, b'0'),
(1171, '2026-04-21 18:44:38.307072', '2026-04-30', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.442760', 19, b'0'),
(1172, '2026-04-21 18:44:38.308661', '2026-05-01', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.443714', 19, b'0'),
(1173, '2026-04-21 18:44:38.309494', '2026-05-02', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.444876', 19, b'0'),
(1174, '2026-04-21 18:44:38.310232', '2026-05-03', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.445694', 19, b'0'),
(1175, '2026-04-21 18:44:38.311014', '2026-05-04', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.161949', 19, b'0'),
(1176, '2026-04-21 18:44:38.311753', '2026-05-05', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.447314', 19, b'0'),
(1177, '2026-04-21 18:44:38.312927', '2026-05-06', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.448269', 19, b'0'),
(1178, '2026-04-21 18:44:38.314157', '2026-05-07', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.449148', 19, b'0'),
(1179, '2026-04-21 18:44:38.315063', '2026-05-08', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.450028', 19, b'0'),
(1180, '2026-04-21 18:44:38.316094', '2026-05-09', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.450929', 19, b'0'),
(1181, '2026-04-21 18:44:38.316820', '2026-05-10', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.451872', 19, b'0'),
(1182, '2026-04-21 18:44:38.317822', '2026-05-11', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.161949', 19, b'0'),
(1183, '2026-04-21 18:44:38.318944', '2026-05-12', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.453552', 19, b'0'),
(1184, '2026-04-21 18:44:38.320160', '2026-05-13', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.454719', 19, b'0'),
(1185, '2026-04-21 18:44:38.320908', '2026-05-14', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.455883', 19, b'0'),
(1186, '2026-04-21 18:44:38.321794', '2026-05-15', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.456754', 19, b'0'),
(1187, '2026-04-21 18:44:38.322754', '2026-05-16', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.457989', 19, b'0'),
(1188, '2026-04-21 18:44:38.323688', '2026-05-17', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.458787', 19, b'0'),
(1189, '2026-04-21 18:44:38.324754', '2026-05-18', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.161949', 19, b'0'),
(1190, '2026-04-21 18:44:38.325528', '2026-05-19', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.460539', 19, b'0'),
(1191, '2026-04-21 18:44:38.326711', '2026-05-20', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.461473', 19, b'0'),
(1192, '2026-04-21 18:44:38.327505', '2026-05-21', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.462610', 19, b'0'),
(1193, '2026-04-21 18:44:38.328296', '2026-04-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1194, '2026-04-21 18:44:38.329026', '2026-04-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1195, '2026-04-21 18:44:38.329914', '2026-04-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1196, '2026-04-21 18:44:38.330777', '2026-04-24', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1197, '2026-04-21 18:44:38.331876', '2026-04-25', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1198, '2026-04-21 18:44:38.333126', '2026-04-26', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 28, b'0'),
(1199, '2026-04-21 18:44:38.334006', '2026-04-27', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.469776', 28, b'0'),
(1200, '2026-04-21 18:44:38.334676', '2026-04-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.470694', 28, b'0'),
(1201, '2026-04-21 18:44:38.335457', '2026-04-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.471777', 28, b'0'),
(1202, '2026-04-21 18:44:38.336252', '2026-04-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.472904', 28, b'0'),
(1203, '2026-04-21 18:44:38.336956', '2026-05-01', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.473971', 28, b'0'),
(1204, '2026-04-21 18:44:38.337822', '2026-05-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.475150', 28, b'0'),
(1205, '2026-04-21 18:44:38.338583', '2026-05-03', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.476512', 28, b'0'),
(1206, '2026-04-21 18:44:38.339391', '2026-05-04', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.477343', 28, b'0'),
(1207, '2026-04-21 18:44:38.340410', '2026-05-05', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.478386', 28, b'0'),
(1208, '2026-04-21 18:44:38.341221', '2026-05-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.479367', 28, b'0'),
(1209, '2026-04-21 18:44:38.342122', '2026-05-07', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.480409', 28, b'0'),
(1210, '2026-04-21 18:44:38.343090', '2026-05-08', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.481488', 28, b'0'),
(1211, '2026-04-21 18:44:38.343828', '2026-05-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.482528', 28, b'0'),
(1212, '2026-04-21 18:44:38.344743', '2026-05-10', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.483496', 28, b'0'),
(1213, '2026-04-21 18:44:38.345664', '2026-05-11', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.484650', 28, b'0'),
(1214, '2026-04-21 18:44:38.346713', '2026-05-12', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.485673', 28, b'0'),
(1215, '2026-04-21 18:44:38.347626', '2026-05-13', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.486906', 28, b'0'),
(1216, '2026-04-21 18:44:38.348493', '2026-05-14', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.488112', 28, b'0'),
(1217, '2026-04-21 18:44:38.349304', '2026-05-15', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.489310', 28, b'0'),
(1218, '2026-04-21 18:44:38.350135', '2026-05-16', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.490225', 28, b'0'),
(1219, '2026-04-21 18:44:38.350964', '2026-05-17', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.491395', 28, b'0'),
(1220, '2026-04-21 18:44:38.351745', '2026-05-18', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.493564', 28, b'0'),
(1221, '2026-04-21 18:44:38.352571', '2026-05-19', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.494533', 28, b'0'),
(1222, '2026-04-21 18:44:38.353359', '2026-05-20', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.495686', 28, b'0'),
(1223, '2026-04-21 18:44:38.354197', '2026-05-21', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.496887', 28, b'0'),
(1224, '2026-04-21 18:44:38.355904', '2026-04-21', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.164300', 20, b'0'),
(1225, '2026-04-21 18:44:38.356805', '2026-04-22', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1226, '2026-04-21 18:44:38.357617', '2026-04-23', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1227, '2026-04-21 18:44:38.358700', '2026-04-24', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1228, '2026-04-21 18:44:38.359473', '2026-04-25', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1229, '2026-04-21 18:44:38.360356', '2026-04-26', '23:30:00.000000', '15:00:00.000000', 'CLOSED', NULL, 20, b'0'),
(1230, '2026-04-21 18:44:38.361234', '2026-04-27', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.163651', 20, b'0'),
(1231, '2026-04-21 18:44:38.362029', '2026-04-28', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.164300', 20, b'0'),
(1232, '2026-04-21 18:44:38.362754', '2026-04-29', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.507474', 20, b'0'),
(1233, '2026-04-21 18:44:38.363528', '2026-04-30', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.508954', 20, b'0'),
(1234, '2026-04-21 18:44:38.364429', '2026-05-01', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.510349', 20, b'0');
INSERT INTO `staff_availabilities` (`id`, `created_at`, `date`, `end_time`, `start_time`, `status`, `updated_at`, `staff_id`, `user_edited`) VALUES
(1235, '2026-04-21 18:44:38.365277', '2026-05-02', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.511340', 20, b'0'),
(1236, '2026-04-21 18:44:38.366461', '2026-05-03', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.512566', 20, b'0'),
(1237, '2026-04-21 18:44:38.367645', '2026-05-04', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.163651', 20, b'0'),
(1238, '2026-04-21 18:44:38.368597', '2026-05-05', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.164300', 20, b'0'),
(1239, '2026-04-21 18:44:38.369474', '2026-05-06', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.515425', 20, b'0'),
(1240, '2026-04-21 18:44:38.370404', '2026-05-07', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.516547', 20, b'0'),
(1241, '2026-04-21 18:44:38.371713', '2026-05-08', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.517724', 20, b'0'),
(1242, '2026-04-21 18:44:38.372570', '2026-05-09', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.519031', 20, b'0'),
(1243, '2026-04-21 18:44:38.373362', '2026-05-10', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.520281', 20, b'0'),
(1244, '2026-04-21 18:44:38.374200', '2026-05-11', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.163651', 20, b'0'),
(1245, '2026-04-21 18:44:38.375433', '2026-05-12', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.164300', 20, b'0'),
(1246, '2026-04-21 18:44:38.376311', '2026-05-13', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.523310', 20, b'0'),
(1247, '2026-04-21 18:44:38.377190', '2026-05-14', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.524589', 20, b'0'),
(1248, '2026-04-21 18:44:38.377998', '2026-05-15', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.525980', 20, b'0'),
(1249, '2026-04-21 18:44:38.378876', '2026-05-16', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.527262', 20, b'0'),
(1250, '2026-04-21 18:44:38.379657', '2026-05-17', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.528510', 20, b'0'),
(1251, '2026-04-21 18:44:38.380406', '2026-05-18', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-21 20:00:00.163651', 20, b'0'),
(1252, '2026-04-21 18:44:38.381210', '2026-05-19', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-21 20:00:00.164300', 20, b'0'),
(1253, '2026-04-21 18:44:38.382467', '2026-05-20', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.531461', 20, b'0'),
(1254, '2026-04-21 18:44:38.383471', '2026-05-21', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.532599', 20, b'0'),
(1255, '2026-04-21 18:44:38.385965', '2026-04-21', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1256, '2026-04-21 18:44:38.386988', '2026-04-22', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1257, '2026-04-21 18:44:38.387818', '2026-04-23', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1258, '2026-04-21 18:44:38.388579', '2026-04-24', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(1259, '2026-04-21 18:44:38.389304', '2026-04-25', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1260, '2026-04-21 18:44:38.390009', '2026-04-26', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(1261, '2026-04-21 18:44:38.390785', '2026-04-27', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.543028', 21, b'0'),
(1262, '2026-04-21 18:44:38.391558', '2026-04-28', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.544914', 21, b'0'),
(1263, '2026-04-21 18:44:38.392306', '2026-04-29', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.545971', 21, b'0'),
(1264, '2026-04-21 18:44:38.393092', '2026-04-30', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.546849', 21, b'0'),
(1265, '2026-04-21 18:44:38.393843', '2026-05-01', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.547706', 21, b'0'),
(1266, '2026-04-21 18:44:38.394586', '2026-05-02', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.548952', 21, b'0'),
(1267, '2026-04-21 18:44:38.395896', '2026-05-03', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.550168', 21, b'0'),
(1268, '2026-04-21 18:44:38.396633', '2026-05-04', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.551378', 21, b'0'),
(1269, '2026-04-21 18:44:38.397483', '2026-05-05', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.553048', 21, b'0'),
(1270, '2026-04-21 18:44:38.398558', '2026-05-06', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.553873', 21, b'0'),
(1271, '2026-04-21 18:44:38.399660', '2026-05-07', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.554631', 21, b'0'),
(1272, '2026-04-21 18:44:38.400599', '2026-05-08', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.555854', 21, b'0'),
(1273, '2026-04-21 18:44:38.401351', '2026-05-09', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.556975', 21, b'0'),
(1274, '2026-04-21 18:44:38.402230', '2026-05-10', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.558217', 21, b'0'),
(1275, '2026-04-21 18:44:38.403000', '2026-05-11', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.559555', 21, b'0'),
(1276, '2026-04-21 18:44:38.403853', '2026-05-12', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.560741', 21, b'0'),
(1277, '2026-04-21 18:44:38.404663', '2026-05-13', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.561759', 21, b'0'),
(1278, '2026-04-21 18:44:38.405551', '2026-05-14', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.562846', 21, b'0'),
(1279, '2026-04-21 18:44:38.406404', '2026-05-15', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.564003', 21, b'0'),
(1280, '2026-04-21 18:44:38.407242', '2026-05-16', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.564951', 21, b'0'),
(1281, '2026-04-21 18:44:38.407987', '2026-05-17', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.566157', 21, b'0'),
(1282, '2026-04-21 18:44:38.408954', '2026-05-18', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.567488', 21, b'0'),
(1283, '2026-04-21 18:44:38.409735', '2026-05-19', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.568292', 21, b'0'),
(1284, '2026-04-21 18:44:38.410424', '2026-05-20', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.569415', 21, b'0'),
(1285, '2026-04-21 18:44:38.411420', '2026-05-21', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.570614', 21, b'0'),
(1286, '2026-04-21 18:44:38.412242', '2026-04-21', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1287, '2026-04-21 18:44:38.412961', '2026-04-22', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1288, '2026-04-21 18:44:38.413698', '2026-04-23', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1289, '2026-04-21 18:44:38.414415', '2026-04-24', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(1290, '2026-04-21 18:44:38.415139', '2026-04-25', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1291, '2026-04-21 18:44:38.416030', '2026-04-26', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(1292, '2026-04-21 18:44:38.416848', '2026-04-27', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.578024', 29, b'0'),
(1293, '2026-04-21 18:44:38.417538', '2026-04-28', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.579462', 29, b'0'),
(1294, '2026-04-21 18:44:38.418226', '2026-04-29', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.580303', 29, b'0'),
(1295, '2026-04-21 18:44:38.419001', '2026-04-30', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.581565', 29, b'0'),
(1296, '2026-04-21 18:44:38.419735', '2026-05-01', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.582684', 29, b'0'),
(1297, '2026-04-21 18:44:38.420478', '2026-05-02', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.583882', 29, b'0'),
(1298, '2026-04-21 18:44:38.421324', '2026-05-03', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.585056', 29, b'0'),
(1299, '2026-04-21 18:44:38.422108', '2026-05-04', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.585982', 29, b'0'),
(1300, '2026-04-21 18:44:38.423125', '2026-05-05', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.586819', 29, b'0'),
(1301, '2026-04-21 18:44:38.423906', '2026-05-06', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.588189', 29, b'0'),
(1302, '2026-04-21 18:44:38.424664', '2026-05-07', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.589159', 29, b'0'),
(1303, '2026-04-21 18:44:38.425423', '2026-05-08', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.590378', 29, b'0'),
(1304, '2026-04-21 18:44:38.426207', '2026-05-09', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.591596', 29, b'0'),
(1305, '2026-04-21 18:44:38.426929', '2026-05-10', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.592611', 29, b'0'),
(1306, '2026-04-21 18:44:38.427724', '2026-05-11', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.593543', 29, b'0'),
(1307, '2026-04-21 18:44:38.428528', '2026-05-12', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.594835', 29, b'0'),
(1308, '2026-04-21 18:44:38.429270', '2026-05-13', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.596336', 29, b'0'),
(1309, '2026-04-21 18:44:38.430000', '2026-05-14', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.597172', 29, b'0'),
(1310, '2026-04-21 18:44:38.430699', '2026-05-15', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.598229', 29, b'0'),
(1311, '2026-04-21 18:44:38.431411', '2026-05-16', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.599495', 29, b'0'),
(1312, '2026-04-21 18:44:38.432157', '2026-05-17', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.600285', 29, b'0'),
(1313, '2026-04-21 18:44:38.432906', '2026-05-18', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.601223', 29, b'0'),
(1314, '2026-04-21 18:44:38.433684', '2026-05-19', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.602424', 29, b'0'),
(1315, '2026-04-21 18:44:38.434391', '2026-05-20', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.603918', 29, b'0'),
(1316, '2026-04-21 18:44:38.435477', '2026-05-21', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.604856', 29, b'0'),
(1317, '2026-04-21 18:44:38.437169', '2026-04-21', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1318, '2026-04-21 18:44:38.438537', '2026-04-22', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1319, '2026-04-21 18:44:38.439570', '2026-04-23', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1320, '2026-04-21 18:44:38.440441', '2026-04-24', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1321, '2026-04-21 18:44:38.441268', '2026-04-25', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1322, '2026-04-21 18:44:38.441965', '2026-04-26', '23:00:00.000000', '16:00:00.000000', 'CLOSED', NULL, 22, b'0'),
(1323, '2026-04-21 18:44:38.442707', '2026-04-27', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.614412', 22, b'0'),
(1324, '2026-04-21 18:44:38.443401', '2026-04-28', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.615462', 22, b'0'),
(1325, '2026-04-21 18:44:38.444108', '2026-04-29', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.616450', 22, b'0'),
(1326, '2026-04-21 18:44:38.444837', '2026-04-30', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.617998', 22, b'0'),
(1327, '2026-04-21 18:44:38.445597', '2026-05-01', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.619436', 22, b'0'),
(1328, '2026-04-21 18:44:38.446316', '2026-05-02', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.620684', 22, b'0'),
(1329, '2026-04-21 18:44:38.447043', '2026-05-03', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.622432', 22, b'0'),
(1330, '2026-04-21 18:44:38.447811', '2026-05-04', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.623813', 22, b'0'),
(1331, '2026-04-21 18:44:38.448599', '2026-05-05', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.624766', 22, b'0'),
(1332, '2026-04-21 18:44:38.449281', '2026-05-06', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.626323', 22, b'0'),
(1333, '2026-04-21 18:44:38.450131', '2026-05-07', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.627795', 22, b'0'),
(1334, '2026-04-21 18:44:38.450852', '2026-05-08', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.629404', 22, b'0'),
(1335, '2026-04-21 18:44:38.451849', '2026-05-09', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.631000', 22, b'0'),
(1336, '2026-04-21 18:44:38.453053', '2026-05-10', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.632194', 22, b'0'),
(1337, '2026-04-21 18:44:38.453930', '2026-05-11', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.633037', 22, b'0'),
(1338, '2026-04-21 18:44:38.454715', '2026-05-12', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.634341', 22, b'0'),
(1339, '2026-04-21 18:44:38.455472', '2026-05-13', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.635561', 22, b'0'),
(1340, '2026-04-21 18:44:38.456251', '2026-05-14', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.636965', 22, b'0'),
(1341, '2026-04-21 18:44:38.457076', '2026-05-15', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.638254', 22, b'0'),
(1342, '2026-04-21 18:44:38.457827', '2026-05-16', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.639521', 22, b'0'),
(1343, '2026-04-21 18:44:38.458577', '2026-05-17', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.640578', 22, b'0'),
(1344, '2026-04-21 18:44:38.459382', '2026-05-18', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.641423', 22, b'0'),
(1345, '2026-04-21 18:44:38.460159', '2026-05-19', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.642892', 22, b'0'),
(1346, '2026-04-21 18:44:38.460979', '2026-05-20', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.644170', 22, b'0'),
(1347, '2026-04-21 18:44:38.461739', '2026-05-21', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.645049', 22, b'0'),
(1348, '2026-04-21 18:44:38.463277', '2026-04-21', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1349, '2026-04-21 18:44:38.464021', '2026-04-22', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1350, '2026-04-21 18:44:38.464902', '2026-04-23', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1351, '2026-04-21 18:44:38.465767', '2026-04-24', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1352, '2026-04-21 18:44:38.466777', '2026-04-25', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1353, '2026-04-21 18:44:38.467590', '2026-04-26', '19:00:00.000000', '10:00:00.000000', 'CLOSED', NULL, 23, b'0'),
(1354, '2026-04-21 18:44:38.468435', '2026-04-27', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.655166', 23, b'0'),
(1355, '2026-04-21 18:44:38.469211', '2026-04-28', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.656648', 23, b'0'),
(1356, '2026-04-21 18:44:38.470043', '2026-04-29', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.657516', 23, b'0'),
(1357, '2026-04-21 18:44:38.470773', '2026-04-30', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.658996', 23, b'0'),
(1358, '2026-04-21 18:44:38.471517', '2026-05-01', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.660327', 23, b'0'),
(1359, '2026-04-21 18:44:38.472287', '2026-05-02', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.661246', 23, b'0'),
(1360, '2026-04-21 18:44:38.473062', '2026-05-03', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.662407', 23, b'0'),
(1361, '2026-04-21 18:44:38.473795', '2026-05-04', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.663718', 23, b'0'),
(1362, '2026-04-21 18:44:38.474533', '2026-05-05', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.664870', 23, b'0'),
(1363, '2026-04-21 18:44:38.475492', '2026-05-06', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.666135', 23, b'0'),
(1364, '2026-04-21 18:44:38.476248', '2026-05-07', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.667503', 23, b'0'),
(1365, '2026-04-21 18:44:38.476968', '2026-05-08', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.668892', 23, b'0'),
(1366, '2026-04-21 18:44:38.477701', '2026-05-09', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.670153', 23, b'0'),
(1367, '2026-04-21 18:44:38.478958', '2026-05-10', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.671531', 23, b'0'),
(1368, '2026-04-21 18:44:38.480033', '2026-05-11', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.672906', 23, b'0'),
(1369, '2026-04-21 18:44:38.480885', '2026-05-12', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.674204', 23, b'0'),
(1370, '2026-04-21 18:44:38.481715', '2026-05-13', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.675312', 23, b'0'),
(1371, '2026-04-21 18:44:38.482580', '2026-05-14', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.676751', 23, b'0'),
(1372, '2026-04-21 18:44:38.483425', '2026-05-15', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.678153', 23, b'0'),
(1373, '2026-04-21 18:44:38.484176', '2026-05-16', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.679565', 23, b'0'),
(1374, '2026-04-21 18:44:38.484915', '2026-05-17', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.680938', 23, b'0'),
(1375, '2026-04-21 18:44:38.485654', '2026-05-18', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.682330', 23, b'0'),
(1376, '2026-04-21 18:44:38.486416', '2026-05-19', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.683704', 23, b'0'),
(1377, '2026-04-21 18:44:38.487157', '2026-05-20', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.684608', 23, b'0'),
(1378, '2026-04-21 18:44:38.487924', '2026-05-21', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.686025', 23, b'0'),
(1379, '2026-04-21 18:44:38.489798', '2026-04-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1380, '2026-04-21 18:44:38.490623', '2026-04-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1381, '2026-04-21 18:44:38.492121', '2026-04-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1382, '2026-04-21 18:44:38.492963', '2026-04-24', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1383, '2026-04-21 18:44:38.493765', '2026-04-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1384, '2026-04-21 18:44:38.494539', '2026-04-26', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 24, b'0'),
(1385, '2026-04-21 18:44:38.495302', '2026-04-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.695462', 24, b'0'),
(1386, '2026-04-21 18:44:38.496063', '2026-04-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.696910', 24, b'0'),
(1387, '2026-04-21 18:44:38.496865', '2026-04-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.698311', 24, b'0'),
(1388, '2026-04-21 18:44:38.497611', '2026-04-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.699624', 24, b'0'),
(1389, '2026-04-21 18:44:38.498414', '2026-05-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.700919', 24, b'0'),
(1390, '2026-04-21 18:44:38.499357', '2026-05-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.702277', 24, b'0'),
(1391, '2026-04-21 18:44:38.500323', '2026-05-03', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.703280', 24, b'0'),
(1392, '2026-04-21 18:44:38.501092', '2026-05-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.704218', 24, b'0'),
(1393, '2026-04-21 18:44:38.501840', '2026-05-05', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.705516', 24, b'0'),
(1394, '2026-04-21 18:44:38.502898', '2026-05-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.706843', 24, b'0'),
(1395, '2026-04-21 18:44:38.503730', '2026-05-07', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.708143', 24, b'0'),
(1396, '2026-04-21 18:44:38.504704', '2026-05-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.709493', 24, b'0'),
(1397, '2026-04-21 18:44:38.505821', '2026-05-09', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.710859', 24, b'0'),
(1398, '2026-04-21 18:44:38.506895', '2026-05-10', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.711917', 24, b'0'),
(1399, '2026-04-21 18:44:38.507702', '2026-05-11', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.713027', 24, b'0'),
(1400, '2026-04-21 18:44:38.508578', '2026-05-12', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.714153', 24, b'0'),
(1401, '2026-04-21 18:44:38.509473', '2026-05-13', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.715465', 24, b'0'),
(1402, '2026-04-21 18:44:38.510323', '2026-05-14', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.716732', 24, b'0'),
(1403, '2026-04-21 18:44:38.511182', '2026-05-15', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.718129', 24, b'0'),
(1404, '2026-04-21 18:44:38.512057', '2026-05-16', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.719686', 24, b'0'),
(1405, '2026-04-21 18:44:38.513071', '2026-05-17', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.721053', 24, b'0'),
(1406, '2026-04-21 18:44:38.514124', '2026-05-18', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.722395', 24, b'0'),
(1407, '2026-04-21 18:44:38.515049', '2026-05-19', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.723564', 24, b'0'),
(1408, '2026-04-21 18:44:38.515975', '2026-05-20', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.725020', 24, b'0'),
(1409, '2026-04-21 18:44:38.516882', '2026-05-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.726340', 24, b'0'),
(1410, '2026-04-21 18:44:38.518641', '2026-04-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(1411, '2026-04-21 18:44:38.519810', '2026-04-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(1412, '2026-04-21 18:44:38.520888', '2026-04-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(1413, '2026-04-21 18:44:38.521708', '2026-04-24', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(1414, '2026-04-21 18:44:38.522589', '2026-04-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(1415, '2026-04-21 18:44:38.523398', '2026-04-26', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(1416, '2026-04-21 18:44:38.524200', '2026-04-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.736613', 25, b'0'),
(1417, '2026-04-21 18:44:38.525010', '2026-04-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.738065', 25, b'0'),
(1418, '2026-04-21 18:44:38.525839', '2026-04-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.739451', 25, b'0'),
(1419, '2026-04-21 18:44:38.526704', '2026-04-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.740809', 25, b'0'),
(1420, '2026-04-21 18:44:38.527514', '2026-05-01', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.742727', 25, b'0'),
(1421, '2026-04-21 18:44:38.528313', '2026-05-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.744426', 25, b'0'),
(1422, '2026-04-21 18:44:38.529110', '2026-05-03', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.746018', 25, b'0'),
(1423, '2026-04-21 18:44:38.530422', '2026-05-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.747242', 25, b'0'),
(1424, '2026-04-21 18:44:38.531719', '2026-05-05', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.748582', 25, b'0'),
(1425, '2026-04-21 18:44:38.532773', '2026-05-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.749937', 25, b'0'),
(1426, '2026-04-21 18:44:38.533805', '2026-05-07', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.751032', 25, b'0'),
(1427, '2026-04-21 18:44:38.534830', '2026-05-08', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.752177', 25, b'0'),
(1428, '2026-04-21 18:44:38.535912', '2026-05-09', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.753570', 25, b'0'),
(1429, '2026-04-21 18:44:38.536845', '2026-05-10', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.754974', 25, b'0'),
(1430, '2026-04-21 18:44:38.537657', '2026-05-11', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.756382', 25, b'0'),
(1431, '2026-04-21 18:44:38.538455', '2026-05-12', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.757729', 25, b'0'),
(1432, '2026-04-21 18:44:38.539225', '2026-05-13', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.759291', 25, b'0'),
(1433, '2026-04-21 18:44:38.540099', '2026-05-14', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.760675', 25, b'0'),
(1434, '2026-04-21 18:44:38.540912', '2026-05-15', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.761829', 25, b'0'),
(1435, '2026-04-21 18:44:38.541757', '2026-05-16', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.763196', 25, b'0'),
(1436, '2026-04-21 18:44:38.542560', '2026-05-17', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.764615', 25, b'0'),
(1437, '2026-04-21 18:44:38.543346', '2026-05-18', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.766020', 25, b'0'),
(1438, '2026-04-21 18:44:38.544119', '2026-05-19', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.767368', 25, b'0'),
(1439, '2026-04-21 18:44:38.545034', '2026-05-20', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.768732', 25, b'0'),
(1440, '2026-04-21 18:44:38.546198', '2026-05-21', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.770026', 25, b'0'),
(1472, '2026-04-26 21:57:53.802262', '2026-04-26', '17:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 1, b'0'),
(1473, '2026-04-26 21:57:53.810986', '2026-04-27', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.019495', 1, b'0'),
(1474, '2026-04-26 21:57:53.812750', '2026-04-28', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.029682', 1, b'0'),
(1475, '2026-04-26 21:57:53.814328', '2026-04-29', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.031618', 1, b'0'),
(1476, '2026-04-26 21:57:53.815801', '2026-04-30', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.033116', 1, b'0'),
(1477, '2026-04-26 21:57:53.817935', '2026-05-01', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.034888', 1, b'0'),
(1478, '2026-04-26 21:57:53.819743', '2026-05-02', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.036285', 1, b'0'),
(1479, '2026-04-26 21:57:53.821435', '2026-05-03', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.037408', 1, b'0'),
(1480, '2026-04-26 21:57:53.822902', '2026-05-04', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.038480', 1, b'0'),
(1481, '2026-04-26 21:57:53.824421', '2026-05-05', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.040107', 1, b'0'),
(1482, '2026-04-26 21:57:53.825673', '2026-05-06', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.042415', 1, b'0'),
(1483, '2026-04-26 21:57:53.827602', '2026-05-07', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.044295', 1, b'0'),
(1484, '2026-04-26 21:57:53.829084', '2026-05-08', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.045992', 1, b'0'),
(1485, '2026-04-26 21:57:53.830522', '2026-05-09', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.047576', 1, b'0'),
(1486, '2026-04-26 21:57:53.832085', '2026-05-10', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.049163', 1, b'0'),
(1487, '2026-04-26 21:57:53.833625', '2026-05-11', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.050625', 1, b'0'),
(1488, '2026-04-26 21:57:53.835037', '2026-05-12', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.052115', 1, b'0'),
(1489, '2026-04-26 21:57:53.836619', '2026-05-13', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.053971', 1, b'0'),
(1490, '2026-04-26 21:57:53.838128', '2026-05-14', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.055486', 1, b'0'),
(1491, '2026-04-26 21:57:53.839431', '2026-05-15', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.056993', 1, b'0'),
(1492, '2026-04-26 21:57:53.840995', '2026-05-16', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.058509', 1, b'0'),
(1493, '2026-04-26 21:57:53.842304', '2026-05-17', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.060079', 1, b'0'),
(1494, '2026-04-26 21:57:53.843989', '2026-05-18', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.061760', 1, b'0'),
(1495, '2026-04-26 21:57:53.845477', '2026-05-19', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.063236', 1, b'0'),
(1496, '2026-04-26 21:57:53.846906', '2026-05-20', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.064712', 1, b'0'),
(1497, '2026-04-26 21:57:53.848314', '2026-05-21', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.066228', 1, b'0'),
(1498, '2026-04-26 21:57:53.849730', '2026-05-22', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.067721', 1, b'0'),
(1499, '2026-04-26 21:57:53.851027', '2026-05-23', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.069312', 1, b'0'),
(1500, '2026-04-26 21:57:53.852094', '2026-05-24', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.070846', 1, b'0'),
(1501, '2026-04-26 21:57:53.853148', '2026-05-25', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 01:23:02.072366', 1, b'0'),
(1502, '2026-04-26 21:57:53.854136', '2026-05-26', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 01:23:02.074165', 1, b'0'),
(1503, '2026-04-27 01:23:02.076645', '2026-05-27', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.069816', 1, b'0'),
(1504, '2026-04-27 01:23:02.121098', '2026-05-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.125766', 2, b'0'),
(1505, '2026-04-27 01:23:02.123158', '2026-05-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.127054', 2, b'0'),
(1506, '2026-04-27 01:23:02.125700', '2026-05-24', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.128137', 2, b'0'),
(1507, '2026-04-27 01:23:02.128360', '2026-05-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.129160', 2, b'0'),
(1508, '2026-04-27 01:23:02.130121', '2026-05-26', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.130487', 2, b'0'),
(1509, '2026-04-27 01:23:02.131953', '2026-05-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.131673', 2, b'0'),
(1510, '2026-04-27 01:23:02.196569', '2026-05-22', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.155934', 5, b'0'),
(1511, '2026-04-27 01:23:02.198227', '2026-05-23', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.157074', 5, b'0'),
(1512, '2026-04-27 01:23:02.199704', '2026-05-24', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.158138', 5, b'0'),
(1513, '2026-04-27 01:23:02.201492', '2026-05-25', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.159203', 5, b'0'),
(1514, '2026-04-27 01:23:02.203595', '2026-05-26', '17:30:00.000000', '08:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.160164', 5, b'0'),
(1515, '2026-04-27 01:23:02.205680', '2026-05-27', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.161177', 5, b'0'),
(1516, '2026-04-27 01:23:02.267336', '2026-05-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.190693', 26, b'0'),
(1517, '2026-04-27 01:23:02.268856', '2026-05-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.191986', 26, b'0'),
(1518, '2026-04-27 01:23:02.270578', '2026-05-24', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.193265', 26, b'0'),
(1519, '2026-04-27 01:23:02.272494', '2026-05-25', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.194505', 26, b'0'),
(1520, '2026-04-27 01:23:02.273904', '2026-05-26', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.195542', 26, b'0'),
(1521, '2026-04-27 01:23:02.274971', '2026-05-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.196526', 26, b'0'),
(1522, '2026-04-27 01:23:02.306403', '2026-05-22', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.226937', 16, b'0'),
(1523, '2026-04-27 01:23:02.307527', '2026-05-23', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.228280', 16, b'0'),
(1524, '2026-04-27 01:23:02.309440', '2026-05-24', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.229451', 16, b'0'),
(1525, '2026-04-27 01:23:02.310462', '2026-05-25', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-04-27 03:00:00.004795', 16, b'0'),
(1526, '2026-04-27 01:23:02.311373', '2026-05-26', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.231667', 16, b'0'),
(1527, '2026-04-27 01:23:02.312465', '2026-05-27', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.232778', 16, b'0'),
(1528, '2026-04-27 01:23:02.343766', '2026-05-22', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.263833', 30, b'0'),
(1529, '2026-04-27 01:23:02.344753', '2026-05-23', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.264985', 30, b'0'),
(1530, '2026-04-27 01:23:02.345879', '2026-05-24', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.266611', 30, b'0'),
(1531, '2026-04-27 01:23:02.347089', '2026-05-25', '22:00:00.000000', '14:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.268134', 30, b'0'),
(1532, '2026-04-27 01:23:02.348495', '2026-05-26', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.269502', 30, b'0'),
(1533, '2026-04-27 01:23:02.349957', '2026-05-27', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.271045', 30, b'0'),
(1534, '2026-04-27 01:23:02.375420', '2026-05-22', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 03:00:00.007233', 17, b'0'),
(1535, '2026-04-27 01:23:02.376344', '2026-05-23', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.308228', 17, b'0'),
(1536, '2026-04-27 01:23:02.377178', '2026-05-24', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.311298', 17, b'0'),
(1537, '2026-04-27 01:23:02.378026', '2026-05-25', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.312779', 17, b'0'),
(1538, '2026-04-27 01:23:02.378765', '2026-05-26', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.314090', 17, b'0'),
(1539, '2026-04-27 01:23:02.379664', '2026-05-27', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.315629', 17, b'0'),
(1540, '2026-04-27 01:23:02.403587', '2026-05-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.373511', 18, b'0'),
(1541, '2026-04-27 01:23:02.404719', '2026-05-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.376026', 18, b'0'),
(1542, '2026-04-27 01:23:02.405617', '2026-05-24', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.377131', 18, b'0'),
(1543, '2026-04-27 01:23:02.406491', '2026-05-25', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-04-27 03:00:00.011292', 18, b'0'),
(1544, '2026-04-27 01:23:02.407649', '2026-05-26', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.379462', 18, b'0'),
(1545, '2026-04-27 01:23:02.408632', '2026-05-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.380635', 18, b'0'),
(1546, '2026-04-27 01:23:02.432844', '2026-05-22', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.411635', 27, b'0'),
(1547, '2026-04-27 01:23:02.433809', '2026-05-23', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.412715', 27, b'0'),
(1548, '2026-04-27 01:23:02.434694', '2026-05-24', '17:30:00.000000', '08:30:00.000000', 'CLOSED', '2026-05-09 01:00:00.414228', 27, b'0'),
(1549, '2026-04-27 01:23:02.435667', '2026-05-25', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.415587', 27, b'0'),
(1550, '2026-04-27 01:23:02.436796', '2026-05-26', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.416854', 27, b'0'),
(1551, '2026-04-27 01:23:02.437992', '2026-05-27', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.417700', 27, b'0'),
(1552, '2026-04-27 01:23:02.463581', '2026-05-22', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.441390', 19, b'0'),
(1553, '2026-04-27 01:23:02.464738', '2026-05-23', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.442469', 19, b'0'),
(1554, '2026-04-27 01:23:02.465644', '2026-05-24', '18:30:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.443296', 19, b'0'),
(1555, '2026-04-27 01:23:02.466551', '2026-05-25', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-04-27 03:00:00.015487', 19, b'0'),
(1556, '2026-04-27 01:23:02.467512', '2026-05-26', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.445001', 19, b'0'),
(1557, '2026-04-27 01:23:02.468518', '2026-05-27', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.445890', 19, b'0'),
(1558, '2026-04-27 01:23:02.497717', '2026-05-22', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.471721', 28, b'0'),
(1559, '2026-04-27 01:23:02.498805', '2026-05-23', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.472986', 28, b'0'),
(1560, '2026-04-27 01:23:02.499780', '2026-05-24', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.473885', 28, b'0'),
(1561, '2026-04-27 01:23:02.500844', '2026-05-25', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.475154', 28, b'0'),
(1562, '2026-04-27 01:23:02.501919', '2026-05-26', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.476468', 28, b'0'),
(1563, '2026-04-27 01:23:02.503200', '2026-05-27', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.478903', 28, b'0'),
(1564, '2026-04-27 01:23:02.533534', '2026-05-22', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.506945', 20, b'0'),
(1565, '2026-04-27 01:23:02.534819', '2026-05-23', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.508248', 20, b'0'),
(1566, '2026-04-27 01:23:02.536029', '2026-05-24', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.509661', 20, b'0'),
(1567, '2026-04-27 01:23:02.537311', '2026-05-25', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-04-27 03:00:00.017840', 20, b'0'),
(1568, '2026-04-27 01:23:02.538906', '2026-05-26', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-04-27 03:00:00.019062', 20, b'0'),
(1569, '2026-04-27 01:23:02.540267', '2026-05-27', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.511906', 20, b'0'),
(1570, '2026-04-27 01:23:02.571346', '2026-05-22', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.538204', 21, b'0'),
(1571, '2026-04-27 01:23:02.572466', '2026-05-23', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.539184', 21, b'0'),
(1572, '2026-04-27 01:23:02.573465', '2026-05-24', '20:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.540103', 21, b'0'),
(1573, '2026-04-27 01:23:02.574279', '2026-05-25', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.540929', 21, b'0'),
(1574, '2026-04-27 01:23:02.575338', '2026-05-26', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.542148', 21, b'0'),
(1575, '2026-04-27 01:23:02.576355', '2026-05-27', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.543017', 21, b'0'),
(1576, '2026-04-27 01:23:02.605958', '2026-05-22', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.567287', 29, b'0'),
(1577, '2026-04-27 01:23:02.607272', '2026-05-23', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.568481', 29, b'0'),
(1578, '2026-04-27 01:23:02.608411', '2026-05-24', '16:00:00.000000', '07:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.569332', 29, b'0'),
(1579, '2026-04-27 01:23:02.609803', '2026-05-25', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.570192', 29, b'0'),
(1580, '2026-04-27 01:23:02.611040', '2026-05-26', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.571043', 29, b'0'),
(1581, '2026-04-27 01:23:02.611938', '2026-05-27', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.571953', 29, b'0'),
(1582, '2026-04-27 01:23:02.645883', '2026-05-22', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.595374', 22, b'0'),
(1583, '2026-04-27 01:23:02.647839', '2026-05-23', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.596299', 22, b'0'),
(1584, '2026-04-27 01:23:02.648984', '2026-05-24', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.597217', 22, b'0'),
(1585, '2026-04-27 01:23:02.650284', '2026-05-25', '23:00:00.000000', '16:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.598546', 22, b'0'),
(1586, '2026-04-27 01:23:02.651530', '2026-05-26', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.599964', 22, b'0'),
(1587, '2026-04-27 01:23:02.652471', '2026-05-27', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.600779', 22, b'0'),
(1588, '2026-04-27 01:23:02.686669', '2026-05-22', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.624232', 23, b'0'),
(1589, '2026-04-27 01:23:02.687640', '2026-05-23', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.625130', 23, b'0'),
(1590, '2026-04-27 01:23:02.688987', '2026-05-24', '19:00:00.000000', '10:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.626092', 23, b'0'),
(1591, '2026-04-27 01:23:02.690040', '2026-05-25', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.626975', 23, b'0'),
(1592, '2026-04-27 01:23:02.690948', '2026-05-26', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.627872', 23, b'0'),
(1593, '2026-04-27 01:23:02.692464', '2026-05-27', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.628788', 23, b'0'),
(1594, '2026-04-27 01:23:02.726989', '2026-05-22', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.653063', 24, b'0'),
(1595, '2026-04-27 01:23:02.728263', '2026-05-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.654297', 24, b'0'),
(1596, '2026-04-27 01:23:02.729649', '2026-05-24', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.655540', 24, b'0'),
(1597, '2026-04-27 01:23:02.730770', '2026-05-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.656590', 24, b'0'),
(1598, '2026-04-27 01:23:02.731887', '2026-05-26', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.657726', 24, b'0'),
(1599, '2026-04-27 01:23:02.733099', '2026-05-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.658710', 24, b'0'),
(1600, '2026-04-27 01:23:02.770892', '2026-05-22', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.686811', 25, b'0'),
(1601, '2026-04-27 01:23:02.772328', '2026-05-23', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.688418', 25, b'0'),
(1602, '2026-04-27 01:23:02.773864', '2026-05-24', '17:00:00.000000', '08:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.689726', 25, b'0'),
(1603, '2026-04-27 01:23:02.775412', '2026-05-25', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.690884', 25, b'0'),
(1604, '2026-04-27 01:23:02.776762', '2026-05-26', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.692193', 25, b'0'),
(1605, '2026-04-27 01:23:02.778088', '2026-05-27', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.693598', 25, b'0'),
(1727, '2026-05-08 22:51:40.058717', '2026-05-08', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 33, b'0'),
(1728, '2026-05-08 22:51:40.071809', '2026-05-09', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.715782', 33, b'0'),
(1729, '2026-05-08 22:51:40.073527', '2026-05-10', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.716922', 33, b'0'),
(1730, '2026-05-08 22:51:40.075596', '2026-05-11', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.718009', 33, b'0'),
(1731, '2026-05-08 22:51:40.078558', '2026-05-12', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.719285', 33, b'0'),
(1732, '2026-05-08 22:51:40.080168', '2026-05-13', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.720363', 33, b'0'),
(1733, '2026-05-08 22:51:40.081526', '2026-05-14', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.721284', 33, b'0'),
(1734, '2026-05-08 22:51:40.082872', '2026-05-15', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.722447', 33, b'0'),
(1735, '2026-05-08 22:51:40.096412', '2026-05-16', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.723576', 33, b'0'),
(1736, '2026-05-08 22:51:40.098951', '2026-05-17', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.724617', 33, b'0'),
(1737, '2026-05-08 22:51:40.100895', '2026-05-18', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.725914', 33, b'0'),
(1738, '2026-05-08 22:51:40.102671', '2026-05-19', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.726914', 33, b'0'),
(1739, '2026-05-08 22:51:40.104036', '2026-05-20', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.727924', 33, b'0'),
(1740, '2026-05-08 22:51:40.105171', '2026-05-21', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.728856', 33, b'0'),
(1741, '2026-05-08 22:51:40.106337', '2026-05-22', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.729903', 33, b'0'),
(1742, '2026-05-08 22:51:40.107510', '2026-05-23', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.730985', 33, b'0'),
(1743, '2026-05-08 22:51:40.109002', '2026-05-24', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.732278', 33, b'0'),
(1744, '2026-05-08 22:51:40.111230', '2026-05-25', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.733399', 33, b'0'),
(1745, '2026-05-08 22:51:40.112645', '2026-05-26', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.734666', 33, b'0'),
(1746, '2026-05-08 22:51:40.113900', '2026-05-27', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.735744', 33, b'0'),
(1747, '2026-05-08 22:51:40.115118', '2026-05-28', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.736736', 33, b'0'),
(1748, '2026-05-08 22:51:40.116463', '2026-05-29', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.737568', 33, b'0');
INSERT INTO `staff_availabilities` (`id`, `created_at`, `date`, `end_time`, `start_time`, `status`, `updated_at`, `staff_id`, `user_edited`) VALUES
(1749, '2026-05-08 22:51:40.117487', '2026-05-30', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.738548', 33, b'0'),
(1750, '2026-05-08 22:51:40.118543', '2026-05-31', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.740468', 33, b'0'),
(1751, '2026-05-08 22:51:40.127744', '2026-06-01', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.741897', 33, b'0'),
(1752, '2026-05-08 22:51:40.129483', '2026-06-02', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.743070', 33, b'0'),
(1753, '2026-05-08 22:51:40.131094', '2026-06-03', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.744138', 33, b'0'),
(1754, '2026-05-08 22:51:40.132214', '2026-06-04', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.745101', 33, b'0'),
(1755, '2026-05-08 22:51:40.133219', '2026-06-05', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.746050', 33, b'0'),
(1756, '2026-05-08 22:51:40.134506', '2026-06-06', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.747249', 33, b'0'),
(1757, '2026-05-08 22:51:40.135538', '2026-06-07', '17:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 01:00:00.748515', 33, b'0'),
(1758, '2026-05-08 22:51:40.136663', '2026-06-08', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 01:00:00.750086', 33, b'0'),
(1781, '2026-05-09 01:00:00.101255', '2026-05-28', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1782, '2026-05-09 01:00:00.104365', '2026-05-29', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1783, '2026-05-09 01:00:00.105862', '2026-05-30', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1784, '2026-05-09 01:00:00.107066', '2026-05-31', '17:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 1, b'0'),
(1785, '2026-05-09 01:00:00.108228', '2026-06-01', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1786, '2026-05-09 01:00:00.109495', '2026-06-02', '17:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 1, b'0'),
(1787, '2026-05-09 01:00:00.110671', '2026-06-03', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1788, '2026-05-09 01:00:00.111663', '2026-06-04', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1789, '2026-05-09 01:00:00.112658', '2026-06-05', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1790, '2026-05-09 01:00:00.113712', '2026-06-06', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1791, '2026-05-09 01:00:00.114721', '2026-06-07', '17:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 1, b'0'),
(1792, '2026-05-09 01:00:00.115909', '2026-06-08', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 1, b'0'),
(1793, '2026-05-09 01:00:00.116888', '2026-06-09', '17:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 1, b'0'),
(1794, '2026-05-09 01:00:00.132560', '2026-05-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1795, '2026-05-09 01:00:00.134023', '2026-05-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1796, '2026-05-09 01:00:00.135005', '2026-05-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1797, '2026-05-09 01:00:00.136033', '2026-05-31', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(1798, '2026-05-09 01:00:00.137098', '2026-06-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1799, '2026-05-09 01:00:00.138184', '2026-06-02', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(1800, '2026-05-09 01:00:00.139291', '2026-06-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1801, '2026-05-09 01:00:00.140268', '2026-06-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1802, '2026-05-09 01:00:00.141448', '2026-06-05', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1803, '2026-05-09 01:00:00.142443', '2026-06-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1804, '2026-05-09 01:00:00.143705', '2026-06-07', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(1805, '2026-05-09 01:00:00.144674', '2026-06-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 2, b'0'),
(1806, '2026-05-09 01:00:00.145770', '2026-06-09', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 2, b'0'),
(1807, '2026-05-09 01:00:00.162064', '2026-05-28', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1808, '2026-05-09 01:00:00.163210', '2026-05-29', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1809, '2026-05-09 01:00:00.164743', '2026-05-30', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1810, '2026-05-09 01:00:00.166019', '2026-05-31', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(1811, '2026-05-09 01:00:00.167126', '2026-06-01', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1812, '2026-05-09 01:00:00.168148', '2026-06-02', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(1813, '2026-05-09 01:00:00.169164', '2026-06-03', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1814, '2026-05-09 01:00:00.170623', '2026-06-04', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1815, '2026-05-09 01:00:00.171632', '2026-06-05', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1816, '2026-05-09 01:00:00.175070', '2026-06-06', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1817, '2026-05-09 01:00:00.176555', '2026-06-07', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(1818, '2026-05-09 01:00:00.177953', '2026-06-08', '17:30:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 5, b'0'),
(1819, '2026-05-09 01:00:00.179002', '2026-06-09', '17:30:00.000000', '08:00:00.000000', 'CLOSED', NULL, 5, b'0'),
(1820, '2026-05-09 01:00:00.197260', '2026-05-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1821, '2026-05-09 01:00:00.198885', '2026-05-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1822, '2026-05-09 01:00:00.200578', '2026-05-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1823, '2026-05-09 01:00:00.202023', '2026-05-31', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(1824, '2026-05-09 01:00:00.203039', '2026-06-01', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1825, '2026-05-09 01:00:00.204371', '2026-06-02', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(1826, '2026-05-09 01:00:00.205603', '2026-06-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1827, '2026-05-09 01:00:00.206727', '2026-06-04', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1828, '2026-05-09 01:00:00.207716', '2026-06-05', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1829, '2026-05-09 01:00:00.209114', '2026-06-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1830, '2026-05-09 01:00:00.210129', '2026-06-07', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(1831, '2026-05-09 01:00:00.211244', '2026-06-08', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 26, b'0'),
(1832, '2026-05-09 01:00:00.212486', '2026-06-09', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 26, b'0'),
(1833, '2026-05-09 01:00:00.233960', '2026-05-28', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1834, '2026-05-09 01:00:00.235055', '2026-05-29', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1835, '2026-05-09 01:00:00.236239', '2026-05-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1836, '2026-05-09 01:00:00.237721', '2026-05-31', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 16, b'0'),
(1837, '2026-05-09 01:00:00.238966', '2026-06-01', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 03:00:00.052826', 16, b'0'),
(1838, '2026-05-09 01:00:00.240108', '2026-06-02', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1839, '2026-05-09 01:00:00.242216', '2026-06-03', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1840, '2026-05-09 01:00:00.243491', '2026-06-04', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1841, '2026-05-09 01:00:00.244775', '2026-06-05', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1842, '2026-05-09 01:00:00.245866', '2026-06-06', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1843, '2026-05-09 01:00:00.247260', '2026-06-07', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 16, b'0'),
(1844, '2026-05-09 01:00:00.248929', '2026-06-08', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', '2026-05-09 03:00:00.052826', 16, b'0'),
(1845, '2026-05-09 01:00:00.250303', '2026-06-09', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 16, b'0'),
(1846, '2026-05-09 01:00:00.271812', '2026-05-28', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1847, '2026-05-09 01:00:00.273240', '2026-05-29', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1848, '2026-05-09 01:00:00.274768', '2026-05-30', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1849, '2026-05-09 01:00:00.275978', '2026-05-31', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 30, b'0'),
(1850, '2026-05-09 01:00:00.277095', '2026-06-01', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 30, b'0'),
(1851, '2026-05-09 01:00:00.278319', '2026-06-02', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1852, '2026-05-09 01:00:00.279435', '2026-06-03', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1853, '2026-05-09 01:00:00.281006', '2026-06-04', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1854, '2026-05-09 01:00:00.282581', '2026-06-05', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1855, '2026-05-09 01:00:00.284210', '2026-06-06', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1856, '2026-05-09 01:00:00.285789', '2026-06-07', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 30, b'0'),
(1857, '2026-05-09 01:00:00.287228', '2026-06-08', '22:00:00.000000', '14:00:00.000000', 'CLOSED', NULL, 30, b'0'),
(1858, '2026-05-09 01:00:00.288584', '2026-06-09', '22:00:00.000000', '14:00:00.000000', 'AVAILABLE', NULL, 30, b'0'),
(1859, '2026-05-09 01:00:00.318274', '2026-05-28', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1860, '2026-05-09 01:00:00.320617', '2026-05-29', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-05-09 03:00:00.056253', 17, b'0'),
(1861, '2026-05-09 01:00:00.325071', '2026-05-30', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1862, '2026-05-09 01:00:00.328896', '2026-05-31', '23:00:00.000000', '15:00:00.000000', 'CLOSED', NULL, 17, b'0'),
(1863, '2026-05-09 01:00:00.331044', '2026-06-01', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1864, '2026-05-09 01:00:00.332981', '2026-06-02', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1865, '2026-05-09 01:00:00.335094', '2026-06-03', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1866, '2026-05-09 01:00:00.337291', '2026-06-04', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1867, '2026-05-09 01:00:00.342362', '2026-06-05', '23:00:00.000000', '15:00:00.000000', 'CLOSED', '2026-05-09 03:00:00.056253', 17, b'0'),
(1868, '2026-05-09 01:00:00.345953', '2026-06-06', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1869, '2026-05-09 01:00:00.348216', '2026-06-07', '23:00:00.000000', '15:00:00.000000', 'CLOSED', NULL, 17, b'0'),
(1870, '2026-05-09 01:00:00.351533', '2026-06-08', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1871, '2026-05-09 01:00:00.355433', '2026-06-09', '23:00:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 17, b'0'),
(1872, '2026-05-09 01:00:00.382280', '2026-05-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1873, '2026-05-09 01:00:00.384901', '2026-05-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1874, '2026-05-09 01:00:00.387687', '2026-05-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1875, '2026-05-09 01:00:00.389615', '2026-05-31', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 18, b'0'),
(1876, '2026-05-09 01:00:00.391409', '2026-06-01', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 03:00:00.059080', 18, b'0'),
(1877, '2026-05-09 01:00:00.392788', '2026-06-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1878, '2026-05-09 01:00:00.393920', '2026-06-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1879, '2026-05-09 01:00:00.395133', '2026-06-04', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1880, '2026-05-09 01:00:00.396730', '2026-06-05', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1881, '2026-05-09 01:00:00.398095', '2026-06-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1882, '2026-05-09 01:00:00.399386', '2026-06-07', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 18, b'0'),
(1883, '2026-05-09 01:00:00.400695', '2026-06-08', '18:00:00.000000', '09:00:00.000000', 'CLOSED', '2026-05-09 03:00:00.059080', 18, b'0'),
(1884, '2026-05-09 01:00:00.401763', '2026-06-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 18, b'0'),
(1885, '2026-05-09 01:00:00.418287', '2026-05-28', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1886, '2026-05-09 01:00:00.419355', '2026-05-29', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1887, '2026-05-09 01:00:00.420485', '2026-05-30', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1888, '2026-05-09 01:00:00.421907', '2026-05-31', '17:30:00.000000', '08:30:00.000000', 'CLOSED', NULL, 27, b'0'),
(1889, '2026-05-09 01:00:00.422864', '2026-06-01', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1890, '2026-05-09 01:00:00.423722', '2026-06-02', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1891, '2026-05-09 01:00:00.424859', '2026-06-03', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1892, '2026-05-09 01:00:00.425742', '2026-06-04', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1893, '2026-05-09 01:00:00.426555', '2026-06-05', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1894, '2026-05-09 01:00:00.427510', '2026-06-06', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1895, '2026-05-09 01:00:00.428363', '2026-06-07', '17:30:00.000000', '08:30:00.000000', 'CLOSED', NULL, 27, b'0'),
(1896, '2026-05-09 01:00:00.429379', '2026-06-08', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1897, '2026-05-09 01:00:00.430256', '2026-06-09', '17:30:00.000000', '08:30:00.000000', 'AVAILABLE', NULL, 27, b'0'),
(1898, '2026-05-09 01:00:00.446501', '2026-05-28', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1899, '2026-05-09 01:00:00.448197', '2026-05-29', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1900, '2026-05-09 01:00:00.449517', '2026-05-30', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1901, '2026-05-09 01:00:00.450876', '2026-05-31', '18:30:00.000000', '09:00:00.000000', 'CLOSED', NULL, 19, b'0'),
(1902, '2026-05-09 01:00:00.451922', '2026-06-01', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 03:00:00.062754', 19, b'0'),
(1903, '2026-05-09 01:00:00.453054', '2026-06-02', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1904, '2026-05-09 01:00:00.454754', '2026-06-03', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1905, '2026-05-09 01:00:00.456479', '2026-06-04', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1906, '2026-05-09 01:00:00.457411', '2026-06-05', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1907, '2026-05-09 01:00:00.458262', '2026-06-06', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1908, '2026-05-09 01:00:00.459669', '2026-06-07', '18:30:00.000000', '09:00:00.000000', 'CLOSED', NULL, 19, b'0'),
(1909, '2026-05-09 01:00:00.460581', '2026-06-08', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', '2026-05-09 03:00:00.062754', 19, b'0'),
(1910, '2026-05-09 01:00:00.461544', '2026-06-09', '18:30:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 19, b'0'),
(1911, '2026-05-09 01:00:00.479766', '2026-05-28', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1912, '2026-05-09 01:00:00.481712', '2026-05-29', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1913, '2026-05-09 01:00:00.484024', '2026-05-30', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1914, '2026-05-09 01:00:00.485097', '2026-05-31', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 28, b'0'),
(1915, '2026-05-09 01:00:00.486120', '2026-06-01', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 28, b'0'),
(1916, '2026-05-09 01:00:00.487736', '2026-06-02', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1917, '2026-05-09 01:00:00.488939', '2026-06-03', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1918, '2026-05-09 01:00:00.489812', '2026-06-04', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1919, '2026-05-09 01:00:00.490604', '2026-06-05', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1920, '2026-05-09 01:00:00.491723', '2026-06-06', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1921, '2026-05-09 01:00:00.492823', '2026-06-07', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 28, b'0'),
(1922, '2026-05-09 01:00:00.493819', '2026-06-08', '18:00:00.000000', '09:00:00.000000', 'CLOSED', NULL, 28, b'0'),
(1923, '2026-05-09 01:00:00.494753', '2026-06-09', '18:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 28, b'0'),
(1924, '2026-05-09 01:00:00.512639', '2026-05-28', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1925, '2026-05-09 01:00:00.514064', '2026-05-29', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1926, '2026-05-09 01:00:00.515154', '2026-05-30', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1927, '2026-05-09 01:00:00.516223', '2026-05-31', '23:30:00.000000', '15:00:00.000000', 'CLOSED', NULL, 20, b'0'),
(1928, '2026-05-09 01:00:00.517382', '2026-06-01', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-05-09 03:00:00.064567', 20, b'0'),
(1929, '2026-05-09 01:00:00.518390', '2026-06-02', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 03:00:00.065464', 20, b'0'),
(1930, '2026-05-09 01:00:00.519549', '2026-06-03', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1931, '2026-05-09 01:00:00.521664', '2026-06-04', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1932, '2026-05-09 01:00:00.522723', '2026-06-05', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1933, '2026-05-09 01:00:00.523776', '2026-06-06', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', NULL, 20, b'0'),
(1934, '2026-05-09 01:00:00.524983', '2026-06-07', '23:30:00.000000', '15:00:00.000000', 'CLOSED', NULL, 20, b'0'),
(1935, '2026-05-09 01:00:00.526279', '2026-06-08', '23:30:00.000000', '15:00:00.000000', 'CLOSED', '2026-05-09 03:00:00.064567', 20, b'0'),
(1936, '2026-05-09 01:00:00.527187', '2026-06-09', '23:30:00.000000', '15:00:00.000000', 'AVAILABLE', '2026-05-09 03:00:00.065464', 20, b'0'),
(1937, '2026-05-09 01:00:00.543823', '2026-05-28', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1938, '2026-05-09 01:00:00.545457', '2026-05-29', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(1939, '2026-05-09 01:00:00.547025', '2026-05-30', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1940, '2026-05-09 01:00:00.548153', '2026-05-31', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(1941, '2026-05-09 01:00:00.549120', '2026-06-01', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1942, '2026-05-09 01:00:00.550158', '2026-06-02', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1943, '2026-05-09 01:00:00.551101', '2026-06-03', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1944, '2026-05-09 01:00:00.552041', '2026-06-04', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1945, '2026-05-09 01:00:00.553469', '2026-06-05', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(1946, '2026-05-09 01:00:00.554714', '2026-06-06', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1947, '2026-05-09 01:00:00.555669', '2026-06-07', '20:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 21, b'0'),
(1948, '2026-05-09 01:00:00.556537', '2026-06-08', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1949, '2026-05-09 01:00:00.557494', '2026-06-09', '20:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 21, b'0'),
(1950, '2026-05-09 01:00:00.572495', '2026-05-28', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1951, '2026-05-09 01:00:00.573355', '2026-05-29', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(1952, '2026-05-09 01:00:00.574224', '2026-05-30', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1953, '2026-05-09 01:00:00.575121', '2026-05-31', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(1954, '2026-05-09 01:00:00.575967', '2026-06-01', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1955, '2026-05-09 01:00:00.576823', '2026-06-02', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1956, '2026-05-09 01:00:00.577765', '2026-06-03', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1957, '2026-05-09 01:00:00.578679', '2026-06-04', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1958, '2026-05-09 01:00:00.579529', '2026-06-05', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(1959, '2026-05-09 01:00:00.580380', '2026-06-06', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1960, '2026-05-09 01:00:00.581315', '2026-06-07', '16:00:00.000000', '07:00:00.000000', 'CLOSED', NULL, 29, b'0'),
(1961, '2026-05-09 01:00:00.582162', '2026-06-08', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1962, '2026-05-09 01:00:00.583503', '2026-06-09', '16:00:00.000000', '07:00:00.000000', 'AVAILABLE', NULL, 29, b'0'),
(1963, '2026-05-09 01:00:00.601539', '2026-05-28', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1964, '2026-05-09 01:00:00.602627', '2026-05-29', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1965, '2026-05-09 01:00:00.603498', '2026-05-30', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1966, '2026-05-09 01:00:00.604392', '2026-05-31', '23:00:00.000000', '16:00:00.000000', 'CLOSED', NULL, 22, b'0'),
(1967, '2026-05-09 01:00:00.605282', '2026-06-01', '23:00:00.000000', '16:00:00.000000', 'CLOSED', NULL, 22, b'0'),
(1968, '2026-05-09 01:00:00.606205', '2026-06-02', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1969, '2026-05-09 01:00:00.607114', '2026-06-03', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1970, '2026-05-09 01:00:00.607936', '2026-06-04', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1971, '2026-05-09 01:00:00.608760', '2026-06-05', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1972, '2026-05-09 01:00:00.609762', '2026-06-06', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1973, '2026-05-09 01:00:00.610613', '2026-06-07', '23:00:00.000000', '16:00:00.000000', 'CLOSED', NULL, 22, b'0'),
(1974, '2026-05-09 01:00:00.611472', '2026-06-08', '23:00:00.000000', '16:00:00.000000', 'CLOSED', NULL, 22, b'0'),
(1975, '2026-05-09 01:00:00.612383', '2026-06-09', '23:00:00.000000', '16:00:00.000000', 'AVAILABLE', NULL, 22, b'0'),
(1976, '2026-05-09 01:00:00.629349', '2026-05-28', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1977, '2026-05-09 01:00:00.630271', '2026-05-29', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1978, '2026-05-09 01:00:00.631251', '2026-05-30', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1979, '2026-05-09 01:00:00.632244', '2026-05-31', '19:00:00.000000', '10:00:00.000000', 'CLOSED', NULL, 23, b'0'),
(1980, '2026-05-09 01:00:00.633237', '2026-06-01', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1981, '2026-05-09 01:00:00.634261', '2026-06-02', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1982, '2026-05-09 01:00:00.635232', '2026-06-03', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1983, '2026-05-09 01:00:00.636170', '2026-06-04', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1984, '2026-05-09 01:00:00.637088', '2026-06-05', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1985, '2026-05-09 01:00:00.637997', '2026-06-06', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1986, '2026-05-09 01:00:00.638946', '2026-06-07', '19:00:00.000000', '10:00:00.000000', 'CLOSED', NULL, 23, b'0'),
(1987, '2026-05-09 01:00:00.640014', '2026-06-08', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1988, '2026-05-09 01:00:00.640982', '2026-06-09', '19:00:00.000000', '10:00:00.000000', 'AVAILABLE', NULL, 23, b'0'),
(1989, '2026-05-09 01:00:00.659730', '2026-05-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1990, '2026-05-09 01:00:00.660884', '2026-05-29', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1991, '2026-05-09 01:00:00.662062', '2026-05-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1992, '2026-05-09 01:00:00.663283', '2026-05-31', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 24, b'0'),
(1993, '2026-05-09 01:00:00.664233', '2026-06-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1994, '2026-05-09 01:00:00.665229', '2026-06-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1995, '2026-05-09 01:00:00.666143', '2026-06-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1996, '2026-05-09 01:00:00.667480', '2026-06-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1997, '2026-05-09 01:00:00.668658', '2026-06-05', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1998, '2026-05-09 01:00:00.669811', '2026-06-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(1999, '2026-05-09 01:00:00.671260', '2026-06-07', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 24, b'0'),
(2000, '2026-05-09 01:00:00.672415', '2026-06-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(2001, '2026-05-09 01:00:00.673466', '2026-06-09', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 24, b'0'),
(2002, '2026-05-09 01:00:00.694170', '2026-05-28', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2003, '2026-05-09 01:00:00.695441', '2026-05-29', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(2004, '2026-05-09 01:00:00.696562', '2026-05-30', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2005, '2026-05-09 01:00:00.697582', '2026-05-31', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(2006, '2026-05-09 01:00:00.698986', '2026-06-01', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2007, '2026-05-09 01:00:00.700402', '2026-06-02', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2008, '2026-05-09 01:00:00.702102', '2026-06-03', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2009, '2026-05-09 01:00:00.703868', '2026-06-04', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2010, '2026-05-09 01:00:00.705296', '2026-06-05', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(2011, '2026-05-09 01:00:00.706642', '2026-06-06', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2012, '2026-05-09 01:00:00.707874', '2026-06-07', '17:00:00.000000', '08:00:00.000000', 'CLOSED', NULL, 25, b'0'),
(2013, '2026-05-09 01:00:00.708956', '2026-06-08', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2014, '2026-05-09 01:00:00.710028', '2026-06-09', '17:00:00.000000', '08:00:00.000000', 'AVAILABLE', NULL, 25, b'0'),
(2015, '2026-05-09 01:00:00.750692', '2026-06-09', '17:00:00.000000', '09:00:00.000000', 'AVAILABLE', NULL, 33, b'0');

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` bigint NOT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `end_date` date DEFAULT NULL,
  `plan_name` tinyint NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `start_date` date NOT NULL,
  `status` tinyint NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `business_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `avatar_url` text COLLATE utf8mb4_general_ci,
  `created_at` datetime(6) NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password_reset_expires_at` datetime(6) DEFAULT NULL,
  `password_reset_token` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone_number` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('ADMIN','BUSINESS_OWNER','CLIENT','STAFF') COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('PENDING','SUSPENDED','VERIFIED') COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `telegram_chat_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `avatar_url`, `created_at`, `email`, `name`, `password`, `password_reset_expires_at`, `password_reset_token`, `phone_number`, `role`, `status`, `updated_at`, `telegram_chat_id`) VALUES
(1, 'https://res.cloudinary.com/duvougrqx/image/upload/v1767364523/Bookify/StoonProd-user-1.avif', '2025-10-30 18:12:43.000000', 'amirghodhben2.0@gmail.com', 'amir', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21680138013', 'BUSINESS_OWNER', 'VERIFIED', '2026-01-02 14:35:23.000000', NULL),
(2, 'https://c8.alamy.com/comp/2J3B2T7/3d-illustration-of-smiling-businessman-close-up-portrait-cute-cartoon-man-avatar-character-face-isolated-on-white-background-2J3B2T7.jpg', '2025-11-25 19:53:25.000000', 'dissojak@icloud.com', 'disso mac Staff', '$2a$10$VzwOJHUQNmn/fkj1K1u8Z.CoO.Fd9ruku6m.t3GkgQeD/AkZ2kF/q', NULL, NULL, '+21623039320', 'STAFF', 'VERIFIED', '2026-05-08 23:08:58.073678', '2074587103'),
(3, 'https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001882.png', '2025-11-25 19:55:00.000000', 'dissojak@gmail.com', 'Kayedni Client', '$2a$10$9sY.bZ.sIU5qL7zC./Jq1O.baq9I9Mv4gmedk.h0sh3hYCbrvaPEG', NULL, NULL, '+21623039320', 'CLIENT', 'VERIFIED', '2026-05-08 23:08:58.080328', '2074587103'),
(4, 'https://example.com/avatars/admin.jpg', '2025-11-25 19:55:48.000000', 'admin@example.com', 'Admin User', '$2a$10$7fVU6aNkqykITEorIh2DHeBnPEhPLztLxQpeWmBoxYJ1YpyoyB8Ou', '2026-05-04 18:37:00.830934', '442061', '+33123456789', 'ADMIN', 'VERIFIED', '2026-05-04 18:22:03.421480', NULL),
(5, 'https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001877.png', '2025-11-25 19:57:32.000000', 'therealstoon@gmail.com', 'TheRealStoon mac', '$2a$10$Skm5ljinLBCCXGgkpuUMP.0R3t8RDH.gxzbbCsQatlumGc3BGHDYe', NULL, NULL, '+21623039320', 'STAFF', 'VERIFIED', '2026-05-08 23:08:58.088262', '2074587103'),
(6, 'https://res.cloudinary.com/duvougrqx/image/upload/v1766762155/Bookify/StoonProd-user-6.svg', '2025-11-26 20:35:51.000000', 'stoonproduction@gmail.com', 'Stoon Prod', '$2a$10$L4sXEahryFTJxhenG2egueiiaHrs97QhkS1oeB/.H3m0VHvxN1QF.', NULL, NULL, '+21623039320', 'BUSINESS_OWNER', 'VERIFIED', '2026-05-08 23:08:58.094223', '2074587103'),
(7, 'https://res.cloudinary.com/duvougrqx/image/upload/v1766761870/Bookify/StoonProd-user-7.png', '2025-12-23 15:30:39.000000', 'ademadembenamor@hotmail.com', 'Emna Gmati', '$2a$10$.dO/H6zd0oiwCpOlP.jIV.JirdR2JP9n8Z0enC4OVZKENpBLkQTLC', NULL, NULL, '+216 95132694', 'CLIENT', 'VERIFIED', '2026-01-03 22:00:45.000000', NULL),
(8, 'https://randomuser.me/api/portraits/men/75.jpg', '2025-10-10 10:00:00.000000', 'mario.rossi@bellaitalia.fr', 'Mario Rossi', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33142567890', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-10 14:00:00.000000', NULL),
(9, 'https://randomuser.me/api/portraits/men/60.jpg', '2025-09-15 09:00:00.000000', 'ali.sarrar@darsarrar.tn', 'Ali Sarrar', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21671234567', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-08 16:00:00.000000', NULL),
(10, 'https://randomuser.me/api/portraits/women/68.jpg', '2025-10-25 11:00:00.000000', 'lina.bouzid@glamourhair.com', 'Lina Bouzid', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21698765432', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-15 10:00:00.000000', NULL),
(11, 'https://randomuser.me/api/portraits/men/35.jpg', '2025-08-05 09:30:00.000000', 'nicolas.dupont@urbancuts.com', 'Nicolas Dupont', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33478901234', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-12 11:00:00.000000', NULL),
(12, 'https://randomuser.me/api/portraits/men/88.jpg', '2025-07-01 16:00:00.000000', 'kenji.tanaka@sakuratokyo.fr', 'Kenji Tanaka', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33145678901', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-11 18:00:00.000000', NULL),
(13, 'https://randomuser.me/api/portraits/women/25.jpg', '2025-06-10 12:00:00.000000', 'nadia.amor@fitlifestudio.tn', 'Nadia Amor', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21655443322', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-13 08:00:00.000000', NULL),
(14, 'https://randomuser.me/api/portraits/men/42.jpg', '2025-05-18 14:30:00.000000', 'luigi.napoli@pizzanapoletana.fr', 'Luigi Napoli', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33149876543', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-09 17:00:00.000000', NULL),
(15, 'https://randomuser.me/api/portraits/women/55.jpg', '2025-04-22 11:00:00.000000', 'yasmine.ben@zenspacenter. tn', 'Yasmine Ben Salem', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21670112233', 'BUSINESS_OWNER', 'VERIFIED', '2025-12-07 13:00:00.000000', NULL),
(16, 'https://randomuser.me/api/portraits/women/33.jpg', '2025-11-05 10:30:00.000000', 'sarah.jones@email.com', 'Sarah Jones', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33609887766', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(17, 'https://randomuser.me/api/portraits/men/28.jpg', '2025-11-08 14:00:00.000000', 'karim.slimani@email.com', 'Karim Slimani', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21699123456', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(18, 'https://randomuser.me/api/portraits/women/77.jpg', '2025-10-15 16:00:00.000000', 'alice.petit@email.fr', 'Alice Petit', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33601122334', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(19, 'https://randomuser.me/api/portraits/men/29.jpg', '2025-09-20 11:00:00.000000', 'mohamed.brahmi@email.com', 'Mohamed Brahmi', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21620998877', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(20, 'https://randomuser.me/api/portraits/women/88.jpg', '2025-08-15 15:30:00.000000', 'fatima.hamdi@email. com', 'Fatima Hamdi', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21655887766', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(21, 'https://randomuser.me/api/portraits/men/55.jpg', '2025-11-12 09:00:00.000000', 'pierre.martin@email.fr', 'Pierre Martin', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33607123456', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(22, 'https://randomuser.me/api/portraits/women/22.jpg', '2025-11-15 13:00:00.000000', 'leila.ben@email.com', 'Leila Ben Ali', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21698334455', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(23, 'https://randomuser.me/api/portraits/men/66.jpg', '2025-11-18 10:30:00.000000', 'jean.dubois@email.fr', 'Jean Dubois', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33609998877', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(24, 'https://randomuser.me/api/portraits/women/40.jpg', '2025-11-20 14:00:00.000000', 'amira.ktari@email.com', 'Amira Ktari', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21655667788', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(25, 'https://randomuser.me/api/portraits/men/38.jpg', '2025-11-22 16:00:00.000000', 'ahmed.najjar@email.com', 'Ahmed Najjar', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21620556677', 'STAFF', 'VERIFIED', '2025-12-24 18:00:00.000000', NULL),
(26, 'https://randomuser.me/api/portraits/men/19.jpg', '2025-11-26 08:00:00.000000', 'hamza.barber@stoonbarber.com', 'Hamza Cherif', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21698223344', 'STAFF', 'VERIFIED', '2025-12-10 09:00:00.000000', NULL),
(27, 'https://randomuser.me/api/portraits/women/30.jpg', '2025-11-27 09:00:00.000000', 'salma.stylist@glamourhair.com', 'Salma Agrebi', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21699445566', 'STAFF', 'VERIFIED', '2025-12-11 10:00:00.000000', NULL),
(28, 'https://randomuser.me/api/portraits/men/24.jpg', '2025-11-28 10:00:00.000000', 'youssef.barber@urbancuts.com', 'Youssef Mansour', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33607334455', 'STAFF', 'VERIFIED', '2025-12-08 11:00:00.000000', NULL),
(29, 'https://randomuser.me/api/portraits/women/18.jpg', '2025-11-29 11:00:00.000000', 'ines.trainer@fitlifestudio.tn', 'Ines Gharbi', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+21655998877', 'STAFF', 'VERIFIED', '2025-12-09 12:00:00.000000', NULL),
(30, 'https://randomuser.me/api/portraits/men/41.jpg', '2025-11-30 12:00:00.000000', 'mehdi.chef@bellaitalia.fr', 'Mehdi Tlili', '$2a$10$EW9L6l.tpKPN1mxgyAsdQO3I/mWB.bCuOrj7yNrGnNE.HQOGH6yxG', NULL, NULL, '+33608776655', 'STAFF', 'VERIFIED', '2025-12-06 13:00:00.000000', NULL),
(33, NULL, '2026-04-25 20:47:09.156110', 'kaishamas@gmail.com', 'kais ben amor', '$2a$10$lMMeCT5m1Lx2bNhLO.PuT.tJjbQDfFuT1//OvVXC00Kl8Ot.GseeC', NULL, NULL, NULL, 'BUSINESS_OWNER', 'VERIFIED', '2026-04-25 20:48:58.550393', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_behavior_profile_snapshots`
--

CREATE TABLE `user_behavior_profile_snapshots` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `profile_json` longtext NOT NULL,
  `snapshot_version` int NOT NULL,
  `source_last_updated_at` datetime(6) DEFAULT NULL,
  `stale` bit(1) NOT NULL,
  `synced_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_behavior_profile_snapshots`
--

INSERT INTO `user_behavior_profile_snapshots` (`id`, `created_at`, `profile_json`, `snapshot_version`, `source_last_updated_at`, `stale`, `synced_at`, `updated_at`, `user_id`) VALUES
(1, '2026-05-04 18:30:00.000000', '{\"_id\":\"69b968ecb6dc0548e407a517\",\"userId\":\"1\",\"__v\":0,\"avgEventsPerSession\":11,\"avgSessionDuration\":492944,\"browserTypes\":{\"Unknown\":1302,\"Chrome\":45},\"countriesUsed\":{},\"createdAt\":\"2026-03-17T14:45:00.354Z\",\"deviceTypes\":{\"desktop\":123},\"favoritePages\":[\"/business\",\"/\",\"/business/stoon-barber-1\",\"/business/dashboard\",\"/login\"],\"firstSeenAt\":\"2026-03-17T14:40:13.039Z\",\"lastActive\":\"2026-05-09T08:31:54.026Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:01.292Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":\"1\",\"lastSeenBusinessAt\":\"2026-04-26T22:03:26.811Z\",\"topEventTypes\":{\"testimonial_section_view\":10,\"filter_used\":3,\"booking_started\":1,\"page_view\":1015,\"logout\":38,\"booking_completed\":1,\"profile_update\":2,\"click\":109,\"category_browsed\":1,\"time_on_page\":105,\"slice_landing_view\":12,\"business_impression\":11,\"search_query\":1,\"business_view\":38},\"totalEvents\":1347,\"totalSessionDuration\":60632057,\"totalSessions\":123,\"updatedAt\":\"2026-05-09T11:55:01.292Z\"}', 1, '2026-05-09 12:55:01.292000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '1'),
(2, '2026-05-04 18:30:00.000000', '{\"_id\":\"69d0dff521c3816f254752b9\",\"userId\":\"19\",\"__v\":0,\"avgEventsPerSession\":4,\"avgSessionDuration\":74309,\"browserTypes\":{\"Unknown\":25},\"countriesUsed\":{},\"createdAt\":\"2026-04-04T09:55:01.132Z\",\"deviceTypes\":{\"desktop\":6},\"favoritePages\":[\"/\",\"/login\"],\"firstSeenAt\":\"2026-04-04T09:52:16.615Z\",\"lastActive\":\"2026-04-04T10:05:50.631Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:02.100Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"page_view\":12,\"logout\":4,\"click\":4,\"testimonial_section_view\":1,\"time_on_page\":4},\"totalEvents\":25,\"totalSessionDuration\":445852,\"totalSessions\":6,\"updatedAt\":\"2026-05-09T11:55:02.101Z\"}', 1, '2026-05-09 12:55:02.100000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '19'),
(3, '2026-05-04 18:30:00.000000', '{\"_id\":\"69b7cec5b6dc0548e4079f72\",\"userId\":\"2\",\"__v\":0,\"avgEventsPerSession\":11,\"avgSessionDuration\":327962,\"browserTypes\":{\"Chrome\":533,\"Unknown\":443},\"countriesUsed\":{},\"createdAt\":\"2026-03-16T09:35:01.180Z\",\"deviceTypes\":{\"desktop\":91},\"favoritePages\":[\"/staff/bookings\",\"/staff/dashboard\",\"/\",\"/staff/schedule\",\"/staff/services\"],\"firstSeenAt\":\"2026-03-16T09:15:18.712Z\",\"lastActive\":\"2026-05-09T02:19:24.235Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:02.449Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":\"1\",\"lastSeenBusinessAt\":\"2026-05-09T02:17:31.852Z\",\"topEventTypes\":{\"business_view\":12,\"testimonial_section_view\":4,\"logout\":39,\"profile_update\":2,\"time_on_page\":60,\"page_view\":776,\"click\":83},\"totalEvents\":976,\"totalSessionDuration\":29844553,\"totalSessions\":91,\"updatedAt\":\"2026-05-09T11:55:02.449Z\"}', 1, '2026-05-09 12:55:02.449000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '2'),
(4, '2026-05-04 18:30:00.000000', '{\"_id\":\"69d06e4a21c3816f25475131\",\"userId\":\"24\",\"__v\":0,\"avgEventsPerSession\":5,\"avgSessionDuration\":150650,\"browserTypes\":{\"Unknown\":148},\"countriesUsed\":{},\"createdAt\":\"2026-04-04T01:50:02.175Z\",\"deviceTypes\":{\"desktop\":32},\"favoritePages\":[\"/\",\"/staff/bookings\",\"/barber\",\"/login\",\"/staff/dashboard\"],\"firstSeenAt\":\"2026-04-04T01:45:22.055Z\",\"lastActive\":\"2026-05-09T01:16:47.297Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:02.811Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":\"11\",\"lastSeenBusinessAt\":\"2026-04-26T13:54:36.407Z\",\"topEventTypes\":{\"page_view\":92,\"booking_started\":1,\"testimonial_section_view\":2,\"booking_completed\":1,\"logout\":11,\"slice_landing_view\":6,\"time_on_page\":18,\"category_browsed\":1,\"click\":14,\"business_view\":2},\"totalEvents\":148,\"totalSessionDuration\":4820788,\"totalSessions\":32,\"updatedAt\":\"2026-05-09T11:55:02.811Z\"}', 1, '2026-05-09 12:55:02.811000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '24'),
(5, '2026-05-04 18:30:00.000000', '{\"_id\":\"69bc109db6dc0548e407b04b\",\"userId\":\"26\",\"__v\":0,\"avgEventsPerSession\":7,\"avgSessionDuration\":801214,\"browserTypes\":{\"Chrome\":7},\"countriesUsed\":{},\"createdAt\":\"2026-03-19T15:05:01.584Z\",\"deviceTypes\":{\"desktop\":1},\"favoritePages\":[\"/staff/dashboard\",\"/staff/schedule\",\"/login\",\"/\"],\"firstSeenAt\":\"2026-03-19T14:48:16.084Z\",\"lastActive\":\"2026-03-19T14:48:33.115Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:03.287Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"time_on_page\":1,\"logout\":1,\"click\":1,\"page_view\":4},\"totalEvents\":7,\"totalSessionDuration\":801214,\"totalSessions\":1,\"updatedAt\":\"2026-05-09T11:55:03.287Z\"}', 1, '2026-05-09 12:55:03.287000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '26'),
(6, '2026-05-04 18:30:00.000000', '{\"_id\":\"69e552bc89bdd42434b132da\",\"userId\":\"27\",\"__v\":0,\"avgEventsPerSession\":10,\"avgSessionDuration\":44720,\"browserTypes\":{\"Unknown\":19},\"countriesUsed\":{},\"createdAt\":\"2026-04-19T22:10:04.207Z\",\"deviceTypes\":{\"desktop\":2},\"favoritePages\":[\"/staff/dashboard\",\"/staff/bookings\",\"/staff/services\",\"/\",\"/login\"],\"firstSeenAt\":\"2026-04-19T22:08:07.989Z\",\"lastActive\":\"2026-04-19T22:12:33.017Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:03.631Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"click\":2,\"time_on_page\":2,\"page_view\":13,\"logout\":2},\"totalEvents\":19,\"totalSessionDuration\":89439,\"totalSessions\":2,\"updatedAt\":\"2026-05-09T11:55:03.631Z\"}', 1, '2026-05-09 12:55:03.631000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '27'),
(7, '2026-05-04 18:30:00.000000', '{\"_id\":\"69ab9871968f71327c43811e\",\"userId\":\"3\",\"__v\":0,\"avgEventsPerSession\":15,\"avgSessionDuration\":207589,\"browserTypes\":{\"Chrome\":1009,\"Unknown\":365},\"countriesUsed\":{},\"createdAt\":\"2026-03-07T03:16:01.569Z\",\"deviceTypes\":{\"desktop\":90},\"favoritePages\":[\"/business/stoon-barber-1\",\"/businesses\",\"/\",\"/booking/checkout\",\"/bookings\"],\"firstSeenAt\":\"2026-03-07T02:53:28.178Z\",\"lastActive\":\"2026-05-08T23:48:16.227Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:03.975Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":\"1\",\"lastSeenBusinessAt\":\"2026-05-08T23:10:53.281Z\",\"topEventTypes\":{\"login_attempt\":2,\"login\":2,\"business_impression\":55,\"click\":59,\"time_on_page\":334,\"search_query\":1,\"logout\":40,\"booking_completed\":52,\"testimonial_section_view\":8,\"page_view\":589,\"business_view\":175,\"profile_update\":1,\"booking_abandoned\":1,\"category_browsed\":2,\"slice_landing_view\":6,\"booking_started\":47},\"totalEvents\":1374,\"totalSessionDuration\":18682974,\"totalSessions\":90,\"updatedAt\":\"2026-05-09T11:55:03.975Z\"}', 1, '2026-05-09 12:55:03.975000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '3'),
(8, '2026-05-04 18:30:00.000000', '{\"_id\":\"69e5412b89bdd42434b13298\",\"userId\":\"31\",\"__v\":0,\"avgEventsPerSession\":7,\"avgSessionDuration\":54683,\"browserTypes\":{\"Unknown\":98},\"countriesUsed\":{},\"createdAt\":\"2026-04-19T20:55:06.894Z\",\"deviceTypes\":{\"desktop\":15},\"favoritePages\":[\"/\",\"/search\",\"/business/barber-cave-16\",\"/bookings\",\"/booking/checkout\"],\"firstSeenAt\":\"2026-04-19T20:50:40.673Z\",\"lastActive\":\"2026-04-21T18:42:56.454Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:04.343Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":\"16\",\"lastSeenBusinessAt\":\"2026-04-19T21:45:46.558Z\",\"topEventTypes\":{\"time_on_page\":17,\"logout\":1,\"testimonial_section_view\":1,\"page_view\":56,\"booking_completed\":3,\"booking_started\":2,\"profile_update\":1,\"business_view\":8,\"category_browsed\":2,\"click\":6,\"business_impression\":1},\"totalEvents\":98,\"totalSessionDuration\":820239,\"totalSessions\":15,\"updatedAt\":\"2026-05-09T11:55:04.343Z\"}', 1, '2026-05-09 12:55:04.343000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '31'),
(9, '2026-05-04 18:30:00.000000', '{\"_id\":\"69e544b389bdd42434b132a5\",\"userId\":\"32\",\"__v\":0,\"avgEventsPerSession\":18,\"avgSessionDuration\":141274,\"browserTypes\":{\"Unknown\":175},\"countriesUsed\":{},\"createdAt\":\"2026-04-19T21:10:11.824Z\",\"deviceTypes\":{\"desktop\":10},\"favoritePages\":[\"/business/dashboard\",\"/business/bookings\",\"/staff/dashboard\",\"/business/staff\",\"/business\"],\"firstSeenAt\":\"2026-04-19T21:06:43.612Z\",\"lastActive\":\"2026-04-19T22:00:23.224Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:04.756Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":\"16\",\"lastSeenBusinessAt\":\"2026-04-19T21:44:23.972Z\",\"topEventTypes\":{\"time_on_page\":12,\"logout\":3,\"testimonial_section_view\":1,\"page_view\":144,\"booking_started\":1,\"booking_completed\":1,\"profile_update\":1,\"business_view\":2,\"category_browsed\":1,\"click\":8,\"slice_landing_view\":1},\"totalEvents\":175,\"totalSessionDuration\":1412737,\"totalSessions\":10,\"updatedAt\":\"2026-05-09T11:55:04.757Z\"}', 1, '2026-05-09 12:55:04.756000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '32'),
(10, '2026-05-04 18:30:00.000000', '{\"_id\":\"69ed2904b60f7bf4eaa899b8\",\"userId\":\"33\",\"__v\":0,\"avgEventsPerSession\":7,\"avgSessionDuration\":120608,\"browserTypes\":{\"Unknown\":48},\"countriesUsed\":{},\"createdAt\":\"2026-04-25T20:50:11.898Z\",\"deviceTypes\":{\"desktop\":7},\"favoritePages\":[\"/business\",\"/business/staff\",\"/bookings\",\"/\",\"/business/dashboard\"],\"firstSeenAt\":\"2026-04-25T20:49:16.289Z\",\"lastActive\":\"2026-05-08T23:03:52.621Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:05.113Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":\"17\",\"lastSeenBusinessAt\":\"2026-04-25T21:07:27.984Z\",\"topEventTypes\":{\"page_view\":29,\"logout\":4,\"business_view\":1,\"click\":5,\"booking_completed\":1,\"time_on_page\":8},\"totalEvents\":48,\"totalSessionDuration\":844253,\"totalSessions\":7,\"updatedAt\":\"2026-05-09T11:55:05.114Z\"}', 1, '2026-05-09 12:55:05.113000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '33'),
(11, '2026-05-04 18:30:00.000000', '{\"_id\":\"69d0e37a21c3816f254752c7\",\"userId\":\"42\",\"__v\":0,\"avgEventsPerSession\":6,\"avgSessionDuration\":54902,\"browserTypes\":{\"Unknown\":45},\"countriesUsed\":{},\"createdAt\":\"2026-04-04T10:10:02.401Z\",\"deviceTypes\":{\"desktop\":8},\"favoritePages\":[\"/business\",\"/business/dashboard\",\"/\",\"/login\",\"/business/services\"],\"firstSeenAt\":\"2026-04-04T10:06:05.230Z\",\"lastActive\":\"2026-04-04T11:12:27.502Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:05.790Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"time_on_page\":3,\"logout\":3,\"click\":3,\"page_view\":36},\"totalEvents\":45,\"totalSessionDuration\":439216,\"totalSessions\":8,\"updatedAt\":\"2026-05-09T11:55:05.790Z\"}', 1, '2026-05-09 12:55:05.790000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '42'),
(12, '2026-05-04 18:30:00.000000', '{\"_id\":\"69bc0d1ab6dc0548e407b005\",\"userId\":\"5\",\"__v\":0,\"avgEventsPerSession\":6,\"avgSessionDuration\":37921,\"browserTypes\":{\"Chrome\":6},\"countriesUsed\":{},\"createdAt\":\"2026-03-19T14:50:01.996Z\",\"deviceTypes\":{\"desktop\":1},\"favoritePages\":[\"/staff/schedule\",\"/login\",\"/\"],\"firstSeenAt\":\"2026-03-19T14:46:55.841Z\",\"lastActive\":\"2026-03-19T14:47:28.043Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:06.172Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"page_view\":3,\"logout\":1,\"click\":1,\"time_on_page\":1},\"totalEvents\":6,\"totalSessionDuration\":37921,\"totalSessions\":1,\"updatedAt\":\"2026-05-09T11:55:06.172Z\"}', 1, '2026-05-09 12:55:06.172000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '5'),
(13, '2026-05-04 18:30:00.000000', '{\"_id\":\"69e81b3db60f7bf4eaa886f2\",\"userId\":\"6\",\"__v\":0,\"avgEventsPerSession\":4,\"avgSessionDuration\":100872,\"browserTypes\":{\"Unknown\":40},\"countriesUsed\":{},\"createdAt\":\"2026-04-22T00:50:05.053Z\",\"deviceTypes\":{\"desktop\":9},\"favoritePages\":[\"/business\",\"/\",\"/login\",\"/health-care\",\"/business/dashboard\"],\"firstSeenAt\":\"2026-04-22T00:40:33.885Z\",\"lastActive\":\"2026-04-22T00:55:37.669Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:06.519Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"page_view\":25,\"logout\":5,\"click\":5,\"time_on_page\":5},\"totalEvents\":40,\"totalSessionDuration\":907847,\"totalSessions\":9,\"updatedAt\":\"2026-05-09T11:55:06.519Z\"}', 1, '2026-05-09 12:55:06.519000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '6'),
(63, '2026-05-04 19:30:00.000000', '{\"_id\":\"69f8e47f4db40ab06851d654\",\"userId\":\"4\",\"__v\":0,\"avgEventsPerSession\":3,\"avgSessionDuration\":56541,\"browserTypes\":{\"Unknown\":110},\"countriesUsed\":{},\"createdAt\":\"2026-05-04T18:25:03.359Z\",\"deviceTypes\":{\"desktop\":40},\"favoritePages\":[\"/admin/invite-keys\",\"/admin/control-panel\",\"/admin/login\",\"/\",\"/control-panel\"],\"firstSeenAt\":\"2026-05-04T18:22:35.906Z\",\"lastActive\":\"2026-05-09T08:31:34.536Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:05.449Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"click\":1,\"page_view\":106,\"time_on_page\":2,\"logout\":1},\"totalEvents\":110,\"totalSessionDuration\":2261637,\"totalSessions\":40,\"updatedAt\":\"2026-05-09T11:55:05.449Z\"}', 1, '2026-05-09 12:55:05.449000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '4'),
(278, '2026-05-09 02:30:00.000000', '{\"_id\":\"69fe8bc1d521785bbac5d8e1\",\"userId\":\"18\",\"__v\":0,\"avgEventsPerSession\":6,\"avgSessionDuration\":198749,\"browserTypes\":{\"Unknown\":6},\"countriesUsed\":{},\"createdAt\":\"2026-05-09T01:20:01.275Z\",\"deviceTypes\":{\"desktop\":1},\"favoritePages\":[\"/staff/dashboard\",\"/login\",\"/\"],\"firstSeenAt\":\"2026-05-09T01:12:10.971Z\",\"lastActive\":\"2026-05-09T01:15:23.695Z\",\"lastAggregatedAt\":\"2026-05-09T11:55:01.737Z\",\"lastKnownIp\":\"127.0.0.1\",\"lastSeenBusiness\":null,\"lastSeenBusinessAt\":null,\"topEventTypes\":{\"logout\":1,\"page_view\":3,\"click\":1,\"time_on_page\":1},\"totalEvents\":6,\"totalSessionDuration\":198749,\"totalSessions\":1,\"updatedAt\":\"2026-05-09T11:55:01.738Z\"}', 1, '2026-05-09 12:55:01.737000', b'0', '2026-05-09 13:00:01.000000', '2026-05-09 13:00:01.000000', '18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activation_tokens`
--
ALTER TABLE `activation_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK5jny0xpou62bqdjhkbw1c0qxd` (`token`),
  ADD KEY `fk_activation_token_user` (`user_id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `businesses`
--
ALTER TABLE `businesses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_business_owner` (`owner_id`),
  ADD KEY `fk_business_category` (`category_id`);

--
-- Indexes for table `business_clients`
--
ALTER TABLE `business_clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_business_client_phone` (`business_id`,`phone`);

--
-- Indexes for table `business_evaluations`
--
ALTER TABLE `business_evaluations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_eval_business` (`business_id`);

--
-- Indexes for table `business_images`
--
ALTER TABLE `business_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_business_image_business` (`business_id`);

--
-- Indexes for table `business_invite_tokens`
--
ALTER TABLE `business_invite_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK3i15xtj9l0goi1nxh2kmvo64p` (`token_hash`),
  ADD KEY `idx_token_hash` (`token_hash`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_assigned_email` (`assigned_email`),
  ADD KEY `idx_expires_at` (`expires_at`),
  ADD KEY `fk_invite_created_by_admin` (`created_by_admin_id`),
  ADD KEY `fk_invite_used_by_user` (`used_by_user_id`);

--
-- Indexes for table `business_ratings`
--
ALTER TABLE `business_ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKdi5ag3hnfia75c38b8n0u9d98` (`business_id`),
  ADD KEY `FKtp2yfws8kctdgl1njrh5f1mij` (`client_id`);

--
-- Indexes for table `cancellation_reason_templates`
--
ALTER TABLE `cancellation_reason_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cancel_reason_business` (`business_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKt8o6pivur7nn124jehx7cygw5` (`name`),
  ADD KEY `fk_category_created_by` (`created_by`);

--
-- Indexes for table `industry_feedback_submissions`
--
ALTER TABLE `industry_feedback_submissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKc52o2b1jkxttngufqp3t7jr3h` (`booking_id`),
  ADD KEY `FKa3xnf2o6mt8cqbewvq2ouq3rq` (`subscription_id`);

--
-- Indexes for table `profile_alert_states`
--
ALTER TABLE `profile_alert_states`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK439x1ulndgiahgu4qbnegkpm3` (`alert_key`);

--
-- Indexes for table `profile_resolution_audits`
--
ALTER TABLE `profile_resolution_audits`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profile_snapshot_sync_runs`
--
ALTER TABLE `profile_snapshot_sync_runs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKc9hsd0b9wogdgg69ljpnlqiph` (`business_id`);

--
-- Indexes for table `resource_availabilities`
--
ALTER TABLE `resource_availabilities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK1kev4jivfvl370wnxjtrq6efh` (`resource_id`);

--
-- Indexes for table `resource_ratings`
--
ALTER TABLE `resource_ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK7ad6rnmb063euhsqy0bgjfk0g` (`client_id`),
  ADD KEY `FKckiv8u2mpj223y0th29xrost5` (`resource_id`);

--
-- Indexes for table `resource_reservations`
--
ALTER TABLE `resource_reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK938p5d4n34777gj8jbukme8fb` (`client_id`),
  ADD KEY `FKgv5iq0d0eoxctbo01ma39sd8y` (`resource_availability_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK28an517hrxtt2bsg93uefugrm` (`booking_id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKryfh22ccvq43d77rj8d6nfrk8` (`business_id`),
  ADD KEY `fk_service_created_by` (`created_by`);

--
-- Indexes for table `service_bookings`
--
ALTER TABLE `service_bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK9ybrxpcjjmqm7p3lqo1sfrb1e` (`client_id`),
  ADD KEY `FK1cyr30xgaheo32v5iha15mvfn` (`service_id`),
  ADD KEY `FKobkxb0byfe0oq2tynu2e85h01` (`staff_id`),
  ADD KEY `FKd5s1pkxqucj9g6sxd3djgsyiy` (`business_client_id`);

--
-- Indexes for table `service_booking_occupancy`
--
ALTER TABLE `service_booking_occupancy`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_booking_occupancy_staff_date_slot` (`staff_id`,`date`,`slot_index`),
  ADD KEY `idx_booking_occupancy_booking` (`booking_id`),
  ADD KEY `idx_booking_occupancy_staff_date` (`staff_id`,`date`);

--
-- Indexes for table `service_ratings`
--
ALTER TABLE `service_ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKdlunwaiw7ktcbcr4rvejtjd74` (`client_id`),
  ADD KEY `FKkunckmqok9qmy5c2hbvdj4pmb` (`service_id`);

--
-- Indexes for table `service_staff`
--
ALTER TABLE `service_staff`
  ADD KEY `FKdycnsk82nmegdwl9yb4hfja3h` (`staff_id`),
  ADD KEY `FKb3hes1oc5ia6nr0fjvni6kg7j` (`service_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_staff_business` (`business_id`);

--
-- Indexes for table `staff_availabilities`
--
ALTER TABLE `staff_availabilities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKrve8emdy0iof8ltpu2cl6goel` (`staff_id`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKd75uwj5b3erhwwt5flxnevr7o` (`business_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`);

--
-- Indexes for table `user_behavior_profile_snapshots`
--
ALTER TABLE `user_behavior_profile_snapshots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKd3l123mp9b7mr3qcnb5mwsyaa` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activation_tokens`
--
ALTER TABLE `activation_tokens`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=252;

--
-- AUTO_INCREMENT for table `businesses`
--
ALTER TABLE `businesses`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT for table `business_clients`
--
ALTER TABLE `business_clients`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `business_evaluations`
--
ALTER TABLE `business_evaluations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `business_images`
--
ALTER TABLE `business_images`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `business_invite_tokens`
--
ALTER TABLE `business_invite_tokens`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `cancellation_reason_templates`
--
ALTER TABLE `cancellation_reason_templates`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=155;

--
-- AUTO_INCREMENT for table `industry_feedback_submissions`
--
ALTER TABLE `industry_feedback_submissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `profile_alert_states`
--
ALTER TABLE `profile_alert_states`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `profile_resolution_audits`
--
ALTER TABLE `profile_resolution_audits`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `profile_snapshot_sync_runs`
--
ALTER TABLE `profile_snapshot_sync_runs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `resource_availabilities`
--
ALTER TABLE `resource_availabilities`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=189;

--
-- AUTO_INCREMENT for table `service_booking_occupancy`
--
ALTER TABLE `service_booking_occupancy`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13146;

--
-- AUTO_INCREMENT for table `staff_availabilities`
--
ALTER TABLE `staff_availabilities`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2016;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=437;

--
-- AUTO_INCREMENT for table `user_behavior_profile_snapshots`
--
ALTER TABLE `user_behavior_profile_snapshots`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=577;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activation_tokens`
--
ALTER TABLE `activation_tokens`
  ADD CONSTRAINT `fk_activation_token_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `businesses`
--
ALTER TABLE `businesses`
  ADD CONSTRAINT `fk_business_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `fk_business_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `business_clients`
--
ALTER TABLE `business_clients`
  ADD CONSTRAINT `fk_business_client_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);

--
-- Constraints for table `business_evaluations`
--
ALTER TABLE `business_evaluations`
  ADD CONSTRAINT `fk_eval_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);

--
-- Constraints for table `business_images`
--
ALTER TABLE `business_images`
  ADD CONSTRAINT `fk_business_image_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);

--
-- Constraints for table `business_invite_tokens`
--
ALTER TABLE `business_invite_tokens`
  ADD CONSTRAINT `fk_invite_created_by_admin` FOREIGN KEY (`created_by_admin_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_invite_used_by_user` FOREIGN KEY (`used_by_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `business_ratings`
--
ALTER TABLE `business_ratings`
  ADD CONSTRAINT `FK3sb0qmu96yiuh6tgh56xa1fn3` FOREIGN KEY (`id`) REFERENCES `ratings` (`id`),
  ADD CONSTRAINT `FKdi5ag3hnfia75c38b8n0u9d98` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`),
  ADD CONSTRAINT `FKtp2yfws8kctdgl1njrh5f1mij` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `cancellation_reason_templates`
--
ALTER TABLE `cancellation_reason_templates`
  ADD CONSTRAINT `fk_cancel_reason_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `fk_category_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `FKa3xnf2o6mt8cqbewvq2ouq3rq` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`),
  ADD CONSTRAINT `FKc52o2b1jkxttngufqp3t7jr3h` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`);

--
-- Constraints for table `resources`
--
ALTER TABLE `resources`
  ADD CONSTRAINT `FKc9hsd0b9wogdgg69ljpnlqiph` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);

--
-- Constraints for table `resource_availabilities`
--
ALTER TABLE `resource_availabilities`
  ADD CONSTRAINT `FK1kev4jivfvl370wnxjtrq6efh` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`);

--
-- Constraints for table `resource_ratings`
--
ALTER TABLE `resource_ratings`
  ADD CONSTRAINT `FK7ad6rnmb063euhsqy0bgjfk0g` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKckiv8u2mpj223y0th29xrost5` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`),
  ADD CONSTRAINT `FKgxn9yqmios192clsgokw20fi8` FOREIGN KEY (`id`) REFERENCES `ratings` (`id`);

--
-- Constraints for table `resource_reservations`
--
ALTER TABLE `resource_reservations`
  ADD CONSTRAINT `FK938p5d4n34777gj8jbukme8fb` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKgv5iq0d0eoxctbo01ma39sd8y` FOREIGN KEY (`resource_availability_id`) REFERENCES `resource_availabilities` (`id`),
  ADD CONSTRAINT `FKn37j36nancpcmt0d3p6u9rxfr` FOREIGN KEY (`id`) REFERENCES `bookings` (`id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `FK28an517hrxtt2bsg93uefugrm` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`);

--
-- Constraints for table `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `fk_service_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKryfh22ccvq43d77rj8d6nfrk8` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);

--
-- Constraints for table `service_bookings`
--
ALTER TABLE `service_bookings`
  ADD CONSTRAINT `FK1cyr30xgaheo32v5iha15mvfn` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  ADD CONSTRAINT `FK6t4e5id96v16yj88y4vnipeqp` FOREIGN KEY (`id`) REFERENCES `bookings` (`id`),
  ADD CONSTRAINT `FK9ybrxpcjjmqm7p3lqo1sfrb1e` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKd5s1pkxqucj9g6sxd3djgsyiy` FOREIGN KEY (`business_client_id`) REFERENCES `business_clients` (`id`),
  ADD CONSTRAINT `FKobkxb0byfe0oq2tynu2e85h01` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`);

--
-- Constraints for table `service_ratings`
--
ALTER TABLE `service_ratings`
  ADD CONSTRAINT `FKdlunwaiw7ktcbcr4rvejtjd74` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FKkunckmqok9qmy5c2hbvdj4pmb` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  ADD CONSTRAINT `FKqrgme1bj9kts4vbrsj2xupqdo` FOREIGN KEY (`id`) REFERENCES `ratings` (`id`);

--
-- Constraints for table `service_staff`
--
ALTER TABLE `service_staff`
  ADD CONSTRAINT `FKb3hes1oc5ia6nr0fjvni6kg7j` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  ADD CONSTRAINT `FKdycnsk82nmegdwl9yb4hfja3h` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`);

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `FK5aes4ihkx95t5h3fvhayg940u` FOREIGN KEY (`id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_staff_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);

--
-- Constraints for table `staff_availabilities`
--
ALTER TABLE `staff_availabilities`
  ADD CONSTRAINT `FKrve8emdy0iof8ltpu2cl6goel` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`);

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `FKd75uwj5b3erhwwt5flxnevr7o` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
