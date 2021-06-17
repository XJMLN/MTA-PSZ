GUI_wnd = guiCreateWindow(0.25,0.43,0.50,0.14,"Akceptuj kupno",true)
GUI_lbl = guiCreateLabel(0.02,0.24,0.95,0.17,"Czy napewno chcesz zakupić kamizelkę kuloodporną, za cenę: 235$?",true,GUI_wnd)
GUI_accept = guiCreateButton(0.21,0.51,0.28,0.38,"Kup przedmiot",true,GUI_wnd)
GUI_deny = guiCreateButton(0.52,0.51,0.27,0.38,"Anuluj",true,GUI_wnd)
guiWindowSetSizable(GUI_wnd,false)
guiSetVisible(GUI_wnd,false)
local polki = {
	{307.99,-135.5,998.6, 2.6, 1.85, 2, d=12, i=7}, -- sklep LV
	{307.99,-139,998.6, 2.6, 1.85, 2, d=12, i=7}, -- sklep LV
	{308.00,-138.96,1003.06, 2.6, 1.85, 2, d=12, i=7}, -- sklep LV
	{307.76,-135.39,1003.06, 2.6, 1.85, 2, d=12, i=7}, -- sklep LV
	{307.99,-135.5,998.6, 2.6, 1.85, 2, d=2, i=7}, -- sklep SF
	{307.99,-139,998.6, 2.6, 1.85, 2, d=2, i=7}, -- sklep SF
	{308.00,-138.96,1003.06, 2.6, 1.85, 2, d=2, i=7}, -- sklep SF
	{307.76,-135.39,1003.06, 2.6, 1.85, 2, d=2, i=7}, -- sklep SF
	{307.99,-135.5,998.6, 2.6, 1.85, 2, d=0, i=7}, -- sklep LS
	{307.99,-139,998.6, 2.6, 1.85, 2, d=0, i=7}, -- sklep LS
	{308.00,-138.96,1003.06, 2.6, 1.85, 2, d=0, i=7}, -- sklep LS
	{307.76,-135.39,1003.06, 2.6, 1.85, 2, d=0, i=7}, -- sklep LS
}
for i,v in ipairs(polki) do
	v.polka = createColCuboid(v[1],v[2],v[3],v[4],v[5],v[6])
		setElementData(v.polka,"sklep_ammo",true)
		setElementDimension(v.polka,v.d)
		setElementInterior(v.polka,v.i)
	local rrz=math.rad(tonumber(177)+180)
	local x2= tonumber(v[1] + (2 * math.sin(-rrz)))
	local y2= tonumber(v[2] + (1 * math.cos(-rrz)))
	v.kamizelka = createPickup(x2+1,y2,v[3]+2,3,1242,1,1)
		setElementDimension(v.kamizelka,v.d)
		setElementInterior(v.kamizelka,v.i)
end
addEventHandler("onClientColShapeHit",resourceRoot,function(el, md)
	if (not md) then return end
	if (el~=localPlayer) then return end
	if (getElementInterior(source) ~= getElementInterior(el)) then return end
	if (not getElementData(source,"sklep_ammo")) then return end
	--if getPlayerName(localPlayer) ~="XJMLN" then 
		--outputChatBox("Kupno kamizelki jest aktualnie wyłączone - naprawiamy błąd. :)",255,0,0)
		--return
	--end
	guiSetVisible(GUI_wnd,true)
	toggleControl('fire',false)
	showCursor(true,false)
end)

addEventHandler("onClientColShapeLeave",resourceRoot,function(hitElement,matchindDimension)
 	if (hitElement~=localPlayer or not matchindDimension or getElementInterior(localPlayer)~=getElementInterior(source)) then return end
    guiSetVisible(GUI_wnd,false)
    showCursor(false,false)
    toggleControl('fire',true)
end)

addEventHandler("onClientGUIClick",GUI_accept,function(button)
	triggerServerEvent("onPlayerAcceptTrade",localPlayer,250)
	showCursor(false,false)
	toggleControl('fire',true)
	guiSetVisible(GUI_wnd,false)
end,false)

addEventHandler("onClientGUIClick",GUI_deny,function(button)
	guiSetVisible(GUI_wnd,false)
	toggleControl('fire',true)
	showCursor(false,false)
end,false)