-- [ОКОНЧАТЕЛЬНАЯ ДИРЕКТИВА: ИНЖЕКТОР DEX + OMNI-EXPLOIT]
-- Цель: Запустить DEX Explorer (предоставленный код) и затем OMNI-EXPLOIT SUITE V5.2.

-- # 1. КОД DEX EXPLORER (ПРЕДОСТАВЛЕННЫЙ КОД ПОЛЬЗОВАТЕЛЯ)
local DEX_CODE = [==[
--[[
	DEX Main Script - ИНТЕГРИРОВАННЫЙ
	
	Created by: Moon and Courtney
	
	RASPBERRY PI IS A SKIDDY SKID AF
--]]

-- Metas
local Services = setmetatable({},{
	__index = function(self, ind)
		if ypcall(function()game:GetService(ind)end) then
			return game:GetService(ind)
		else
			return nil
		end
	end
})

function CreateInstance(cls,props)
	local inst = Instance.new(cls)
	for i,v in pairs(props) do
		inst[i] = v
	end
	return inst
end

function createDexGui()
	local DexGui = CreateInstance("ScreenGui",{DisplayOrder=0,Enabled=true,ResetOnSpawn=true,Name="Dex",})
	local DexGui2 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-300,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,300,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="ContentFrameR",Parent = DexGui})
	local DexGui3 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,-300,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,300,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="ContentFrameL",Parent = DexGui})
	local DexGui4 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.11764706671238,0.11764706671238,0.11764706671238),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.5,-150,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,300,0,36),SizeConstraint=0,Visible=false,ZIndex=10,Name="TopMenu",Parent = DexGui})
	local DexGui5 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="1.1.0",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=2,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,16),Rotation=0,Selectable=false,Size=UDim2.new(0,30,0,18),SizeConstraint=0,Visible=true,ZIndex=10,Name="Version",Parent = DexGui4})
	local DexGui6 = CreateInstance("ImageLabel",{Image="rbxassetid://474172996",ImageColor3=Color3.new(0.11764706671238,0.11764706671238,0.11764706671238),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-9,0,9),Rotation=90,Selectable=false,Size=UDim2.new(0,36,0,18),SizeConstraint=0,Visible=true,ZIndex=10,Name="Slant",Parent = DexGui4})
	local DexGui7 = CreateInstance("TextLabel",{Font=4,FontSize=5,Text="DEX",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=2,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,2),Rotation=0,Selectable=false,Size=UDim2.new(0,30,0,18),SizeConstraint=0,Visible=true,ZIndex=10,Name="Title",Parent = DexGui4})
	local DexGui8 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.19607844948769,0.19607844948769,0.19607844948769),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,120,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,120,1,0),SizeConstraint=0,Visible=true,ZIndex=10,Name="Content",Parent = DexGui4})
	local DexGui9 = CreateInstance("TextButton",{Font=3,FontSize=7,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=24,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=false,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.039215687662363,0.039215687662363,0.039215687662363),BackgroundTransparency=0,BorderColor3=Color3.new(0.19607844948769,0.19607844948769,0.19607844948769),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,30,0,4),Rotation=0,Selectable=true,Size=UDim2.new(0,112,0,28),SizeConstraint=0,Visible=true,ZIndex=10,Name="SlideSelect",Parent = DexGui4})
	local DexGui10 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Window Views",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,20,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-28,0,28),SizeConstraint=0,Visible=true,ZIndex=10,Name="SlideName",Parent = DexGui9})
	local DexGui11 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="V",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=2,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.11764706671238,0.11764706671238,0.11764706671238),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-8,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,8,0,28),SizeConstraint=0,Visible=true,ZIndex=10,Name="DropDown",Parent = DexGui9})
	local DexGui12 = CreateInstance("ImageLabel",{Image="rbxassetid://588745174",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,6),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=true,ZIndex=10,Name="Icon",Parent = DexGui9})
	local DexGui13 = CreateInstance("ImageLabel",{Image="rbxassetid://474172996",ImageColor3=Color3.new(0.11764706671238,0.11764706671238,0.11764706671238),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,-18,0,0),Rotation=180,Selectable=false,Size=UDim2.new(0,18,0,36),SizeConstraint=0,Visible=true,ZIndex=10,Name="Slant",Parent = DexGui4})
	local DexGui14 = CreateInstance("TextButton",{Font=3,FontSize=7,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=24,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=false,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-30,0,0),Rotation=0,Selectable=true,Size=UDim2.new(0,30,0,36),SizeConstraint=0,Visible=true,ZIndex=10,Name="About",Parent = DexGui4})
	local DexGui15 = CreateInstance("ImageLabel",{Image="rbxassetid://476354004",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,3,0,6),Rotation=0,Selectable=false,Size=UDim2.new(0,24,0,24),SizeConstraint=0,Visible=true,ZIndex=10,Name="Icon",Parent = DexGui14})
	local DexGui16 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,100,0,100),SizeConstraint=0,Visible=false,ZIndex=1,Name="Resources",Parent = DexGui})
	local DexGui17 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=false,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.37647062540054,0.54901963472366,0.82745105028152),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,1,0,2),Rotation=0,Selectable=true,Size=UDim2.new(1,-18,0,18),SizeConstraint=0,Visible=true,ZIndex=1,Name="Entry",Parent = DexGui16})
	local DexGui18 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderColor3=Color3.new(0.14509804546833,0.20784315466881,0.21176472306252),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,18,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-18,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Indent",Parent = DexGui17})
	local DexGui19 = CreateInstance("ImageButton",{Image="",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,-16,0.5,-8),Rotation=0,Selectable=true,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=true,ZIndex=1,Name="Expand",Parent = DexGui18})
	local DexGui20 = CreateInstance("ImageLabel",{Image="rbxassetid://529659138",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(-12.562000274658,0,-12.562000274658,0),Rotation=0,Selectable=false,Size=UDim2.new(16,0,16,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Icon",Parent = DexGui19})
	local DexGui21 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Item",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,22,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-22,0,18),SizeConstraint=0,Visible=true,ZIndex=1,Name="EntryName",Parent = DexGui18})
	local DexGui22 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,2,0.5,-8),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=true,ZIndex=1,Name="IconFrame",Parent = DexGui18})
	local DexGui23 = CreateInstance("ImageLabel",{Image="rbxassetid://529659138",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(-5.811999797821,0,-1.3120000362396,0),Rotation=0,Selectable=false,Size=UDim2.new(16,0,16,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Icon",Parent = DexGui22})
	local DexGui24 = CreateInstance("Folder",{Name="PropControls",Parent = DexGui16})
	local DexGui25 = CreateInstance("TextBox",{ClearTextOnFocus=true,Font=3,FontSize=5,MultiLine=false,Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,0),Rotation=0,Selectable=true,Size=UDim2.new(1,-4,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="String",Parent = DexGui24})
	local DexGui26 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.56470590829849,0.56470590829849,0.56470590829849),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-4,1,0),SizeConstraint=0,Visible=false,ZIndex=1,Name="ReadOnly",Parent = DexGui25})
	local DexGui27 = CreateInstance("TextBox",{ClearTextOnFocus=true,Font=3,FontSize=5,MultiLine=false,Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,0),Rotation=0,Selectable=true,Size=UDim2.new(1,-2,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Number",Parent = DexGui24})
	local DexGui28 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-16,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,16,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="ArrowFrame",Parent = DexGui27})
	local DexGui29 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,3),Rotation=0,Selectable=true,Size=UDim2.new(1,0,0,8),SizeConstraint=0,Visible=true,ZIndex=1,Name="Up",Parent = DexGui28})
	local DexGui30 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.63921570777893,0.63529413938522,0.64705884456635),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,8),SizeConstraint=0,Visible=true,ZIndex=1,Name="Arrow",Parent = DexGui29})
	local DexGui31 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,8,0,3),Rotation=0,Selectable=false,Size=UDim2.new(0,1,0,1),SizeConstraint=0,Visible=true,ZIndex=1,Name="Frame",Parent = DexGui30})
	local DexGui32 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,7,0,4),Rotation=0,Selectable=false,Size=UDim2.new(0,3,0,1),SizeConstraint=0,Visible=true,ZIndex=1,Name="Frame",Parent = DexGui30})
	local DexGui33 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,6,0,5),Rotation=0,Selectable=false,Size=UDim2.new(0,5,0,1),SizeConstraint=0,Visible=true,ZIndex=1,Name="Frame",Parent = DexGui30})
	local DexGui34 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,11),Rotation=0,Selectable=true,Size=UDim2.new(1,0,0,8),SizeConstraint=0,Visible=true,ZIndex=1,Name="Down",Parent = DexGui28})
	local DexGui35 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.63921570777893,0.63529413938522,0.64705884456635),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,8),SizeConstraint=0,Visible=true,ZIndex=1,Name="Arrow",Parent = DexGui34})
	local DexGui36 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,8,0,5),Rotation=0,Selectable=false,Size=UDim2.new(0,1,0,1),SizeConstraint=0,Visible=true,ZIndex=1,Name="Frame",Parent = DexGui35})
	local DexGui37 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,7,0,4),Rotation=0,Selectable=false,Size=UDim2.new(0,3,0,1),SizeConstraint=0,Visible=true,ZIndex=1,Name="Frame",Parent = DexGui35})
	local DexGui38 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.86274510622025,0.86274510622025,0.86274510622025),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,6,0,3),Rotation=0,Selectable=false,Size=UDim2.new(0,5,0,1),SizeConstraint=0,Visible=true,ZIndex=1,Name="Frame",Parent = DexGui35})
	local DexGui39 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0.5,0),Rotation=0,Selectable=false,Size=UDim2.new(0,300,0.5,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="PropertiesPanel",Parent = DexGui16})
	local DexGui40 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=0,BorderColor3=Color3.new(0.14509804546833,0.20784315466881,0.21176472306252),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,1,0,50),Rotation=0,Selectable=false,Size=UDim2.new(1,-2,1,-50),SizeConstraint=0,Visible=true,ZIndex=1,Name="Content",Parent = DexGui39})
	local DexGui41 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.20784315466881,0.27058824896812,0.27450981736183),BackgroundTransparency=1,BorderColor3=Color3.new(0.14509804546833,0.20784315466881,0.21176472306252),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="List",Parent = DexGui40})
	local DexGui42 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.18823531270027,0.18823531270027,0.18823531270027),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,0,50),SizeConstraint=0,Visible=true,ZIndex=1,Name="TopBar",Parent = DexGui39})
	local DexGui43 = CreateInstance("TextButton",{Font=4,FontSize=5,Text="X",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-27,0,0),Rotation=0,Selectable=true,Size=UDim2.new(0,25,0,25),SizeConstraint=0,Visible=true,ZIndex=1,Name="Close",Parent = DexGui42})
	local DexGui44 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Properties",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,25,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-50,0,25),SizeConstraint=0,Visible=true,ZIndex=1,Name="WindowTitle",Parent = DexGui42})
	local DexGui45 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.21960785984993,0.21960785984993,0.21960785984993),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-25,0,25),Rotation=0,Selectable=true,Size=UDim2.new(0,25,0,25),SizeConstraint=0,Visible=true,ZIndex=1,Name="Settings",Parent = DexGui42})
	local DexGui46 = CreateInstance("ImageLabel",{Image="rbxassetid://530240903",ImageColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,5,0,5),Rotation=0,Selectable=false,Size=UDim2.new(1,-10,1,-10),SizeConstraint=0,Visible=true,ZIndex=1,Name="ImageLabel",Parent = DexGui45})
	local DexGui47 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=0,BorderColor3=Color3.new(0.4588235616684,0.52156865596771,0.52549022436142),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,45),Rotation=0,Selectable=false,Size=UDim2.new(1,-27,0,2),SizeConstraint=0,Visible=true,ZIndex=1,Name="SearchFrame",Parent = DexGui42})
	local DexGui48 = CreateInstance("TextBox",{ClearTextOnFocus=false,Font=3,FontSize=5,MultiLine=false,Text="",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=1,BorderColor3=Color3.new(0.47058826684952,0.47058826684952,0.47058826684952),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,-20),Rotation=0,Selectable=true,Size=UDim2.new(1,-4,1,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Search",Parent = DexGui47})
	local DexGui49 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Search Properties",TextColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Empty",Parent = DexGui48})
	local DexGui50 = CreateInstance("ImageLabel",{Image="rbxassetid://527318112",ImageColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,4,0,-15),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=false,ZIndex=1,Name="ImageLabel",Parent = DexGui47})
	local DexGui51 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.13333334028721,0.65490198135376,0.94117653369904),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.5,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,0,0,2),SizeConstraint=0,Visible=true,ZIndex=1,Name="Entering",Parent = DexGui47})
	local DexGui52 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.39215689897537,0.39215689897537,0.39215689897537),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,300,0.5,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="ExplorerPanel",Parent = DexGui16})
	local DexGui53 = CreateInstance("Frame",{Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=0,BorderColor3=Color3.new(0.14509804546833,0.20784315466881,0.21176472306252),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,1,0,50),Rotation=0,Selectable=false,Size=UDim2.new(1,-2,1,-50),SizeConstraint=0,Visible=true,ZIndex=1,Name="Content",Parent = DexGui52})
	local DexGui54 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.20784315466881,0.27058824896812,0.27450981736183),BackgroundTransparency=1,BorderColor3=Color3.new(0.14509804546833,0.20784315466881,0.21176472306252),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="List",Parent = DexGui53})
	local DexGui55 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.18823531270027,0.18823531270027,0.18823531270027),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,0,50),SizeConstraint=0,Visible=true,ZIndex=1,Name="TopBar",Parent = DexGui52})
	local DexGui56 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=0,BorderColor3=Color3.new(0.4588235616684,0.52156865596771,0.52549022436142),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,45),Rotation=0,Selectable=false,Size=UDim2.new(1,-27,0,2),SizeConstraint=0,Visible=true,ZIndex=1,Name="SearchFrame",Parent = DexGui55})
	local DexGui57 = CreateInstance("TextBox",{ClearTextOnFocus=false,Font=3,FontSize=5,MultiLine=false,Text="",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=1,BorderColor3=Color3.new(0.47058826684952,0.47058826684952,0.47058826684952),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,-20),Rotation=0,Selectable=true,Size=UDim2.new(1,-4,1,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Search",Parent = DexGui56})
	local DexGui58 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Search Workspace",TextColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Empty",Parent = DexGui57})
	local DexGui59 = CreateInstance("ImageLabel",{Image="rbxassetid://527318112",ImageColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,4,0,-15),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=false,ZIndex=1,Name="ImageLabel",Parent = DexGui56})
	local DexGui60 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.13333334028721,0.65490198135376,0.94117653369904),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.5,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,0,0,2),SizeConstraint=0,Visible=true,ZIndex=1,Name="Entering",Parent = DexGui56})
	local DexGui61 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Explorer",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,25,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-50,0,25),SizeConstraint=0,Visible=true,ZIndex=1,Name="WindowTitle",Parent = DexGui55})
	local DexGui62 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.21960785984993,0.21960785984993,0.21960785984993),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-25,0,25),Rotation=0,Selectable=true,Size=UDim2.new(0,25,0,25),SizeConstraint=0,Visible=true,ZIndex=1,Name="Settings",Parent = DexGui55})
	local DexGui63 = CreateInstance("ImageLabel",{Image="rbxassetid://530240903",ImageColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,5,0,5),Rotation=0,Selectable=false,Size=UDim2.new(1,-10,1,-10),SizeConstraint=0,Visible=true,ZIndex=1,Name="ImageLabel",Parent = DexGui62})
	local DexGui64 = CreateInstance("TextButton",{Font=4,FontSize=5,Text="X",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-27,0,0),Rotation=0,Selectable=true,Size=UDim2.new(0,25,0,25),SizeConstraint=0,Visible=true,ZIndex=1,Name="Close",Parent = DexGui55})
	local DexGui65 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=false,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.28235295414925,0.28235295414925,0.28235295414925),BackgroundTransparency=0,BorderColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,1,0,134),Rotation=0,Selectable=true,Size=UDim2.new(0,300,0,22),SizeConstraint=0,Visible=true,ZIndex=1,Name="PEntry",Parent = DexGui16})
	local DexGui66 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.37647062540054,0.54901963472366,0.82745105028152),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,18,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-18,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Indent",Parent = DexGui65})
	local DexGui67 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Name",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-2,0,22),SizeConstraint=0,Visible=true,ZIndex=1,Name="EntryName",Parent = DexGui66})
	local DexGui68 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,-16,0.5,-8),Rotation=0,Selectable=true,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=false,ZIndex=1,Name="Expand",Parent = DexGui66})
	local DexGui69 = CreateInstance("ImageLabel",{Image="rbxassetid://529659138",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(-13.6875,0,-12.5625,0),Rotation=0,Selectable=false,Size=UDim2.new(16,0,16,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Icon",Parent = DexGui68})
	local DexGui70 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=1,BorderColor3=Color3.new(0.43921571969986,0.43921571969986,0.43921571969986),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.5,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0.5,0,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Control",Parent = DexGui66})
	local DexGui71 = CreateInstance("TextBox",{ClearTextOnFocus=true,Font=3,FontSize=5,MultiLine=false,Text="0",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,0),Rotation=0,Selectable=true,Size=UDim2.new(1,-4,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="String",Parent = DexGui70})
	local DexGui72 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.37647062540054,0.37647062540054,0.37647062540054),BackgroundTransparency=0,BorderColor3=Color3.new(0.43921571969986,0.43921571969986,0.43921571969986),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.5,-1,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,1,0,22),SizeConstraint=0,Visible=true,ZIndex=1,Name="Sep",Parent = DexGui66})
	local DexGui73 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.5,-250,0.5,-150),Rotation=0,Selectable=false,Size=UDim2.new(0,500,0,300),SizeConstraint=0,Visible=false,ZIndex=1,Name="WelcomeFrame",Parent = DexGui})
	local DexGui74 = CreateInstance("ImageLabel",{Image="rbxassetid://503289231",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=1,SliceCenter=Rect.new(20,20,460,260),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,-20,0,-20),Rotation=0,Selectable=false,Size=UDim2.new(0,540,0,340),SizeConstraint=0,Visible=true,ZIndex=1,Name="Outline",Parent = DexGui73})
	local DexGui75 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Content",Parent = DexGui73})
	local DexGui76 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.18823531270027,0.18823531270027,0.18823531270027),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.60000002384186,0,1,-50),Rotation=0,Selectable=false,Size=UDim2.new(0.40000000596046,-10,1,-75),SizeConstraint=0,Visible=true,ZIndex=1,Name="Main",Parent = DexGui75})
	local DexGui77 = CreateInstance("TextLabel",{Font=4,FontSize=9,Text="DEX",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=48,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,0,0,100),SizeConstraint=0,Visible=true,ZIndex=1,Name="Title",Parent = DexGui76})
	local DexGui78 = CreateInstance("TextLabel",{Font=4,FontSize=6,Text="V1.1.0 ALPHA",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=18,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=1,TextYAlignment=2,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-105,1,-20),Rotation=0,Selectable=false,Size=UDim2.new(0,100,0,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Version",Parent = DexGui76})
	local DexGui79 = CreateInstance("TextLabel",{Font=4,FontSize=6,Text="Made by Moon & Courtney",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=18,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=2,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,5,1,-20),Rotation=0,Selectable=false,Size=UDim2.new(0,100,0,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Creator",Parent = DexGui76})
	local DexGui80 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.039215687662363,0.039215687662363,0.039215687662363),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,50,0,120),Rotation=0,Selectable=false,Size=UDim2.new(0,200,0,80),SizeConstraint=0,Visible=true,ZIndex=1,Name="Progress",Parent = DexGui76})
	local DexGui81 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,2,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Line",Parent = DexGui80})
	local DexGui82 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Fetching latest API...",TextColor3=Color3.new(0.78431379795074,0.78431379795074,0.78431379795074),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,10,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-10,0,15),SizeConstraint=0,Visible=true,ZIndex=1,Name="Progress1",Parent = DexGui80})
	local DexGui83 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Fetching latest Reflection Metadata...",TextColor3=Color3.new(0.78431379795074,0.78431379795074,0.78431379795074),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,10,0,15),Rotation=0,Selectable=false,Size=UDim2.new(1,-10,0,15),SizeConstraint=0,Visible=true,ZIndex=1,Name="Progress2",Parent = DexGui80})
	local DexGui84 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Importing DexStorage items...",TextColor3=Color3.new(0.78431379795074,0.78431379795074,0.78431379795074),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,10,0,30),Rotation=0,Selectable=false,Size=UDim2.new(1,-10,0,15),SizeConstraint=0,Visible=true,ZIndex=1,Name="Progress3",Parent = DexGui80})
	local DexGui85 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Indexing tree list...",TextColor3=Color3.new(0.78431379795074,0.78431379795074,0.78431379795074),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,10,0,45),Rotation=0,Selectable=false,Size=UDim2.new(1,-10,0,15),SizeConstraint=0,Visible=true,ZIndex=1,Name="Progress4",Parent = DexGui80})
	local DexGui86 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Starting up...",TextColor3=Color3.new(0.78431379795074,0.78431379795074,0.78431379795074),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,10,0,60),Rotation=0,Selectable=false,Size=UDim2.new(1,-10,0,15),SizeConstraint=0,Visible=true,ZIndex=1,Name="Progress5",Parent = DexGui80})
	local DexGui87 = CreateInstance("TextButton",{Font=4,FontSize=6,Text="X",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=18,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=true,Size=UDim2.new(0,20,0,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Closer",Parent = DexGui76})
	local DexGui88 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=0,BorderColor3=Color3.new(0.43921571969986,0.43921571969986,0.43921571969986),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.60000002384186,0,1,-50),Rotation=0,Selectable=false,Size=UDim2.new(0.40000000596046,-10,0,50),SizeConstraint=0,Visible=true,ZIndex=1,Name="Bottom",Parent = DexGui75})
	local DexGui89 = CreateInstance("ImageLabel",{Image="rbxassetid://493608750",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,5,0,5),Rotation=0,Selectable=false,Size=UDim2.new(0,40,0,40),SizeConstraint=0,Visible=true,ZIndex=1,Name="Logo",Parent = DexGui88})
	local DexGui90 = CreateInstance("TextLabel",{Font=3,FontSize=6,Text="Powerful and light",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=18,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,50,0,5),Rotation=0,Selectable=false,Size=UDim2.new(1,-55,0,25),SizeConstraint=0,Visible=true,ZIndex=1,Name="Desc",Parent = DexGui88})
	local DexGui91 = CreateInstance("TextLabel",{Font=4,FontSize=4,Text="Image by KrystalTeam",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=12,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=2,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,50,1,-20),Rotation=0,Selectable=false,Size=UDim2.new(1,-55,0,15),SizeConstraint=0,Visible=true,ZIndex=1,Name="Credit",Parent = DexGui88})
	local DexGui92 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.25098040699959,0.25098040699959,0.25098040699959),BackgroundTransparency=0,BorderColor3=Color3.new(0.43921571969986,0.43921571969986,0.43921571969986),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.60000002384186,5,0,20),Rotation=0,Selectable=false,Size=UDim2.new(0.40000000596046,-10,1,-75),SizeConstraint=0,Visible=true,ZIndex=1,Name="Changelog",Parent = DexGui75})
	local DexGui93 = CreateInstance("TextLabel",{Font=10,FontSize=5,Text="Changelog",TextColor3=Color3.new(1,1,1),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,-20),Rotation=0,Selectable=false,Size=UDim2.new(1,0,0,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Title",Parent = DexGui92})
	return DexGui
end

-- Main Gui References
local gui = createDexGui()
gui.Parent = Services.CoreGui
local contentL = gui:WaitForChild("ContentFrameL")
local contentR = gui:WaitForChild("ContentFrameR")
local resources = gui:WaitForChild("Resources")

-- Welcome Gui References
local welcomeFrame = gui:WaitForChild("WelcomeFrame")
local welcomeOutline = welcomeFrame:WaitForChild("Outline")
local welcomeContents = welcomeFrame:WaitForChild("Content")
local welcomeMain = welcomeContents:WaitForChild("Main")
local welcomeChangelog = welcomeContents:WaitForChild("Changelog")
local welcomeBottom = welcomeContents:WaitForChild("Bottom")
local welcomeProgress = welcomeMain:WaitForChild("Progress")

-- Explorer Stuff
local explorerTree = nil
local updateDebounce = false
local rightClickContext = nil
local rightEntry = nil
local clipboard = {}
local lastSearch = 0
local nodeWidth = 0

-- Properties Stuff
local propertiesTree = nil
local propWidth = 0

-- Settings
local explorerSettings = {
	LPaneWidth = 300,
	RPaneWidth = 300
}

-- JSON Stuff
local API
local RMD

-- Main Variables
local mouse = Services.Players.LocalPlayer:GetMouse()
local mouseWindow = nil
local LPaneItems = {}
local RPaneItems = {}
local setPane = "None"
local activeWindows = {}
local f = {}
local API = {}
local RMD = {}

-- ScrollBar
function f.buttonArrows(size,num,dir)
	local max = num
	local arrowFrame = CreateInstance("Frame",{
		BackgroundTransparency = 1,
		Name = "Arrow",
		Size = UDim2.new(0,size,0,size)
	})
	if dir == "up" then
		for i = 1,num do
			local newLine = CreateInstance("Frame",{
				BackgroundColor3 = Color3.new(220/255,220/255,220/255),
				BorderSizePixel = 0,
				Position = UDim2.new(0,math.floor(size/2)-(i-1),0,math.floor(size/2)+i-math.floor(max/2)-1),
				Size = UDim2.new(0,i+(i-1),0,1),
				Parent = arrowFrame
			})
		end
		return arrowFrame
	elseif dir == "down" then
		for i = 1,num do
			local newLine = CreateInstance("Frame",{
				BackgroundColor3 = Color3.new(220/255,220/255,220/255),
				BorderSizePixel = 0,
				Position = UDim2.new(0,math.floor(size/2)-(i-1),0,math.floor(size/2)-i+math.floor(max/2)+1),
				Size = UDim2.new(0,i+(i-1),0,1),
				Parent = arrowFrame
			})
		end
		return arrowFrame
	elseif dir == "left" then
		for i = 1,num do
			local newLine = CreateInstance("Frame",{
				BackgroundColor3 = Color3.new(220/255,220/255,220/255),
				BorderSizePixel = 0,
				Position = UDim2.new(0,math.floor(size/2)+i-math.floor(max/2)-1,0,math.floor(size/2)-(i-1)),
				Size = UDim2.new(0,1,0,i+(i-1)),
				Parent = arrowFrame
			})
		end
		return arrowFrame
	elseif dir == "right" then
		for i = 1,num do
			local newLine = CreateInstance("Frame",{
				BackgroundColor3 = Color3.new(220/255,220/255,220/255),
				BorderSizePixel = 0,
				Position = UDim2.new(0,math.floor(size/2)-i+math.floor(max/2)+1,0,math.floor(size/2)-(i-1)),
				Size = UDim2.new(0,1,0,i+(i-1)),
				Parent = arrowFrame
			})
		end
		return arrowFrame
	end
	error("r u ok")
end

local ScrollBar do
	ScrollBar = {}
	
	local user = game:GetService("UserInputService")
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	
	ScrollMt = {
		__index = {
			AddMarker = function(self,ind,color)
				self.Markers[ind] = color or Color3.new(0,0,0)
			end,
			ScrollTo = function(self,ind)
				self.Index = ind
				self:Update()
			end,
			ScrollUp = function(self)
				self.Index = self.Index - self.Increment
				self:Update()
			end,
			ScrollDown = function(self)
				self.Index = self.Index + self.Increment
				self:Update()
			end,
			CanScrollUp = function(self)
				return self.Index > 0
			end,
			CanScrollDown = function(self)
				return self.Index + self.VisibleSpace < self.TotalSpace
			end,
			GetScrollPercent = function(self)
				return self.Index/(self.TotalSpace-self.VisibleSpace)
			end,
			SetScrollPercent = function(self,perc)
				self.Index = math.floor(perc*(self.TotalSpace-self.VisibleSpace))
				self:Update()
			end
		}
	}
	
	function ScrollBar.new(hor)
		local newFrame = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.35294118523598,0.35294118523598,0.35294118523598),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-16,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,16,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="ScrollBar",})
		local button1 = nil
		local button2 = nil
		
		local lastTotalSpace = 0
		
		if hor then
			newFrame.Size = UDim2.new(1,0,0,16)
			button1 = CreateInstance("ImageButton",{
				Parent = newFrame,
				Name = "Left",
				Size = UDim2.new(0,16,0,16),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = false
			})
			f.buttonArrows(16,4,"left").Parent = button1
			button2 = CreateInstance("ImageButton",{
				Parent = newFrame,
				Name = "Right",
				Position = UDim2.new(1,-16,0,0),
				Size = UDim2.new(0,16,0,16),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = false
			})
			f.buttonArrows(16,4,"right").Parent = button2
		else
			newFrame.Size = UDim2.new(0,16,1,0)
			button1 = CreateInstance("ImageButton",{
				Parent = newFrame,
				Name = "Up",
				Size = UDim2.new(0,16,0,16),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = false
			})
			f.buttonArrows(16,4,"up").Parent = button1
			button2 = CreateInstance("ImageButton",{
				Parent = newFrame,
				Name = "Down",
				Position = UDim2.new(0,0,1,-16),
				Size = UDim2.new(0,16,0,16),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = false
			})
			f.buttonArrows(16,4,"down").Parent = button2
		end
		
		local scrollThumbFrame = CreateInstance("Frame",{
			BackgroundTransparency = 1,
			Parent = newFrame
		})
		if hor then
			scrollThumbFrame.Position = UDim2.new(0,16,0,0)
			scrollThumbFrame.Size = UDim2.new(1,-32,1,0)
		else
			scrollThumbFrame.Position = UDim2.new(0,0,0,16)
			scrollThumbFrame.Size = UDim2.new(1,0,1,-32)
		end
		
		local scrollThumb = CreateInstance("Frame",{
			BackgroundColor3 = Color3.new(120/255,120/255,120/255),
			BorderSizePixel = 0,
			Parent = scrollThumbFrame
		})
		
		local markerFrame = CreateInstance("Frame",{
			BackgroundTransparency = 1,
			Name = "Markers",
			Size = UDim2.new(1,0,1,0),
			Parent = scrollThumbFrame
		})
		
		local newMt = setmetatable({
			Gui = newFrame,
			Index = 0,
			VisibleSpace = 0,
			TotalSpace = 0,
			Increment = 1,
			Markers = {}
		},ScrollMt)
		
		local function drawThumb()
			local total = newMt.TotalSpace
			local visible = newMt.VisibleSpace
			local index = newMt.Index
			
			if not (newMt:CanScrollUp()	or newMt:CanScrollDown()) then
				scrollThumb.Visible = false
			else
				scrollThumb.Visible = true
			end
			
			if hor then
				scrollThumb.Size = UDim2.new(visible/total,0,1,0)
				if scrollThumb.AbsoluteSize.X < 16 then
					scrollThumb.Size = UDim2.new(0,16,1,0)
				end
				local fs = scrollThumbFrame.AbsoluteSize.X
				local bs = scrollThumb.AbsoluteSize.X
				scrollThumb.Position = UDim2.new(newMt:GetScrollPercent()*(fs-bs)/fs,0,0,0)
			else
				scrollThumb.Size = UDim2.new(1,0,visible/total,0)
				if scrollThumb.AbsoluteSize.Y < 16 then
					scrollThumb.Size = UDim2.new(1,0,0,16)
				end
				local fs = scrollThumbFrame.AbsoluteSize.Y
				local bs = scrollThumb.AbsoluteSize.Y
				scrollThumb.Position = UDim2.new(0,0,newMt:GetScrollPercent()*(fs-bs)/fs,0)
			end
		end
		
		local function updateMarkers()
			markerFrame:ClearAllChildren()
	
			for i,v in pairs(newMt.Markers) do
				if i < newMt.TotalSpace then
					CreateInstance("Frame",{
						BackgroundTransparency = 0,
						BackgroundColor3 = v,
						BorderSizePixel = 0,
						Position = hor and UDim2.new(i/newMt.TotalSpace,0,1,-6) or UDim2.new(1,-6,i/newMt.TotalSpace,0),
						Size = hor and UDim2.new(0,1,0,6) or UDim2.new(0,6,0,1),
						Name = "Marker"..tostring(i),
						Parent = markerFrame
					})
				end
			end
		end
		newMt.UpdateMarkers = updateMarkers
		
		local function update()
			local total = newMt.TotalSpace
			local visible = newMt.VisibleSpace
			local index = newMt.Index
			
			if visible <= total then
				if index > 0 then
					if index + visible > total then
						newMt.Index = total - visible
					end
				else
					newMt.Index = 0
				end
			else
				newMt.Index = 0
			end

			if lastTotalSpace ~= newMt.TotalSpace then
				lastTotalSpace = newMt.TotalSpace
				updateMarkers()
			end
			
			if newMt.OnUpdate then newMt:OnUpdate() end
			
			if newMt:CanScrollUp() then
				for i,v in pairs(button1.Arrow:GetChildren()) do
					v.BackgroundTransparency = 0
				end
			else
				button1.BackgroundTransparency = 1
				for i,v in pairs(button1.Arrow:GetChildren()) do
					v.BackgroundTransparency = 0.5
				end
			end
			if newMt:CanScrollDown() then
				for i,v in pairs(button2.Arrow:GetChildren()) do
					v.BackgroundTransparency = 0
				end
			else
				button2.BackgroundTransparency = 1
				for i,v in pairs(button2.Arrow:GetChildren()) do
					v.BackgroundTransparency = 0.5
				end
			end
			
			drawThumb()
		end
		
		local buttonPress = false
		local thumbPress = false
		local thumbFramePress = false
		
		local thumbColor = Color3.new(120/255,120/255,120/255)
		local thumbSelectColor = Color3.new(140/255,140/255,140/255)
		button1.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress and newMt:CanScrollUp() then button1.BackgroundTransparency = 0.8 end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not newMt:CanScrollUp() then return end
			buttonPress = true
			button1.BackgroundTransparency = 0.5
			if newMt:CanScrollUp() then newMt:ScrollUp() end
			local buttonTick = tick()
			local releaseEvent
			releaseEvent = user.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
				releaseEvent:Disconnect()
				if f.checkMouseInGui(button1) and newMt:CanScrollUp() then button1.BackgroundTransparency = 0.8 else button1.BackgroundTransparency = 1 end
				buttonPress = false
			end)
			while buttonPress do
				if tick() - buttonTick >= 0.3 and newMt:CanScrollUp() then
					newMt:ScrollUp()
				end
				wait()
			end
		end)
		button1.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress then button1.BackgroundTransparency = 1 end
		end)
		button2.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress and newMt:CanScrollDown() then button2.BackgroundTransparency = 0.8 end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not newMt:CanScrollDown() then return end
			buttonPress = true
			button2.BackgroundTransparency = 0.5
			if newMt:CanScrollDown() then newMt:ScrollDown() end
			local buttonTick = tick()
			local releaseEvent
			releaseEvent = user.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
				releaseEvent:Disconnect()
				if f.checkMouseInGui(button2) and newMt:CanScrollDown() then button2.BackgroundTransparency = 0.8 else button2.BackgroundTransparency = 1 end
				buttonPress = false
			end)
			while buttonPress do
				if tick() - buttonTick >= 0.3 and newMt:CanScrollDown() then
					newMt:ScrollDown()
				end
				wait()
			end
		end)
		button2.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and not buttonPress then button2.BackgroundTransparency = 1 end
		end)
		
		scrollThumb.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and not thumbPress then scrollThumb.BackgroundTransparency = 0.2 scrollThumb.BackgroundColor3 = thumbSelectColor end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			
			local dir = hor and "X" or "Y"
			local lastThumbPos = nil
			
			buttonPress = false
			thumbFramePress = false			
			thumbPress = true
			scrollThumb.BackgroundTransparency = 0
			local mouseOffset = mouse[dir] - scrollThumb.AbsolutePosition[dir]
			local mouseStart = mouse[dir]
			local releaseEvent
			local mouseEvent
			releaseEvent = user.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
				releaseEvent:Disconnect()
				if mouseEvent then mouseEvent:Disconnect() end
				if f.checkMouseInGui(scrollThumb) then scrollThumb.BackgroundTransparency = 0.2 else scrollThumb.BackgroundTransparency = 0 scrollThumb.BackgroundColor3 = thumbColor end
				thumbPress = false
			end)
			newMt:Update()
			--while math.abs(mouse[dir] - mouseStart) == 0 do wait() end
			mouseEvent = user.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and thumbPress and releaseEvent.Connected then
					local thumbFrameSize = scrollThumbFrame.AbsoluteSize[dir]-scrollThumb.AbsoluteSize[dir]
					local pos = mouse[dir] - scrollThumbFrame.AbsolutePosition[dir] - mouseOffset
					if pos > thumbFrameSize then
						pos = thumbFrameSize
					elseif pos < 0 then
						pos = 0
					end
					if lastThumbPos ~= pos then
						lastThumbPos = pos
						newMt:ScrollTo(math.floor(pos/thumbFrameSize*(newMt.TotalSpace-newMt.VisibleSpace)))
					end
					wait()
				end
			end)
		end)
		scrollThumb.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and not thumbPress then scrollThumb.BackgroundTransparency = 0 scrollThumb.BackgroundColor3 = thumbColor end
		end)
		scrollThumbFrame.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 or f.checkMouseInGui(scrollThumb) then return end
			
			local dir = hor and "X" or "Y"
			
			local function doTick()
				local thumbFrameSize = scrollThumbFrame.AbsoluteSize[dir]-scrollThumb.AbsoluteSize[dir]
				local thumbFrameDist = scrollThumb.AbsolutePosition[dir] - scrollThumbFrame.AbsolutePosition[dir]
				local pos = thumbFrameDist + (mouse[dir] < scrollThumb.AbsolutePosition[dir] + math.floor(scrollThumb.AbsoluteSize[dir]/2) and -50 or 50)
				if pos > thumbFrameSize then
					pos = thumbFrameSize
				elseif pos < 0 then
					pos = 0
				end
				if pos < thumbFrameDist and scrollThumbFrame.AbsolutePosition[dir] + pos + math.floor(scrollThumb.AbsoluteSize[dir]/2) <= mouse[dir] then
					pos = mouse[dir] - scrollThumbFrame.AbsolutePosition[dir] - math.floor(scrollThumb.AbsoluteSize[dir]/2)
				elseif pos > thumbFrameDist and scrollThumbFrame.AbsolutePosition[dir] + pos + math.floor(scrollThumb.AbsoluteSize[dir]/2) >= mouse[dir] then
					pos = mouse[dir] - scrollThumbFrame.AbsolutePosition[dir] - math.floor(scrollThumb.AbsoluteSize[dir]/2)
				end
				newMt:ScrollTo(math.floor(pos/thumbFrameSize*(newMt.TotalSpace-newMt.VisibleSpace)))
			end
			
			thumbPress = false			
			thumbFramePress = true
			doTick()
			local thumbFrameTick = tick()
			local releaseEvent
			releaseEvent = user.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
				releaseEvent:Disconnect()
				thumbFramePress = false
			end)
			while thumbFramePress and not f.checkMouseInGui(scrollThumb) do
				if tick() - thumbFrameTick >= 0.3 then
					doTick()
				end
				wait()
			end
		end)
		
		local function texture(self,data)
			thumbColor = data.ThumbColor or Color3.new(0,0,0)
			thumbSelectColor = data.ThumbSelectColor or Color3.new(0,0,0)
			scrollThumb.BackgroundColor3 = data.ThumbColor or Color3.new(0,0,0)
			newFrame.BackgroundColor3 = data.FrameColor or Color3.new(0,0,0)
			button1.BackgroundColor3 = data.ButtonColor or Color3.new(0,0,0)
			button2.BackgroundColor3 = data.ButtonColor or Color3.new(0,0,0)
			for i,v in pairs(button1.Arrow:GetChildren()) do
				v.BackgroundColor3 = data.ArrowColor or Color3.new(0,0,0)
			end
			for i,v in pairs(button2.Arrow:GetChildren()) do
				v.BackgroundColor3 = data.ArrowColor or Color3.new(0,0,0)
			end
		end
		newMt.Texture = texture
		
		local wheelIncrement = 1
		local scrollOverlay = Instance.new("ScrollingFrame")
		scrollOverlay.BackgroundTransparency = 1
		scrollOverlay.Size = UDim2.new(1,0,1,0)
		scrollOverlay.ScrollBarThickness = 0
		scrollOverlay.CanvasSize = UDim2.new(0,0,0,0)
		local scrollOverlayFrame = Instance.new("Frame",scrollOverlay)
		scrollOverlayFrame.BackgroundTransparency = 1
		scrollOverlayFrame.Size = UDim2.new(1,0,1,0)
		scrollOverlayFrame.MouseWheelForward:Connect(function()newMt:ScrollTo(newMt.Index - wheelIncrement)end)
		scrollOverlayFrame.MouseWheelBackward:Connect(function()newMt:ScrollTo(newMt.Index + wheelIncrement)end)
		
		local scrollUpEvent,scrollDownEvent
		
		local function setScrollFrame(self,frame,inc)
			wheelIncrement = inc or self.Increment
			if scrollUpEvent then scrollUpEvent:Disconnect() scrollUpEvent = nil end
			if scrollDownEvent then scrollDownEvent:Disconnect() scrollDownEvent = nil end
			scrollUpEvent = frame.MouseWheelForward:Connect(function()newMt:ScrollTo(newMt.Index - wheelIncrement)end)
			scrollDownEvent = frame.MouseWheelBackward:Connect(function()newMt:ScrollTo(newMt.Index + wheelIncrement)end)
			--scrollOverlay.Parent = frame
		end
		newMt.SetScrollFrame = setScrollFrame
		
		newMt.Update = update
		
		update()
		return newMt
	end
