--[[
    PoC: ChangeColour RemoteEvent Abuse

    Context:
    No modo corrida, o jogador pode alterar a aparência/cor do carro
    através da interface do jogo.

    This PoC:
    - Acessa o RemoteEvent responsável pela alteração de cor.
    - Envia valores Color3 continuamente.
    - Gera um efeito visual de arco-íris no veículo.
    - Demonstra que o RemoteEvent pode ser acionado repetidamente
      pelo cliente.

    Observação:
    Durante os testes, o efeito observado foi apenas visual/FE.
    Não foi observado impacto perceptível no servidor ou em outros
    jogadores próximos.

    Tools:
    - Roblox
    - Luau
    - Xeno
]]

local targetRemote =
    workspace.VehicleFolder.EiLouissCar.Colour.ColourScript.ChangeColour

-- Controle do loop. Defina como false para interromper a execução.
local running = true

print("[PoC] ChangeColour RemoteEvent test started.")

-- Converte um valor de Hue em uma cor Color3.
-- Saturação e brilho permanecem no máximo para produzir
-- um efeito de arco-íris mais evidente.
local function getRainbowColor(hue)
    return Color3.fromHSV(hue, 1, 1)
end

local hue = 0

while running do
    pcall(function()
        local color = getRainbowColor(hue)

        -- Envia a cor ao servidor através do RemoteEvent.
        targetRemote:FireServer(color)
    end)

    -- Avança pelo espectro de cores.
    hue += 0.05

    -- Reinicia o ciclo quando o Hue chega ao final do espectro.
    if hue > 1 then
        hue = 0
    end

    -- Aguarda o próximo ciclo.
    task.wait()
end

print("[PoC] ChangeColour RemoteEvent test stopped.")