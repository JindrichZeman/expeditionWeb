<?php
/**
 * BaseModel.php - Základní třída všech modelů
 */

namespace App\Core;

use PDO;

class BaseModel
{
    protected Database $db;
    protected string $table = '';

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    /**
     * Vrátí všechny záznamy
     */
    public function findAll(): array
    {
        $sql = "SELECT * FROM `{$this->table}`";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
     * Vrátí jeden záznam podle ID
     */
    public function findById(int $id): ?array
    {
        $sql = "SELECT * FROM `{$this->table}` WHERE id = :id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['id' => $id]);
        $result = $stmt->fetch();
        return $result ?: null;
    }

    /**
     * Vloží nový záznam
     */
    public function insert(array $data): int
    {
        $columns = implode(', ', array_map(fn($col) => "`$col`", array_keys($data)));
        $placeholders = implode(', ', array_map(fn($col) => ":$col", array_keys($data)));

        $sql = "INSERT INTO `{$this->table}` ($columns) VALUES ($placeholders)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute($data);

        return (int)$this->db->lastInsertId();
    }

    /**
     * Aktualizuje záznam
     */
    public function update(int $id, array $data): bool
    {
        $sets = implode(', ', array_map(fn($col) => "`$col` = :$col", array_keys($data)));
        $sql = "UPDATE `{$this->table}` SET $sets WHERE id = :id";

        $data['id'] = $id;
        $stmt = $this->db->prepare($sql);

        return $stmt->execute($data);
    }

    /**
     * Smaže záznam
     */
    public function delete(int $id): bool
    {
        $sql = "DELETE FROM `{$this->table}` WHERE id = :id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute(['id' => $id]);
    }
}