<?php
$pageTitle = $title ?? 'Expedition System';
?>
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($pageTitle) ?></title>
    <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body class="bg-gray-100 p-6">
<main class="paper-container">
    <?= $content ?>
</main>
</body>
</html>
