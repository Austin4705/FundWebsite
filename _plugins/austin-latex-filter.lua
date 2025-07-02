-- austin-latex-filter.lua
-- Pandoc filter to convert custom LaTeX from austin.sty to web-compatible formats

-- Helper function to create a blockquote with custom styling
function create_blockquote(title, content, style_class)
    local blocks = {}
    
    -- Create the header with bold title
    local header_content = pandoc.Strong(title)
    table.insert(blocks, pandoc.Para(header_content))
    
    -- Add content blocks
    for _, block in ipairs(content) do
        table.insert(blocks, block)
    end
    
    -- Create blockquote
    local blockquote = pandoc.BlockQuote(blocks)
    
    -- Add custom class using a Div wrapper for styling
    return pandoc.Div(blockquote, pandoc.Attr("", {style_class, "theorem-blockquote"}, {}))
end

-- Color mapping for theorem environments
local theorem_colors = {
    theorem = "theorem-blue",
    lemma = "lemma-cyan", 
    corollary = "corollary-purple",
    proposition = "proposition-green",
    claim = "claim-green",
    example = "example-red",
    remark = "remark-lightred",
    definition = "definition-gray",
    exercise = "exercise-teal",
    problem = "problem-blue",
    subproblem = "subproblem-lightblue",
    note = "note-gray"
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
    ["\\argmin"] = "\\mathrm{argmin}",
    ["\\argmax"] = "\\mathrm{argmax}",
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
    ["\\im"] = "\\operatorname{im}",
    ["\\semi"] = "\\ltimes",
    ["\\acts"] = "\\circlearrowright",
    ["\\notimplies"] = "\\not\\Rightarrow",
    ["\\Zp"] = "\\mathbb{Z}/p\\mathbb{Z}",
    ["\\RMod"] = "R\\text{-Mod}",
    ["\\ModR"] = "\\text{Mod-}R",
    ["\\kAlg"] = "k\\text{-Alg}",
    ["\\expect"] = "\\mathbb{E}",
    ["\\1"] = "\\mathbbm{1}"
}

-- Function to replace custom math commands
function replace_math_commands(text)
    -- Replace custom operators
    for cmd, replacement in pairs(math_operators) do
        text = text:gsub(cmd:gsub("\\", "\\\\"), replacement)
    end
    
    -- Replace custom commands
    for cmd, replacement in pairs(custom_commands) do
        text = text:gsub(cmd:gsub("\\", "\\\\"), replacement)
    end
    
    -- Replace parameterized commands
    text = text:gsub("\\cbrt{([^}]+)}", "\\sqrt[3]{%1}")
    text = text:gsub("\\floor{([^}]+)}", "\\lfloor %1 \\rfloor")
    text = text:gsub("\\ceil{([^}]+)}", "\\lceil %1 \\rceil")
    text = text:gsub("\\bb{([^}]+)}", "\\boxed{%1}")
    text = text:gsub("\\fr{([^}]+)}{([^}]+)}", "\\frac{%1}{%2}")
    text = text:gsub("\\T{([^}]+)}", "\\text{%1}")
    text = text:gsub("\\Ts{([^}]+)}", "\\text{ %1 }")
    text = text:gsub("\\e{([^}]+)}", "\\emph{%1}")
    text = text:gsub("\\bv{([^}]+)}", "\\mathbf{%1}")
    text = text:gsub("\\xto{([^}]+)}", "\\xrightarrow{%1}")
    
    -- Replace matrix environments
    text = text:gsub("\\V{([^}]+)}", "\\begin{bmatrix}%1\\end{bmatrix}")
    text = text:gsub("\\pV{([^}]+)}", "\\begin{pmatrix}%1\\end{pmatrix}")
    
    -- Replace integral shortcuts
    text = text:gsub("\\intab{([^}]+)}", "\\int_a^b %1")
    text = text:gsub("\\intrn{([^}]+)}", "\\int_{\\mathbb{R}^n} %1")
    text = text:gsub("\\intg{([^}]+)}", "\\int_{\\gamma} %1")
    text = text:gsub("\\intinf{([^}]+)}", "\\int_{-\\infty}^{\\infty} %1")
    
    -- Replace probability/stats commands
    text = text:gsub("\\Ex{([^}]+)}", "\\mathbb{E}[%1]")
    text = text:gsub("\\ExS{([^}]+)}{([^}]+)}", "\\mathbb{E}_{%1}[%2]")
    text = text:gsub("\\Var{([^}]+)}", "\\text{Var}(%1)")
    text = text:gsub("\\Cov{([^}]+)}{([^}]+)}", "\\text{Cov}(%1, %2)")
    text = text:gsub("\\corr{([^}]+)}{([^}]+)}", "\\text{corr}(%1, %2)")
    text = text:gsub("\\Bern{([^}]+)}", "\\text{Bern}(%1)")
    text = text:gsub("\\Geom{([^}]+)}", "\\text{Geom}(%1)")
    text = text:gsub("\\Binom{([^}]+)}{([^}]+)}", "\\text{Binom}(%1, %2)")
    
    -- Handle \mathbbm{1} if MathJax doesn't support it
    text = text:gsub("\\mathbbm{1}", "\\mathbf{1}")
    
    return text
