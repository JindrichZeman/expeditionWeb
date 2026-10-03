<?php
/**
 * Router.php - Jednoduché URL routování
 */

namespace App\Core;

class Router
{
    private array $routes = [];
    private string $currentRoute = '';
    private array $params = [];

    /**
     * Registruje GET trasu
     */
    public function get(string $path, string $controller, string $action): void
    {
        $this->routes['GET'][$path] = ['controller' => $controller, 'action' => $action];
    }

    /**
     * Registruje POST trasu
     */
    public function post(string $path, string $controller, string $action): void
    {
        $this->routes['POST'][$path] = ['controller' => $controller, 'action' => $action];
    }

    /**
     * Určí aktuální trasu a spustí controller
     */
    public function dispatch(): void
    {
        $method = $_SERVER['REQUEST_METHOD'];
        $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

        // Odstraň prefix /app/public z cesty
        //$path = str_replace('/app/public', '', $path);
        if (empty($path)) {
            $path = '/';
        }

        // Hledej trasu v tabulce
        $route = $this->routes[$method][$path] ?? null;

        if (!$route) {
            // Pokud přesná cesta neexistuje, zkus home
            if ($path === '/' && isset($this->routes[$method]['/'])) {
                $route = $this->routes[$method]['/'];
            } else {
                http_response_code(404);
                die("404 - Stránka nenalezena");
            }
        }

        // Vytvoř controller a zavolej akci
        $controllerClass = "App\\Controllers\\" . $route['controller'];
        $action = $route['action'];

        if (!class_exists($controllerClass)) {
            die("Controller $controllerClass neexistuje");
        }

        $controller = new $controllerClass();

        if (!method_exists($controller, $action)) {
            die("Akce $action neexistuje v $controllerClass");
        }

        $controller->$action();
    }
}
?>