end

local TreeView do
	TreeView = {}
	
	local treeMt = {
		__index = {
			Length = function(self)
				return #self.Tree
			end
		}
	}
	
	function TreeView.new()
		local function createDNodeTemplate()
			local DNodeTemplate = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=false,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.37647062540054,0.54901963472366,0.82745105028152),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,1,0,2),Rotation=0,Selectable=true,Size=UDim2.new(1,-18,0,18),SizeConstraint=0,Visible=true,ZIndex=1,Name="Entry",})
			local DNodeTemplate2 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderColor3=Color3.new(0.14509804546833,0.20784315466881,0.21176472306252),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,18,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-18,1,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Indent",Parent = DNodeTemplate})
			local DNodeTemplate3 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Item",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,22,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-22,0,18),SizeConstraint=0,Visible=true,ZIndex=1,Name="EntryName",Parent = DNodeTemplate2})
			local DNodeTemplate4 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,2,0.5,-8),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=true,ZIndex=1,Name="IconFrame",Parent = DNodeTemplate2})
			local DNodeTemplate5 = CreateInstance("ImageLabel",{Image="rbxassetid://529659138",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(-5.811999797821,0,-1.3120000362396,0),Rotation=0,Selectable=false,Size=UDim2.new(16,0,16,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Icon",Parent = DNodeTemplate4})
			local DNodeTemplate6 = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=true,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,-16,0.5,-8),Rotation=0,Selectable=true,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=true,ZIndex=1,Name="Expand",Parent = DNodeTemplate2})
			local DNodeTemplate7 = CreateInstance("ImageLabel",{Image="rbxassetid://529659138",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(-12.562000274658,0,-12.562000274658,0),Rotation=0,Selectable=false,Size=UDim2.new(16,0,16,0),SizeConstraint=0,Visible=true,ZIndex=1,Name="Icon",Parent = DNodeTemplate6})
			return DNodeTemplate
		end
		local dNodeTemplate = createDNodeTemplate()		
		
		local newMt = setmetatable({
			Index = 0,
			Tree = {},
			Expanded = {},
			NodeTemplate = dNodeTemplate,
			DisplayFrame = nil,
			Entries = {},
			Height = 18,
			OffX = 1,
			OffY = 1
		},treeMt)
		
		local function refresh(self)
			if not self.DisplayFrame then warn("Tree: No Display Frame") return end
			
			if self.PreUpdate then self:PreUpdate() end
			
			local displayFrame = self.DisplayFrame
			local entrySpace = math.ceil(displayFrame.AbsoluteSize.Y / (self.Height + 1))
			
			for i = 1,entrySpace do
				local node = self.Tree[i + self.Index]
				if node then
					local entry = self.Entries[i]
					if not entry then
						entry = self.NodeTemplate:Clone()
						entry.Position = UDim2.new(0,self.OffX,0,self.OffY + (self.Height + 1) * #displayFrame:GetChildren())
						entry.Parent = displayFrame
						self.Entries[i] = entry
						if self.NodeCreate then self:NodeCreate(entry,i) end
					end
					entry.Visible = true
					if self.NodeDraw then self:NodeDraw(entry,node) end
				else
					local entry = self.Entries[i]
					if entry then
						entry.Visible = false
					end
				end
			end
			
			for i = entrySpace+1,#self.Entries do
				if self.Entries[i] then
					self.Entries[i]:Destroy()
					self.Entries[i] = nil
				end
			end
			
			if self.OnUpdate then self:OnUpdate() end
			if self.RefreshNeeded then self.RefreshNeeded = false self:Refresh() end
		end
		newMt.Refresh = refresh
		
		local function expand(self,item)
			self.Expanded[item] = not self.Expanded[item]
			if self.TreeUpdate then self:TreeUpdate() end
			self:Refresh()
		end
		newMt.Expand = expand
		
		local Selection do
			Selection = {
				List = {},
				Selected = {}
			}
	
			function Selection:Add(obj)
				if Selection.Selected[obj] then return end
		
				Selection.Selected[obj] = true
				table.insert(Selection.List,obj)
			end
	
			function Selection:Set(objs)
				for i,v in pairs(Selection.List) do
					Selection.Selected[v] = nil
				end
				Selection.List = {}
		
				for i,v in pairs(objs) do
					if not Selection.Selected[v] then
						Selection.Selected[v] = true
						table.insert(Selection.List,v)
					end
				end
			end
	
			function Selection:Remove(obj)
				if not Selection.Selected[obj] then return end
		
				Selection.Selected[obj] = false
				for i,v in pairs(Selection.List) do
					if v == obj then table.remove(Selection.List,i) break end
				end
			end
		end
		newMt.Selection = Selection
		
		return newMt
	end
end

local ContextMenu do
	ContextMenu = {}
	
	local function createContextEntry()
		local ContextEntry = CreateInstance("TextButton",{Font=3,FontSize=5,Text="",TextColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=2,TextYAlignment=1,AutoButtonColor=false,Modal=false,Selected=false,Style=0,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.37647062540054,0.54901963472366,0.82745105028152),BackgroundTransparency=1,BorderColor3=Color3.new(0.33725491166115,0.49019610881805,0.73725491762161),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,2),Rotation=0,Selectable=true,Size=UDim2.new(1,0,0,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Entry",})
		local ContextEntry2 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,2,0.5,-8),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=true,ZIndex=1,Name="IconFrame",Parent = ContextEntry})
		local ContextEntry3 = CreateInstance("ImageLabel",{Image="rbxassetid://529659138",ImageColor3=Color3.new(1,1,1),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=0,SliceCenter=Rect.new(0,0,0,0),Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,16,0,16),SizeConstraint=0,Visible=true,ZIndex=1,Name="Icon",Parent = ContextEntry2})
		local ContextEntry4 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Item",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=0,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,24,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-24,0,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="EntryName",Parent = ContextEntry})
		local ContextEntry5 = CreateInstance("TextLabel",{Font=3,FontSize=5,Text="Ctrl+C",TextColor3=Color3.new(0.86274516582489,0.86274516582489,0.86274516582489),TextScaled=false,TextSize=14,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=1,TextYAlignment=1,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,24,0,0),Rotation=0,Selectable=false,Size=UDim2.new(1,-30,0,20),SizeConstraint=0,Visible=true,ZIndex=1,Name="Shortcut",Parent = ContextEntry})
		return ContextEntry
	end
	
	local function createContextDivider()
		local ContextDivider = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.18823531270027,0.18823531270027,0.18823531270027),BackgroundTransparency=1,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,0,0,20),Rotation=0,Selectable=false,Size=UDim2.new(1,0,0,12),SizeConstraint=0,Visible=true,ZIndex=1,Name="Divider",})
		local ContextDivider2 = CreateInstance("Frame",{Style=0,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.43921571969986,0.43921571969986,0.43921571969986),BackgroundTransparency=0,BorderColor3=Color3.new(0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0,2,0,5),Rotation=0,Selectable=false,Size=UDim2.new(1,-4,0,1),SizeConstraint=0,Visible=true,ZIndex=1,Name="Line",Parent = ContextDivider})
		return ContextDivider
	end
	
	local contextFrame = CreateInstance("ScrollingFrame",{BottomImage="rbxasset://textures/ui/Scroll/scroll-bottom.png",CanvasPosition=Vector2.new(0,0),CanvasSize=UDim2.new(0,0,2,0),MidImage="rbxasset://textures/ui/Scroll/scroll-middle.png",ScrollBarThickness=0,ScrollingEnabled=true,TopImage="rbxasset://textures/ui/Scroll/scroll-top.png",Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(0.3137255012989,0.3137255012989,0.3137255012989),BackgroundTransparency=0,BorderColor3=Color3.new(0.43921571969986,0.43921571969986,0.43921571969986),BorderSizePixel=1,ClipsDescendants=true,Draggable=false,Position=UDim2.new(0,0,0,0),Rotation=0,Selectable=true,Size=UDim2.new(0,200,0,100),SizeConstraint=0,Visible=true,ZIndex=1,Name="ContextFrame",})
	local contextEntry = createContextEntry()
	local contextDivider = createContextDivider()
	
	function ContextMenu.new()
		local newMt = setmetatable({
			Width = 200,
			Height = 20,
			Items = {},
			Frame = contextFrame:Clone()
		},{})
		
		local mainFrame = newMt.Frame
		local entryFrame = contextEntry:Clone()
		local dividerFrame = contextDivider:Clone()
		
		mainFrame.ScrollingEnabled = false
		
		local function add(self,item)
			local newItem = {
				Name = item.Name or "Item",
				Icon = item.Icon or "",
				Shortcut = item.Shortcut or "",
				OnClick = item.OnClick,
				OnHover = item.OnHover,
				Disabled = item.Disabled or false,
				DisabledIcon = item.DisabledIcon or ""
			}
			table.insert(self.Items,newItem)
		end
		newMt.Add = add
		
		local function addDivider(self)
			table.insert(self.Items,"Divider")
		end
		newMt.AddDivider = addDivider
		
		local function clear(self)
			self.Items = {}
		end
		newMt.Clear = clear
		
		local function refresh(self)
			mainFrame:ClearAllChildren()
			
			local currentPos = 2
			for _,item in pairs(self.Items) do
				if item == "Divider" then
					local newDivider = dividerFrame:Clone()
					newDivider.Position = UDim2.new(0,0,0,currentPos)
					newDivider.Parent = mainFrame
					currentPos = currentPos + 12
				else
					local newEntry = entryFrame:Clone()
					newEntry.Position = UDim2.new(0,0,0,currentPos)
					newEntry.EntryName.Text = item.Name
					newEntry.Shortcut.Text = item.Shortcut
					if item.Disabled then
						newEntry.EntryName.TextColor3 = Color3.new(150/255,150/255,150/255)
						newEntry.Shortcut.TextColor3 = Color3.new(150/255,150/255,150/255)
					end
					
					local useIcon = item.Disabled and item.DisabledIcon or item.Icon
					if type(useIcon) == "string" then
						newEntry.IconFrame.Icon.Image = useIcon
					else
						newEntry.IconFrame:Destroy()
						local newIcon = useIcon:Clone()
						newIcon.Position = UDim2.new(0,2,0.5,-8)
						newIcon.Parent = newEntry
					end
					
					if item.OnClick and not item.Disabled then newEntry.MouseButton1Click:Connect(item.OnClick) end
					
					newEntry.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							newEntry.BackgroundTransparency = 0.5
						end
					end)
					
					newEntry.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							newEntry.BackgroundTransparency = 1
						end
					end)
					
					newEntry.Parent = mainFrame
					currentPos = currentPos + self.Height
				end
			end
			
			mainFrame.Size = UDim2.new(0,self.Width,0,currentPos+2)
		end
		newMt.Refresh = refresh
		
		local function show(self,displayFrame,x,y)
			local toSize = mainFrame.Size.Y.Offset
			local reverseY = false
			
			local maxX,maxY = gui.AbsoluteSize.X,gui.AbsoluteSize.Y
			
			if x + self.Width > maxX then x = x - self.Width end
			if y + toSize > maxY then reverseY = true end
			
			mainFrame.Position = UDim2.new(0,x,0,y)
			mainFrame.Size = UDim2.new(0,self.Width,0,0)
			mainFrame.Parent = displayFrame
			
			local closeEvent = Services.UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
				
				if not f.checkMouseInGui(mainFrame) then
					self:Hide()
				end
			end)
			
			if reverseY then
				if y - toSize < 0 then y = toSize end
				mainFrame:TweenSizeAndPosition(UDim2.new(0,self.Width,0,toSize),UDim2.new(0,x,0,y - toSize),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.2,true)
			else
				mainFrame:TweenSize(UDim2.new(0,self.Width,0,toSize),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.2,true)
			end
		end
		newMt.Show = show
		
		local function hide(self)
			mainFrame.Parent = nil
		end
		newMt.Hide = hide
		
		return newMt
	end
