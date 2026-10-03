<?php
namespace App\Controllers;

use App\Core\BaseController;
use App\Models\UserModel;

class UserController extends BaseController
{
    public function index()
    {
        // 1. Vytvoříme instanci našeho UserModelu
        $userModel = new UserModel();

        // 2. Vytáhneme všechny uživatele z databáze (využívá děděný findAll z BaseModel)
        $users = $userModel->findAll();

        // 3. Pošleme data do View šablony
        $this->render('users/index', [
            'title' => 'Seznam personálu',
            'users' => $users
        ]);
    }
}