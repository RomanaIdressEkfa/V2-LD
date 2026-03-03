-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20250715.4ccd84bc02
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Mar 03, 2026 at 06:30 AM
-- Server version: 5.7.39
-- PHP Version: 8.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `laravel`
--

-- --------------------------------------------------------

--
-- Table structure for table `arguments`
--

CREATE TABLE `arguments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `debate_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `side` enum('pro','con') COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `reply_type` enum('agree','disagree','neutral') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'neutral',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `attachment_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachment_audio` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachment_video` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attachment_doc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `arguments`
--

INSERT INTO `arguments` (`id`, `debate_id`, `user_id`, `side`, `body`, `parent_id`, `reply_type`, `created_at`, `updated_at`, `attachment_image`, `attachment_audio`, `attachment_video`, `attachment_doc`) VALUES
(39, 2, 1, 'pro', 'Hiiii 1', NULL, 'neutral', '2026-03-02 23:54:59', '2026-03-02 23:54:59', NULL, NULL, NULL, NULL),
(40, 2, 1, 'pro', 'Hiii 2', NULL, 'neutral', '2026-03-02 23:55:15', '2026-03-02 23:55:15', NULL, NULL, NULL, NULL),
(41, 2, 1, 'pro', 'ghfhgfhgfjh', 39, 'agree', '2026-03-03 00:06:31', '2026-03-03 00:06:31', NULL, NULL, NULL, NULL),
(42, 2, 1, 'con', 'dhfghfhgfjhdgdf', NULL, 'neutral', '2026-03-03 00:08:03', '2026-03-03 00:08:03', NULL, NULL, NULL, NULL),
(43, 2, 1, 'con', '<p>look my video</p>', NULL, 'neutral', '2026-03-03 00:15:32', '2026-03-03 00:15:32', NULL, NULL, NULL, NULL),
(44, 2, 1, 'pro', '<p>image</p>', NULL, 'neutral', '2026-03-03 00:20:54', '2026-03-03 00:20:54', NULL, NULL, NULL, NULL),
(45, 2, 1, 'pro', '', 44, 'agree', '2026-03-03 00:21:08', '2026-03-03 00:21:08', NULL, NULL, NULL, NULL),
(46, 2, 1, 'pro', '', 45, 'agree', '2026-03-03 00:23:47', '2026-03-03 00:23:47', 'uploads/images/g6fwl69L2dVjNSilaJBaGSY3R0lpIeyRg7q5jme2.jpg', NULL, NULL, NULL),
(47, 2, 1, 'pro', '<p>assdad</p>', 42, 'disagree', '2026-03-03 00:24:54', '2026-03-03 00:24:54', 'uploads/images/NeYwjB94z6Erziz15XFi7GcHsZhPtUaOApJvkDm9.jpg', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-logicallydebate@gmail.com|127.0.0.1', 'i:1;', 1770025917),
('laravel-cache-logicallydebate@gmail.com|127.0.0.1:timer', 'i:1770025917;', 1770025917);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `debates`
--

CREATE TABLE `debates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_participants` int(11) DEFAULT NULL,
  `status` enum('active','closed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `winner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `debates`
--

INSERT INTO `debates` (`id`, `title`, `description`, `max_participants`, `status`, `winner_id`, `created_at`, `updated_at`) VALUES
(2, 'Is the Quran the latest, unchanged and true holy book?', 'Is the Quran the latest, unchanged and true holy book?', 2, 'active', NULL, '2026-02-02 02:07:19', '2026-02-02 05:56:41');

-- --------------------------------------------------------

--
-- Table structure for table `debate_participants`
--

CREATE TABLE `debate_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `debate_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `side` enum('pro','con') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `debate_participants`
--

