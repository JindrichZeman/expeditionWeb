<?php
namespace App\Controllers;

use App\Core\BaseController;
use App\Models\UserModel;
use MongoDB\Driver\Session;

class AuthController extends BaseController {
    public function showRegister()
    {
        $this->render('auth/register', [
            "title" => "Registrace nového průzkumníka"
        ]);
    }

    public function handleRegister()
    {
        //Ověření CSFR tokenu
        if (!Session::validateCSFRToken($_POST['csfr_token'] ?? '')) {
            Session::setFlash('error', 'Neplatný token.');
            $this->redirect('/register');
        }

        $userFirstName = trim($_POST['userFirstName'] ?? '');
        $userLastName = trim($_POST['userLastName'] ?? '');
        $userFirstName = trim($_POST['userFirstName'] ?? '');
        $login = trim($_POST['login'] ?? '');
        $email = $_POST['email'] ?? '';
        $password = $_POST['password'] ?? '';
        $passwordConfirm = $_POST['passwordConfirm'] ?? '';
    }
}
