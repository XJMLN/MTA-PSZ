local modele={
--  [id_modelu]=true,
    [1223]=true,
    [3261]=true,
    [1226]=true,
	[996]=true,
    [1231]=true,
    [1232]=true,
    [1283]=true,
    [1284]=true,
    [1290]=true,
    [1294]=true,
    [1297]=true,
    [1298]=true,
    [1315]=true,
    [1350]=true,
    [1351]=true,
    [1352]=true,
    [2618]=true,
    [3460]=true,
    [3463]=true,
    [3853]=true,
    [3855]=true,
	[3698]=true,
    [1232]=true,
    [1346]=true,
    [1481]=true,	--grill
    [1451]=true,
}
setTimer(function()
  for i,v in ipairs(getElementsByType("object", root)) do
   if modele[getElementModel(v)] then
    setObjectBreakable(v,false)
    setElementFrozen(v,true)
   end
  end
end, 60000, 1)
