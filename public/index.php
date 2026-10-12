<?php

require_once __DIR__ . "/../vendor/autoload.php";
use App\Core\Router;
use App\Core\Session;

Session::start();

$router = new Router();

$router->get("/", "UserController", "index");
$router->dispatch();