<h1>Registrace</h1>

<?php $flash = \App\Core\Session::getFlash(); ?>
<?php if ($flash): ?>
    <div class="alert <?= $flash['type'] === 'error' ? 'alert-danger' : 'alert-success' ?>">
        <?php htmlspecialchars($flash['message'])?>
    </div>
<?php endif; ?>
<form action="/register" method="POST">
    <div class="flex flex-col gap-4">
        <input type="hidden" name="csrf_token" value="<?= \App\Core\Session::getCsrfToken() ?>">
        <label>Jméno</label>
        <input name="userFirstName" type="text">
        <label>Příjmení</label>
        <input name="userLastName" type="text">
        <label>Přihlašovací jméno (login)</label>
        <input name="login" type="text">
        <label>Email</label>
        <input name="email" type="email">
        <label>Heslo</label>
        <input name="password" type="password">
        <label>Heslo znova</label>
        <input name="passwordConfirm" type="password">
        <button type="submit">Zaregistrovat se</button>
    </div>
</form>