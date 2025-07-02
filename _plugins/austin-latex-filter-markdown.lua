-- austin-latex-filter-markdown.lua
-- Pandoc filter to convert custom LaTeX from austin.sty to Markdown-friendly formats
-- This version is optimized for pure Markdown output (no HTML/CSS)

-- Helper function to create a blockquote for theorem-like environments
function create_theorem_blockquote(title, content)
    local blocks = {}
    
    -- Create the header with bold title
    local header_content = pandoc.Strong(title .. ":")
    table.insert(blocks, pandoc.Para(header_content))
    
    -- Add content blocks
    for _, block in ipairs(content) do
        table.insert(blocks, block)
    end
    
    -- Create and return blockquote
    return pandoc.BlockQuote(blocks)
end

-- Environment names for theorem-like structures
local theorem_environments = {
    "theorem", "lemma", "corollary", "proposition", "claim",
    "example", "remark", "definition", "exercise", "problem",
    "subproblem", "note", "case2", "question", "subquestion"
}

-- Math operator replacements
local math_operators = {
    ["\\cis"] = "\\mathrm{cis}",
    ["\\lcm"] = "\\mathrm{lcm}",
    ["\\ord"] = "\\mathrm{ord}",
    ["\\Span"] = "\\mathrm{span}",
    ["\\Id"] = "\\mathrm{Id}",
    ["\\img"] = "\\mathrm{img}",
    ["\\vol"] = "\\mathrm{vol}",
    ["\\sgn"] = "\\mathrm{sgn}",
    ["\\arsinh"] = "\\mathrm{arsinh}",
    ["\\arcosh"] = "\\mathrm{arcosh}",
    ["\\artanh"] = "\\mathrm{artanh}",
    ["\\arsech"] = "\\mathrm{arsech}",
    ["\\arcsch"] = "\\mathrm{arcsch}",
    ["\\arcoth"] = "\\mathrm{arcoth}",
    ["\\dR"] = "\\mathrm{dR}",
    ["\\Mat"] = "\\mathrm{Mat}",
    ["\\PGL"] = "\\mathrm{PGL}",
    ["\\PSL"] = "\\mathrm{PSL}",
    ["\\Irr"] = "\\mathrm{Irr}",
    ["\\cl"] = "\\mathrm{cl}",
    ["\\Aut"] = "\\mathrm{Aut}",
    ["\\End"] = "\\mathrm{End}",
    ["\\Inn"] = "\\mathrm{Inn}",
    ["\\Out"] = "\\mathrm{Out}",
    ["\\Stab"] = "\\mathrm{Stab}",
    ["\\supp"] = "\\mathrm{supp}",
    ["\\argmin"] = "\\mathrm{arg\\,min}",
    ["\\argmax"] = "\\mathrm{arg\\,max}",
    ["\\Obj"] = "\\mathrm{Obj}",
    ["\\Hom"] = "\\mathrm{Hom}",
    ["\\Grp"] = "\\mathrm{Grp}",
    ["\\Ab"] = "\\mathrm{Ab}",
    ["\\Ring"] = "\\mathrm{Ring}",
    ["\\Mod"] = "\\mathrm{Mod}",
    ["\\Alg"] = "\\mathrm{Alg}",
    ["\\Man"] = "\\mathrm{Man}",
    ["\\Diff"] = "\\mathrm{Diff}"
}

-- Custom command replacements
local custom_commands = {
    ["\\C"] = "\\mathbb{C}",
    ["\\F"] = "\\mathbb{F}",
    ["\\N"] = "\\mathbb{N}",
    ["\\Q"] = "\\mathbb{Q}",
    ["\\R"] = "\\mathbb{R}",
    ["\\Z"] = "\\mathbb{Z}",
    ["\\HH"] = "\\mathbb{H}",
    ["\\Sph"] = "\\mathbb{S}",
    ["\\Tor"] = "\\mathbb{T}",
    ["\\RP"] = "\\mathbb{RP}",
    ["\\CP"] = "\\mathbb{CP}",
    ["\\bigO"] = "\\mathcal{O}",
    ["\\algo"] = "\\mathcal{A}",
    ["\\mS"] = "\\mathcal{S}",
    ["\\M"] = "\\mathcal{M}",
    ["\\dg"] = "^{\\circ}",
    ["\\ii"] = "\\mathbf{i}",
    ["\\jj"] = "\\mathbf{j}",
    ["\\kk"] = "\\mathbf{k}",
    ["\\cd"] = "\\cdot",
    ["\\der"] = "^{\\circ}",
    ["\\st"] = "\\ \\text{s.t.} \\ ",
    ["\\lat"] = "\\mathcal{L}",
    ["\\im"] = "\\mathrm{im}",
    ["\\semi"] = "\\ltimes",
    ["\\acts"] = "\\circlearrowright",
    ["\\notimplies"] = "\\not\\Rightarrow",
    ["\\Zp"] = "\\mathbb{Z}/p\\mathbb{Z}",
    ["\\RMod"] = "R\\text{-Mod}",
    ["\\ModR"] = "\\text{Mod-}R",
    ["\\kAlg"] = "k\\text{-Alg}",
    ["\\expect"] = "\\mathbb{E}",
    ["\\1"] = "\\mathbf{1}",  -- Changed from \mathbbm{1}
    ["\\coloneq"] = ":="  -- Added support for coloneq
}

