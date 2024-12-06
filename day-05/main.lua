local function parseInput(input)
	local orderings = {}
	local manuals = {}
	local firstSection = ""
	local secondSection = ""

	for line in input:gmatch("[^\n]+") do
		if string.find(line, "|") then
			firstSection = firstSection .. line .. "+"
		end

		if string.find(line, ",") then
			secondSection = secondSection .. line .. "+"
		end
	end

	for line in firstSection:gmatch("[^+]+") do
		local parts = {}
		for part in line:gmatch("[^|]+") do
			table.insert(parts, part)
		end
		table.insert(orderings, parts)
	end

	for line in secondSection:gmatch("[^+]+") do
		local parts = {}
		for part in line:gmatch("[^,]+") do
			table.insert(parts, part)
		end
		table.insert(manuals, parts)
	end

	return { orderings, manuals }
end

local function filterRules(orderings, manual)
	local filtered = {}
	local pageSet = {}
	for _, page in ipairs(manual) do
		pageSet[page] = true
	end

	for _, rule in ipairs(orderings) do
		if pageSet[rule[1]] and pageSet[rule[2]] then
			table.insert(filtered, rule)
		end
	end

	return filtered
end

local function topologicalSort(nodes, edges)
	local inDegree = {}
	local graph = {}
	local order = {}

	for _, node in ipairs(nodes) do
		graph[node] = {}
		inDegree[node] = 0
	end

	for _, edge in ipairs(edges) do
		local from, to = edge[1], edge[2]
		if graph[from] then
			table.insert(graph[from], to)
			inDegree[to] = inDegree[to] + 1
		end
	end

	local queue = {}
	for node, degree in pairs(inDegree) do
		if degree == 0 then
			table.insert(queue, node)
		end
	end

	while #queue > 0 do
		local current = table.remove(queue, 1)
		table.insert(order, current)
		for _, neighbor in ipairs(graph[current]) do
			inDegree[neighbor] = inDegree[neighbor] - 1
			if inDegree[neighbor] == 0 then
				table.insert(queue, neighbor)
			end
		end
	end

	if #order == #nodes then
		return order
	else
		error("Cycle detected in graph!")
	end
end

local function isManualValid(orderings, manual)
	local position = {}
	for i, page in ipairs(manual) do
		position[page] = i
	end

	for _, rule in ipairs(orderings) do
		local x, y = rule[1], rule[2]
		if position[x] and position[y] and position[x] > position[y] then
			return false
		end
	end

	return true
end

local function part1(input)
	local orderings = input[1]
	local manuals = input[2]
	local sum = 0

	for _, manual in ipairs(manuals) do
		local filteredOrderings = filterRules(orderings, manual)

		if isManualValid(filteredOrderings, manual) then
			local mid = math.floor(#manual / 2) + 1
			sum = sum + manual[mid]
		end
	end

	print("Part 1:", sum)
end

local function part2(input)
	local orderings = input[1]
	local manuals = input[2]
	local sum = 0

	for _, manual in ipairs(manuals) do
		local filteredOrderings = filterRules(orderings, manual)

		if not isManualValid(filteredOrderings, manual) then
			manual = topologicalSort(manual, filteredOrderings)

			local mid = math.floor(#manual / 2) + 1
			sum = sum + manual[mid]
		end
	end

	print("Part 2:", sum)
end

function Main()
	local file = io.open("05.txt", "r")
	if file then
		local content = file:read("*all")
		Input = parseInput(content)
		file:close()
	end

	part1(Input)
	part2(Input)
end

Main()
