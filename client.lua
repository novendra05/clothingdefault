local initialClothes = {
    Male = {
        Model = `mp_m_freemode_01`,
        Components = {
            { component_id = 0, drawable = 0, texture = 0 }, -- Face
            { component_id = 1, drawable = 0, texture = 0 }, -- Mask
            { component_id = 3, drawable = 0, texture = 0 }, -- Upper Body / Arms
            { component_id = 4, drawable = 22, texture = 0 }, -- Lower Body / Pants
            { component_id = 6, drawable = 16, texture = 0 }, -- Shoes
            { component_id = 8, drawable = 15, texture = 0 }, -- Shirt
            { component_id = 11, drawable = 1, texture = 0 }, -- Jacket
        },
        Props = {
            { prop_id = 0, drawable = -1, texture = 0 }, -- Hat
            { prop_id = 1, drawable = -1, texture = 0 }, -- Glass
            { prop_id = 2, drawable = -1, texture = 0 }, -- Ear
            { prop_id = 6, drawable = -1, texture = 0 }, -- Watch
            { prop_id = 7, drawable = -1, texture = 0 }, -- Bracelet
        }
    },
    Female = {
        Model = `mp_f_freemode_01`,
        Components = {
            { component_id = 0, drawable = 0, texture = 0 }, -- Face
            { component_id = 1, drawable = 0, texture = 0 }, -- Mask
            { component_id = 3, drawable = 0, texture = 0 }, -- Upper Body / Arms
            { component_id = 4, drawable = 25, texture = 0 }, -- Lower Body / Pants
            { component_id = 6, drawable = 15, texture = 0 }, -- Shoes
            { component_id = 8, drawable = 15, texture = 0 }, -- Shirt
            { component_id = 11, drawable = 0, texture = 15 }, -- Jacket
        },
        Props = {
            { prop_id = 0, drawable = -1, texture = 0 }, -- Hat
            { prop_id = 1, drawable = -1, texture = 0 }, -- Glass
            { prop_id = 2, drawable = -1, texture = 0 }, -- Ear
            { prop_id = 6, drawable = -1, texture = 0 }, -- Watch
            { prop_id = 7, drawable = -1, texture = 0 }, -- Bracelet
        }
    }
}

-- Debug print saat script pertama kali jalan

-- Fungsi utama untuk mereset pakaian
local function ResetToDefault()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    local gender = 'Male'
    
    if model == `mp_f_freemode_01` then
        gender = 'Female'
    end

    local data = initialClothes[gender]
    
   

    -- Pastikan export tersedia
    if GetResourceState('illenium-appearance') ~= 'started' then
        return print('^1[force-default-clothing] ERROR: illenium-appearance belum jalan!^7')
    end

    -- Menggunakan export illenium-appearance untuk mengubah pakaian
    exports['illenium-appearance']:setPedComponents(ped, data.Components)
    -- exports['illenium-appearance']:setPedProps(ped, data.Props) -- Opsional jika ingin prop dipaksa juga
    
    -- Kita tidak perlu saveAppearance di sini karena sudah ditangani di server illenium-appearance
    -- TriggerServerEvent('illenium-appearance:server:saveAppearance', appearance)
    
 
end

-- Hook saat player masuk (spawn) - Coba beberapa event populer di Qbox/QBCore
local function onPlayerLoaded()
    Wait(600) -- Menaikkan ke 7 detik agar lebih pasti
    ResetToDefault()
end

RegisterNetEvent('qbx_core:client:playerLoaded', onPlayerLoaded)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', onPlayerLoaded)

-- Cek jika script direstart saat player sudah di dalam server
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if LocalPlayer.state.isLoggedIn then
        print('^3[force-default-clothing] Player sudah login saat script start, mereset...^7')
        ResetToDefault()
    end
end)

-- Command untuk tes manual (Opsional)
-- RegisterCommand('resetbaju', function()
--     ResetToDefault()
--     lib.notify({
--         title = 'Default Clothing',
--         description = 'Baju Anda telah dikembalikan ke default.',
--         type = 'inform'
--     })
-- end, false)

exports('GetInitialClothes', function()
    return initialClothes
end)