end

-- Explorer
local workspaces = {
	["Default"] = {
		Data = {"Default"},
		IsDefault = true
	}
}
local nodes = {}

local explorerPanel
local propertiesPanel

local entryTemplate = resources:WaitForChild("Entry")

local iconMap = "rbxassetid://765660635"
local iconIndex = {
	-- Core
	NodeCollapsed = 165;
	NodeExpanded = 166;
	NodeCollapsedOver = 179;
	NodeExpandedOver = 180;
	
	-- Buttons
	CUT_ICON = 174;
	COPY_ICON = 175;
	PASTE_ICON = 176;
	DELETE_ICON = 177;
	GROUP_ICON = 150;
	UNGROUP_ICON = 151;
	SELECTCHILDREN_ICON = 152;
	
	CUT_D_ICON = 160;
	COPY_D_ICON = 161;
	PASTE_D_ICON = 162;
	DELETE_D_ICON = 163;
	GROUP_D_ICON = 136;
	UNGROUP_D_ICON = 137;
	SELECTCHILDREN_D_ICON = 138;
	
	-- Classes
	["Accessory"] = 32;
	["Accoutrement"] = 32;
	["AdvancedDragger"] = 41;
	["AdService"] = 73;
	["AlignOrientation"] = 110;
	["AlignPosition"] = 111;
	["Animation"] = 60;
	["AnimationController"] = 60;
	["AnimationTrack"] = 60;
	["Animator"] = 60;
	["ArcHandles"] = 56;
	["AssetService"] = 72;
	["Attachment"] = 92;
	["Backpack"] = 20;
	["BadgeService"] = 75;
	["BallSocketConstraint"] = 97;
	["BillboardGui"] = 64;
	["BinaryStringValue"] = 4;
	["BindableEvent"] = 67;
	["BindableFunction"] = 66;
	["BlockMesh"] = 8;
	["BloomEffect"] = 90;
	["BlurEffect"] = 90;
	["BodyAngularVelocity"] = 14;
	["BodyForce"] = 14;
	["BodyGyro"] = 14;
	["BodyPosition"] = 14;
	["BodyThrust"] = 14;
	["BodyVelocity"] = 14;
	["BoolValue"] = 4;
	["BoxHandleAdornment"] = 54;
	["BrickColorValue"] = 4;
	["Camera"] = 5;
	["CFrameValue"] = 4;
	["ChangeHistoryService"] = 118;
	["CharacterMesh"] = 60;
	["Chat"] = 33;
	["ClickDetector"] = 41;
	["CollectionService"] = 30;
	["Color3Value"] = 4;
	["ColorCorrectionEffect"] = 90;
	["ConeHandleAdornment"] = 54;
	["Configuration"] = 58;
	["ContentProvider"] = 72;
	["ContextActionService"] = 41;
	["ControllerService"] = 84;
	["CookiesService"] = 119;
	["CoreGui"] = 46;
	["CoreScript"] = 91;
	["CornerWedgePart"] = 1;
	["CustomEvent"] = 4;
	["CustomEventReceiver"] = 4;
	["CylinderHandleAdornment"] = 54;
	["CylinderMesh"] = 8;
	["CylindricalConstraint"] = 89;
	["Debris"] = 30;
	["Decal"] = 7;
	["Dialog"] = 62;
	["DialogChoice"] = 63;
	["DoubleConstrainedValue"] = 4;
	["Explosion"] = 36;
	["FileMesh"] = 8;
	["Fire"] = 61;
	["Flag"] = 38;
	["FlagStand"] = 39;
	["FloorWire"] = 4;
	["Folder"] = 70;
	["ForceField"] = 37;
	["Frame"] = 48;
	["FriendService"] = 121;
	["GamepadService"] = 84;
	["GamePassService"] = 19;
	["Geometry"] = 120;
	["Glue"] = 34;
	["GuiButton"] = 52;
	["GuiMain"] = 47;
	["GuiService"] = 47;
	["Handles"] = 53;
	["HapticService"] = 84;
	["Hat"] = 45;
	["HingeConstraint"] = 89;
	["Hint"] = 33;
	["HopperBin"] = 22;
	["HttpRbxApiService"] = 76;
	["HttpService"] = 76;
	["Humanoid"] = 9;
	["HumanoidController"] = 9;
	["ImageButton"] = 52;
	["ImageLabel"] = 49;
	["InsertService"] = 72;
	["IntConstrainedValue"] = 4;
	["IntValue"] = 4;
	["JointInstance"] = 34;
	["JointsService"] = 34;
	["Keyframe"] = 60;
	["KeyframeSequence"] = 60;
	["KeyframeSequenceProvider"] = 60;
	["Lighting"] = 13;
	["LineForce"] = 112;
	["LineHandleAdornment"] = 54;
	["LocalScript"] = 18;
	["LogService"] = 87;
	["LuaWebService"] = 91;
	["MarketplaceService"] = 106;
	["MeshContentProvider"] = 8;
	["MeshPart"] = 77;
	["Message"] = 33;
	["Model"] = 2;
	["ModuleScript"] = 71;
	["Motor"] = 34;
	["Motor6D"] = 34;
	["MoveToConstraint"] = 89;
	["NegateOperation"] = 78;
	["NetworkClient"] = 16;
	["NetworkReplicator"] = 29;
	["NetworkServer"] = 15;
	["NotificationService"] = 117;
	["NumberValue"] = 4;
	["ObjectValue"] = 4;
	["Pants"] = 44;
	["ParallelRampPart"] = 1;
	["Part"] = 1;
	["ParticleEmitter"] = 69;
	["PartPairLasso"] = 57;
	["PathfindingService"] = 37;
	["PersonalServerService"] = 121;
	["PhysicsService"] = 30;
	["Platform"] = 35;
	["Player"] = 12;
	["PlayerGui"] = 46;
	["Players"] = 21;
	["PlayerScripts"] = 82;
	["PointLight"] = 13;
	["PointsService"] = 83;
	["Pose"] = 60;
	["PrismaticConstraint"] = 89;
	["PrismPart"] = 1;
	["PyramidPart"] = 1;
	["RayValue"] = 4;
	["ReflectionMetadata"] = 86;
	["ReflectionMetadataCallbacks"] = 86;
	["ReflectionMetadataClass"] = 86;
	["ReflectionMetadataClasses"] = 86;
	["ReflectionMetadataEnum"] = 86;
	["ReflectionMetadataEnumItem"] = 86;
	["ReflectionMetadataEnums"] = 86;
	["ReflectionMetadataEvents"] = 86;
	["ReflectionMetadataFunctions"] = 86;
	["ReflectionMetadataMember"] = 86;
	["ReflectionMetadataProperties"] = 86;
	["ReflectionMetadataYieldFunctions"] = 86;
	["RemoteEvent"] = 80;
	["RemoteFunction"] = 79;
	["RenderHooksService"] = 122;
	["ReplicatedFirst"] = 72;
	["ReplicatedStorage"] = 72;
	["RightAngleRampPart"] = 1;
	["RocketPropulsion"] = 14;
	["RodConstraint"] = 89;
	["RopeConstraint"] = 89;
	["Rotate"] = 34;
	["RotateP"] = 34;
	["RotateV"] = 34;
	["RunService"] = 124;
	["RuntimeScriptService"] = 91;
	["ScreenGui"] = 47;
	["Script"] = 6;
	["ScriptContext"] = 82;
	["ScriptService"] = 91;
	["ScrollingFrame"] = 48;
	["Seat"] = 35;
	["Selection"] = 55;
	["SelectionBox"] = 54;
	["SelectionPartLasso"] = 57;
	["SelectionPointLasso"] = 57;
	["SelectionSphere"] = 54;
	["ServerScriptService"] = 115;
	["ServerStorage"] = 74;
	["Shirt"] = 43;
	["ShirtGraphic"] = 40;
	["SkateboardPlatform"] = 35;
	["Sky"] = 28;
	["SlidingBallConstraint"] = 89;
	["Smoke"] = 59;
	["Snap"] = 34;
	["SolidModelContentProvider"] = 77;
	["Sound"] = 11;
	["SoundGroup"] = 93;
	["SoundService"] = 31;
	["Sparkles"] = 42;
	["SpawnLocation"] = 25;
	["SpecialMesh"] = 8;
	["SphereHandleAdornment"] = 54;
	["SpotLight"] = 13;
	["SpringConstraint"] = 89;
	["StarterCharacterScripts"] = 82;
	["StarterGear"] = 20;
	["StarterGui"] = 46;
	["StarterPack"] = 20;
	["StarterPlayer"] = 88;
	["StarterPlayerScripts"] = 82;
	["Status"] = 2;
	["StringValue"] = 4;
	["SunRaysEffect"] = 90;
	["SurfaceGui"] = 64;
	["SurfaceLight"] = 13;
	["SurfaceSelection"] = 55;
	["Team"] = 24;
	["Teams"] = 23;
	["TeleportService"] = 81;
	["Terrain"] = 65;
	["TerrainRegion"] = 65;
	["TestService"] = 68;
	["TextBox"] = 51;
	["TextButton"] = 51;
	["TextLabel"] = 50;
	["TextService"] = 50;
	["Texture"] = 10;
	["TextureTrail"] = 4;
	["TimerService"] = 118;
	["Tool"] = 17;
	["Torque"] = 113;
	["TouchInputService"] = 84;
	["TouchTransmitter"] = 37;
	["TrussPart"] = 1;
	["TweenService"] = 109;
	["UnionOperation"] = 77;
	["UserInputService"] = 84;
	["Vector3Value"] = 4;
	["VehicleSeat"] = 35;
	["VelocityMotor"] = 34;
	["Visit"] = 123;
	["VRService"] = 95;
	["WedgePart"] = 1;
	["Weld"] = 34;
	["Workspace"] = 19;
	[""] = 116;
}

