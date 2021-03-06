local api = vim.api
local icons = require 'devicon'
local session = require 'abduco'
local M = {}

session.abduco_session()

-- Different colors for mode
-- local red = '#BF616A'
-- local yellow = '#EBCB8B'
-- local green = '#A3BE8C'
-- local blue = '#81A1C1'
-- local purple = '#B48EAD'

local white = '#ffffff'
local red = '#ff5349' -- red orange
local orange = '#ff9326'
local yellow = '#fe6e00' -- blaze orange
local green = '#4CBB17' -- color Kelly
-- local green = '#55a630'
local turquoise = '#3FE0D0'
local aqua = '#18ffe0'
local blue = '#31baff'
-- local blue = '#3a86ff'
local purple = '#9d8cff'

-- fg and bg
local white_fg = '#e6e6e6'
local black_fg = '#282c34'
local bg = '#4d4d4d'

-- Separators
-- local left_separator = ''
-- local right_separator = ''
-- local left_separator = ' '
-- local right_separator = ' '
-- local left_separator = ' '
-- local right_separator = ' '
-- statusline = statusline.."▒░"
-- local left_separator = ''
-- local right_separator = ''
local left_separator = ''
local right_separator = ''
-- let s:separators = {
      -- \ 'arrow' : ["\ue0b0", "\ue0b2"],
      -- \ 'curve' : ["\ue0b4", "\ue0b6"],
      -- \ 'slant' : ["\ue0b8", "\ue0ba"],
      -- \ 'brace' : ["\ue0d2", "\ue0d4"],
      -- \ 'fire' : ["\ue0c0", "\ue0c2"],
-- call s:check_defined('g:airline_left_sep', "\ue0b0")      " 
-- call s:check_defined('g:airline_left_alt_sep', "\ue0b1")  " 
-- call s:check_defined('g:airline_right_sep', "\ue0b2")     " 
-- call s:check_defined('g:airline_right_alt_sep', "\ue0b3") " 

-- Blank Between Components
local blank = ' '

-- Icons
local iconNERDTree = '🌳 NERDTree'
local iconVista = '📌 Vista'

-- Using NERDFonts
-- https://github.com/ryanoasis/powerline-extra-symbols
-- ro=, ws=☲, lnr=☰, mlnr=, br=, nx=Ɇ, crypt=🔒, dirty=⚡
local ln=''

------------------------------------------------------------------------
--                             StatusLine                             --
------------------------------------------------------------------------

-- Mode Prompt Table
local current_mode = setmetatable({
      ['n'] = 'NORMAL',
      ['no'] = 'N·Operator Pending',
      ['v'] = 'VISUAL',
      ['V'] = 'V·Line',
      ['^V'] = 'V·Block',
      ['s'] = 'Select',
      ['S'] = 'S·Line',
      ['^S'] = 'S·Block',
      ['i'] = 'INSERT',
      ['ic'] = 'INSERT',
      ['ix'] = 'INSERT',
      ['R'] = 'Replace',
      ['Rv'] = 'V·Replace',
      ['c'] = 'COMMAND',
      ['cv'] = 'Vim Ex',
      ['ce'] = 'Ex',
      ['r'] = 'Prompt',
      ['rm'] = 'More',
      ['r?'] = 'Confirm',
      ['!'] = 'Shell',
      ['t'] = 'TERMINAL'
    }, {
      -- TODO
      -- fix weird issues
      __index = function(_, _)
        return 'V·Block'
      end
    }
)

-- Redraw different colors for different mode
local RedrawColors = function(mode)
  if mode == 'n' then
    api.nvim_command('hi NeoLineMode guibg='..blue..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi NeoLineModeSeparator guifg='..blue)
    api.nvim_command('hi NeoLineDefault guibg='..blue)
  end
  if mode == 'i' then
    api.nvim_command('hi NeoLineMode guibg='..green..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi NeoLineModeSeparator guifg='..green)
    api.nvim_command('hi NeoLineDefault guibg='..green)
  end
  if mode == 'v' or mode == 'V' or mode == '^V' then
    api.nvim_command('hi NeoLineMode guibg='..purple..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi NeoLineModeSeparator guifg='..purple)
    api.nvim_command('hi NeoLineDefault guibg='..purple)
  end
  if mode == 'c' then
    api.nvim_command('hi NeoLineMode guibg='..yellow..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi NeoLineModeSeparator guifg='..yellow)
    api.nvim_command('hi NeoLineDefault guibg='..yellow)
  end
  if mode == 'R' then
    api.nvim_command('hi NeoLineMode guibg='..red..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi NeoLineModeSeparator guifg='..red)
    api.nvim_command('hi NeoLineDefault guibg='..red)
  end
  if mode == 't' then
    api.nvim_command('hi NeoLineMode guibg='..turquoise..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi NeoLineModeSeparator guifg='..turquoise)
    api.nvim_command('hi NeoLineDefault guibg='..turquoise)
  end
end

local TrimmedDirectory = function(dir)
  local home = os.getenv("HOME")
  local _, index = string.find(dir, home, 1)
  if index ~= nil and index ~= string.len(dir) then
    -- TODO Trimmed Home NeoLineDirectory
    return string.gsub(dir, home, '~')
  end
  return dir
end

-- Initialize colors
function M.initColors()
    -- Filename Color
    local file_bg = purple
    local file_fg = black_fg
    local file_gui = 'bold'
    api.nvim_command('hi NeoLineFile guibg='..file_bg..' guifg='..file_fg..' gui='..file_gui)
    api.nvim_command('hi NeoLineFileSeparator guifg='..file_bg)
    
    -- Working directory Color
    local dir_bg = bg
    local dir_fg = white_fg
    local dir_gui = 'bold'
    api.nvim_command('hi NeoLineNeoLineDirectory guibg='..dir_bg..' guifg='..dir_fg..' gui='..dir_gui)
    api.nvim_command('hi NeoLineDirSeparator guifg='..dir_bg)
    
    -- FileType Color
    local filetype_bg = 'None'
    local filetype_fg = blue
    local filetype_gui = 'bold'
    api.nvim_command('hi NeoLineFiletype guibg='..filetype_bg..' guifg='..filetype_fg..' gui='..filetype_gui)
    
    -- VCS Color
    local vcs_add = green
    local vcs_delete = red
    local vcs_change = orange
    local vcs_fg = white
    api.nvim_command('hi NeoLineVCSLeft guifg='..white..' guibg='..blue)
    api.nvim_command('hi NeoLineVCSLeft1 guifg='..blue..' guibg='..white)
    api.nvim_command('hi NeoLineVCSAdd guifg='..green..' guibg='..white)
    api.nvim_command('hi NeoLineVCSDelete guifg='..red..' guibg='..white)
    api.nvim_command('hi NeoLineVCSChange guifg='..orange..' guibg='..white)
    api.nvim_command('hi NeoLineVCSRight guifg='..white..' guibg='..blue)
    
    api.nvim_command('hi NeoLineDefault guifg='..white..' guibg='..blue)
    
    -- row and column Color
    local line_bg = 'None'
    local line_fg = white_fg
    local line_gui = 'bold'
    api.nvim_command('hi NeoLineLine guibg='..line_bg..' guifg='..line_fg..' gui='..line_gui)

    -- TabLine
    api.nvim_command('hi NeoLineTabLineSel gui=Bold guibg='..blue..' guifg='..white)
    api.nvim_command('hi NeoLineTabLineSelSeparator gui=bold guifg='..blue)
    api.nvim_command('hi NeoLineTabLine guibg=#4d4d4d guifg=#c7c7c7 gui=None')
    api.nvim_command('hi NeoLineTabLineSeparator guifg=#4d4d4d')
    api.nvim_command('hi NeoLineTabLineFill guibg=None gui=None')

    local InactiveLine_bg = '#4d4d4d'
    local InactiveLine_fg = white_fg
    api.nvim_command('hi NeoLineInActive guibg='..InactiveLine_bg..' guifg='..InactiveLine_fg)

end

function M.activeLine(idbuffer)
  local statusline = "%#NeoLineDefault#"

  local filetype = api.nvim_buf_get_option(0, 'filetype')

  -- Icon For File
  if filetype == 'nerdtree' then
      statusline = statusline.."%f"
      -- statusline = statusline..iconNERDTree
      return statusline
  elseif filetype == 'vista' then
      statusline = statusline.."%f"
      -- statusline = statusline..iconVista
      return statusline
  end

  -- Component: Mode
  local mode = api.nvim_get_mode()['mode']
  RedrawColors(mode)
  statusline = statusline.."%#NeoLineDefault#"..current_mode[mode].." %#NeoLineDefault#"
  statusline = statusline..blank

  -- Component: Working Directory
  -- local dir = api.nvim_call_function('getcwd', {})
  -- statusline = statusline.."%#NeoLineDirSeparator#"..left_separator.."%#NeoLineDirectory# "..TrimmedDirectory(dir).." %#NeoLineDirSeparator#"..right_separator
  -- statusline = statusline..blank

  -- Repository Status
  local repostats = api.nvim_call_function('sy#repo#get_stats', {})
  if repostats[1] > -1 then
    statusline = statusline.."%#NeoLineVCSLeft#"
    -- statusline = statusline..left_separator
    statusline = statusline.."%#NeoLineDefault#"
    statusline = statusline..''
    statusline = statusline.."%#NeoLineVCSAdd#"
    statusline = statusline.."+"..repostats[1]
    statusline = statusline.."%#NeoLineVCSDelete#"
    statusline = statusline.."-"..repostats[2]
    statusline = statusline.."%#NeoLineVCSChange#"
    statusline = statusline.."~"..repostats[3]
    statusline = statusline.."%#NeoLineVCSRight#"
    -- statusline = statusline..right_separator
    statusline = statusline.."%#NeoLineDefault#"
    statusline = statusline..''
  end

  -- Alignment to left
  statusline = statusline.."%#NeoLineDefault#"
  statusline = statusline.."%="
  statusline = statusline.."%#NeoLineDefault#"

  -- neoclide/coc.nvim

  local didCocLoaded = api.nvim_call_function('exists', {'g:did_coc_loaded'})
  if didCocLoaded ~= 0 then
      local cocstatus = api.nvim_call_function('coc#status', {})
      statusline = statusline..cocstatus
  end

  -- lsp-status

  local useLspStatus, importedLspStatus = pcall(require, "lsp-status")

  if useLspStatus then
    statusline = statusline..importedLspStatus.status()
  end

  -- Component: FileType
  statusline = statusline.."%#NeoLineDefault# "..filetype
  statusline = statusline..blank

  -- Component: row and col
  local line = api.nvim_call_function('line', {"."})
  statusline = statusline.."%#NeoLineDefault# "..ln.." "..line

  return statusline
end

function M.inActiveLine(idbuffer)
  local statusline = ""

  statusline = "%#NeoLineInActive# %f"

  -- local filetype = api.nvim_buf_get_option(idbuffer, 'filetype')
  -- -- Icon For File
  -- if filetype == 'nerdtree' then
      -- statusline = statusline..iconNERDTree
      -- return statusline
  -- elseif filetype == 'vista' then
      -- statusline = statusline..iconVista
      -- return statusline
  -- end

  -- local file_name = api.nvim_call_function('expand', {'%F'})
  statusline = statusline.."%#NeoLineInActive# "

  return statusline
end

------------------------------------------------------------------------
--                              TabLine                               --
------------------------------------------------------------------------

local getIcon = function(file_name)
  -- local icon = icons.deviconTable[file_name]

  -- TODO verify if var exists
  -- g:webdevicons_enable
  local icon = api.nvim_call_function('WebDevIconsGetFileTypeSymbol', {file_name})
  return icon
end

local getTabLabel = function(n)
  local current_number = api.nvim_tabpage_get_number(n)
  local current_win = api.nvim_tabpage_get_win(n)
  local current_buf = api.nvim_win_get_buf(current_win)
  local file_name = api.nvim_buf_get_name(current_buf)
  if string.find(file_name, 'term://') ~= nil then
    return current_number..'  '..api.nvim_call_function('fnamemodify', {file_name, ":p:t"})
  end
  file_name = api.nvim_call_function('fnamemodify', {file_name, ":p:t"})
  if file_name == '' then
    return current_number.." No Name"
  end
  local icon = getIcon(file_name)
  if icon ~= nil then
    return current_number..' '..icon..' '..file_name
  end
  return current_number..' '..file_name
end

function M.TabLine()
  local tabline = ''
  local tab_list = api.nvim_list_tabpages()
  local current_tab = api.nvim_get_current_tabpage()
  for _, val in ipairs(tab_list) do
    local file_name = getTabLabel(val)
    if val == current_tab then
      tabline = tabline.."%#NeoLineTabLineSelSeparator# "..left_separator
      tabline = tabline.."%#NeoLineTabLineSel# "..file_name
      tabline = tabline.." %#NeoLineTabLineSelSeparator#"..right_separator
    else
      tabline = tabline.."%#NeoLineTabLineSeparator# "..left_separator
      tabline = tabline.."%#NeoLineTabLine# "..file_name
      tabline = tabline.." %#NeoLineTabLineSeparator#"..right_separator
    end
  end
  tabline = tabline.."%="
  if session.data ~= nil then
    tabline = tabline.."%#NeoLineTabLineSeparator# "..left_separator
    tabline = tabline.."%#NeoLineTabLine# session: "..session.data
    tabline = tabline.." %#NeoLineTabLineSeparator#"..right_separator
  end
  return tabline
end

M.initColors()

return M