INSERT INTO `debate_participants` (`id`, `debate_id`, `user_id`, `side`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'pro', '2026-02-07 00:54:42', '2026-02-07 00:54:42'),
(2, 2, 3, 'con', '2026-02-08 00:03:21', '2026-02-08 00:03:21'),
(3, 2, 4, 'pro', '2026-02-09 03:47:19', '2026-02-09 03:47:19'),
(4, 2, 5, 'con', '2026-02-13 22:01:41', '2026-02-13 22:01:41');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_02_02_055623_create_debates_table', 1),
(5, '2026_02_02_055635_create_arguments_table', 1),
(6, '2026_02_02_055641_create_votes_table', 1),
(7, '2026_02_02_110200_create_debate_participants_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('3TQG27WhWxTIC8RyoLjBRbnpoZcFroIkAL5yH95z', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiZVNEYlpGaWJ0QUNCWnJ4ek5jQWJRbzlaZjdBT0Q5Z1FkakNoWXU0SSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHA6Ly9sb2dpYy1kZWJhdGUudGVzdCI7czo1OiJyb3V0ZSI7czo0OiJob21lIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7fQ==', 1772260143),
('PZpsn3cQrVWjNyGkkfcnKIVC6TYrJUQtuVr98h8d', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiSHZvR1NLMTUybG1NVkQ0QzFnbVRBRDdDeGt4ZUduRjlhUlp5MEtOaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9sb2dpYy1kZWJhdGUudGVzdC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6MzoidXJsIjthOjE6e3M6ODoiaW50ZW5kZWQiO3M6MjU6Imh0dHA6Ly9sb2dpYy1kZWJhdGUudGVzdC8iO319', 1772261509),
('SzkHIg6bC9zD9dw8VCqfwjixPVmFVoTjcuZleVMt', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiN3d6RXVoSFhrd29DUzN4WmI4ZjVCaW9mM0xwcm1wdnlBSGxDVDY1TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHA6Ly9sb2dpYy1kZWJhdGUudGVzdCI7czo1OiJyb3V0ZSI7czo0OiJob21lIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7fQ==', 1772519095),
('X0D5oiOpfiDNi1w6l16OXFbxyMWdL8KOt6C5GLMN', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieFprVkRIVHBpZkd6YUxpUVNqSjRpSWx2SkxWdkxheXViQVQ0aVljUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHA6Ly9sb2dpYy1kZWJhdGUudGVzdCI7czo1OiJyb3V0ZSI7czo0OiJob21lIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772515331);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `avatar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`, `avatar`) VALUES
(1, 'Logically Debate Admin', 'admin@gmail.com', '2026-02-02 00:06:17', '$2y$12$FEoB0/q7h.DWK3Et6q1mc.GtZ/CpXaNnc.IdbFmTw8PJFySzfn3rG', 'admin', 'v4RyfcbvRyqnK7ZF8xBQnjRz2IIe0H7slqbXVyfWSnam50qQbgpPiKcVZKHN', '2026-02-02 00:06:18', '2026-02-02 00:06:18', NULL),
(2, 'Romana Idress Ekfa', 'logicallydebate@gmail.com', NULL, '$2y$12$.YXnYTHRKvuB.zUX5EIrXuesAf88vuKIc.SU6P3UwiTuRFIXhWyB2', 'user', NULL, '2026-02-02 00:07:58', '2026-02-02 00:07:58', NULL),
(3, 'Romana Idress Ekfa', 'romana-idress-ekfa_1770530600@guest.com', NULL, '$2y$12$mkEI4mKhHsFo4EFPfson8OBgJrUr6ooYqtOvjOAP20mWrwjRAb/D2', 'user', 'IzfIuvrnbeErcXi6KCh42UpBsSeY97lEyU82oMqOfX14gQcmndpbH7EadhCS', '2026-02-08 00:03:21', '2026-02-08 00:03:21', 'avatars/NLfz57GjwC6TzEUhphxhTNLysR24AwRjknJa98F5.jpg'),
(4, 'test', 'test@gmail.com', NULL, '$2y$12$2dShxgA9EnG/DDNv8jLQYOuPKsG5HW7/BgbfEv7fK6CKq95f1oRKC', 'user', 'OXyGfUZjc7dqQvnvzJiyysmwCeGLYVkuGfNAdlmMD6iiJ2XZllkfS3a3KgyA', '2026-02-09 03:47:19', '2026-02-09 03:47:19', 'avatars/RgoupbWF3A8bL6LYTvnFQWShQivuzm8ZYjzI7UHo.webp'),
(5, 'x', 'x@gmail.com', NULL, '$2y$12$kC/xH0HKBeE5kl5Ni8JdQ.8ci8Vr2jDN8wTeG5HRmYegUPC4G28.6', 'user', 'dQD9lJWJVKWkcUpX5ZopLuK9Dw3HWdaTV6EkDxJvDGkLOZBO7JLNP3ck9VwN', '2026-02-13 22:01:41', '2026-02-13 22:01:41', 'avatars/OiYWFipyDsqHwqesub6q0cwFo3oZY7oswE1qpGtl.png');

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `argument_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('agree','disagree') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `votes`
--

INSERT INTO `votes` (`id`, `user_id`, `argument_id`, `type`, `created_at`, `updated_at`) VALUES
(21, 1, 42, 'agree', '2026-03-03 00:14:57', '2026-03-03 00:14:57'),
(23, 1, 41, 'agree', '2026-03-03 00:15:01', '2026-03-03 00:15:01'),
(25, 1, 40, 'agree', '2026-03-03 00:15:05', '2026-03-03 00:15:05'),
(26, 1, 39, 'agree', '2026-03-03 00:20:31', '2026-03-03 00:20:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `arguments`
--
ALTER TABLE `arguments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `arguments_debate_id_foreign` (`debate_id`),
  ADD KEY `arguments_user_id_foreign` (`user_id`),
  ADD KEY `arguments_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `debates`
--
ALTER TABLE `debates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `debate_participants`
--
ALTER TABLE `debate_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `debate_participants_debate_id_user_id_unique` (`debate_id`,`user_id`),
  ADD KEY `debate_participants_user_id_foreign` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `votes`
--
ALTER TABLE `votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `votes_user_id_argument_id_unique` (`user_id`,`argument_id`),
  ADD KEY `votes_argument_id_foreign` (`argument_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `arguments`
--
ALTER TABLE `arguments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `debates`
--
ALTER TABLE `debates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `debate_participants`
--
ALTER TABLE `debate_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `votes`
--
ALTER TABLE `votes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `arguments`
--
ALTER TABLE `arguments`
  ADD CONSTRAINT `arguments_debate_id_foreign` FOREIGN KEY (`debate_id`) REFERENCES `debates` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `arguments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `arguments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `arguments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `debate_participants`
--
ALTER TABLE `debate_participants`
  ADD CONSTRAINT `debate_participants_debate_id_foreign` FOREIGN KEY (`debate_id`) REFERENCES `debates` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `debate_participants_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `votes`
--
ALTER TABLE `votes`
  ADD CONSTRAINT `votes_argument_id_foreign` FOREIGN KEY (`argument_id`) REFERENCES `arguments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `votes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