end

-- Main filter function
function RawBlock(elem)
    if elem.format == "latex" then
        local text = elem.text
        
        -- Check for theorem-like environments
        for env, class in pairs(theorem_colors) do
            -- Handle environments with optional arguments
            local pattern = "\\begin{" .. env .. "}%s*(%b[])?(.*)"
            local opt_arg, content = text:match(pattern)
            if content then
                -- Extract title from optional argument
                local title = env:sub(1,1):upper() .. env:sub(2)
                if opt_arg then
                    title = title .. " " .. opt_arg:sub(2, -2)
                end
                
                -- Find the end of the environment
                local end_pattern = "\\end{" .. env .. "}"
                local end_pos = text:find(end_pattern, 1, true)
                if end_pos then
                    content = text:sub(#("\\begin{" .. env .. "}") + (opt_arg and #opt_arg or 0) + 1, end_pos - 1)
                    
                    -- Parse the content as markdown
                    local parsed = pandoc.read(content, "markdown")
                    
                    return create_blockquote(title, parsed.blocks, class)
                end
            end
        end
        
        -- Handle TikZ pictures (convert to placeholder)
        if text:match("\\begin{tikzpicture}") then
            return pandoc.Para(pandoc.Str("[TikZ diagram - cannot be rendered in web version]"))
        end
        
        -- Handle QED symbol with duck
        if text:match("\\duck%[") then
            return pandoc.Para(pandoc.Str("∎")) -- Use standard QED symbol
        end
        
        -- Handle listings
        if text:match("\\begin{lstlisting}") then
            local code_content = text:match("\\begin{lstlisting}(.-)\\end{lstlisting}")
            if code_content then
                return pandoc.CodeBlock(code_content:gsub("^%s+", ""):gsub("%s+$", ""))
            end
        end
    end
    
    return elem
end

function Math(elem)
    -- Replace custom commands in math
    elem.text = replace_math_commands(elem.text)
    return elem
end

function Div(elem)
    -- Handle tcolorbox environments that might be parsed as divs
    if elem.classes:includes("tcolorbox") then
        -- Try to extract the title and content
        local first_elem = elem.content[1]
        if first_elem and first_elem.t == "Para" then
            local content = pandoc.utils.stringify(first_elem)
            -- Extract theorem type and create appropriate blockquote
            for env, class in pairs(theorem_colors) do
                if content:lower():match("^" .. env) then
                    return create_blockquote(env:sub(1,1):upper() .. env:sub(2), elem.content, class)
                end
            end
        end
    end
    
    return elem
end

-- Add CSS to style the theorem-like blockquotes
function Meta(meta)
    if not meta['header-includes'] then
        meta['header-includes'] = pandoc.MetaBlocks({})
    end
    
    local css = [[
<style>
/* Theorem-like blockquote styles */
.theorem-blockquote blockquote {
    margin: 1em 0;
    padding: 1em;
    border-left: 4px solid;
    background-color: rgba(0, 0, 0, 0.02);
    font-style: normal;
}

.theorem-blockquote blockquote p:first-child {
    margin-top: 0;
}

.theorem-blockquote blockquote p:last-child {
    margin-bottom: 0;
}

.theorem-blue blockquote {
    border-left-color: #0000ff;
    background-color: #f0f0ff;
}

.lemma-cyan blockquote {
    border-left-color: #0080ff;
    background-color: #f0f8ff;
}

.corollary-purple blockquote {
    border-left-color: #c55cd4;
    background-color: #faf0ff;
}

.proposition-green blockquote {
    border-left-color: #00b300;
    background-color: #f0fff0;
}

.claim-green blockquote {
    border-left-color: #388c46;
    background-color: #f5fff5;
}

.example-red blockquote {
    border-left-color: #ff0000;
    background-color: #fff0f0;
}

.remark-lightred blockquote {
    border-left-color: #ff8080;
    background-color: #fffafa;
}

.definition-gray blockquote {
    border-left-color: #808080;
    background-color: #f8f8f8;
}

.exercise-teal blockquote {
    border-left-color: #58d6d1;
    background-color: #f2fbf8;
}

.problem-blue blockquote {
    border-left-color: #00a3f3;
    background-color: #f0f8ff;
}

.subproblem-lightblue blockquote {
    border-left-color: #00a3f3;
    background-color: #f5fbff;
}

.note-gray blockquote {
    border-left-color: #cccccc;
    background-color: #f5f5f5;
}

/* Code block styling */
pre {
    background-color: #f5f5f6;
    padding: 1em;
    overflow-x: auto;
}

code {
    font-family: 'Courier New', monospace;
    background-color: #f5f5f6;
    padding: 0.2em 0.4em;
}
</style>
]]
    
    table.insert(meta['header-includes'], pandoc.RawBlock('html', css))
    return meta
end

-- Return filter functions in order
return {
    {Meta = Meta},
    {RawBlock = RawBlock},
    {Math = Math},
    {Div = Div}
} 