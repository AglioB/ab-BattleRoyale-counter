Config = {}

Config.Framework = 'ESX' -- 'QBCore' or 'ESX'

Config.Int = {
    npc = {
        Name = "NPC_CONTADOR",
        model = "a_m_y_acult_02",
        hash = 0x80e59f2e,
        message = "Pulsa E para teletransportarte",
        x = 146.37,
        y = 199.2,
        z = 106.55,
        h = 98.50
    },
    tp = {
        TpEnter = vector3(148.82, 189.57, 106.33), -- Coords to tp player when interact with npc
        TpDie = vector3(154.14, 194.7, 106.24) -- coords to tp player when his die
    },
    notify = {
        CantJoinAgain = 'Ya no puedes unirte a esta actividad'
    }
}
