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
<body class="bg-paper-back">
    <!--Navbar-->
    <nav class="mb-8 border-b-2">
        <div class="flex">
            <h2 class="text-secret-color text-3xl p-4 font-serif font-black tracking-widest">TOP SECRET // NASA ARCHIVE</h2>
        </div>
    </nav>
<main class="paper-container">
    <?= $content ?>
</main>
</body>
</html>
