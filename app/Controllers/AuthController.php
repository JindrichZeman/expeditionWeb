<?php
namespace App\Controllers;

use App\Core\BaseController;
use App\Models\UserModel;

class AuthController extends BaseController {
    public function showRegister()
    {
        $this->render('auth/register', [
            "title" => "Registrace nového průzkumníka"
        ]);
    }
}
