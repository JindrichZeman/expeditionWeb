<?php
/**
 * BaseController.php - Základní třída všech controllerů
 */

namespace App\Core;

class BaseController
{
    protected array $data = [];

    /**
     * Renderuje view šablonu
     */
    protected function render(string $view, array $data = []): void
    {
        $this->data = array_merge($this->data, $data);
        $viewPath = __DIR__ . '/../Views/' . $view . '.php';

        if (!file_exists($viewPath)) {
            die("View $view nenalezen");
        }

        extract($this->data);
        ob_start();
        require $viewPath;
        $content = ob_get_clean();
        require __DIR__ . '/../Views/layouts/main.php';
    }

    /**
     * Redirect na jinou URL
     */
    protected function redirect(string $url): void
    {
        header("Location: $url");
        exit;
    }

    /**
     * JSON response
     */
    protected function json(array $data, int $statusCode = 200): void
    {
        header('Content-Type: application/json');
        http_response_code($statusCode);
        echo json_encode($data);
        exit;
    }
}