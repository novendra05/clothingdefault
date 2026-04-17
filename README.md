# Force Default Clothing (Qbox)

Script sederhana untuk memaksa pemain menggunakan pakaian default saat pertama kali login dan memberikan tampilan pakaian default pada menu pemilihan karakter (multicharacter).

## Fitur
- **Reset Pakaian Saat Spawn**: Pemain akan otomatis menggunakan baju default setelah login/spawn.
- **Multicharacter Preview**: Karakter di menu pemilihan akan selalu tampil dengan baju default, bukan baju terakhir yang mereka pakai.
- **Dukungan Gender**: Mendukung pengaturan pakaian berbeda untuk model `mp_m_freemode_01` (pria) dan `mp_f_freemode_01` (wanita).

## Persyaratan
- [qbx_core](https://github.com/Qbox-Project/qbx_core)
- [illenium-appearance](https://github.com/iLLENIUM-Studios/illenium-appearance)
- [ox_lib](https://github.com/overextended/ox_lib)

## Instalasi

1. Masukkan folder `force-default-clothing` ke dalam folder `resources` Anda.
2. Tambahkan `ensure force-default-clothing` ke dalam `server.cfg`.
3. **PENTING**: Untuk mengaktifkan fitur preview di menu pemilihan karakter, Anda harus memodifikasi `qbx_core` secara manual:

### Modifikasi qbx_core
Buka file `resources/[qbx]/qbx_core/client/character.lua`, lalu cari fungsi `previewPed` dan ubah isinya menjadi:

```lua
local function previewPed(citizenId)
    if not citizenId then randomPed() return end

    local clothing, model = lib.callback.await('qbx_core:server:getPreviewPedData', false, citizenId)
    if model and clothing then
        lib.requestModel(model, config.loadingModelsTimeout)
        SetPlayerModel(cache.playerId, model)

        local appearance = json.decode(clothing)

        -- Tambahkan Logika Override Pakaian Default
        if GetResourceState('force-default-clothing') == 'started' then
            local defaults = exports['force-default-clothing']:GetInitialClothes()
            local gender = model == `mp_f_freemode_01` and 'Female' or 'Male'
            if defaults[gender] then
                appearance.components = defaults[gender].Components
                appearance.props = defaults[gender].Props
            end
        end

        pcall(function() exports['illenium-appearance']:setPedAppearance(PlayerPedId(), appearance) end)
        SetModelAsNoLongerNeeded(model)
    else
        randomPed()
    end
end
```

## Konfigurasi
Anda dapat mengubah jenis pakaian default di file `client.lua` pada tabel `initialClothes`:

```lua
local initialClothes = {
    Male = {
        Components = { ... },
        Props = { ... }
    },
    Female = {
        Components = { ... },
        Props = { ... }
    }
}
```

## Kredit
Dibuat untuk kebutuhan server Qbox Project.
