-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cVRP = {}
Tunnel.bindInterface("rotas",cVRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cVRP.checkPermission()
    local source = source
    local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"Vanilla") or vRP.hasPermission(user_id,"Arcade") then
        return true
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cVRP.paymentMethod()
    local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.inventoryWeight(user_id) + 1 > vRP.getWeight(user_id) then
			TriggerClientEvent("Notify",source,"vermelho","A sua Mochila está cheia.",5000)
		return false
		else
			if vRP.hasPermission(user_id,"Vanilla") or vRP.hasPermission(user_id,"Arcade") then
				local consultItem = vRP.getInventoryItemAmount(user_id,"dollars2")
				if consultItem[1] <= 0 then
					TriggerClientEvent("Notify",source,"vermelho","Você não possui Malote Desmarcado",5000)
					return false
				end

				if vRP.tryGetInventoryItem(user_id,consultItem[2],1,true) then
					vRP.generateItem(user_id,"dollars",10000,true)
					vRP.antiflood(source,"paymentMethod",3)
					return true
				end
			end
		end
	end
end