-- Function to escape special pattern characters
local function escape_pattern(str)
    return str:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end

-- Function to replace custom math commands
function replace_math_commands(text)
    -- Replace custom operators
    for cmd, replacement in pairs(math_operators) do
        local pattern = escape_pattern(cmd)
        text = text:gsub(pattern .. "([^%a])", replacement .. "%1")
        text = text:gsub(pattern .. "$", replacement)
    end
    
    -- Replace custom commands
    for cmd, replacement in pairs(custom_commands) do
        local pattern = escape_pattern(cmd)
        text = text:gsub(pattern .. "([^%a])", replacement .. "%1")
        text = text:gsub(pattern .. "$", replacement)
    end
    
    -- Replace parameterized commands
    text = text:gsub("\\cbrt%s*{([^{}]-)}", "\\sqrt[3]{%1}")
    text = text:gsub("\\floor%s*{([^{}]-)}", "\\lfloor %1 \\rfloor")
    text = text:gsub("\\ceil%s*{([^{}]-)}", "\\lceil %1 \\rceil")
    text = text:gsub("\\bb%s*{([^{}]-)}", "\\boxed{%1}")
    
    -- Comprehensive \ab macro replacement (handles all bracket types)
    -- \ab[...] -> \lvert ... \rvert (absolute value with square bracket syntax)
    text = text:gsub("\\ab%s*%[([^%[%]]-)%]", "\\lvert %1 \\rvert")
    
    -- \ab{...} -> \lvert ... \rvert (absolute value with curly brace syntax)
    text = text:gsub("\\ab%s*{([^{}]-)}", "\\lvert %1 \\rvert")
    
    -- \ab(...) -> \lvert ... \rvert (absolute value with parentheses syntax)
    text = text:gsub("\\ab%s*%b()", function(param)
        local inner = param:sub(2, -2)
        return "\\lvert " .. inner .. " \\rvert"
    end)
    
    -- \ab|...| -> \lvert ... \rvert (absolute value with vertical bar syntax)
    text = text:gsub("\\ab%s*|([^|]-)|", "\\lvert %1 \\rvert")
    
    -- Handle \abs command as well (standard physics package command)
    text = text:gsub("\\abs%s*{([^{}]-)}", "\\lvert %1 \\rvert")
    text = text:gsub("\\abs%s*%b()", function(param)
        local inner = param:sub(2, -2)
        return "\\lvert " .. inner .. " \\rvert"
    end)
    
    -- Add norm commands (physics package style)
    text = text:gsub("\\norm%s*{([^{}]-)}", "\\lVert %1 \\rVert")
    text = text:gsub("\\norm%s*%b()", function(param)
        local inner = param:sub(2, -2)
        return "\\lVert " .. inner .. " \\rVert"
    end)
    
    -- Fix \implies command
    text = text:gsub("\\implies", "\\Rightarrow")
    
    -- Add evaluation brackets (physics package style)
    text = text:gsub("\\eval%s*{([^{}]-)}", "\\left.%1\\right|")
    
    -- Add physics-style derivatives
    text = text:gsub("\\dv%s*{([^{}]-)}%s*{([^{}]-)}", "\\frac{d%1}{d%2}")
    text = text:gsub("\\pdv%s*{([^{}]-)}%s*{([^{}]-)}", "\\frac{\\partial %1}{\\partial %2}")
    
    -- Add more bracket commands
    text = text:gsub("\\paren%s*{([^{}]-)}", "\\left(%1\\right)")
    text = text:gsub("\\bracket%s*{([^{}]-)}", "\\left[%1\\right]")
    text = text:gsub("\\brace%s*{([^{}]-)}", "\\left\\{%1\\right\\}")
    
    text = text:gsub("\\fr%s*{([^{}]-)}%s*{([^{}]-)}", "\\frac{%1}{%2}")
    text = text:gsub("\\T%s*{([^{}]-)}", "\\text{%1}")
    text = text:gsub("\\Ts%s*{([^{}]-)}", "\\text{ %1 }")
    text = text:gsub("\\e%s*{([^{}]-)}", "\\emph{%1}")
    text = text:gsub("\\bv%s*{([^{}]-)}", "\\mathbf{%1}")
    text = text:gsub("\\xto%s*{([^{}]-)}", "\\xrightarrow{%1}")
    text = text:gsub("\\b%s*{([^{}]-)}", "\\mathbf{%1}")
    text = text:gsub("\\bm%s*{([^{}]-)}", "\\mathbf{%1}")
    
    -- Replace matrix shortcuts like \V{...} -> \begin{bmatrix} ... \end{bmatrix}
    text = text:gsub("\\V%s*{([^{}]-)}", "\\begin{bmatrix}%1\\end{bmatrix}")
    text = text:gsub("\\pV%s*{([^{}]-)}", "\\begin{pmatrix}%1\\end{pmatrix}")
    
    -- Replace integral shortcuts
    text = text:gsub("\\intab%s*{([^{}]-)}", "\\int_a^b %1")
    text = text:gsub("\\intrn%s*{([^{}]-)}", "\\int_{\\mathbb{R}^n} %1")
    text = text:gsub("\\intg%s*{([^{}]-)}", "\\int_{\\gamma} %1")
    text = text:gsub("\\intinf%s*{([^{}]-)}", "\\int_{-\\infty}^{\\infty} %1")
    
    -- Replace probability/stats commands
    text = text:gsub("\\Ex%s*{([^{}]-)}", "\\mathbb{E}[%1]")
    text = text:gsub("\\ExS%s*{([^{}]-)}%s*{([^{}]-)}", "\\mathbb{E}_{%1}[%2]")
    text = text:gsub("\\Var%s*{([^{}]-)}", "\\mathrm{Var}(%1)")
    text = text:gsub("\\Cov%s*{([^{}]-)}%s*{([^{}]-)}", "\\mathrm{Cov}(%1, %2)")
    text = text:gsub("\\corr%s*{([^{}]-)}%s*{([^{}]-)}", "\\mathrm{corr}(%1, %2)")
    text = text:gsub("\\Bern%s*{([^{}]-)}", "\\mathrm{Bern}(%1)")
    text = text:gsub("\\Geom%s*{([^{}]-)}", "\\mathrm{Geom}(%1)")
    text = text:gsub("\\Binom%s*{([^{}]-)}%s*{([^{}]-)}", "\\mathrm{Binom}(%1, %2)")
    
    -- Handle \det with optional argument
    text = text:gsub("\\det%s*{([^{}]-)}", "\\det(%1)")
    
    -- Replace QED inline markers inside math
    text = text:gsub("\\qedsymbol", "∎")
    text = text:gsub("\\qed", "∎")
    text = text:gsub("\\duck%s*%b[]", "∎")
    
    -- Fix any \mathop{...} that might have been generated
    text = text:gsub("\\mathop{\\mathrm{([^}]-)}}", "\\mathrm{%1}")
    
    -- Handle braceless usage like \bm\Omega
    text = text:gsub("\\bm%s*(\\?[%a]+)", "\\mathbf{%1}")
    
    return text
