<?php
namespace App\Models;

use App\Core\BaseModel;
use http\Encoding\Stream\Inflate;

class UserModel extends BaseModel
{
    // propojení s tabulkou v databázi
    protected string $table = "USERS";

    public function findByLogin(string $login): ?array
    {
        $sql = "SELECT * FROM `{$this->table}` WHERE login = :login";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(["login" => $login]);

        $result = $stmt->fetch();
        return $result ?: null;
    }
}