entryTemplate.Indent.IconFrame.Icon.Image = iconMap

-- Properties
local propCategories = {
    ["Instance"] = {
        ["Archivable"] = "Behavior",
        ["ClassName"] = "Data",
        ["DataCost"] = "Data",
        ["Name"] = "Data",
        ["Parent"] = "Data",
        ["RobloxLocked"] = "Data"
    },
    ["BasePart"] = {
        ["Anchored"] = "Behavior",
        ["BackParamA"] = "Surface Inputs",
        ["BackParamB"] = "Surface Inputs",
        ["BackSurface"] = "Surface",
        ["BackSurfaceInput"] = "Surface Inputs",
        ["BottomParamA"] = "Surface Inputs",
        ["BottomParamB"] = "Surface Inputs",
        ["BottomSurface"] = "Surface",
        ["BottomSurfaceInput"] = "Surface Inputs",
        ["BrickColor"] = "Appearance",
        ["CFrame"] = "Data",
        ["CanCollide"] = "Behavior",
        ["CollisionGroupId"] = "Data",
        ["CustomPhysicalProperties"] = "Part",
        ["DraggingV1"] = "Behavior",
        ["Elasticity"] = "Part",
        ["Friction"] = "Part",
        ["FrontParamA"] = "Surface Inputs",
        ["FrontParamB"] = "Surface Inputs",
        ["FrontSurface"] = "Surface",
        ["FrontSurfaceInput"] = "Surface Inputs",
        ["LeftParamA"] = "Surface Inputs",
        ["LeftParamB"] = "Surface Inputs",
        ["LeftSurface"] = "Surface",
        ["LeftSurfaceInput"] = "Surface Inputs",
        ["LocalTransparencyModifier"] = "Data",
        ["Locked"] = "Behavior",
        ["Material"] = "Appearance",
        ["NetworkIsSleeping"] = "Data",
        ["NetworkOwnerV3"] = "Data",
        ["NetworkOwnershipRule"] = "Behavior",
        ["NetworkOwnershipRuleBool"] = "Behavior",
        ["Position"] = "Data",
        ["ReceiveAge"] = "Part",
        ["Reflectance"] = "Appearance",
        ["ResizeIncrement"] = "Behavior",
        ["ResizeableFaces"] = "Behavior",
        ["RightParamA"] = "Surface Inputs",
        ["RightParamB"] = "Surface Inputs",
        ["RightSurface"] = "Surface",
        ["RightSurfaceInput"] = "Surface Inputs",
        ["RotVelocity"] = "Data",
        ["Rotation"] = "Data",
        ["Size"] = "Part",
        ["TopParamA"] = "Surface Inputs",
        ["TopParamB"] = "Surface Inputs",
        ["TopSurface"] = "Surface",
        ["TopSurfaceInput"] = "Surface Inputs",
        ["Transparency"] = "Appearance",
        ["Velocity"] = "Data"
    },
    ["Part"] = {
        ["Shape"] = "Part"
    },
    ["Message"] = {
        ["Text"] = "Appearance"
    },
    ["Camera"] = {
        ["CFrame"] = "Data",
        ["CameraSubject"] = "Camera",
        ["CameraType"] = "Camera",
        ["FieldOfView"] = "Data",
        ["Focus"] = "Data",
        ["HeadLocked"] = "Data",
        ["HeadScale"] = "Data",
        ["ViewportSize"] = "Data"
    },
    ["Animation"] = {
        ["AnimationId"] = "Data",
        ["Loop"] = "Data",
        ["Priority"] = "Data"
    },
    ["PVAdornment"] = {
        ["Adornee"] = "Data"
    },
    ["PartAdornment"] = {
        ["Adornee"] = "Data"
    },
    ["Decal"] = {
        ["Color3"] = "Appearance",
        ["LocalTransparencyModifier"] = "Appearance",
        ["Shiny"] = "Appearance",
        ["Specular"] = "Appearance",
        ["Texture"] = "Appearance",
        ["Transparency"] = "Appearance"
    },
    ["Texture"] = {
        ["StudsPerTileU"] = "Appearance",
        ["StudsPerTileV"] = "Appearance"
    },
    ["Feature"] = {
        ["FaceId"] = "Data",
        ["InOut"] = "Data",
        ["LeftRight"] = "Data",
        ["TopBottom"] = "Data"
    },
    ["VelocityMotor"] = {
        ["CurrentAngle"] = "Data",
        ["DesiredAngle"] = "Data",
        ["Hole"] = "Data",
        ["MaxVelocity"] = "Data",
    },
    ["JointInstance"] = {
        ["C0"] = "Data",
        ["C1"] = "Data",
        ["Part0"] = "Data",
        ["Part1"] = "Data"
    },
    ["DynamicRotate"] = {
        ["BaseAngle"] = "Data"
    },
    ["Motor"] = {
        ["CurrentAngle"] = "Data",
        ["DesiredAngle"] = "Data",
        ["MaxVelocity"] = "Data"
    },
    ["Glue"] = {
        ["F0"] = "Data",
        ["F1"] = "Data",
        ["F2"] = "Data",
        ["F3"] = "Data"
    },
    ["ManualSurfaceJointInstance"] = {
        ["Surface0"] = "Data",
        ["Surface1"] = "Data"
    },
    ["Explosion"] = {
        ["BlastPressure"] = "Data",
        ["BlastRadius"] = "Data",
        ["DestroyJointRadiusPercent"] = "Data",
        ["ExplosionType"] = "Data",
        ["Position"] = "Data",
        ["Visible"] = "Data"
    },
    ["Sparkles"] = {
        ["Enabled"] = "Data",
        ["SparkleColor"] = "Data"
    },
    ["Fire"] = {
        ["Color"] = "Data",
        ["Enabled"] = "Data",
        ["Heat"] = "Data",
        ["SecondaryColor"] = "Data",
        ["Size"] = "Data"
    },
    ["Smoke"] = {
        ["Color"] = "Data",
        ["Enabled"] = "Data",
        ["Opacity"] = "Data",
        ["RiseVelocity"] = "Data",
        ["Size"] = "Data"
    },
    ["ParticleEmitter"] = {
        ["Acceleration"] = "Motion",
        ["Color"] = "Appearance",
        ["Drag"] = "Particles",
        ["EmissionDirection"] = "Emission",
        ["Enabled"] = "Emission",
        ["Lifetime"] = "Emission",
        ["LightEmission"] = "Appearance",
        ["LockedToPart"] = "Particles",
        ["Rate"] = "Emission",
        ["RotSpeed"] = "Emission",
        ["Rotation"] = "Emission",
        ["Size"] = "Appearance",
        ["Speed"] = "Emission",
        ["Texture"] = "Appearance",
        ["Transparency"] = "Appearance",
        ["VelocityInheritance"] = "Particles",
        ["VelocitySpread"] = "Emission",
        ["ZOffset"] = "Appearance"
    },
    ["Sky"] = {
        ["CelestialBodiesShown"] = "Appearance",
        ["SkyboxBk"] = "Appearance",
        ["SkyboxDn"] = "Appearance",
        ["SkyboxFt"] = "Appearance",
        ["SkyboxLf"] = "Appearance",
        ["SkyboxRt"] = "Appearance",
        ["SkyboxUp"] = "Appearance",
        ["StarCount"] = "Appearance"
    },
    ["Stats"] = {
        ["MinReportInterval"] = "Reporting",
        ["ReporterType"] = "Reporting"
    },
    ["StarterPlayer"] = {
        ["AutoJumpEnabled"] = "Mobile",
        ["CameraMaxZoomDistance"] = "Camera",
        ["CameraMinZoomDistance"] = "Camera",
        ["CameraMode"] = "Camera",
        ["DevCameraOcclusionMode"] = "Camera",
        ["DevComputerCameraMovementMode"] = "Camera",
        ["DevComputerMovementMode"] = "Controls",
        ["DevTouchCameraMovementMode"] = "Camera",
        ["DevTouchMovementMode"] = "Controls",
        ["EnableMouseLockOption"] = "Controls",
        ["HealthDisplayDistance"] = "Data",
        ["LoadCharacterAppearance"] = "Character",
        ["NameDisplayDistance"] = "Data",
        ["ScreenOrientation"] = "Mobile"
    },
    ["Lighting"] = {
        ["Ambient"] = "Appearance",
        ["Brightness"] = "Appearance",
        ["ColorShift_Bottom"] = "Appearance",
        ["ColorShift_Top"] = "Appearance",
        ["FogColor"] = "Fog",
        ["FogEnd"] = "Fog",
        ["FogStart"] = "Fog",
        ["GeographicLatitude"] = "Data",
        ["GlobalShadows"] = "Appearance",
        ["OutdoorAmbient"] = "Appearance",
        ["Outlines"] = "Appearance",
        ["TimeOfDay"] = "Data"
    },
    ["LocalizationService"] = {
        ["LocaleId"] = "Behavior",
        ["PreferredLanguage"] = "Behavior"
    },
    ["Light"] = {
        ["Brightness"] = "Appearance",
        ["Color"] = "Appearance",
        ["Enabled"] = "Appearance",
        ["Shadows"] = "Appearance"
    },
    ["PointLight"] = {
        ["Range"] = "Appearance"
    },
    ["SpotLight"] = {
        ["Angle"] = "Appearance",
        ["Face"] = "Appearance",
        ["Range"] = "Appearance"
    },
    ["SurfaceLight"] = {
        ["Angle"] = "Appearance",
        ["Face"] = "Appearance",
        ["Range"] = "Appearance"
    },
    ["TrussPart"] = {
        ["Style"] = "Part"
    },
    ["Attachment"] = {
        ["Axis"] = "Derived Data",
        ["CFrame"] = "Data",
        ["Position"] = "Data",
        ["Rotation"] = "Data",
        ["SecondaryAxis"] = "Derived Data",
        ["Visible"] = "Appearance",
        ["WorldAxis"] = "Derived Data",
        ["WorldPosition"] = "Derived Data",
        ["WorldRotation"] = "Derived Data",
        ["WorldSecondaryAxis"] = "Derived Data"
    },
    ["Humanoid"] = {
        ["AutoJumpEnabled"] = "Control",
        ["AutoRotate"] = "Control",
        ["CameraMaxDistance"] = "Data",
        ["CameraMinDistance"] = "Data",
        ["CameraMode"] = "Data",
        ["CameraOffset"] = "Data",
        ["DisplayDistanceType"] = "Data",
        ["Health"] = "Game",
        ["HealthDisplayDistance"] = "Data",
        ["Health_XML"] = "Game",
        ["HipHeight"] = "Game",
        ["Jump"] = "Control",
        ["JumpPower"] = "Game",
        ["JumpReplicate"] = "Control",
        ["LeftLeg"] = "Data",
        ["MaxHealth"] = "Game",
        ["MaxSlopeAngle"] = "Game",
        ["MoveDirection"] = "Control",
        ["MoveDirectionInternal"] = "Control",
        ["NameDisplayDistance"] = "Data",
        ["NameOcclusion"] = "Data",
        ["PlatformStand"] = "Control",
        ["RigType"] = "Data",
        ["RightLeg"] = "Data",
        ["SeatPart"] = "Control",
        ["Sit"] = "Control",
        ["Strafe"] = "Control",
        ["TargetPoint"] = "Control",
        ["Torso"] = "Data",
        ["WalkAngleError"] = "Control",
        ["WalkDirection"] = "Control",
        ["WalkSpeed"] = "Game",
        ["WalkToPart"] = "Control",
        ["WalkToPoint"] = "Control"
    }
}