end

-- Main filter function for raw LaTeX blocks
function RawBlock(elem)
    if elem.format == "latex" then
        local text = elem.text
        
        -- Check for theorem-like environments
        for _, env in ipairs(theorem_environments) do
            -- Handle environments with optional arguments and starred versions
            local pattern = "\\begin{" .. escape_pattern(env) .. "%*?}%s*(%b[])?"
            local start_pos, end_pos, opt_arg = text:find(pattern)
            
            if start_pos then
                -- Find the matching \end
                local end_pattern = "\\end{" .. escape_pattern(env) .. "%*?}"
                local env_end_start, env_end = text:find(end_pattern, end_pos + 1)
                
                if env_end then
                    -- Extract content between begin and end
                    local content = text:sub(end_pos + 1, env_end_start - 1)
                    
                    -- Create title
                    local title = env:sub(1,1):upper() .. env:sub(2)
                    if opt_arg then
                        local arg_content = opt_arg:sub(2, -2) -- Remove [ ]
                        title = title .. " (" .. arg_content .. ")"
                    end
                    
                    -- Parse the content
                    local parsed_content = pandoc.read(content, "latex").blocks
                    
                    return create_theorem_blockquote(title, parsed_content)
                end
            end
        end
        
        -- Handle TikZ pictures
        if text:match("\\begin{tikzpicture}") then
            return pandoc.Para(pandoc.Emph(pandoc.Str("[TikZ diagram - cannot be rendered in web version]")))
        end
        
        -- Handle QED symbol
        if text:match("\\qedsymbol") or text:match("\\duck%[") then
            return pandoc.Para(pandoc.Str("∎"))
        end
        if text:match("\\qed") then
            return pandoc.Para(pandoc.Str("∎"))
        end
        
        -- Handle listings
        if text:match("\\begin{lstlisting}") then
            local lang = text:match("\\begin{lstlisting}%[language=([^%]]+)%]") or ""
            local code_content = text:match("\\begin{lstlisting}.-\n(.-)\\end{lstlisting}")
            if code_content then
                -- Clean up the code content
                code_content = code_content:gsub("^%s+", ""):gsub("%s+$", "")
                -- For markdown output, just return the code with language specifier
                if lang ~= "" then
                    -- Return as fenced code block with language
                    return pandoc.RawBlock("markdown", "```" .. lang:lower() .. "\n" .. code_content .. "\n```")
                else
                    -- Return as plain fenced code block
                    return pandoc.RawBlock("markdown", "```\n" .. code_content .. "\n```")
                end
            end
        end
        
        -- Handle incfig command
        if text:match("\\incfig{") then
            local figname = text:match("\\incfig{([^}]+)}")
            return pandoc.Para(pandoc.Emph(pandoc.Str("[Figure: " .. (figname or "unknown") .. "]")))
        end
    end
    
    return elem
