function SpawnVehicle_Menu( ply )
	
	local Frame = vgui.Create( "DFrame" )
	Frame:SetTitle("Buy Vehicles!")
	Frame:SetSize( ScrW() * 0.073, ScrH() * (0.12 * #RP.Vehicles) )
	Frame:Center()
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:SetSizable( false )
	Frame:ShowCloseButton ( false )
	Frame:MakePopup()
	
	for k,v in ipairs(RP.Vehicles) do
		local Icon = vgui.Create( "DImageButton", Frame)
		Icon:SetPos( ScrW() * 0.008, ScrH() * 0.01 + (k*(ScrH() * 0.1)) - (ScrH() * 0.07) )
		Icon:SetSize(ScrW() * 0.06, ScrH() * 0.08 )
		Icon:SetImage( v.icon )
		Icon:SetToolTip( "$".. v.cost )
		Icon.DoClick = function()
			RunConsoleCommand("rp_vehiclespawn", v.name )
		end
	end

	
	function RP_CloseSpawnMenu()
		if LocalPlayer():Team() == 3 then
			gui.SetMousePos( ScrW(), ScrH() )
			timer.Simple(0.1,function()
				if Frame:IsValid() then
					Frame:Close()
				end
				timer.Simple(0.1,function()
					gui.SetMousePos( ScrW()/2, ScrH()/2 )
				end)
			end)
		end
	end
	
	hook.Add( "OnSpawnMenuClose", "RP_CloseSpawnMenu", RP_CloseSpawnMenu)
	hook.Add( "OnContextMenuClose", "RP_CloseSpawnMenu", RP_CloseSpawnMenu)
end