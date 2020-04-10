local matrix = Matrix()
local matrixAngle = Angle(0, 0, 0)
local matrixScale = Vector(0, 0, 0)
local matrixTranslation = Vector(0, 0, 0)

function draw.TextRotated(text, font, x, y, xScale, yScale, angle, color, bshadow)
	render.PushFilterMag( TEXFILTER.LINEAR )
	render.PushFilterMin( TEXFILTER.LINEAR )
		matrix:SetTranslation( Vector( x, y ) )
		matrix:SetAngles( Angle( 0, angle, 0 ) )

		surface.SetFont( font )

		if bshadow then
			surface.SetTextColor( Color(0,0,0,90) )

			matrixScale.x = xScale
			matrixScale.y = yScale
			matrix:Scale(matrixScale)

			surface.SetTextPos(1, 1)

			cam.PushModelMatrix(matrix)
				surface.DrawText(text)
			cam.PopModelMatrix()
		end

		surface.SetTextColor( color )
		surface.SetTextPos(0, 0)

		cam.PushModelMatrix(matrix)
			surface.DrawText(text)
		cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end

function draw.ShadowSimpleText( text, font, x, y, color, xalign, yalign )
	draw.SimpleText(text, font, x+1, y+1, Color(0,0,0,190), xalign, yalign)
	draw.SimpleText(text, font, x, y, color, xalign, yalign)
end

function draw.ShadowText(text, font, x, y, colortext, colorshadow, dist, xalign, yalign)
	draw.SimpleText(text, font, x + dist, y + dist, colorshadow, xalign, yalign)
	draw.SimpleText(text, font, x, y, colortext, xalign, yalign)
end


function draw.DrawPolyLine(tblVectors, tblColor)
	surface.SetDrawColor( tblColor )
	draw.NoTexture()
	surface.DrawPoly( tblVectors )
end

function draw.Icon( x, y, w, h, Mat, tblColor )
	surface.SetMaterial(Mat)
	surface.SetDrawColor(tblColor or Color(255,255,255,255))
	surface.DrawTexturedRect(x, y, w, h)
end

local blur = Material("pp/blurscreen", "noclamp")
function draw.DrawBlur(x, y, w, h, amount)
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilWriteMask( 1 )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect(x,y,w,h)

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

	surface.SetMaterial( blur )
	surface.SetDrawColor( 255, 255, 255, 255 )

	for i = 0, 1, 0.33 do
		blur:SetFloat( '$blur', i * (amount or 0.2) )
		blur:Recompute()
		render.UpdateScreenEffectTexture()

		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	end
	render.SetStencilEnable( false )
end

function draw.StencilBlur( panel, w, h )
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilWriteMask( 1 )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( 0, 0, w, h )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

		surface.SetMaterial( blur )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i = 0, 1, 0.33 do
			blur:SetFloat( '$blur', 5 *i )
			blur:Recompute()
			render.UpdateScreenEffectTexture()

			local x, y = panel:GetPos()

			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end

	render.SetStencilEnable( false )
end

-- function draw.Circle( center, radius, segs, color )
-- 	local cir = {}
-- 	local x, y = center.x, center.y

-- 	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
-- 	for i = 0, segs do
-- 		local a = math.rad( ( i / segs ) * -360 )
-- 		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
-- 	end

-- 	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
-- 	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

-- 	surface.SetDrawColor( color.r, color.g, color.b, color.a )
-- 	surface.DrawPoly( cir )
-- end

function draw.Arc( center, startang, endang, radius, roughness, thickness, color )
	draw.NoTexture()
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	local segs, p = roughness, {}
	for i2 = 0, segs do
		p[i2] = -i2 / segs * (math.pi/180) * endang - (startang/57.3)
	end
	for i2 = 1, segs do
		if endang <= 90 then
			segs = segs/2
		elseif endang <= 180 then
			segs = segs/4
		elseif endang <= 270 then
			segs = segs/6
		else
			segs = segs
		end
		local r1, r2 = radius, math.max(radius - thickness, 0)
		local v1, v2 = p[i2 - 1], p[i2]
		local c1, c2 = math.cos( v1 ), math.cos( v2 )
		local s1, s2 = math.sin( v1 ), math.sin( v2 )
		surface.DrawPoly{
			{ x = center.x + c1 * r2, y = center.y - s1 * r2 },
			{ x = center.x + c1 * r1, y = center.y - s1 * r1 },
			{ x = center.x + c2 * r1, y = center.y - s2 * r1 },
			{ x = center.x + c2 * r2, y = center.y - s2 * r2 },
		}
	end
end
