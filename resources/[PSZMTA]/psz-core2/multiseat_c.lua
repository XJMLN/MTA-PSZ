--[[
Multiseat - czesc kliencka
@package PSZMTA.psz-core2

@copyright 2013-2014 AFX <afx@pylife.pl>
@author Wielebny <wielebny@bestplay.pl>

https://github.com/lpiob/MTA-MultiSeat/
]]--

addEventHandler("onClientVehicleEnter", resourceRoot, function(plr, seat, door)
  if plr~=localPlayer then return end
  if getElementModel(source)~=441 then return end
  setCameraViewMode(5)
end)