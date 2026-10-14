<?php

require_once __DIR__ . "/../vendor/autoload.php";
use App\Core\Router;
use App\Core\Session;

Session::start();

$router = new Router();
$router->post("/register", "AuthController", "handleRegister");

$router->get("/", "UserController", "index");
$router->get("/register", "AuthController", "showRegister");
$router->dispatch();