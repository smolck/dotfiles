local snippets = require'snippets'
snippets.use_suggested_mappings()
snippets.set_ux(require'snippets.inserters.floaty')
local match_indent = snippets.u.match_indentation

function nested_list(input)
  local indent = 0
  local indent_step = 2
  local str = ''
  local padding = ''
  for item, operator in input:gmatch('([%s%w]+)([,<>]+)') do
    padding = string.rep(' ', indent)
    str = str ..string.format('%s[ ] %s\n', padding, item)
    if operator == '>' then
      indent = indent + indent_step
    elseif operator == '<' and indent >= indent_step then
      indent = indent - indent_step
    end
  end
  return str
end

function create_list_of_strings(input)
  local str = ''
  local function wrap_quotes(x) return "'" .. x .. "'" end
  for item, _ in input:gmatch('([%s%w%.%_]+),') do
    local str_end = (' '):rep(vim.bo.shiftwidth) .. wrap_quotes(item)
    if str == '' then
      str = str .. str_end
    else
      str = str .. ',\n' .. str_end
    end
  end

  return str
end

require'snippets'.snippets = {
  typescriptreact = {
    stydiv = match_indent [[
<div style={{
    ${1}
  }}>
    ${2}
  </div>
]]
  };
  todoist = {
    create_task = [[${1|nested_list(S.v)}]];
  };
  lua = {
    -- Courtesy of @norcalli
    func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]];
    req = [[local ${2:${1|S.v:match"%w+$"}} = require '$1']];
    ["local"] = [[local ${2:${1|S.v:match"[^.]+$"}} = ${1}]];

    ["for"] = "for ${1:i}, ${2:v} in ipairs(${3:t}) do\n$0\nend";

    ["vmap"] = [[vim.tbl_map(function(x) return ${1:x} end, ${2:t})]];
    ["vfilter"] = [[vim.tbl_filter(function(x) return ${1:x} == ${2} end, ${3:t})]];

    slis = [[
local $1 = {
${2|create_list_of_strings(S.v)}
}
]];

    randcolor = function()
      return string.format("#%06X", math.floor(math.random() * 0xFFFFFF))
    end;


    -- ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]];
  }
}
