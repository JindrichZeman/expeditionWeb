<div class="mb-6 border-b border-gray-400 pb-4 flex justify-between items-center">
    <h2 class="font-mono text-2xl font-bold uppercase tracking-wide">Databáze personálu</h2>
    <span class="font-mono text-xs bg-gray-200 px-2 py-1">SEKTOR: ARCHIV</span>
</div>

<div class="bg-white border border-gray-300 shadow-sm overflow-x-auto">
    <table class="w-full text-left border-collapse">
        <thead>
        <tr class="bg-gray-100 border-b border-gray-300 font-mono text-sm uppercase text-gray-700">
            <th class="p-3 border-r border-gray-200">ID</th>
            <th class="p-3 border-r border-gray-200">Uživatelské jméno (Login)</th>
            <th class="p-3">Oprávnění (Role ID)</th>
        </tr>
        </thead>
        <tbody>
        <?php if (empty($users)): ?>
            <tr>
                <td colspan="3" class="p-6 text-center font-mono text-gray-500 italic">
                    Žádní uživatelé v databázi nenalezeni.
                </td>
            </tr>
        <?php else: ?>
            <?php foreach ($users as $user): ?>
                <tr class="border-b border-gray-200 hover:bg-gray-50">
                    <td class="p-3 font-mono border-r border-gray-200 text-gray-600">
                        #<?= htmlspecialchars((string) $user['user_id']) ?>
                    </td>
                    <td class="p-3 font-bold font-sans border-r border-gray-200">
                        <?= htmlspecialchars($user['login']) ?>
                    </td>
                    <td class="p-3 font-mono">
                        <?= $user['role_id'] ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php endif; ?>
        </tbody>
    </table>
</div>