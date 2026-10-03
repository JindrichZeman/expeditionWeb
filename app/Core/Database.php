<?php
namespace App\Core;

use PDO;
use PDOException;

class Database
{
    private static ?Database $instance = null;
    private PDO $pdo;

    private function __construct()
    {
        try {
            $dsn = sprintf(
                'mysql:host=%s;dbname=%s;charset=utf8mb4',
                $_ENV['DB_HOST'] ?? 'mariadb',
                $_ENV['DB_NAME'] ?? 'expedition_db'
            );

            $this->pdo = new PDO(
                $dsn,
                $_ENV['DB_USER'] ?? 'expedition_user',
                $_ENV['DB_PASS'] ?? 'expedition_password',
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ]
            );
        } catch (PDOException $e) {
            die("Chyba připojení k databázi: " . $e->getMessage());
        }
    }

    /**
     * Singleton - vrátí jedinou instanci
     */
    public static function getInstance(): Database
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Vrátí PDO objekt pro přímé dotazy
     */
    public function getConnection(): PDO
    {
        return $this->pdo;
    }

    /**
     * Připraví a spustí dotaz s Prepared Statements
     */
    public function prepare(string $sql)
    {
        return $this->pdo->prepare($sql);
    }

    /**
     * Spustí dotaz bez parametrů
     */
    public function query(string $sql)
    {
        return $this->pdo->query($sql);
    }

    /**
     * Vrátí poslední vložené ID
     */
    public function lastInsertId(): string
    {
        return $this->pdo->lastInsertId();
    }

    /**
     * Zabránění klonování
     */
    private function __clone() {}

    /**
     * Zabránění unserialize
     */
    public function __wakeup() {}
}
?>