end

-- Filter for inline math
function Math(elem)
    elem.text = replace_math_commands(elem.text)
    return elem
end

-- Filter for code blocks to simplify attributes
function CodeBlock(elem)
    -- Always output a plain fenced code block, stripping any extra attributes
    local lang = ""
    if elem.classes and #elem.classes > 0 then
        -- Use the first class as the language identifier
        lang = elem.classes[1]
    end
    return pandoc.RawBlock("markdown", "```" .. lang .. "\n" .. elem.text .. "\n```")
end

-- Filter for divs that are created by pandoc's latex reader
function Div(elem)
    -- Check if this div has a class that matches our theorem environments
    for _, env in ipairs(theorem_environments) do
        if elem.classes:includes(env) then
            -- Extract any title from attributes
            local title = env:sub(1,1):upper() .. env:sub(2)
            
            -- Look for title in various possible locations
            if elem.attributes.title then
                title = title .. " (" .. elem.attributes.title .. ")"
            elseif elem.attributes.label then
                -- Sometimes the optional argument gets parsed as a label
                title = title .. " (" .. elem.attributes.label .. ")"
            else
                -- Check if first element contains title info
                local first = elem.content[1]
                if first and first.t == "Para" and #first.content > 0 then
                    local first_str = pandoc.utils.stringify(first.content[1])
                    -- Check if it looks like a title (starts with capital letter)
                    if first_str:match("^%[") then
                        -- Extract title from [Title] format
                        local extracted = first_str:match("^%[(.-)%]")
                        if extracted then
                            title = title .. " (" .. extracted .. ")"
                            -- Remove the title from content
                            table.remove(elem.content, 1)
                        end
                    end
                end
            end
            
            -- Return as blockquote
            return create_theorem_blockquote(title, elem.content)
        end
    end
    
    -- Check if this might be a tcolorbox environment
    if elem.classes:includes("tcolorbox") then
        local first_elem = elem.content[1]
        if first_elem and first_elem.t == "Para" then
            local content_str = pandoc.utils.stringify(first_elem)
            -- Try to identify the environment type
            for _, env in ipairs(theorem_environments) do
                if content_str:lower():find("^" .. env) then
                    local title = env:sub(1,1):upper() .. env:sub(2)
                    -- Remove the first element (which contains the environment name)
                    local content = {}
                    for i = 2, #elem.content do
                        table.insert(content, elem.content[i])
                    end
                    return create_theorem_blockquote(title, content)
                end
            end
        end
    end
    
    return elem
end

-- No Meta function needed for pure Markdown output
-- Return filter functions in order
return {
    {Math = Math},
    {RawBlock = RawBlock},
    {Div = Div},
    {CodeBlock = CodeBlock},
    {RawInline = RawInline}
} 