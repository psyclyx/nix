local function merge_all(...)
	local result = {}
	for _, tbl in ipairs({ ... }) do
		if type(tbl) == "table" then
			for k, v in pairs(tbl) do
				result[k] = v
			end
		end
	end
	return result
end

return {
	merge_all = merge_all,
}
