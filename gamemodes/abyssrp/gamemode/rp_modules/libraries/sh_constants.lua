-- Constants

RP.Constants={}

function RP:AddConstant(type,name)
	if not RP.Constants[type] then
		RP.Constants[type]={}
	end
	if table.HasValue(RP.Constants[type],name) then
		return RP:GetConstantN(type,name)
	end
	local n=#RP.Constants[type]+1
	RP.Constants[type][n]=name
	return n
end

function RP:GetConstant(type,n)
	if not RP.Constants[type] then
		return false
	end
	for k,v in pairs(RP.Constants[type]) do
		if k==n then
			return v
		end
	end
	return false
end

function RP:GetConstantN(type,n)
	if not RP.Constants[type] then
		return false
	end
	for k,v in pairs(RP.Constants[type]) do
		if v==n then
			return k
		end
	end
	return false
end