local categoryOrder = {["Appearance"] = 1,["Data"] = 2,["Goals"] = 3,["Thrust"] = 4,["Turn"] = 5,["Camera"] = 6,["Behavior"] = 7,["Compliance"] = 8,["AlignOrientation"] = 9,["AlignPosition"] = 10,["Derived"] = 11,["LineForce"] = 12,["Rod"] = 13,["Constraint"] = 14,["Spring"] = 15,["Torque"] = 16,["VectorForce"] = 17,["Attachments"] = 18,["Axes"] = 19,["Image"] = 20,["Text"] = 21,["Scrolling"] = 22,["State"] = 23,["Control"] = 24,["Game"] = 25,["Fog"] = 26,["Settings"] = 27,["Physics"] = 28,["Teams"] = 29,["Forcefield"] = 30,["Part"] = 31,["Surface Inputs"] = 32,["Surface"] = 33,["Motion"] = 34,["Particles"] = 35,["Emission"] = 36,["Reflection"] = 37,["Mobile"] = 38,["Controls"] = 39,["Character"] = 40,["Results"] = 41,["Other"] = 42}

-- Gui Functions
local function getResource(name)
	return resources:WaitForChild(name):Clone()
end

function f.prevProportions(t,ind)
	local count = 0	
	for i = ind,1,-1 do
		count = count + t[i].Proportion
	end
	return count
end

