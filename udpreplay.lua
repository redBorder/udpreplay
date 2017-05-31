-- Send UDP packets to multiple addresses
-- Copyright (C) 2017 Diego Fernández Barrera
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local gopiper = require("gopiper")

-- Parse a CSV to a lua table
local function ParseCSVLine(line, sep)
  local res = {}
  local pos = 1
  sep = sep or ','
  while true do
    local c = string.sub(line, pos, pos)
    if (c == "") then break end
    if (c == '"') then
      local txt = ""
      repeat
        local startp, endp = string.find(line, '^%b""', pos)
        txt = txt..string.sub(line, startp + 1, endp - 1)
        pos = endp + 1
        c = string.sub(line, pos, pos)
        if (c == '"') then txt = txt..'"' end
      until (c ~= '"')
      table.insert(res, txt)
      assert(c == sep or c == "")
      pos = pos + 1
    else
      local startp, endp = string.find(line, sep, pos)
      if (startp) then
        table.insert(res, string.sub(line, pos, startp - 1))
        pos = endp + 1
      else
        table.insert(res, string.sub(line, pos))
        break
      end
    end
  end

  return res
end

-- Configuration

local DEVICE = os.getenv('DEVICE')
if DEVICE == nil then
  print('No device has been set')
  os.exit()
end

local FILTER = os.getenv('FILTER')
if FILTER == nil then
  FILTER = ''
end

local ADDRESS_LIST = os.getenv('ADDRESS_LIST')
if ADDRESS_LIST == nil then
  print('No addresses has been set')
  os.exit()
end

local ADDRESSES = ParseCSVLine(ADDRESS_LIST)

-- Build pipeline

local multiudp = gopiper.loadComponent(
  'multiudp_component.so', {
    address_list = ADDRESSES,
  }
)

local pcap = gopiper.loadComponent(
  'pcap_component.so', {
    device = DEVICE,
    filter = FILTER,
  }
)

gopiper.createPipeline({ pcap, multiudp})
