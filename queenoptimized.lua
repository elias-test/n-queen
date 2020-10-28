-- My take on the N queen problem
-- For people not familiar with Lua: #table returns the number of indexes (length) of the table, the rest should hopefully be obvious

-- The number of Queens and the number of Tiles; The program wont work correctly if numQueens != numTiles.
local numQueens = 6
local numTiles = numQueens

-- creates all the tiles where the queen standing on the specific tile could hit
local function generateIllegalTiles (tile)
  local illegal = {}
  
    table.insert(illegal, {tile[1], tile[2]})
    for i = 1, numTiles do
      if tile[2] + i <= numTiles then
        table.insert(illegal, {tile[1], tile[2]+i})
      end
      
      if tile[2] - i > 0 then
        table.insert(illegal, {tile[1], tile[2]-i})
      end
      
      if tile[1]+i <= numTiles then
        table.insert(illegal, {tile[1]+i, tile[2]})
      end
      
      if tile[1]-i > 0 then
        table.insert(illegal, {tile[1]-i, tile[2]})
      end
      
      if tile[1]+i <= numTiles and tile[2]+i <= numTiles then
        table.insert(illegal, {tile[1]+i, tile[2]+i})
      end
      
      if tile[1]-i > 0 and tile[2] + i <= numTiles then
        table.insert(illegal, {tile[1]-i, tile[2]+i})
      end
      
      if tile[1]-i > 0 and tile[2]-i > 0 then 
        table.insert(illegal, {tile[1]-i, tile[2]-i})
      end
      
      if tile[1]+i <= numTiles and tile[2]-i > 0 then
        table.insert(illegal, {tile[1]+i, tile[2]-i})
      end
      
    end
  
  return illegal
end

-- Creates the Chessboard
local function createTiles ()
  local tiles = {}
  
  for i = 1, numTiles do
    
    for j = 1, numTiles do
      
      table.insert(tiles, {i, j})
      
    end

  end

  return tiles
end

local tiles = createTiles()

-- generates all illegal tiles going out from each tile
local function createIllegalTileTable (board)
  local illegal = {}
  
  for i = 1, #board do
    local temp = generateIllegalTiles({board[i][1], board[i][2]})
    illegal[board[i][1] .. board[i][2]] = temp
  end
  
  return illegal
end

local illegal = createIllegalTileTable(tiles)

-- Checks all illegal tiles against all remaining possible tiles and removes the ones matching
local function removeIllegalTiles (board, tile, pos)
  local tempBoard = {}
  
  for i = 1, #board do
    tempBoard[i] = board[i]
  end
  
  for i = pos, 1, -1 do
    table.remove(tempBoard, i)
  end

  for i = 1, #illegal[tile] do
    
    for k = #tempBoard, 1, -1 do
      
      if tempBoard[k][1] .. tempBoard[k][2] == illegal[tile][i][1] .. illegal[tile][i][2] then
        table.remove(tempBoard, k)
      end
      
    end
    
  end

  return tempBoard

end

-- Logic to transform the positions to readable data (Creates a chessboard in the console with the used Spots marked)
local function showBoard (board)
  for i = 1, numTiles do
    
    for j = 1, numTiles do
      
      local toShow = "00 | "
      
      for k = 1, #board do
        if board[k][1] .. board[k][2] == i .. j then
          toShow = k .. "X | "
        end
      end
      
      io.write(toShow)
    end
    io.write("\n")
  end
  print()
end

local loops = 0

-- Stores all the possible Solutions
local solutions = {}
local function copySolution (s)
  table.insert(solutions, {})
  for i = 1, #s do
    solutions[#solutions][i] = s[i]
  end
  
end


-- Generates all the possible positions
local function generate (usedPositions, currentQueen, legalTiles)
  loops = loops +1
  if currentQueen > numQueens then
    copySolution(usedPositions)
    return 
  end

  for i = 1, #legalTiles-(numQueens-currentQueen) do
    usedPositions[currentQueen] = {legalTiles[i][1], legalTiles[i][2]}
    generate(usedPositions, currentQueen+1, removeIllegalTiles(legalTiles, legalTiles[i][1] .. legalTiles[i][2], i))
  end
  
end

for i = 1, numTiles do
  generate({{tiles[i][1], tiles[i][2]}}, 2, removeIllegalTiles(tiles, tiles[i][1] .. tiles[i][2], i))
end

-- Prints all possible Solutions to the Console
for i = 1, #solutions do
  print("__________________________" .. i .. "__________________________\n")
  showBoard(solutions[i])
  print("_____________________________________________________")
end


print("\nThere are " .. #solutions .. " total solutions.")
print("Loops = " .. loops)