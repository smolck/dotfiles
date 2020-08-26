require'snippets'.use_suggested_mappings()
require'snippets'.set_ux(require'snippets.inserters.floaty')

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

require'snippets'.snippets = {
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

    randcolor = function()
      return string.format("#%06X", math.floor(math.random() * 0xFFFFFF))
    end;

    -- ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]];
  }
}