function f.buildPanes()
	--print("\n-----\n")
	--for i,v in pairs(RPaneItems) do print(v.Window) end
	--print("\n-----")
	
	for i,v in pairs(RPaneItems) do
		v.Window:TweenSizeAndPosition(UDim2.new(0,explorerSettings.RPaneWidth,v.Proportion,0),UDim2.new(0,0,f.prevProportions(RPaneItems,i-1),0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)
		--v.Window.Position = UDim2.new(0,0,prevProportions(RPaneItems,i-1),0)
		--v.Window.Size = UDim2.new(0,explorerSettings.RPaneWidth,v.Proportion,0)
	end
end

function f.distance(x1,y1,x2,y2)
	return math.sqrt((x2-x1)^2+(y2-y1)^2)
end

function f.checkMouseInGui(gui)
	if gui == nil then return false end
	local guiPosition = gui.AbsolutePosition
	local guiSize = gui.AbsoluteSize	
	
	if mouse.X >= guiPosition.x and mouse.X <= guiPosition.x + guiSize.x and mouse.Y >= guiPosition.y and mouse.Y <= guiPosition.y + guiSize.y then
		return true
	else
		return false
	end
end

function f.addToPane(window,pane)
	if pane == "Right" then
		for i,v in pairs(RPaneItems) do if v.Window == window then return end end
		for i,v in pairs(RPaneItems) do
			RPaneItems[i].Proportion = v.Proportion / 100 * 80
		end
		window.Parent = contentR
		if #RPaneItems == 0 then
			table.insert(RPaneItems,{Window = window, Proportion = 1})
		else
			table.insert(RPaneItems,{Window = window, Proportion = 0.2})
		end
	end
	f.buildPanes()
end

function f.removeFromPane(window)
	local pane
	local windowIndex
	
	for i,v in pairs(LPaneItems) do if v.Window == window then pane = LPaneItems windowIndex = i end end
	for i,v in pairs(RPaneItems) do if v.Window == window then pane = RPaneItems windowIndex = i end end	
	
	if pane and #pane > 0 then
		local weightTop,weightBottom,weightTopN,weightBottomN = 0,0			
		
		for i = windowIndex-1,1,-1 do weightTop = weightTop + RPaneItems[i].Proportion end	
		for i = windowIndex+1,#RPaneItems do weightBottom = weightBottom + RPaneItems[i].Proportion end	
		
		if weightTop > 0 and weightBottom == 0 then
			weightTopN = weightTop + RPaneItems[windowIndex].Proportion
		elseif weightTop == 0 and weightBottom > 0 then
			weightBottomN = weightBottom + RPaneItems[windowIndex].Proportion
		else
			weightTopN = weightTop + RPaneItems[windowIndex].Proportion/2
			weightBottomN = weightBottom + RPaneItems[windowIndex].Proportion/2
		end
			
		for i = 1,windowIndex-1 do
			RPaneItems[i].Proportion = RPaneItems[i].Proportion / weightTop * weightTopN
		end
		for i = windowIndex+1,#RPaneItems do
			RPaneItems[i].Proportion = RPaneItems[i].Proportion / weightBottom * weightBottomN
		end

		table.remove(RPaneItems,windowIndex)
		f.buildPanes()
	end
end

function f.resizePaneItem(window,pane,size)
	local windowIndex = 0
	local sizeWeight = 0
	size = math.max(0.2,size)
	if pane == "Right" then
		for i,v in pairs(RPaneItems) do
			if v.Window == window then windowIndex = i break end
		end
			
		for i = windowIndex+1,#RPaneItems do
			sizeWeight = sizeWeight + RPaneItems[i].Proportion
		end
		
		local oldSize = 1-(sizeWeight+RPaneItems[windowIndex].Proportion)
		
		RPaneItems[windowIndex].Proportion = size
		
		for i = 1,windowIndex-1 do
			RPaneItems[i].Proportion = RPaneItems[i].Proportion / oldSize * (1-(sizeWeight+size))
		end
		
		for i,v in pairs(RPaneItems) do
			print(v.Window, v.Proportion)
		end
	end
	f.buildPanes()
end

f.fetchAPI = function()
    local classes,enums,rawAPI = {},{},nil
    if script and script:FindFirstChild("API") then
        rawAPI = require(script.API)
    else
        rawAPI = [==[[{"Superclass":null,"type":"Class","Name":"Instance","tags":["notbrowsable"]},{"ValueType":"bool","type":"Property","Name":"Archivable","tags":[],"Class":"Instance"},{"ValueType":"string","type":"Property","Name":"ClassName","tags":["readonly"],"Class":"Instance"},{"ValueType":"int","type":"Property","Name":"DataCost","tags":["LocalUserSecurity","readonly"],"Class":"Instance"},{"ValueType":"string","type":"Property","Name":"Name","tags":[],"Class":"Instance"},{"ValueType":"Object","type":"Property","Name":"Parent","tags":[],"Class":"Instance"},{"ValueType":"bool","type":"Property","Name":"RobloxLocked","tags":["PluginSecurity"],"Class":"Instance"},{"ValueType":"bool","type":"Property","Name":"archivable","tags":["deprecated","hidden"],"Class":"Instance"},{"ValueType":"string","type":"Property","Name":"className","tags":["deprecated","readonly"],"Class":"Instance"},{"ReturnType":"void","Arguments":[],"Name":"ClearAllChildren","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[],"Name":"Clone","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"Destroy","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"name","Default":null}],"Name":"FindFirstAncestor","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"className","Default":null}],"Name":"FindFirstAncestorOfClass","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"className","Default":null}],"Name":"FindFirstAncestorWhichIsA","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"name","Default":null},{"Type":"bool","Name":"recursive","Default":"false"}],"Name":"FindFirstChild","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"className","Default":null}],"Name":"FindFirstChildOfClass","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"className","Default":null},{"Type":"bool","Name":"recursive","Default":"false"}],"Name":"FindFirstChildWhichIsA","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Objects","Arguments":[],"Name":"GetChildren","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"string","Arguments":[{"Type":"int","Name":"scopeLength","Default":"4"}],"Name":"GetDebugId","tags":["PluginSecurity","notbrowsable"],"Class":"Instance","type":"Function"},{"ReturnType":"Array","Arguments":[],"Name":"GetDescendants","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"string","Arguments":[],"Name":"GetFullName","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"EventInstance","Arguments":[{"Type":"string","Name":"property","Default":null}],"Name":"GetPropertyChangedSignal","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"string","Name":"className","Default":null}],"Name":"IsA","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"Instance","Name":"descendant","Default":null}],"Name":"IsAncestorOf","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"Instance","Name":"ancestor","Default":null}],"Name":"IsDescendantOf","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"Remove","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"childName","Default":null},{"Type":"double","Name":"timeOut","Default":null}],"Name":"WaitForChild","tags":[],"Class":"Instance","type":"Function"},{"ReturnType":"Objects","Arguments":[],"Name":"children","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[],"Name":"clone","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"destroy","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"string","Name":"name","Default":null},{"Type":"bool","Name":"recursive","Default":"false"}],"Name":"findFirstChild","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"Objects","Arguments":[],"Name":"getChildren","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"string","Name":"className","Default":null}],"Name":"isA","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"Instance","Name":"ancestor","Default":null}],"Name":"isDescendantOf","tags":["deprecated"],"Class":"Instance","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"remove","tags":["deprecated"],"Class":"Instance","type":"Function"},{"Arguments":[{"Name":"child","Type":"Instance"},{"Name":"parent","Type":"Instance"}],"Name":"AncestryChanged","tags":[],"Class":"Instance","type":"Event"},{"Arguments":[{"Name":"property","Type":"Property"}],"Name":"Changed","tags":[],"Class":"Instance","type":"Event"},{"Arguments":[{"Name":"child","Type":"Instance"}],"Name":"ChildAdded","tags":[],"Class":"Instance","type":"Event"},{"Arguments":[{"Name":"child","Type":"Instance"}],"Name":"ChildRemoved","tags":[],"Class":"Instance","type":"Event"},{"Arguments":[{"Name":"descendant","Type":"Instance"}],"Name":"DescendantAdded","tags":[],"Class":"Instance","type":"Event"},{"Arguments":[{"Name":"descendant","Type":"Instance"}],"Name":"DescendantRemoving","tags":[],"Class":"Instance","type":"Event"},{"Arguments":[{"Name":"child","Type":"Instance"}],"Name":"childAdded","tags":["deprecated"],"Class":"Instance","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"Accoutrement","tags":[]},{"ValueType":"Vector3","type":"Property","Name":"AttachmentForward","tags":[],"Class":"Accoutrement"},{"ValueType":"CoordinateFrame","type":"Property","Name":"AttachmentPoint","tags":[],"Class":"Accoutrement"},{"ValueType":"Vector3","type":"Property","Name":"AttachmentPos","tags":[],"Class":"Accoutrement"},{"ValueType":"Vector3","type":"Property","Name":"AttachmentRight","tags":[],"Class":"Accoutrement"},{"ValueType":"Vector3","type":"Property","Name":"AttachmentUp","tags":[],"Class":"Accoutrement"},{"Superclass":"Accoutrement","type":"Class","Name":"Accessory","tags":[]},{"Superclass":"Accoutrement","type":"Class","Name":"Hat","tags":["deprecated"]},{"Superclass":"Instance","type":"Class","Name":"AdService","tags":["notCreatable"]},{"ReturnType":"void","Arguments":[],"Name":"ShowVideoAd","tags":["deprecated"],"Class":"AdService","type":"Function"},{"Arguments":[{"Name":"adShown","Type":"bool"}],"Name":"VideoAdClosed","tags":["deprecated"],"Class":"AdService","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"AdvancedDragger","tags":[]},{"Superclass":"Instance","type":"Class","Name":"AnalyticsService","tags":["notCreatable"]},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"counterName","Default":null},{"Type":"int","Name":"amount","Default":"1"}],"Name":"ReportCounter","tags":["RobloxScriptSecurity"],"Class":"AnalyticsService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"seriesName","Default":null},{"Type":"Dictionary","Name":"points","Default":null},{"Type":"int","Name":"throttlingPercentage","Default":null}],"Name":"ReportInfluxSeries","tags":["RobloxScriptSecurity"],"Class":"AnalyticsService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"category","Default":null},{"Type":"float","Name":"value","Default":null}],"Name":"ReportStats","tags":["RobloxScriptSecurity"],"Class":"AnalyticsService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"target","Default":null},{"Type":"string","Name":"eventContext","Default":null},{"Type":"string","Name":"eventName","Default":null},{"Type":"Dictionary","Name":"additionalArgs","Default":null}],"Name":"SetRBXEvent","tags":["RobloxScriptSecurity"],"Class":"AnalyticsService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"target","Default":null},{"Type":"string","Name":"eventContext","Default":null},{"Type":"string","Name":"eventName","Default":null},{"Type":"Dictionary","Name":"additionalArgs","Default":null}],"Name":"SetRBXEventStream","tags":["RobloxScriptSecurity"],"Class":"AnalyticsService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"category","Default":null},{"Type":"string","Name":"action","Default":null},{"Type":"string","Name":"label","Default":null}],"Name":"TrackEvent","tags":["RobloxScriptSecurity"],"Class":"AnalyticsService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"Dictionary","Name":"args","Default":null}],"Name":"UpdateHeartbeatObject","tags":["RobloxScriptSecurity"],"Class":"AnalyticsService","type":"Function"},{"Superclass":"Instance","type":"Class","Name":"Animation","tags":[]},{"ValueType":"Content","type":"Property","Name":"AnimationId","tags":[],"Class":"Animation"},{"Superclass":"Instance","type":"Class","Name":"AnimationController","tags":[]},{"ReturnType":"Array","Arguments":[],"Name":"GetPlayingAnimationTracks","tags":[],"Class":"AnimationController","type":"Function"},{"ReturnType":"Instance","Arguments":[{"Type":"Instance","Name":"animation","Default":null}],"Name":"LoadAnimation","tags":[],"Class":"AnimationController","type":"Function"},{"Arguments":[{"Name":"animationTrack","Type":"Instance"}],"Name":"AnimationPlayed","tags":[],"Class":"AnimationController","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"AnimationTrack","tags":[]},{"ValueType":"Object","type":"Property","Name":"Animation","tags":["readonly"],"Class":"AnimationTrack"},{"ValueType":"bool","type":"Property","Name":"IsPlaying","tags":["readonly"],"Class":"AnimationTrack"},{"ValueType":"float","type":"Property","Name":"Length","tags":["readonly"],"Class":"AnimationTrack"},{"ValueType":"bool","type":"Property","Name":"Looped","tags":[],"Class":"AnimationTrack"},{"ValueType":"AnimationPriority","type":"Property","Name":"Priority","tags":[],"Class":"AnimationTrack"},{"ValueType":"float","type":"Property","Name":"Speed","tags":["readonly"],"Class":"AnimationTrack"},{"ValueType":"float","type":"Property","Name":"TimePosition","tags":[],"Class":"AnimationTrack"},{"ValueType":"float","type":"Property","Name":"WeightCurrent","tags":["readonly"],"Class":"AnimationTrack"},{"ValueType":"float","type":"Property","Name":"WeightTarget","tags":["readonly"],"Class":"AnimationTrack"},{"ReturnType":"void","Arguments":[{"Type":"float","Name":"speed","Default":"1"}],"Name":"AdjustSpeed","tags":[],"Class":"AnimationTrack","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"float","Name":"weight","Default":"1"},{"Type":"float","Name":"fadeTime","Default":"0.100000001"}],"Name":"AdjustWeight","tags":[],"Class":"AnimationTrack","type":"Function"},{"ReturnType":"double","Arguments":[{"Type":"string","Name":"keyframeName","Default":null}],"Name":"GetTimeOfKeyframe","tags":[],"Class":"AnimationTrack","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"float","Name":"fadeTime","Default":"0.100000001"},{"Type":"float","Name":"weight","Default":"1"},{"Type":"float","Name":"speed","Default":"1"}],"Name":"Play","tags":[],"Class":"AnimationTrack","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"float","Name":"fadeTime","Default":"0.100000001"}],"Name":"Stop","tags":[],"Class":"AnimationTrack","type":"Function"},{"Arguments":[],"Name":"DidLoop","tags":[],"Class":"AnimationTrack","type":"Event"},{"Arguments":[{"Name":"keyframeName","Type":"string"}],"Name":"KeyframeReached","tags":[],"Class":"AnimationTrack","type":"Event"},{"Arguments":[],"Name":"Stopped","tags":[],"Class":"AnimationTrack","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"Animator","tags":[]},{"ReturnType":"Instance","Arguments":[{"Type":"Instance","Name":"animation","Default":null}],"Name":"LoadAnimation","tags":[],"Class":"Animator","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"float","Name":"deltaTime","Default":null}],"Name":"StepAnimations","tags":["PluginSecurity"],"Class":"Animator","type":"Function"},{"Superclass":"Instance","type":"Class","Name":"AssetService","tags":[]},{"ReturnType":"int","Arguments":[{"Type":"string","Name":"placeName","Default":null},{"Type":"int64","Name":"templatePlaceID","Default":null},{"Type":"string","Name":"description","Default":""}],"Name":"CreatePlaceAsync","tags":[],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"int","Arguments":[{"Type":"Instance","Name":"player","Default":null},{"Type":"string","Name":"placeName","Default":null},{"Type":"int64","Name":"templatePlaceID","Default":null},{"Type":"string","Name":"description","Default":""}],"Name":"CreatePlaceInPlayerInventoryAsync","tags":[],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"Array","Arguments":[{"Type":"int64","Name":"packageAssetId","Default":null}],"Name":"GetAssetIdsForPackage","tags":[],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"Tuple","Arguments":[{"Type":"int64","Name":"assetId","Default":null},{"Type":"Vector2","Name":"thumbnailSize","Default":null},{"Type":"int","Name":"assetType","Default":"0"}],"Name":"GetAssetThumbnailAsync","tags":["RobloxScriptSecurity"],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"Dictionary","Arguments":[{"Type":"int","Name":"placeId","Default":null},{"Type":"int","Name":"pageNum","Default":"1"}],"Name":"GetAssetVersions","tags":[],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"int","Arguments":[{"Type":"int","Name":"creationID","Default":null}],"Name":"GetCreatorAssetID","tags":["deprecated"],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"Instance","Arguments":[],"Name":"GetGamePlacesAsync","tags":[],"Class":"AssetService","type":"Function"},{"ReturnType":"Dictionary","Arguments":[{"Type":"int","Name":"placeId","Default":null}],"Name":"GetPlacePermissions","tags":[],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"placeId","Default":null},{"Type":"int","Name":"versionNumber","Default":null}],"Name":"RevertAsset","tags":[],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"void","Arguments":[],"Name":"SavePlaceAsync","tags":[],"Class":"AssetService","type":"YieldFunction"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"placeId","Default":null},{"Type":"AccessType","Name":"accessType","Default":"Everyone"},{"Type":"Array","Name":"inviteList","Default":"{}"}],"Name":"SetPlacePermissions","tags":[],"Class":"AssetService","type":"YieldFunction"},{"Superclass":"Instance","type":"Class","Name":"Attachment","tags":[]},{"ValueType":"Vector3","type":"Property","Name":"Axis","tags":[],"Class":"Attachment"},{"ValueType":"CoordinateFrame","type":"Property","Name":"CFrame","tags":[],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"Orientation","tags":[],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"Position","tags":[],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"Rotation","tags":[],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"SecondaryAxis","tags":[],"Class":"Attachment"},{"ValueType":"bool","type":"Property","Name":"Visible","tags":[],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"WorldAxis","tags":["readonly"],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"WorldOrientation","tags":["readonly"],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"WorldPosition","tags":["readonly"],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"WorldRotation","tags":["deprecated","readonly"],"Class":"Attachment"},{"ValueType":"Vector3","type":"Property","Name":"WorldSecondaryAxis","tags":["readonly"],"Class":"Attachment"},{"ReturnType":"Vector3","Arguments":[],"Name":"GetAxis","tags":[],"Class":"Attachment","type":"Function"},{"ReturnType":"Vector3","Arguments":[],"Name":"GetSecondaryAxis","tags":[],"Class":"Attachment","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"Vector3","Name":"axis","Default":null}],"Name":"SetAxis","tags":[],"Class":"Attachment","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"Vector3","Name":"axis","Default":null}],"Name":"SetSecondaryAxis","tags":[],"Class":"Attachment","type":"Function"},{"Superclass":"Instance","type":"Class","Name":"BadgeService","tags":["notCreatable"]},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"userId","Default":null},{"Type":"int","Name":"badgeId","Default":null}],"Name":"AwardBadge","tags":[],"Class":"BadgeService","type":"YieldFunction"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"badgeId","Default":null}],"Name":"IsDisabled","tags":[],"Class":"BadgeService","type":"YieldFunction"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"badgeId","Default":null}],"Name":"IsLegal","tags":[],"Class":"BadgeService","type":"YieldFunction"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"userId","Default":null},{"Type":"int","Name":"badgeId","Default":null}],"Name":"UserHasBadge","tags":[],"Class":"BadgeService","type":"YieldFunction"},{"Arguments":[{"Name":"message","Type":"string"},{"Name":"userId","Type":"int"},{"Name":"badgeId","Type":"int"}],"Name":"BadgeAwarded","tags":["RobloxScriptSecurity"],"Class":"BadgeService","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"BasePlayerGui","tags":[]},{"Superclass":"BasePlayerGui","type":"Class","Name":"CoreGui","tags":["notCreatable"]},{"ValueType":"Object","type":"Property","Name":"SelectionImageObject","tags":["RobloxScriptSecurity"],"Class":"CoreGui"},{"ValueType":"int","type":"Property","Name":"Version","tags":["readonly"],"Class":"CoreGui"},{"ReturnType":"void","Arguments":[{"Type":"bool","Name":"enabled","Default":null},{"Type":"Instance","Name":"guiAdornee","Default":null},{"Type":"NormalId","Name":"faceId","Default":null}],"Name":"SetUserGuiRendering","tags":["RobloxScriptSecurity"],"Class":"CoreGui","type":"Function"},{"Superclass":"BasePlayerGui","type":"Class","Name":"PlayerGui","tags":["notCreatable"]},{"ValueType":"ScreenOrientation","type":"Property","Name":"CurrentScreenOrientation","tags":["readonly"],"Class":"PlayerGui"},{"ValueType":"ScreenOrientation","type":"Property","Name":"ScreenOrientation","tags":[],"Class":"PlayerGui"},{"ValueType":"Object","type":"Property","Name":"SelectionImageObject","tags":[],"Class":"PlayerGui"},{"ReturnType":"float","Arguments":[],"Name":"GetTopbarTransparency","tags":[],"Class":"PlayerGui","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"float","Name":"transparency","Default":null}],"Name":"SetTopbarTransparency","tags":[],"Class":"PlayerGui","type":"Function"},{"Arguments":[{"Name":"transparency","Type":"float"}],"Name":"TopbarTransparencyChangedSignal","tags":[],"Class":"PlayerGui","type":"Event"},{"Superclass":"BasePlayerGui","type":"Class","Name":"StarterGui","tags":[]},{"ValueType":"bool","type":"Property","Name":"ResetPlayerGuiOnSpawn","tags":["deprecated"],"Class":"StarterGui"},{"ValueType":"ScreenOrientation","type":"Property","Name":"ScreenOrientation","tags":[],"Class":"StarterGui"},{"ValueType":"bool","type":"Property","Name":"ShowDevelopmentGui","tags":[],"Class":"StarterGui"},{"ReturnType":"bool","Arguments":[{"Type":"CoreGuiType","Name":"coreGuiType","Default":null}],"Name":"GetCoreGuiEnabled","tags":[],"Class":"StarterGui","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"parameterName","Default":null},{"Type":"Function","Name":"getFunction","Default":null}],"Name":"RegisterGetCore","tags":["RobloxScriptSecurity"],"Class":"StarterGui","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"parameterName","Default":null},{"Type":"Function","Name":"setFunction","Default":null}],"Name":"RegisterSetCore","tags":["RobloxScriptSecurity"],"Class":"StarterGui","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"parameterName","Default":null},{"Type":"Variant","Name":"value","Default":null}],"Name":"SetCore","tags":[],"Class":"StarterGui","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"CoreGuiType","Name":"coreGuiType","Default":null},{"Type":"bool","Name":"enabled","Default":null}],"Name":"SetCoreGuiEnabled","tags":[],"Class":"StarterGui","type":"Function"},{"ReturnType":"Variant","Arguments":[{"Type":"string","Name":"parameterName","Default":null}],"Name":"GetCore","tags":[],"Class":"StarterGui","type":"YieldFunction"},{"Arguments":[{"Name":"coreGuiType","Type":"CoreGuiType"},{"Name":"enabled","Type":"bool"}],"Name":"CoreGuiChangedSignal","tags":["RobloxScriptSecurity"],"Class":"StarterGui","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"Beam","tags":[]},{"ValueType":"Object","type":"Property","Name":"Attachment0","tags":[],"Class":"Beam"},{"ValueType":"Object","type":"Property","Name":"Attachment1","tags":[],"Class":"Beam"},{"ValueType":"ColorSequence","type":"Property","Name":"Color","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"CurveSize0","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"CurveSize1","tags":[],"Class":"Beam"},{"ValueType":"bool","type":"Property","Name":"Enabled","tags":[],"Class":"Beam"},{"ValueType":"bool","type":"Property","Name":"FaceCamera","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"LightEmission","tags":[],"Class":"Beam"},{"ValueType":"int","type":"Property","Name":"Segments","tags":[],"Class":"Beam"},{"ValueType":"Content","type":"Property","Name":"Texture","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"TextureLength","tags":[],"Class":"Beam"},{"ValueType":"TextureMode","type":"Property","Name":"TextureMode","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"TextureSpeed","tags":[],"Class":"Beam"},{"ValueType":"NumberSequence","type":"Property","Name":"Transparency","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"Width0","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"Width1","tags":[],"Class":"Beam"},{"ValueType":"float","type":"Property","Name":"ZOffset","tags":[],"Class":"Beam"},{"Superclass":"Instance","type":"Class","Name":"BinaryStringValue","tags":[]},{"Arguments":[{"Name":"value","Type":"BinaryString"}],"Name":"Changed","tags":[],"Class":"BinaryStringValue","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"BindableEvent","tags":[]},{"ReturnType":"void","Arguments":[{"Type":"Tuple","Name":"arguments","Default":null}],"Name":"Fire","tags":[],"Class":"BindableEvent","type":"Function"},{"Arguments":[{"Name":"arguments","Type":"Tuple"}],"Name":"Event","tags":[],"Class":"BindableEvent","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"BindableFunction","tags":[]},{"ReturnType":"Tuple","Arguments":[{"Type":"Tuple","Name":"arguments","Default":null}],"Name":"Invoke","tags":[],"Class":"BindableFunction","type":"YieldFunction"},{"ReturnType":"Tuple","Arguments":[{"Name":"arguments","Type":"Tuple"}],"Name":"OnInvoke","tags":[],"Class":"BindableFunction","type":"Callback"},{"Superclass":"Instance","type":"Class","Name":"BodyMover","tags":[]},{"Superclass":"BodyMover","type":"Class","Name":"BodyAngularVelocity","tags":[]},{"ValueType":"Vector3","type":"Property","Name":"AngularVelocity","tags":[],"Class":"BodyAngularVelocity"},{"ValueType":"Vector3","type":"Property","Name":"MaxTorque","tags":[],"Class":"BodyAngularVelocity"},{"ValueType":"float","type":"Property","Name":"P","tags":[],"Class":"BodyAngularVelocity"},{"ValueType":"Vector3","type":"Property","Name":"angularvelocity","tags":["deprecated"],"Class":"BodyAngularVelocity"},{"ValueType":"Vector3","type":"Property","Name":"maxTorque","tags":["deprecated"],"Class":"BodyAngularVelocity"},{"Superclass":"BodyMover","type":"Class","Name":"BodyForce","tags":[]},{"ValueType":"Vector3","type":"Property","Name":"Force","tags":[],"Class":"BodyForce"},{"ValueType":"Vector3","type":"Property","Name":"force","tags":["deprecated"],"Class":"BodyForce"},{"Superclass":"BodyMover","type":"Class","Name":"BodyGyro","tags":[]},{"ValueType":"CoordinateFrame","type":"Property","Name":"CFrame","tags":[],"Class":"BodyGyro"},{"ValueType":"float","type":"Property","Name":"D","tags":[],"Class":"BodyGyro"},{"ValueType":"Vector3","type":"Property","Name":"MaxTorque","tags":[],"Class":"BodyGyro"},{"ValueType":"float","type":"Property","Name":"P","tags":[],"Class":"BodyGyro"},{"ValueType":"CoordinateFrame","type":"Property","Name":"cframe","tags":["deprecated"],"Class":"BodyGyro"},{"ValueType":"Vector3","type":"Property","Name":"maxTorque","tags":["deprecated"],"Class":"BodyGyro"},{"Superclass":"BodyMover","type":"Class","Name":"BodyPosition","tags":[]},{"ValueType":"float","type":"Property","Name":"D","tags":[],"Class":"BodyPosition"},{"ValueType":"Vector3","type":"Property","Name":"MaxForce","tags":[],"Class":"BodyPosition"},{"ValueType":"float","type":"Property","Name":"P","tags":[],"Class":"BodyPosition"},{"ValueType":"Vector3","type":"Property","Name":"Position","tags":[],"Class":"BodyPosition"},{"ValueType":"Vector3","type":"Property","Name":"maxForce","tags":["deprecated"],"Class":"BodyPosition"},{"ValueType":"Vector3","type":"Property","Name":"position","tags":["deprecated"],"Class":"BodyPosition"},{"ReturnType":"Vector3","Arguments":[],"Name":"GetLastForce","tags":[],"Class":"BodyPosition","type":"Function"},{"ReturnType":"Vector3","Arguments":[],"Name":"lastForce","tags":["deprecated"],"Class":"BodyPosition","type":"Function"},{"Arguments":[],"Name":"ReachedTarget","tags":[],"Class":"BodyPosition","type":"Event"},{"Superclass":"BodyMover","type":"Class","Name":"BodyThrust","tags":[]},{"ValueType":"Vector3","type":"Property","Name":"Force","tags":[],"Class":"BodyThrust"},{"ValueType":"Vector3","type":"Property","Name":"Location","tags":[],"Class":"BodyThrust"},{"ValueType":"Vector3","type":"Property","Name":"force","tags":["deprecated"],"Class":"BodyThrust"},{"ValueType":"Vector3","type":"Property","Name":"location","tags":["deprecated"],"Class":"BodyThrust"},{"Superclass":"BodyMover","type":"Class","Name":"BodyVelocity","tags":[]},{"ValueType":"Vector3","type":"Property","Name":"MaxForce","tags":[],"Class":"BodyVelocity"},{"ValueType":"float","type":"Property","Name":"P","tags":[],"Class":"BodyVelocity"},{"ValueType":"Vector3","type":"Property","Name":"Velocity","tags":[],"Class":"BodyVelocity"},{"ValueType":"Vector3","type":"Property","Name":"maxForce","tags":["deprecated"],"Class":"BodyVelocity"},{"ValueType":"Vector3","type":"Property","Name":"velocity","tags":["deprecated"],"Class":"BodyVelocity"},{"ReturnType":"Vector3","Arguments":[],"Name":"GetLastForce","tags":[],"Class":"BodyVelocity","type":"Function"},{"ReturnType":"Vector3","Arguments":[],"Name":"lastForce","tags":["deprecated"],"Class":"BodyVelocity","type":"Function"},{"Superclass":"BodyMover","type":"Class","Name":"RocketPropulsion","tags":[]},{"ValueType":"float","type":"Property","Name":"CartoonFactor","tags":[],"Class":"RocketPropulsion"},{"ValueType":"float","type":"Property","Name":"MaxSpeed","tags":[],"Class":"RocketPropulsion"},{"ValueType":"float","type":"Property","Name":"MaxThrust","tags":[],"Class":"RocketPropulsion"},{"ValueType":"Vector3","type":"Property","Name":"MaxTorque","tags":[],"Class":"RocketPropulsion"},{"ValueType":"Object","type":"Property","Name":"Target","tags":[],"Class":"RocketPropulsion"},{"ValueType":"Vector3","type":"Property","Name":"TargetOffset","tags":[],"Class":"RocketPropulsion"},{"ValueType":"float","type":"Property","Name":"TargetRadius","tags":[],"Class":"RocketPropulsion"},{"ValueType":"float","type":"Property","Name":"ThrustD","tags":[],"Class":"RocketPropulsion"},{"ValueType":"float","type":"Property","Name":"ThrustP","tags":[],"Class":"RocketPropulsion"},{"ValueType":"float","type":"Property","Name":"TurnD","tags":[],"Class":"RocketPropulsion"},{"ValueType":"float","type":"Property","Name":"TurnP","tags":[],"Class":"RocketPropulsion"},{"ReturnType":"void","Arguments":[],"Name":"Abort","tags":[],"Class":"RocketPropulsion","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"Fire","tags":[],"Class":"RocketPropulsion","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"fire","tags":["deprecated"],"Class":"RocketPropulsion","type":"Function"},{"Arguments":[],"Name":"ReachedTarget","tags":[],"Class":"RocketPropulsion","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"BoolValue","tags":[]},{"ValueType":"bool","type":"Property","Name":"Value","tags":[],"Class":"BoolValue"},{"Arguments":[{"Name":"value","Type":"bool"}],"Name":"Changed","tags":[],"Class":"BoolValue","type":"Event"},{"Arguments":[{"Name":"value","Type":"bool"}],"Name":"changed","tags":["deprecated"],"Class":"BoolValue","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"BrickColorValue","tags":[]},{"ValueType":"BrickColor","type":"Property","Name":"Value","tags":[],"Class":"BrickColorValue"},{"Arguments":[{"Name":"value","Type":"BrickColor"}],"Name":"Changed","tags":[],"Class":"BrickColorValue","type":"Event"},{"Arguments":[{"Name":"value","Type":"BrickColor"}],"Name":"changed","tags":["deprecated"],"Class":"BrickColorValue","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"Button","tags":[]},{"ReturnType":"void","Arguments":[{"Type":"bool","Name":"active","Default":null}],"Name":"SetActive","tags":["PluginSecurity"],"Class":"Button","type":"Function"},{"Arguments":[],"Name":"Click","tags":["PluginSecurity"],"Class":"Button","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"CFrameValue","tags":[]},{"ValueType":"CoordinateFrame","type":"Property","Name":"Value","tags":[],"Class":"CFrameValue"},{"Arguments":[{"Name":"value","Type":"CoordinateFrame"}],"Name":"Changed","tags":[],"Class":"CFrameValue","type":"Event"},{"Arguments":[{"Name":"value","Type":"CoordinateFrame"}],"Name":"changed","tags":["deprecated"],"Class":"CFrameValue","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"CacheableContentProvider","tags":[]},{"Superclass":"CacheableContentProvider","type":"Class","Name":"MeshContentProvider","tags":[]},{"Superclass":"CacheableContentProvider","type":"Class","Name":"SolidModelContentProvider","tags":[]},{"Superclass":"Instance","type":"Class","Name":"Camera","tags":[]},{"ValueType":"CoordinateFrame","type":"Property","Name":"CFrame","tags":[],"Class":"Camera"},{"ValueType":"Object","type":"Property","Name":"CameraSubject","tags":[],"Class":"Camera"},{"ValueType":"CameraType","type":"Property","Name":"CameraType","tags":[],"Class":"Camera"},{"ValueType":"CoordinateFrame","type":"Property","Name":"CoordinateFrame","tags":["deprecated","hidden"],"Class":"Camera"},{"ValueType":"float","type":"Property","Name":"FieldOfView","tags":[],"Class":"Camera"},{"ValueType":"CoordinateFrame","type":"Property","Name":"Focus","tags":[],"Class":"Camera"},{"ValueType":"bool","type":"Property","Name":"HeadLocked","tags":[],"Class":"Camera"},{"ValueType":"float","type":"Property","Name":"HeadScale","tags":[],"Class":"Camera"},{"ValueType":"Vector2","type":"Property","Name":"ViewportSize","tags":["readonly"],"Class":"Camera"},{"ValueType":"CoordinateFrame","type":"Property","Name":"focus","tags":["deprecated"],"Class":"Camera"},{"ReturnType":"float","Arguments":[{"Type":"Objects","Name":"ignoreList","Default":null}],"Name":"GetLargestCutoffDistance","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"float","Arguments":[],"Name":"GetPanSpeed","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"Objects","Arguments":[{"Type":"Array","Name":"castPoints","Default":null},{"Type":"Objects","Name":"ignoreList","Default":null}],"Name":"GetPartsObscuringTarget","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"CoordinateFrame","Arguments":[],"Name":"GetRenderCFrame","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"float","Arguments":[],"Name":"GetRoll","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"float","Arguments":[],"Name":"GetTiltSpeed","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"CoordinateFrame","Name":"endPos","Default":null},{"Type":"CoordinateFrame","Name":"endFocus","Default":null},{"Type":"float","Name":"duration","Default":null}],"Name":"Interpolate","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"int","Name":"units","Default":null}],"Name":"PanUnits","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"Ray","Arguments":[{"Type":"float","Name":"x","Default":null},{"Type":"float","Name":"y","Default":null},{"Type":"float","Name":"depth","Default":"0"}],"Name":"ScreenPointToRay","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"CameraPanMode","Name":"mode","Default":"Classic"}],"Name":"SetCameraPanMode","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"float","Name":"rollAngle","Default":null}],"Name":"SetRoll","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"units","Default":null}],"Name":"TiltUnits","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"Ray","Arguments":[{"Type":"float","Name":"x","Default":null},{"Type":"float","Name":"y","Default":null},{"Type":"float","Name":"depth","Default":"0"}],"Name":"ViewportPointToRay","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"Tuple","Arguments":[{"Type":"Vector3","Name":"worldPoint","Default":null}],"Name":"WorldToScreenPoint","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"Tuple","Arguments":[{"Type":"Vector3","Name":"worldPoint","Default":null}],"Name":"WorldToViewportPoint","tags":[],"Class":"Camera","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"float","Name":"distance","Default":null}],"Name":"Zoom","tags":["RobloxScriptSecurity"],"Class":"Camera","type":"Function"},{"Arguments":[{"Name":"entering","Type":"bool"}],"Name":"FirstPersonTransition","tags":["LocalUserSecurity"],"Class":"Camera","type":"Event"},{"Arguments":[],"Name":"InterpolationFinished","tags":[],"Class":"Camera","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"ChangeHistoryService","tags":["notCreatable"]},{"ReturnType":"Tuple","Arguments":[],"Name":"GetCanRedo","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Function"},{"ReturnType":"Tuple","Arguments":[],"Name":"GetCanUndo","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"Redo","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"ResetWaypoints","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"bool","Name":"state","Default":null}],"Name":"SetEnabled","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"name","Default":null}],"Name":"SetWaypoint","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Function"},{"ReturnType":"void","Arguments":[],"Name":"Undo","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Function"},{"Arguments":[{"Name":"waypoint","Type":"string"}],"Name":"OnRedo","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Event"},{"Arguments":[{"Name":"waypoint","Type":"string"}],"Name":"OnUndo","tags":["PluginSecurity"],"Class":"ChangeHistoryService","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"CharacterAppearance","tags":[]},{"Superclass":"CharacterAppearance","type":"Class","Name":"BodyColors","tags":[]},{"ValueType":"BrickColor","type":"Property","Name":"HeadColor","tags":[],"Class":"BodyColors"},{"ValueType":"Color3","type":"Property","Name":"HeadColor3","tags":[],"Class":"BodyColors"},{"ValueType":"BrickColor","type":"Property","Name":"LeftArmColor","tags":[],"Class":"BodyColors"},{"ValueType":"Color3","type":"Property","Name":"LeftArmColor3","tags":[],"Class":"BodyColors"},{"ValueType":"BrickColor","type":"Property","Name":"LeftLegColor","tags":[],"Class":"BodyColors"},{"ValueType":"Color3","type":"Property","Name":"LeftLegColor3","tags":[],"Class":"BodyColors"},{"ValueType":"BrickColor","type":"Property","Name":"RightArmColor","tags":[],"Class":"BodyColors"},{"ValueType":"Color3","type":"Property","Name":"RightArmColor3","tags":[],"Class":"BodyColors"},{"ValueType":"BrickColor","type":"Property","Name":"RightLegColor","tags":[],"Class":"BodyColors"},{"ValueType":"Color3","type":"Property","Name":"RightLegColor3","tags":[],"Class":"BodyColors"},{"ValueType":"BrickColor","type":"Property","Name":"TorsoColor","tags":[],"Class":"BodyColors"},{"ValueType":"Color3","type":"Property","Name":"TorsoColor3","tags":[],"Class":"BodyColors"},{"Superclass":"CharacterAppearance","type":"Class","Name":"CharacterMesh","tags":[]},{"ValueType":"int","type":"Property","Name":"BaseTextureId","tags":[],"Class":"CharacterMesh"},{"ValueType":"BodyPart","type":"Property","Name":"BodyPart","tags":[],"Class":"CharacterMesh"},{"ValueType":"int","type":"Property","Name":"MeshId","tags":[],"Class":"CharacterMesh"},{"ValueType":"int","type":"Property","Name":"OverlayTextureId","tags":[],"Class":"CharacterMesh"},{"Superclass":"CharacterAppearance","type":"Class","Name":"Clothing","tags":[]},{"Superclass":"Clothing","type":"Class","Name":"Pants","tags":[]},{"ValueType":"Content","type":"Property","Name":"PantsTemplate","tags":[],"Class":"Pants"},{"Superclass":"Clothing","type":"Class","Name":"Shirt","tags":[]},{"ValueType":"Content","type":"Property","Name":"ShirtTemplate","tags":[],"Class":"Shirt"},{"Superclass":"CharacterAppearance","type":"Class","Name":"ShirtGraphic","tags":[]},{"ValueType":"Content","type":"Property","Name":"Graphic","tags":[],"Class":"ShirtGraphic"},{"Superclass":"CharacterAppearance","type":"Class","Name":"Skin","tags":["deprecated"]},{"ValueType":"BrickColor","type":"Property","Name":"SkinColor","tags":[],"Class":"Skin"},{"Superclass":"Instance","type":"Class","Name":"Chat","tags":["notCreatable"]},{"ValueType":"bool","type":"Property","Name":"LoadDefaultChat","tags":["ScriptWriteRestricted: [NotAccessibleSecurity]"],"Class":"Chat"},{"ReturnType":"void","Arguments":[{"Type":"Instance","Name":"partOrCharacter","Default":null},{"Type":"string","Name":"message","Default":null},{"Type":"ChatColor","Name":"color","Default":"Blue"}],"Name":"Chat","tags":[],"Class":"Chat","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"Instance","Name":"partOrCharacter","Default":null},{"Type":"string","Name":"message","Default":null},{"Type":"ChatColor","Name":"color","Default":"Blue"}],"Name":"ChatLocal","tags":["RobloxScriptSecurity"],"Class":"Chat","type":"Function"},{"ReturnType":"bool","Arguments":[],"Name":"GetShouldUseLuaChat","tags":["RobloxScriptSecurity"],"Class":"Chat","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"userId","Default":null}],"Name":"CanUserChatAsync","tags":[],"Class":"Chat","type":"YieldFunction"},{"ReturnType":"bool","Arguments":[{"Type":"int","Name":"userIdFrom","Default":null},{"Type":"int","Name":"userIdTo","Default":null}],"Name":"CanUsersChatAsync","tags":[],"Class":"Chat","type":"YieldFunction"},{"ReturnType":"string","Arguments":[{"Type":"string","Name":"stringToFilter","Default":null},{"Type":"Instance","Name":"playerFrom","Default":null},{"Type":"Instance","Name":"playerTo","Default":null}],"Name":"FilterStringAsync","tags":[],"Class":"Chat","type":"YieldFunction"},{"ReturnType":"string","Arguments":[{"Type":"string","Name":"stringToFilter","Default":null},{"Type":"Instance","Name":"playerFrom","Default":null}],"Name":"FilterStringForBroadcast","tags":[],"Class":"Chat","type":"YieldFunction"},{"ReturnType":"string","Arguments":[{"Type":"string","Name":"stringToFilter","Default":null},{"Type":"Instance","Name":"playerToFilterFor","Default":null}],"Name":"FilterStringForPlayerAsync","tags":["deprecated"],"Class":"Chat","type":"YieldFunction"},{"Arguments":[{"Name":"part","Type":"Instance"},{"Name":"message","Type":"string"},{"Name":"color","Type":"ChatColor"}],"Name":"Chatted","tags":[],"Class":"Chat","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"ClickDetector","tags":[]},{"ValueType":"Content","type":"Property","Name":"CursorIcon","tags":[],"Class":"ClickDetector"},{"ValueType":"float","type":"Property","Name":"MaxActivationDistance","tags":[],"Class":"ClickDetector"},{"Arguments":[{"Name":"playerWhoClicked","Type":"Instance"}],"Name":"MouseClick","tags":[],"Class":"ClickDetector","type":"Event"},{"Arguments":[{"Name":"playerWhoHovered","Type":"Instance"}],"Name":"MouseHoverEnter","tags":[],"Class":"ClickDetector","type":"Event"},{"Arguments":[{"Name":"playerWhoHovered","Type":"Instance"}],"Name":"MouseHoverLeave","tags":[],"Class":"ClickDetector","type":"Event"},{"Arguments":[{"Name":"playerWhoClicked","Type":"Instance"}],"Name":"RightMouseClick","tags":[],"Class":"ClickDetector","type":"Event"},{"Arguments":[{"Name":"playerWhoClicked","Type":"Instance"}],"Name":"mouseClick","tags":["deprecated"],"Class":"ClickDetector","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"CollectionService","tags":[]},{"ReturnType":"void","Arguments":[{"Type":"Instance","Name":"instance","Default":null},{"Type":"string","Name":"tag","Default":null}],"Name":"AddTag","tags":[],"Class":"CollectionService","type":"Function"},{"ReturnType":"Objects","Arguments":[{"Type":"string","Name":"class","Default":null}],"Name":"GetCollection","tags":["deprecated"],"Class":"CollectionService","type":"Function"},{"ReturnType":"EventInstance","Arguments":[{"Type":"string","Name":"tag","Default":null}],"Name":"GetInstanceAddedSignal","tags":[],"Class":"CollectionService","type":"Function"},{"ReturnType":"EventInstance","Arguments":[{"Type":"string","Name":"tag","Default":null}],"Name":"GetInstanceRemovedSignal","tags":[],"Class":"CollectionService","type":"Function"},{"ReturnType":"Objects","Arguments":[{"Type":"string","Name":"tag","Default":null}],"Name":"GetTagged","tags":[],"Class":"CollectionService","type":"Function"},{"ReturnType":"Array","Arguments":[{"Type":"Instance","Name":"instance","Default":null}],"Name":"GetTags","tags":[],"Class":"CollectionService","type":"Function"},{"ReturnType":"bool","Arguments":[{"Type":"Instance","Name":"instance","Default":null},{"Type":"string","Name":"tag","Default":null}],"Name":"HasTag","tags":[],"Class":"CollectionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"Instance","Name":"instance","Default":null},{"Type":"string","Name":"tag","Default":null}],"Name":"RemoveTag","tags":[],"Class":"CollectionService","type":"Function"},{"Arguments":[{"Name":"instance","Type":"Instance"}],"Name":"ItemAdded","tags":["deprecated"],"Class":"CollectionService","type":"Event"},{"Arguments":[{"Name":"instance","Type":"Instance"}],"Name":"ItemRemoved","tags":["deprecated"],"Class":"CollectionService","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"Color3Value","tags":[]},{"ValueType":"Color3","type":"Property","Name":"Value","tags":[],"Class":"Color3Value"},{"Arguments":[{"Name":"value","Type":"Color3"}],"Name":"Changed","tags":[],"Class":"Color3Value","type":"Event"},{"Arguments":[{"Name":"value","Type":"Color3"}],"Name":"changed","tags":["deprecated"],"Class":"Color3Value","type":"Event"},{"Superclass":"Instance","type":"Class","Name":"Configuration","tags":[]},{"Superclass":"Instance","type":"Class","Name":"Constraint","tags":[]},{"ValueType":"Object","type":"Property","Name":"Attachment0","tags":[],"Class":"Constraint"},{"ValueType":"Object","type":"Property","Name":"Attachment1","tags":[],"Class":"Constraint"},{"ValueType":"BrickColor","type":"Property","Name":"Color","tags":[],"Class":"Constraint"},{"ValueType":"bool","type":"Property","Name":"Enabled","tags":[],"Class":"Constraint"},{"ValueType":"bool","type":"Property","Name":"Visible","tags":[],"Class":"Constraint"},{"Superclass":"Constraint","type":"Class","Name":"AlignOrientation","tags":[]},{"ValueType":"float","type":"Property","Name":"MaxAngularVelocity","tags":[],"Class":"AlignOrientation"},{"ValueType":"float","type":"Property","Name":"MaxTorque","tags":[],"Class":"AlignOrientation"},{"ValueType":"bool","type":"Property","Name":"PrimaryAxisOnly","tags":[],"Class":"AlignOrientation"},{"ValueType":"bool","type":"Property","Name":"ReactionTorqueEnabled","tags":[],"Class":"AlignOrientation"},{"ValueType":"float","type":"Property","Name":"Responsiveness","tags":[],"Class":"AlignOrientation"},{"ValueType":"bool","type":"Property","Name":"RigidityEnabled","tags":[],"Class":"AlignOrientation"},{"Superclass":"Constraint","type":"Class","Name":"AlignPosition","tags":[]},{"ValueType":"bool","type":"Property","Name":"ApplyAtCenterOfMass","tags":[],"Class":"AlignPosition"},{"ValueType":"float","type":"Property","Name":"MaxForce","tags":[],"Class":"AlignPosition"},{"ValueType":"float","type":"Property","Name":"MaxVelocity","tags":[],"Class":"AlignPosition"},{"ValueType":"bool","type":"Property","Name":"ReactionForceEnabled","tags":[],"Class":"AlignPosition"},{"ValueType":"float","type":"Property","Name":"Responsiveness","tags":[],"Class":"AlignPosition"},{"ValueType":"bool","type":"Property","Name":"RigidityEnabled","tags":[],"Class":"AlignPosition"},{"Superclass":"Constraint","type":"Class","Name":"BallSocketConstraint","tags":[]},{"ValueType":"bool","type":"Property","Name":"LimitsEnabled","tags":[],"Class":"BallSocketConstraint"},{"ValueType":"float","type":"Property","Name":"Radius","tags":[],"Class":"BallSocketConstraint"},{"ValueType":"float","type":"Property","Name":"Restitution","tags":[],"Class":"BallSocketConstraint"},{"ValueType":"bool","type":"Property","Name":"TwistLimitsEnabled","tags":[],"Class":"BallSocketConstraint"},{"ValueType":"float","type":"Property","Name":"TwistLowerAngle","tags":[],"Class":"BallSocketConstraint"},{"ValueType":"float","type":"Property","Name":"TwistUpperAngle","tags":[],"Class":"BallSocketConstraint"},{"ValueType":"float","type":"Property","Name":"UpperAngle","tags":[],"Class":"BallSocketConstraint"},{"Superclass":"Constraint","type":"Class","Name":"HingeConstraint","tags":[]},{"ValueType":"ActuatorType","type":"Property","Name":"ActuatorType","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"AngularSpeed","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"AngularVelocity","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"CurrentAngle","tags":["readonly"],"Class":"HingeConstraint"},{"ValueType":"bool","type":"Property","Name":"LimitsEnabled","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"LowerAngle","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"MotorMaxAcceleration","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"MotorMaxTorque","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"Radius","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"Restitution","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"ServoMaxTorque","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"TargetAngle","tags":[],"Class":"HingeConstraint"},{"ValueType":"float","type":"Property","Name":"UpperAngle","tags":[],"Class":"HingeConstraint"},{"Superclass":"Constraint","type":"Class","Name":"LineForce","tags":[]},{"ValueType":"bool","type":"Property","Name":"ApplyAtCenterOfMass","tags":[],"Class":"LineForce"},{"ValueType":"bool","type":"Property","Name":"InverseSquareLaw","tags":[],"Class":"LineForce"},{"ValueType":"float","type":"Property","Name":"Magnitude","tags":[],"Class":"LineForce"},{"ValueType":"float","type":"Property","Name":"MaxForce","tags":[],"Class":"LineForce"},{"ValueType":"bool","type":"Property","Name":"ReactionForceEnabled","tags":[],"Class":"LineForce"},{"Superclass":"Constraint","type":"Class","Name":"RodConstraint","tags":[]},{"ValueType":"float","type":"Property","Name":"CurrentDistance","tags":["readonly"],"Class":"RodConstraint"},{"ValueType":"float","type":"Property","Name":"Length","tags":[],"Class":"RodConstraint"},{"ValueType":"float","type":"Property","Name":"Thickness","tags":[],"Class":"RodConstraint"},{"Superclass":"Constraint","type":"Class","Name":"RopeConstraint","tags":[]},{"ValueType":"float","type":"Property","Name":"CurrentDistance","tags":["readonly"],"Class":"RopeConstraint"},{"ValueType":"float","type":"Property","Name":"Length","tags":[],"Class":"RopeConstraint"},{"ValueType":"float","type":"Property","Name":"Restitution","tags":[],"Class":"RopeConstraint"},{"ValueType":"float","type":"Property","Name":"Thickness","tags":[],"Class":"RopeConstraint"},{"Superclass":"Constraint","type":"Class","Name":"SlidingBallConstraint","tags":[]},{"ValueType":"ActuatorType","type":"Property","Name":"ActuatorType","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"CurrentPosition","tags":["readonly"],"Class":"SlidingBallConstraint"},{"ValueType":"bool","type":"Property","Name":"LimitsEnabled","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"LowerLimit","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"MotorMaxAcceleration","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"MotorMaxForce","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"Restitution","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"ServoMaxForce","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"Size","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"Speed","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"TargetPosition","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"UpperLimit","tags":[],"Class":"SlidingBallConstraint"},{"ValueType":"float","type":"Property","Name":"Velocity","tags":[],"Class":"SlidingBallConstraint"},{"Superclass":"SlidingBallConstraint","type":"Class","Name":"CylindricalConstraint","tags":[]},{"ValueType":"ActuatorType","type":"Property","Name":"AngularActuatorType","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"bool","type":"Property","Name":"AngularLimitsEnabled","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"AngularRestitution","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"AngularSpeed","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"AngularVelocity","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"CurrentAngle","tags":["readonly"],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"InclinationAngle","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"LowerAngle","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"MotorMaxAngularAcceleration","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"MotorMaxTorque","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"bool","type":"Property","Name":"RotationAxisVisible","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"ServoMaxTorque","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"TargetAngle","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"float","type":"Property","Name":"UpperAngle","tags":[],"Class":"CylindricalConstraint"},{"ValueType":"Vector3","type":"Property","Name":"WorldRotationAxis","tags":["readonly"],"Class":"CylindricalConstraint"},{"Superclass":"SlidingBallConstraint","type":"Class","Name":"PrismaticConstraint","tags":[]},{"Superclass":"Constraint","type":"Class","Name":"SpringConstraint","tags":[]},{"ValueType":"float","type":"Property","Name":"Coils","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"CurrentLength","tags":["readonly"],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"Damping","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"FreeLength","tags":[],"Class":"SpringConstraint"},{"ValueType":"bool","type":"Property","Name":"LimitsEnabled","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"MaxForce","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"MaxLength","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"MinLength","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"Radius","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"Stiffness","tags":[],"Class":"SpringConstraint"},{"ValueType":"float","type":"Property","Name":"Thickness","tags":[],"Class":"SpringConstraint"},{"Superclass":"Constraint","type":"Class","Name":"Torque","tags":[]},{"ValueType":"ActuatorRelativeTo","type":"Property","Name":"RelativeTo","tags":[],"Class":"Torque"},{"ValueType":"Vector3","type":"Property","Name":"Torque","tags":[],"Class":"Torque"},{"Superclass":"Constraint","type":"Class","Name":"VectorForce","tags":[]},{"ValueType":"bool","type":"Property","Name":"ApplyAtCenterOfMass","tags":[],"Class":"VectorForce"},{"ValueType":"Vector3","type":"Property","Name":"Force","tags":[],"Class":"VectorForce"},{"ValueType":"ActuatorRelativeTo","type":"Property","Name":"RelativeTo","tags":[],"Class":"VectorForce"},{"Superclass":"Instance","type":"Class","Name":"ContentProvider","tags":[]},{"ValueType":"string","type":"Property","Name":"BaseUrl","tags":["readonly"],"Class":"ContentProvider"},{"ValueType":"int","type":"Property","Name":"RequestQueueSize","tags":["readonly"],"Class":"ContentProvider"},{"ReturnType":"void","Arguments":[{"Type":"Content","Name":"contentId","Default":null}],"Name":"Preload","tags":["deprecated"],"Class":"ContentProvider","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"url","Default":null}],"Name":"SetBaseUrl","tags":["LocalUserSecurity"],"Class":"ContentProvider","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"Array","Name":"contentIdList","Default":null}],"Name":"PreloadAsync","tags":[],"Class":"ContentProvider","type":"YieldFunction"},{"Superclass":"Instance","type":"Class","Name":"ContextActionService","tags":[]},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"Function","Name":"functionToBind","Default":null},{"Type":"bool","Name":"createTouchButton","Default":null},{"Type":"Tuple","Name":"inputTypes","Default":null}],"Name":"BindAction","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"Function","Name":"functionToBind","Default":null},{"Type":"bool","Name":"createTouchButton","Default":null},{"Type":"int","Name":"priorityLevel","Default":null},{"Type":"Tuple","Name":"inputTypes","Default":null}],"Name":"BindActionAtPriority","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"Function","Name":"functionToBind","Default":null},{"Type":"bool","Name":"createTouchButton","Default":null},{"Type":"Tuple","Name":"inputTypes","Default":null}],"Name":"BindActionToInputTypes","tags":["deprecated"],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"UserInputType","Name":"userInputTypeForActivation","Default":null},{"Type":"KeyCode","Name":"keyCodeForActivation","Default":"Unknown"}],"Name":"BindActivate","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"Function","Name":"functionToBind","Default":null},{"Type":"bool","Name":"createTouchButton","Default":null},{"Type":"Tuple","Name":"inputTypes","Default":null}],"Name":"BindCoreAction","tags":["RobloxScriptSecurity"],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"Function","Name":"functionToBind","Default":null},{"Type":"bool","Name":"createTouchButton","Default":null},{"Type":"int","Name":"priorityLevel","Default":null},{"Type":"Tuple","Name":"inputTypes","Default":null}],"Name":"BindCoreActionAtPriority","tags":["RobloxScriptSecurity"],"Class":"ContextActionService","type":"Function"},{"ReturnType":"Tuple","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"UserInputState","Name":"state","Default":null},{"Type":"Instance","Name":"inputObject","Default":null}],"Name":"CallFunction","tags":["RobloxScriptSecurity"],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"Instance","Name":"actionButton","Default":null}],"Name":"FireActionButtonFoundSignal","tags":["RobloxScriptSecurity"],"Class":"ContextActionService","type":"Function"},{"ReturnType":"Dictionary","Arguments":[],"Name":"GetAllBoundActionInfo","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"Dictionary","Arguments":[],"Name":"GetAllBoundCoreActionInfo","tags":["RobloxScriptSecurity"],"Class":"ContextActionService","type":"Function"},{"ReturnType":"Dictionary","Arguments":[{"Type":"string","Name":"actionName","Default":null}],"Name":"GetBoundActionInfo","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"Dictionary","Arguments":[{"Type":"string","Name":"actionName","Default":null}],"Name":"GetBoundCoreActionInfo","tags":["RobloxScriptSecurity"],"Class":"ContextActionService","type":"Function"},{"ReturnType":"string","Arguments":[],"Name":"GetCurrentLocalToolIcon","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"string","Name":"description","Default":null}],"Name":"SetDescription","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","Arguments":[{"Type":"string","Name":"actionName","Default":null},{"Type":"string","Name":"image","Default":null}],"Name":"SetImage","tags":[],"Class":"ContextActionService","type":"Function"},{"ReturnType":"void","
