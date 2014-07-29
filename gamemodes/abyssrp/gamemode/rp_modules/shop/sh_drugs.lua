RP.Drugs={}

function RP:AddDrug(t)
	local n = #RP.Drugs+1
	RP.Drugs[n]=table.Copy(t)
end

-- Drugs

RP:AddDrug({
	name="Alcohol",
	class="durgz_alcohol",
	model="models/drug_mod/alcohol_can.mdl",
	cost=25
})

RP:AddDrug({
	name="Aspirin",
	class="durgz_aspirin",
	model="models/jaanus/aspbtl.mdl",
	cost=110
})

RP:AddDrug({
	name="Cigarette",
	class="durgz_cigarette",
	model="models/boxopencigshib.mdl",
	cost=30
})

RP:AddDrug({
	name="Cocaine",
	class="durgz_cocaine",
	model="models/cocn.mdl",
	cost=225
})

RP:AddDrug({
	name="Heroine",
	class="durgz_heroine",
	model="models/katharsmodels/syringe_out/syringe_out.mdl",
	cost=45
})

RP:AddDrug({
	name="LSD",
	class="durgz_lsd",
	model="models/smile/smile.mdl",
	cost=45
})

RP:AddDrug({
	name="Mushroom",
	class="durgz_mushroom",
	model="models/ipha/mushroom_small.mdl",
	cost=45
})

RP:AddDrug({
	name="PCP",
	class="durgz_pcp",
	model="models/marioragdoll/Super Mario Galaxy/star/star.mdl",
	cost=35
})

RP:AddDrug({
	name="Water",
	class="durgz_water",
	model="models/drug_mod/the_bottle_of_water.mdl",
	cost=5
})

RP:AddDrug({
	name="Weed",
	class="durgz_weed",
	model="models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
	cost=175
})

-- Shop

RP:AddShop({
	uid="drug",
	name="Drugs",
	column="Drug",
	tbl=RP.Drugs,
	view=function(p)
		local mins,maxs = p.Entity:GetRenderBounds()
		p:SetCamPos(mins:Distance(maxs)*Vector(1,1,1))
		p:SetLookAt((maxs + mins)/2)
	end
})

if CLIENT then
	hook.Add("RP-Menu", "RP-Drugs", function(sheet,x,y)
		if not (LocalPlayer():Team()==RP:GetTeamN("black market dealer")) then return end
		RP:OpenShop(sheet,x,y,"drug")
	end)
end