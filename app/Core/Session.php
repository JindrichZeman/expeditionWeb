<?php
/**
 * Session.php - Správa přihlášení a flash zpráv
 */

namespace App\Core;

class Session
{
    public static function start(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }

    /**
     * Vrátí přihlášeného uživatele (nebo null)
     */
    public static function getUser(): ?array
    {
        self::start();
        return $_SESSION['user'] ?? null;
    }

    /**
     * Přihlášení uživatele
     */
    public static function login(array $user): void
    {
        self::start();
        $_SESSION['user'] = $user;
    }

    /**
     * Odhlášení uživatele
     */
    public static function logout(): void
    {
        self::start();
        unset($_SESSION['user']);
        session_destroy();
    }

    /**
     * Kontrola, zda je uživatel přihlášen
     */
    public static function isLoggedIn(): bool
    {
        return self::getUser() !== null;
    }

    /**
     * Vrátí roli přihlášeného uživatele
     */
    public static function getUserRole(): ?int
    {
        $user = self::getUser();
        return $user['role_id'] ?? null;
    }

    /**
     * Zkontroluje, zda má uživatel určitou roli
     */
    public static function hasRole(int $role_id): bool
    {
        return self::getUserRole() === $role_id;
    }

    /**
     * Flash zpráva - uloží ji do session
     */
    public static function setFlash(string $type, string $message): void
    {
        self::start();
        $_SESSION['flash'] = ['type' => $type, 'message' => $message];
    }

    /**
     * Vrátí a smaže flash zprávu
     */
    public static function getFlash(): ?array
    {
        self::start();
        $flash = $_SESSION['flash'] ?? null;
        unset($_SESSION['flash']);
        return $flash;
    }

    /**
     * Ochrana proti CSRF - vrátí token
     */
    public static function getCsrfToken(): string
    {
        self::start();
        if (!isset($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }

    /**
     * Ověří CSRF token
     */
    public static function validateCsrfToken(string $token): bool
    {
        self::start();
        return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
    }
}
?>