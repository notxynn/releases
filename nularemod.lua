UILib = {}
UILib.__index = UILib

ESP_FONTSIZE = 7 -- works great with ProggyClean

BLACK = Color3.new(0, 0, 0)

local myPlayer = game:GetService('Players').LocalPlayer
local myMouse = myPlayer:GetMouse()

local function clamp(x, a, b)
    if x > b then
        return b
    elseif a < a then
        return a
    else
        return x
    end
end

local function color3fromHSV(h, s, v)
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6

    local r, g, b
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    else r, g, b = v, p, q end

    return {r * 255, g * 255, b * 255}
end

local function getMousePos()
    return Vector2.new(myMouse.X, myMouse.Y) 
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function undrawAll(drawingsTable)
    for _, drawing in pairs(drawingsTable) do
        drawing.Visible = false
    end
end

local function destroyAllDrawings(drawingsTable)
    for _, drawing in ipairs(drawingsTable) do
        drawing:Remove()
    end
end

function UILib.new(name, size, watermarkActivity)
    repeat -- iskeypressed is halting our matcha menu button
        wait(1/9999)
    until isrbxactive()

    local self = setmetatable({}, UILib)

    -- input
    self._inputs = {
        ['m1'] = { id = 0x01, held = false, click = false },
        ['m2'] = { id = 0x02, held = false, click = false },
        ['mb'] = { id = 0x04, held = false, click = false },
        ['unbound'] = { id = 0x08, held = false, click = false },
        ['tab'] = { id = 0x09, held = false, click = false },
        ['enter'] = { id = 0x0D, held = false, click = false },
        ['shift'] = { id = 0x10, held = false, click = false },
        ['ctrl'] = { id = 0x11, held = false, click = false },
        ['alt'] = { id = 0x12, held = false, click = false },
        ['pause'] = { id = 0x13, held = false, click = false },
        ['capslock'] = { id = 0x14, held = false, click = false },
        ['esc'] = { id = 0x1B, held = false, click = false },
        ['space'] = { id = 0x20, held = false, click = false },
        ['pageup'] = { id = 0x21, held = false, click = false },
        ['pagedown'] = { id = 0x22, held = false, click = false },
        ['end'] = { id = 0x23, held = false, click = false },
        ['home'] = { id = 0x24, held = false, click = false },
        ['left'] = { id = 0x25, held = false, click = false },
        ['up'] = { id = 0x26, held = false, click = false },
        ['right'] = { id = 0x27, held = false, click = false },
        ['down'] = { id = 0x28, held = false, click = false },
        ['insert'] = { id = 0x2D, held = false, click = false },
        ['delete'] = { id = 0x2E, held = false, click = false },
        ['0'] = { id = 0x30, held = false, click = false },
        ['1'] = { id = 0x31, held = false, click = false },
        ['2'] = { id = 0x32, held = false, click = false },
        ['3'] = { id = 0x33, held = false, click = false },
        ['4'] = { id = 0x34, held = false, click = false },
        ['5'] = { id = 0x35, held = false, click = false },
        ['6'] = { id = 0x36, held = false, click = false },
        ['7'] = { id = 0x37, held = false, click = false },
        ['8'] = { id = 0x38, held = false, click = false },
        ['9'] = { id = 0x39, held = false, click = false },
        ['a'] = { id = 0x41, held = false, click = false },
        ['b'] = { id = 0x42, held = false, click = false },
        ['c'] = { id = 0x43, held = false, click = false },
        ['d'] = { id = 0x44, held = false, click = false },
        ['e'] = { id = 0x45, held = false, click = false },
        ['f'] = { id = 0x46, held = false, click = false },
        ['g'] = { id = 0x47, held = false, click = false },
        ['h'] = { id = 0x48, held = false, click = false },
        ['i'] = { id = 0x49, held = false, click = false },
        ['j'] = { id = 0x4A, held = false, click = false },
        ['k'] = { id = 0x4B, held = false, click = false },
        ['l'] = { id = 0x4C, held = false, click = false },
        ['m'] = { id = 0x4D, held = false, click = false },
        ['n'] = { id = 0x4E, held = false, click = false },
        ['o'] = { id = 0x4F, held = false, click = false },
        ['p'] = { id = 0x50, held = false, click = false },
        ['q'] = { id = 0x51, held = false, click = false },
        ['r'] = { id = 0x52, held = false, click = false },
        ['s'] = { id = 0x53, held = false, click = false },
        ['t'] = { id = 0x54, held = false, click = false },
        ['u'] = { id = 0x55, held = false, click = false },
        ['v'] = { id = 0x56, held = false, click = false },
        ['w'] = { id = 0x57, held = false, click = false },
        ['x'] = { id = 0x58, held = false, click = false },
        ['y'] = { id = 0x59, held = false, click = false },
        ['z'] = { id = 0x5A, held = false, click = false },
        -- ['lwin'] = { id = 0x5B, held = false, click = false },
        -- ['rwin'] = { id = 0x5C, held = false, click = false },
        ['numpad0'] = { id = 0x60, held = false, click = false },
        ['numpad1'] = { id = 0x61, held = false, click = false },
        ['numpad2'] = { id = 0x62, held = false, click = false },
        ['numpad3'] = { id = 0x63, held = false, click = false },
        ['numpad4'] = { id = 0x64, held = false, click = false },
        ['numpad5'] = { id = 0x65, held = false, click = false },
        ['numpad6'] = { id = 0x66, held = false, click = false },
        ['numpad7'] = { id = 0x67, held = false, click = false },
        ['numpad8'] = { id = 0x68, held = false, click = false },
        ['numpad9'] = { id = 0x69, held = false, click = false },
        ['multiply'] = { id = 0x6A, held = false, click = false },
        ['add'] = { id = 0x6B, held = false, click = false },
        ['separator'] = { id = 0x6C, held = false, click = false },
        ['subtract'] = { id = 0x6D, held = false, click = false },
        ['decimal'] = { id = 0x6E, held = false, click = false },
        ['divide'] = { id = 0x6F, held = false, click = false },
        ['f1'] = { id = 0x70, held = false, click = false },
        ['f2'] = { id = 0x71, held = false, click = false },
        ['f3'] = { id = 0x72, held = false, click = false },
        ['f4'] = { id = 0x73, held = false, click = false },
        ['f5'] = { id = 0x74, held = false, click = false },
        ['f6'] = { id = 0x75, held = false, click = false },
        ['f7'] = { id = 0x76, held = false, click = false },
        ['f8'] = { id = 0x77, held = false, click = false },
        ['f9'] = { id = 0x78, held = false, click = false },
        ['f10'] = { id = 0x79, held = false, click = false },
        ['f11'] = { id = 0x7A, held = false, click = false },
        ['f12'] = { id = 0x7B, held = false, click = false },
        ['numlock'] = { id = 0x90, held = false, click = false },
        ['scrolllock'] = { id = 0x91, held = false, click = false },
        ['lshift'] = { id = 0xA0, held = false, click = false },
        ['rshift'] = { id = 0xA1, held = false, click = false },
        ['lctrl'] = { id = 0xA2, held = false, click = false },
        ['rctrl'] = { id = 0xA3, held = false, click = false },
        ['lalt'] = { id = 0xA4, held = false, click = false },
        ['ralt'] = { id = 0xA5, held = false, click = false },
        ['semicolon'] = { id = 0xBA, held = false, click = false },
        ['plus'] = { id = 0xBB, held = false, click = false },
        ['comma'] = { id = 0xBC, held = false, click = false },
        ['minus'] = { id = 0xBD, held = false, click = false },
        ['period'] = { id = 0xBE, held = false, click = false },
        ['slash'] = { id = 0xBF, held = false, click = false },
        ['tilde'] = { id = 0xC0, held = false, click = false },
        ['lbracket'] = { id = 0xDB, held = false, click = false },
        ['backslash'] = { id = 0xDC, held = false, click = false },
        ['rbracket'] = { id = 0xDD, held = false, click = false },
        ['quote'] = { id = 0xDE, held = false, click = false },
    }

    self._active_tab = nil
    self._open = true
    self._watermark = true
    self._base_opacity = 0
    self._dragging = false
    self._drag_offset = Vector2.new(0, 0)
    self._active_dropdown = nil
    self._active_colorpicker = nil
    self._clipboard_color = nil
    self._tick = os.clock()

    -- user
    self.identity = name
    self._watermark_activity = watermarkActivity
    self.x = 20
    self.y = 60
    self.w = size and size.x or 300
    self.h = size and size.y or 400

    -- theme
    self._color_accent = Color3.fromRGB(255, 127, 0)
    self._color_text = Color3.fromRGB(255, 255, 255)
    self._color_crust = Color3.fromRGB(0, 0, 0)
    self._color_border = Color3.fromRGB(25, 25, 25)
    self._color_surface = Color3.fromRGB(38, 38, 38)
    self._color_overlay = Color3.fromRGB(76, 76, 76)

    -- styling
    self._title_h = 25
    self._tab_h = 20
    self._padding = 6
    self._gradient_detail = 80

    -- menu base
    local base = Drawing.new('Square')
    base.Filled = true
    base.Color = self._color_surface

    local crust = Drawing.new('Square')
    crust.Filled = false
    crust.Thickness = 1
    crust.Color = self._color_crust

    local border = Drawing.new('Square')
    border.Filled = false
    border.Thickness = 1
    border.Color = self._color_border

    local navbar = Drawing.new('Square')
    navbar.Filled = true
    navbar.Color = self._color_border

    local title = Drawing.new('Text')
    title.Text = self.identity
    title.Outline = true
    title.Color = self._color_text

    -- watermark
    local watermarkBase = Drawing.new('Square')
    watermarkBase.Filled = true
    watermarkBase.Color = self._color_surface

    local watermarkCursor = Drawing.new('Square')
    watermarkCursor.Filled = true
    watermarkCursor.Color = self._color_accent

    local watermarkCrust = Drawing.new('Square')
    watermarkCrust.Filled = false
    watermarkCrust.Thickness = 1
    watermarkCrust.Color = self._color_crust

    local watermarkBorder = Drawing.new('Square')
    watermarkBorder.Filled = false
    watermarkBorder.Thickness = 1
    watermarkBorder.Color = self._color_border

    local watermarkText = Drawing.new('Text')
    watermarkText.Text = name
    watermarkText.Outline = true
    watermarkText.Color = self._color_text

    self._tree = {
        ['_tabs'] = {},
        ['_drawings'] = { crust, border, base, navbar, title, watermarkBase, watermarkCursor, watermarkCrust, watermarkBorder, watermarkText }
    }

    return self
end

function UILib._GetTextBounds(str)
    return #str * ESP_FONTSIZE, ESP_FONTSIZE
end

function UILib._IsMouseWithinBounds(origin, size)
    local mousePos = getMousePos()
    return mousePos.x >= origin.x and mousePos.x <= origin.x + size.x and mousePos.y >= origin.y and mousePos.y <= origin.y + size.y
end

function UILib:_RemoveDropdown()
    if self._active_dropdown then
        local dropdownDraws = self._active_dropdown['_drawings']

        destroyAllDrawings(dropdownDraws)
        self._active_dropdown = nil
    end
end

function UILib:_RemoveColorpicker()
    if self._active_colorpicker then
        local colorpickerDraws = self._active_colorpicker['_drawings']

        destroyAllDrawings(colorpickerDraws)
        self._active_colorpicker = nil
    end
end

function UILib:_SpawnDropdown(default, choices, multi, callback, position, width)
    if self._active_dropdown then
        self:_RemoveDropdown()
    end

    local base = Drawing.new('Square')
    base.Filled = true
    base.Color = self._color_surface

    local crust = Drawing.new('Square')
    crust.Filled = false
    crust.Thickness = 1
    crust.Color = self._color_crust

    local border = Drawing.new('Square')
    border.Filled = false
    border.Thickness = 1
    border.Color = self._color_border

    local drawings = { base, crust, border }
    for _, entryValue in ipairs(choices) do
        local entry = Drawing.new('Text')
        entry.Outline = true
        entry.Color = self._color_text
        entry.Text = entryValue

        table.insert(drawings, entry)
    end

    -- convert to dictionary
    local choiceHash = {}
    for _, choice in ipairs(choices) do
        choiceHash[choice] = false
    end

    for _, default_ in ipairs(default) do
        choiceHash[default_] = true
    end

    self._active_dropdown = {
        ['choices'] = choiceHash,
        ['multi'] = multi,
        ['callback'] = callback,
        ['position'] = position,
        ['w'] = width,
        ['_drawings'] = drawings
    }
end

function UILib:_SpawnColorpicker(default, colorLabel, callback)
    if self._active_colorpicker then
        self:_RemoveColorpicker()
    end

    -- base
    local base = Drawing.new('Square')
    base.Filled = true
    base.Color = self._color_surface

    local crust = Drawing.new('Square')
    crust.Filled = false
    crust.Thickness = 1
    crust.Color = self._color_crust

    local border = Drawing.new('Square')
    border.Filled = false
    border.Thickness = 1
    border.Color = self._color_border

    local titleBar = Drawing.new('Square')
    titleBar.Filled = true
    titleBar.Color = self._color_border

    local label = Drawing.new('Text')
    label.Outline = true
    label.Color = self._color_text
    label.Text = colorLabel

    local preview = Drawing.new('Square')
    preview.Filled = true
    preview.Color = self._color_surface

    local drawings = { base, crust, border, titleBar, label, preview }

    -- gradients
    for _ = 1, self._gradient_detail * 3 do
        local segment = Drawing.new('Square')
        segment.Filled = true

        table.insert(drawings, segment)
    end

    -- cursors
    local cursorCrustPrimary = Drawing.new('Circle')
    cursorCrustPrimary.Filled = false
    cursorCrustPrimary.Thickness = 3
    cursorCrustPrimary.Radius = 6
    cursorCrustPrimary.NumSides = 20
    cursorCrustPrimary.Color = self._color_crust

    local cursorBasePrimary = Drawing.new('Circle')
    cursorBasePrimary.Filled = false
    cursorBasePrimary.Thickness = 1
    cursorBasePrimary.Radius = 6
    cursorBasePrimary.NumSides = 20
    cursorBasePrimary.Color = self._color_border

    local cursorBaseSecondary = Drawing.new('Square')
    cursorBaseSecondary.Filled = true
    cursorBaseSecondary.Color = self._color_border

    local cursorBorderSecondary = Drawing.new('Square')
    cursorBorderSecondary.Filled = false
    cursorBorderSecondary.Thickness = 1
    cursorBorderSecondary.Color = self._color_surface

    local cursorCrustSecondary = Drawing.new('Square')
    cursorCrustSecondary.Filled = false
    cursorCrustSecondary.Thickness = 1
    cursorCrustSecondary.Color = self._color_crust

    for _, cursor in ipairs{cursorBasePrimary, cursorCrustPrimary, cursorBaseSecondary, cursorCrustSecondary, cursorBorderSecondary} do
        table.insert(drawings, cursor)
    end

    self._active_colorpicker = {
        ['callback'] = callback,
        ['_pallete_pos'] = nil,
        ['_slider_y'] = 0,
        ['_drawings'] = drawings
    }
end

function UILib:ToggleWatermark(state)
    self._watermark = state
end

function UILib:ToggleMenu(state)
    self._open = state
end

function UILib:IsMenuOpen()
    return self._open
end

function UILib:Tab(name)
    local backdrop = Drawing.new('Square')
    backdrop.Color = self._color_border
    backdrop.Filled = true

    local shadow = Drawing.new('Square')
    shadow.Color = BLACK
    shadow.Filled = true

    local cursor = Drawing.new('Square')
    cursor.Color = self._color_accent
    cursor.Filled = true

    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = name

    table.insert(self._tree['_tabs'], {
        ['name'] = name,
        ['_sections'] = {},
        ['_drawings'] = { backdrop, shadow, cursor, text }
    })

    if self._active_tab == nil then
        self._active_tab = name
    end

    return name
end

function UILib:Section(tabName, name, rightside)
    for _, tab in ipairs(self._tree['_tabs']) do
        if tab['name'] == tabName then
            local base = Drawing.new('Square')
            base.Filled = true
            base.Color = self._color_surface

            local crust = Drawing.new('Square')
            crust.Filled = false
            crust.Thickness = 1
            crust.Color = self._color_crust

            local border = Drawing.new('Square')
            border.Filled = false
            border.Thickness = 1
            border.Color = self._color_overlay

            local title = Drawing.new('Text')
            title.Text = name
            title.Outline = true
            title.Color = self._color_text

            local section = {
                ['name'] = name,
                ['_items'] = {},
                ['_drawings'] = { base, crust, border, title },
                ['rightside'] = rightside
            }

            table.insert(tab._sections, section)
            return name
        end
    end
end

function UILib:_AddToSection(tabName, sectionName, itemType, value, callback, drawings, meta, name)
    for _, tab in pairs(self._tree._tabs) do
        if tab.name == tabName then
            for _, section in pairs(tab._sections) do
                if section.name == sectionName then
                    local item = {
                        ['name'] = name,
                        ['type'] = itemType,
                        ['value'] = value,
                        ['callback'] = callback,
                        ['_drawings'] = drawings
                    }

                    if meta then
                        for key, val in pairs(meta) do
                            item[key] = val
                        end
                    end

                    table.insert(section._items, item)
                    return
                end
            end
        end
    end
end

function UILib:Checkbox(tabName, sectionName, label, defaultValue, callback)
    local outline = Drawing.new('Square')
    outline.Color = self._color_crust
    outline.Thickness = 1
    outline.Filled = false

    local check = Drawing.new('Square')
    check.Color = self._color_accent
    check.Filled = true

    local checkShadow = Drawing.new('Square')
    checkShadow.Color = BLACK
    checkShadow.Filled = true

    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = label

    self:_AddToSection(tabName, sectionName, 'checkbox', defaultValue, callback, {
        outline,
        check,
        checkShadow,
        text
    })
end

function UILib:Label(tabName, sectionName, label, defaultValue, callback)
    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = label

    self:_AddToSection(tabName, sectionName, 'label', defaultValue, callback, {
        text
    }, {
        ['label'] = label
    }, label)
end

function UILib:Slider(tabName, sectionName, label, defaultValue, callback, min, max, step, appendix)
    local outline = Drawing.new('Square')
    outline.Color = self._color_crust
    outline.Filled = true

    local fill = Drawing.new('Square')
    fill.Color = self._color_accent
    fill.Filled = true

    local fillShadow = Drawing.new('Square')
    fillShadow.Color = BLACK
    fillShadow.Filled = true

    local value = Drawing.new('Text')
    value.Color = self._color_text
    value.Outline = true
    value.Text = label

    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = label

    self:_AddToSection(tabName, sectionName, 'slider', defaultValue, callback, {
        outline,
        fill,
        fillShadow,
        value,
        text
    }, {
        ['min'] = min,
        ['max'] = max,
        ['step'] = step,
        ['appendix'] = appendix
    })
end

function UILib:Choice(tabName, sectionName, label, defaultValue, callback, choices, multi)
    local outline = Drawing.new('Square')
    outline.Color = self._color_crust
    outline.Thickness = 1
    outline.Filled = false

    local fill = Drawing.new('Square')
    fill.Color = self._color_crust
    fill.Filled = true

    local values = Drawing.new('Text')
    values.Color = self._color_text
    values.Outline = true
    values.Text = label

    local expand = Drawing.new('Text')
    expand.Color = self._color_text
    expand.Outline = true
    expand.Text = label

    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = label

    self:_AddToSection(tabName, sectionName, 'choice', defaultValue, callback, {
        outline,
        fill,
        values,
        expand,
        text
    }, {
        ['choices'] = choices,
        ['multi'] = multi
    })
end

function UILib:Colorpicker(tabName, sectionName, label, defaultValue, callback)
    local outline = Drawing.new('Square')
    outline.Color = self._color_crust
    outline.Thickness = 1
    outline.Filled = false

    local fill = Drawing.new('Square')
    fill.Color = self._color_crust
    fill.Filled = true

    local shadow = Drawing.new('Square')
    shadow.Color = BLACK
    shadow.Filled = true

    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = label

    self:_AddToSection(tabName, sectionName, 'colorpicker', defaultValue, callback, {
        outline,
        fill,
        shadow,
        text
    }, {
        ['label'] = label
    })
end

function UILib:Button(tabName, sectionName, label, callback)
    local outline = Drawing.new('Square')
    outline.Color = self._color_crust
    outline.Thickness = 1
    outline.Filled = false

    local fill = Drawing.new('Square')
    fill.Color = self._color_crust
    fill.Filled = true

    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = label

    self:_AddToSection(tabName, sectionName, 'button', defaultValue, callback, {
        outline,
        fill,
        text
    }, {
        ['label'] = label
    })
end

function UILib:Keybind(tabName, sectionName, label, defaultValue, callback, mode)
    local text = Drawing.new('Text')
    text.Color = self._color_text
    text.Outline = true
    text.Text = label

    local outline = Drawing.new('Square')
    outline.Color = self._color_crust
    outline.Thickness = 1
    outline.Filled = false

    local fill = Drawing.new('Square')
    fill.Color = self._color_crust
    fill.Filled = true

    local key = Drawing.new('Text')
    key.Color = self._color_text
    key.Outline = true

    self:_AddToSection(tabName, sectionName, 'key', defaultValue, callback, {
        text,
        outline,
        fill,
        key
    }, {
        ['mode'] = mode or 'Hold',
        ['_listening'] = false,
        ['_state'] = nil
    })
end

function UILib:CreateSettingsTab(customName)
    local menuTab = self:Tab(customName or 'Menu')
    local menuSettings = self:Section(menuTab, 'Settings')
    self:Keybind(menuTab, menuSettings, 'Open key', 'f1', function (state)
        self:ToggleMenu(state)
    end, 'Toggle')
    self:Checkbox(menuTab, menuSettings, 'Watermark', true, function (state)
        self:ToggleWatermark(state)
    end)
    self:Label(menuTab, menuSettings, 'script by portal', nil, function() end)
    self:Label(menuTab, menuSettings, '(i made tiny ui mod)', nil, function() end)
    self:Label(menuTab, menuSettings, 'ui by nulare', nil, function() end)

    local menuTheme = self:Section(menuTab, 'Theming')
    local presetThemes = {'X11', 'Nord', 'Dracula', 'Catppuccin'}
    self:Choice(menuTab, menuTheme, 'Preset theme', {presetThemes[1]}, function (values)
        local themingItems = self._tree._tabs[#self._tree._tabs]._sections[2]
        local colorAccent = themingItems._items[2]
        local colorBase = themingItems._items[3]
        local colorInnerStroke = themingItems._items[4]
        local colorOuterStroke = themingItems._items[5]
        local colorCrust = themingItems._items[6]

        local theme = values[1]
        if theme == presetThemes[1] then
            colorAccent.value = {255, 128, 0}
            colorBase.value = {38, 38, 38}
            colorInnerStroke.value = {26, 26, 26}
            colorOuterStroke.value = {77, 77, 77}
            colorCrust.value = {0, 0, 0}
        elseif theme == presetThemes[2] then
            colorAccent.value = {135, 206, 235}
            colorBase.value = {49, 54, 60}
            colorInnerStroke.value = {72, 80, 90}
            colorOuterStroke.value = {61, 66, 73}
            colorCrust.value = {88, 96, 106}
        elseif theme == presetThemes[3] then
            colorAccent.value = {243, 67, 54}
            colorBase.value = {40, 44, 59}
            colorInnerStroke.value = {64, 71, 89}
            colorOuterStroke.value = {29, 31, 45}
            colorCrust.value = {72, 73, 95}
        elseif theme == presetThemes[4] then
            colorAccent.value = {240, 160, 200}
            colorBase.value = {48, 47, 63}
            colorInnerStroke.value = {72, 71, 89}
            colorOuterStroke.value = {63, 62, 80}
            colorCrust.value = {33, 32, 44}
        end

        colorAccent.callback(Color3.fromRGB(unpack(colorAccent.value)))
        colorBase.callback(Color3.fromRGB(unpack(colorBase.value)))
        colorInnerStroke.callback(Color3.fromRGB(unpack(colorInnerStroke.value)))
        colorOuterStroke.callback(Color3.fromRGB(unpack(colorOuterStroke.value)))
        colorCrust.callback(Color3.fromRGB(unpack(colorCrust.value)))
    end, presetThemes, false)
    self:Colorpicker(menuTab, menuTheme, 'Accent', {255, 128, 0}, function (newColor)
        self._color_accent = newColor
    end)
    self:Colorpicker(menuTab, menuTheme, 'Base', {38, 38, 38}, function (newColor)
        self._color_surface = newColor
    end)
    self:Colorpicker(menuTab, menuTheme, 'Inner stroke', {25, 25, 25}, function (newColor)
        self._color_border = newColor
    end)
    self:Colorpicker(menuTab, menuTheme, 'Outer stroke', {76, 76, 76}, function (newColor)
        self._color_overlay = newColor
    end)
    self:Colorpicker(menuTab, menuTheme, 'Crust', {0, 0, 0}, function (newColor)
        self._color_crust = newColor
    end)

    return menuTab, menuSettings, menuTheme
end

function UILib:Step()
    -- our input stuff
    local deltaTime = math.max(os.clock() - self._tick, 0.0035)
    local mousePos = getMousePos()

    for keycode, inputData in pairs(self._inputs) do
        local keycodeId = inputData['id']
        local interacted = iskeypressed(keycodeId)
        if isrbxactive() and interacted then
            if inputData['held'] == false and inputData['click'] == false then
                self._inputs[keycode]['click'] = true
            else
                self._inputs[keycode]['click'] = false
            end

            self._inputs[keycode]['held'] = true
        else
            self._inputs[keycode]['held'] = false
        end
    end
    local menuOpen = self._open
    local clickFrame = menuOpen and self._inputs['m1'].click
    local ctxFrame = menuOpen and self._inputs['m2'].click
    local m1Held = menuOpen and self._inputs['m1'].held

    local baseOpacity = self._base_opacity
    local childrenVisible = baseOpacity > 0.22
    self._base_opacity = clamp(lerp(baseOpacity, menuOpen == true and 1 or 0, deltaTime * 11), 0, 1)

    setrobloxinput(not menuOpen)

    -- draw watermark
    local watermarkBase = self._tree['_drawings'][6]
    local watermarkCursor = self._tree['_drawings'][7]
    local watermarkCrust = self._tree['_drawings'][8]
    local watermarkBorder = self._tree['_drawings'][9]
    local watermarkTitle = self._tree['_drawings'][10]

    if self._watermark then
        local watermarkStates = {self.identity}
        local watermarkActivity = self._watermark_activity
        if watermarkActivity then
            for _, activity in ipairs(watermarkActivity) do
                if type(activity) == 'function' then
                    local activityString = activity()
                    if activityString ~= nil and #activityString > 0 then
                        table.insert(watermarkStates, activityString)
                    end
                end
            end
        end

        local watermarkText = table.concat(watermarkStates, ' | ')
        local watermarkW, watermarkH = self._GetTextBounds(watermarkText)
        local watermarkPosition = Vector2.new(20, 20)
        local watermarkSize = Vector2.new(watermarkW + self._padding * 3, watermarkH + self._padding * 3)

        watermarkBase.Position = watermarkPosition
        watermarkBase.Size = watermarkSize
        watermarkBase.Visible = true
        watermarkBase.Color = self._color_surface

        watermarkCrust.Position = watermarkPosition
        watermarkCrust.Size = watermarkSize
        watermarkCrust.Visible = true
        watermarkCrust.Color = self._color_crust

        watermarkBorder.Position = watermarkPosition + Vector2.new(1, 1)
        watermarkBorder.Size = watermarkSize + Vector2.new(-2, -2)
        watermarkBorder.Visible = true
        watermarkBorder.Color = self._color_border

        watermarkCursor.Position = watermarkPosition + Vector2.new(2, 2)
        watermarkCursor.Size = Vector2.new(watermarkSize.x - 4, 1)
        watermarkCursor.Visible = true
        watermarkCursor.Color = self._color_accent

        watermarkTitle.Position = watermarkPosition + Vector2.new(2 + self._padding, 2 + self._padding)
        watermarkTitle.Text = watermarkText
        watermarkTitle.Visible = true
        watermarkTitle.Color = self._color_text
    else
        watermarkBase.Visible = false
        watermarkCrust.Visible = false
        watermarkBorder.Visible = false
        watermarkCursor.Visible = false
        watermarkTitle.Visible = false
    end

    -- draw colorpicker
    if self._active_colorpicker then
        local colorpickerDraws = self._active_colorpicker['_drawings']
        local colorpickerBase = colorpickerDraws[1]
        local colorpickerCrust = colorpickerDraws[2]
        local colorpickerBorder = colorpickerDraws[3]
        local colorpickerTitleBar = colorpickerDraws[4]
        local colorpickerLabel = colorpickerDraws[5]
        local colorpickerPreview = colorpickerDraws[6]

        colorpickerPreview.Visible = false

        local colorpickerPosition = Vector2.new(self.x + self.w + self._padding * 2, self.y)
        local colorpickerSize = Vector2.new(200, 170 + self._title_h)

        colorpickerBase.Position = colorpickerPosition
        colorpickerBase.Size = colorpickerSize
        colorpickerBase.Transparency = baseOpacity
        colorpickerBase.Visible = childrenVisible
        colorpickerBase.Color = self._color_surface

        colorpickerCrust.Position = colorpickerPosition
        colorpickerCrust.Size = colorpickerSize
        colorpickerCrust.Transparency = baseOpacity
        colorpickerCrust.Visible = childrenVisible
        colorpickerCrust.Color = self._color_crust

        colorpickerBorder.Position = colorpickerPosition + Vector2.new(1, 1)
        colorpickerBorder.Size = colorpickerSize - Vector2.new(2, 2)
        colorpickerBorder.Transparency = baseOpacity
        colorpickerBorder.Visible = childrenVisible
        colorpickerBorder.Color = self._color_border

        colorpickerTitleBar.Position = colorpickerPosition + Vector2.new(1, 1)
        colorpickerTitleBar.Size = Vector2.new(colorpickerSize.x - 2, self._title_h - 3)
        colorpickerTitleBar.Transparency = baseOpacity
        colorpickerTitleBar.Visible = childrenVisible
        colorpickerTitleBar.Color = self._color_border

        colorpickerLabel.Position = colorpickerPosition + Vector2.new(self._padding, self._padding)
        colorpickerLabel.Transparency = baseOpacity
        colorpickerLabel.Visible = childrenVisible
        colorpickerLabel.Color = self._color_text

        local palletePosition = colorpickerPosition + Vector2.new(self._padding, self._title_h + self._padding)
        local palleteSize = colorpickerSize.y - self._title_h - self._padding * 2

        for i = 1, self._gradient_detail do
            local segment = colorpickerDraws[6 + i]
            local step = 1 - (i - 1) / (self._gradient_detail - 1)
            segment.Size = Vector2.new(palleteSize * step, palleteSize)
            segment.Position = palletePosition
            local h = clamp((self._active_colorpicker['_slider_y']) / palleteSize, 0, 1)
            segment.Color = Color3.fromHSV(h, step, 1)
            segment.Transparency = baseOpacity
            segment.Visible = childrenVisible
        end

        for i = 1, self._gradient_detail do
            local segment = colorpickerDraws[6 + self._gradient_detail + i]
            local step = 1 - i / self._gradient_detail
            segment.Size = Vector2.new(palleteSize, palleteSize * step)
            segment.Position = palletePosition + Vector2.new(0, palleteSize * (1 - step))
            segment.Color = BLACK
            segment.Transparency = baseOpacity * 1 / (self._gradient_detail / 3)
            segment.Visible = childrenVisible
        end

        local hueSliderWidth = colorpickerSize.x - palleteSize - self._padding * 4
        local hueSliderPos = palletePosition + Vector2.new(colorpickerSize.x - hueSliderWidth - self._padding * 2.5, 0)
        for i = 1, self._gradient_detail do
            local segment = colorpickerDraws[6 + self._gradient_detail * 2 + i]
            local step = 1 - (i - 1) / self._gradient_detail
            segment.Size = Vector2.new(hueSliderWidth, palleteSize * step)
            segment.Position = hueSliderPos
            segment.Color = Color3.fromHSV(step, 1, 1)
            segment.Transparency = baseOpacity
            segment.Visible = childrenVisible
        end

        local drawsOffset = 6 + self._gradient_detail * 3
        local colorpickerCursorBasePrimary = colorpickerDraws[drawsOffset + 1]
        local colorpickerCursorCrustPrimary = colorpickerDraws[drawsOffset + 2]
        local colorpickerCursorBaseSecondary = colorpickerDraws[drawsOffset + 3]
        local colorpickerCursorCrustSecondary = colorpickerDraws[drawsOffset + 4]
        local colorpickerCursorBorderSecondary = colorpickerDraws[drawsOffset + 5]

        if m1Held then
            if self._IsMouseWithinBounds(palletePosition, Vector2.new(palleteSize, palleteSize)) then
                self._active_colorpicker['_pallete_pos'] = mousePos
            elseif self._IsMouseWithinBounds(hueSliderPos, Vector2.new(hueSliderWidth, palleteSize)) then
                self._active_colorpicker['_slider_y'] = mousePos.y - palletePosition.y
            end
        end

        local palletePos = self._active_colorpicker['_pallete_pos'] or palletePosition
        local sliderPos = hueSliderPos + Vector2.new(-2, self._active_colorpicker['_slider_y'])

        local relPalletePos = Vector2.new(
            clamp((palletePos.x - palletePosition.x) / palleteSize, 0, 1),
            clamp((palletePos.y - palletePosition.y) / palleteSize, 0, 1)
        )
        local relSliderPos = clamp((self._active_colorpicker['_slider_y']) / palleteSize, 0, 1)

        local h = relSliderPos
        local s = relPalletePos.x
        local v = 1 - relPalletePos.y
        local newColor = color3fromHSV(h, s, v)

        if m1Held then
            if self._active_colorpicker['callback'] then
                self._active_colorpicker['callback'](newColor)
            end
        end

        colorpickerCursorBasePrimary.Position = palletePos
        colorpickerCursorBasePrimary.Color = self._color_text
        colorpickerCursorBasePrimary.Visible = childrenVisible

        colorpickerCursorCrustPrimary.Position = palletePos
        colorpickerCursorCrustPrimary.Color = self._color_crust
        colorpickerCursorCrustPrimary.Visible = childrenVisible

        local sliderCursorSize = Vector2.new(hueSliderWidth + 4, 4)
        colorpickerCursorBaseSecondary.Size = sliderCursorSize
        colorpickerCursorBaseSecondary.Position = sliderPos
        colorpickerCursorBaseSecondary.Color = self._color_surface
        colorpickerCursorBaseSecondary.Visible = childrenVisible

        colorpickerCursorCrustSecondary.Size = sliderCursorSize
        colorpickerCursorCrustSecondary.Position = sliderPos
        colorpickerCursorCrustSecondary.Color = self._color_crust
        colorpickerCursorCrustSecondary.Visible = childrenVisible

        colorpickerCursorBorderSecondary.Size = sliderCursorSize + Vector2.new(-2, -2)
        colorpickerCursorBorderSecondary.Position = sliderPos + Vector2.new(1, 1)
        colorpickerCursorBorderSecondary.Color = self._color_border
        colorpickerCursorBorderSecondary.Visible = childrenVisible

        if clickFrame and not self._IsMouseWithinBounds(colorpickerPosition, colorpickerSize) then
            self:_RemoveColorpicker()
        end

        clickFrame = false
    end

    -- draw dropdown
    if self._active_dropdown then
        local dropdownChoices = self._active_dropdown['choices']
        local dropdownIsMulti = self._active_dropdown['multi']
        local dropdownCallback = self._active_dropdown['callback']
        local dropdownPosition = self._active_dropdown['position']
        local dropdownWidth = self._active_dropdown['w']
        local dropdownDraws = self._active_dropdown['_drawings']

        local dropdownBase = dropdownDraws[1]
        local dropdownCrust = dropdownDraws[2]
        local dropdownBorder = dropdownDraws[3]

        local totalDropdownY = self._padding
        local dropdownCancel = clickFrame
        local i = 1
        for choice, choiceValue in pairs(dropdownChoices) do
            local _choiceW, choiceH = self._GetTextBounds(choice)
            local choiceDraw = dropdownDraws[3 + i]

            local choicePos = dropdownPosition + Vector2.new(self._padding, totalDropdownY)
            local choiceSize = Vector2.new(dropdownWidth, choiceH + self._padding)

            choiceDraw.Position = choicePos
            choiceDraw.Color = choiceValue and self._color_accent or self._color_text
            choiceDraw.Text = choice
            choiceDraw.Visible = childrenVisible

            if clickFrame and self._IsMouseWithinBounds(choicePos, choiceSize) then
                dropdownCancel = not dropdownIsMulti
                
                if not dropdownIsMulti then
                    for choiceName, _ in pairs(dropdownChoices) do
                        dropdownChoices[choiceName] = false
                    end
                end

                dropdownChoices[choice] = not choiceValue
                if dropdownCallback then
                    local returnedValue = {}
                    for choiceName, choiceValue in pairs(dropdownChoices) do
                        if choiceValue == true then
                            table.insert(returnedValue, choiceName)
                        end
                    end

                    dropdownCallback(returnedValue)
                end
            end

            totalDropdownY = totalDropdownY + choiceH * 2 + self._padding
            i = i + 1
        end

        if dropdownCancel then
            self:_RemoveDropdown()
        else
            dropdownBase.Position = dropdownPosition
            dropdownBase.Size = Vector2.new(dropdownWidth, totalDropdownY)
            dropdownBase.Transparency = baseOpacity
            dropdownBase.Visible = childrenVisible
            dropdownBase.Color = self._color_surface

            dropdownCrust.Position = dropdownPosition
            dropdownCrust.Size = Vector2.new(dropdownWidth, totalDropdownY)
            dropdownCrust.Transparency = baseOpacity
            dropdownCrust.Visible = childrenVisible
            dropdownCrust.Color = self._color_crust

            dropdownBorder.Position = dropdownPosition + Vector2.new(1, 1)
            dropdownBorder.Size = Vector2.new(dropdownWidth - 2, totalDropdownY - 2)
            dropdownBorder.Transparency = baseOpacity
            dropdownBorder.Visible = childrenVisible
            dropdownBorder.Color = self._color_border
        end

        clickFrame = false
    end

    -- draw menu base
    local uiCrust = self._tree['_drawings'][1]
    local uiBorder = self._tree['_drawings'][2]
    local uiBase = self._tree['_drawings'][3]
    local uiNavbar = self._tree['_drawings'][4]
    local uiTitle = self._tree['_drawings'][5]

    uiBase.Position = Vector2.new(self.x, self.y)
    uiBase.Size = Vector2.new(self.w, self.h)
    uiBase.Transparency = baseOpacity
    uiBase.Visible = childrenVisible
    uiBase.Color = self._color_surface

    uiBorder.Position = Vector2.new(self.x + 1, self.y + 1)
    uiBorder.Size = Vector2.new(self.w - 2, self.h - 2)
    uiBorder.Transparency = baseOpacity
    uiBorder.Visible = childrenVisible
    uiBorder.Color = self._color_border

    uiCrust.Position = Vector2.new(self.x, self.y)
    uiCrust.Size = Vector2.new(self.w, self.h)
    uiCrust.Transparency = baseOpacity
    uiCrust.Visible = childrenVisible
    uiCrust.Color = self._color_crust

    uiNavbar.Position = Vector2.new(self.x + 2, self.y + 2)
    uiNavbar.Size = Vector2.new(self.w - 4, self._title_h - 4)
    uiNavbar.Transparency = baseOpacity
    uiNavbar.Visible = childrenVisible
    uiNavbar.Color = self._color_border

    local _titleW, titleH = self._GetTextBounds('')
    uiTitle.Position = Vector2.new(self.x + 7, self.y + self._title_h / 2 - titleH + 2)
    uiTitle.Transparency = baseOpacity
    uiTitle.Visible = childrenVisible
    uiTitle.Color = self._color_text

    -- input handling for menu dragging
    local titleOrigin = Vector2.new(self.x, self.y)
    local titleSize = Vector2.new(self.w, self._title_h)

    if self._IsMouseWithinBounds(titleOrigin, titleSize) then
        if clickFrame then
            self._dragging = true
            self._drag_offset = mousePos - titleOrigin
        end
    end

    if self._dragging then
        if m1Held then
            self.x = mousePos.x - self._drag_offset.x
            self.y = mousePos.y - self._drag_offset.y
        else
            self._dragging = false
        end

        clickFrame = false
    end

    -- draw tabs
    local numTabs = #self._tree['_tabs']
    for tabIndex, tab in ipairs(self._tree['_tabs']) do
        local tabName = tab['name']
        local tabDraws = tab['_drawings']
        local tabOpen = self._active_tab == tabName

        local tabBackdrop = tabDraws[1]
        local tabShadow = tabDraws[2]
        local tabCursor = tabDraws[3]
        local tabText = tabDraws[4]

        local tabW = (self.w - self._padding * 2 - (numTabs - 1) * 2) / numTabs
        local tabH = self._tab_h

        local tabPosition = Vector2.new(self.x + self._padding + (tabIndex - 1) * (tabW + 2), self.y + self._title_h + self._padding)
        local tabSize = Vector2.new(tabW, tabH)

        tabBackdrop.Position = tabPosition
        tabBackdrop.Size = tabSize
        tabBackdrop.Transparency = baseOpacity
        tabBackdrop.Visible = childrenVisible
        tabBackdrop.Color = self._color_border

        tabShadow.Position = tabPosition + Vector2.new(0, tabH - 8)
        tabShadow.Size = Vector2.new(tabW, 8)
        tabShadow.Transparency = 0.05 * baseOpacity
        tabShadow.Visible = childrenVisible

        tabCursor.Position = tabPosition
        tabCursor.Size = Vector2.new(tabW, 1)
        tabCursor.Transparency = baseOpacity
        tabCursor.Visible = tabOpen and childrenVisible
        tabCursor.Color = self._color_accent

        tabText.Position = tabPosition + Vector2.new(4, tabH / 2 - ESP_FONTSIZE / 2)
        tabText.Transparency = baseOpacity
        tabText.Visible = childrenVisible
        tabText.Color = self._color_text

        -- input handling for tabs
        if clickFrame and self._IsMouseWithinBounds(tabPosition, tabSize) then
            self._active_tab = tabName
        end

        -- draw sections
        local totalSectionH_0 = self._padding
        local totalSectionH_1 = self._padding
        for sectionIndex, section in ipairs(tab['_sections']) do
            local sectionDraws = section['_drawings']
            local sectionItems = section['_items']
            local isRight = section['rightside']

            -- keybind processing
            for _, keybind in ipairs(sectionItems) do
                local itemType = keybind['type']
                local itemValue = keybind['value']
                local itemCallback = keybind['callback']

                if itemType == 'key' then
                    if itemValue and itemValue ~= 'unbound' and itemCallback then
                        local keyMode = keybind['mode']
                        local keyState = keybind['state']
                        if keyMode == 'Hold' then
                            keyState = self._inputs[itemValue]['held']
                        elseif keyMode == 'Toggle' and self._inputs[itemValue]['click'] then
                            keyState = not keyState
                        elseif keyMode == 'Always' then
                            keyState = true
                        end

                        if keyState ~= keybind['state'] then
                            itemCallback(keyState)

                            keybind['state'] = keyState
                        end
                    end
                end
            end

            if tabOpen then
                local sectionY = self._padding * 2
                local opposite = isRight and 1 % 2 or (sectionIndex+1) % 2

                local sectionW = self.w / 2 - self._padding * 1.5
                local sectionPos = Vector2.new(
                    self.x + self._padding + self._padding * opposite + sectionW * opposite,
                    self.y + self._title_h + self._tab_h + self._padding * 2 + (opposite==1 and totalSectionH_0 or totalSectionH_1)
                )

                -- draw items
                for _, sectionItem in ipairs(sectionItems) do
                    local itemType = sectionItem['type']
                    local itemDraws = sectionItem['_drawings']
                    local itemValue = sectionItem['value']
                    local itemCallback = sectionItem['callback']

                    local itemPosition = sectionPos + Vector2.new(10, sectionY)

                    if itemType == 'checkbox' then
                        local checkboxOutline = itemDraws[1]
                        local checkboxCheck = itemDraws[2]
                        local checkboxShadow = itemDraws[3]
                        local checkboxLabel = itemDraws[4]

                        local boxSize = Vector2.new(14, 14)
                        checkboxOutline.Position = itemPosition
                        checkboxOutline.Size = boxSize
                        checkboxOutline.Transparency = baseOpacity
                        checkboxOutline.Visible = childrenVisible

                        checkboxCheck.Position = itemPosition + Vector2.new(1, 1)
                        checkboxCheck.Size = boxSize - Vector2.new(2, 2)
                        checkboxCheck.Transparency = baseOpacity
                        checkboxCheck.Visible = itemValue == true and childrenVisible
                        checkboxCheck.Color = self._color_accent

                        checkboxShadow.Position = itemPosition + Vector2.new(1, boxSize.y - 2)
                        checkboxShadow.Size = Vector2.new(boxSize.x - 2, 1)
                        checkboxShadow.Transparency = 0.3 * baseOpacity
                        checkboxShadow.Visible = itemValue == true and childrenVisible
                        checkboxShadow.Color = self._color_border

                        checkboxLabel.Position = itemPosition + Vector2.new(boxSize.x + 8, 0)
                        checkboxLabel.Transparency = baseOpacity
                        checkboxLabel.Visible = childrenVisible
                        checkboxLabel.Color = self._color_text

                        -- handle input
                        if self._IsMouseWithinBounds(itemPosition, boxSize) then
                            checkboxOutline.Color = self._color_accent

                            if clickFrame then
                                sectionItem['value'] = not sectionItem['value']

                                if itemCallback then
                                    itemCallback(sectionItem['value'])
                                end
                            end
                        else
                            checkboxOutline.Color = self._color_crust
                        end

                        sectionY = sectionY + boxSize.y + 8
                    elseif itemType == 'label' then
                        local labelLabel = itemDraws[1]
                        local boxSize = Vector2.new(14, 14)
                        local labelW, labelH = self._GetTextBounds(sectionItem['name'])

                        labelLabel.Position = itemPosition + Vector2.new(0, 0)
                        labelLabel.Transparency = baseOpacity
                        labelLabel.Visible = childrenVisible
                        labelLabel.Color = self._color_text

                        sectionY = sectionY + boxSize.y + labelH
                    elseif itemType == 'slider' then
                        local sliderOutline = itemDraws[1]
                        local sliderFill = itemDraws[2]
                        local sliderFillShadow = itemDraws[3]
                        local sliderValue = itemDraws[4]
                        local sliderLabel = itemDraws[5]

                        local min = sectionItem['min']
                        local max = sectionItem['max']
                        local step = sectionItem['step']
                        local appendix = sectionItem['appendix']

                        local sliderW = sectionW - self._padding * 3
                        local sliderH = 20
                        local sliderBoxSize = Vector2.new(sliderW, sliderH)

                        local _labelW, labelH = self._GetTextBounds('')
                        sliderLabel.Position = itemPosition
                        sliderLabel.Transparency = baseOpacity
                        sliderLabel.Visible = childrenVisible
                        sliderLabel.Color = self._color_text

                        sliderOutline.Position = itemPosition + Vector2.new(0, labelH + 10)
                        sliderOutline.Size = sliderBoxSize
                        sliderOutline.Transparency = baseOpacity
                        sliderOutline.Visible = childrenVisible
                        sliderOutline.Color = self._color_crust

                        local fillVisible = itemValue ~= min and childrenVisible
                        local fillPercent = (itemValue - (sectionItem.min or 0)) / ((sectionItem.max or 1) - (sectionItem.min or 0))
                        fillPercent = clamp(fillPercent, 0, 1)
                        sliderFill.Position = itemPosition + Vector2.new(1, labelH + 11)
                        sliderFill.Size = Vector2.new(math.max(sliderW * fillPercent - 2, 0), sliderH - 2)
                        sliderFill.Transparency = baseOpacity
                        sliderFill.Visible = fillVisible
                        sliderFill.Color = self._color_accent
                        
                        sliderFillShadow.Position = itemPosition + Vector2.new(1, labelH + sliderH + 7)
                        sliderFillShadow.Size = Vector2.new(math.max(sliderW * fillPercent - 2, 0), 2)
                        sliderFillShadow.Transparency = 0.15 * baseOpacity
                        sliderFillShadow.Visible = fillVisible

                        local displayedValue = tostring(itemValue) .. (appendix or '')
                        local sliderValueW, sliderValueH = self._GetTextBounds(displayedValue)
                        sliderValue.Position = itemPosition + Vector2.new(sliderW - sliderValueW - 6, sliderValueH / 2 + sliderH - 2)
                        sliderValue.Text = displayedValue
                        sliderValue.Transparency = baseOpacity
                        sliderValue.Visible = childrenVisible

                        -- handle input
                        if self._IsMouseWithinBounds(itemPosition + Vector2.new(0, labelH + 10), sliderBoxSize) then
                            sliderValue.Color = self._color_accent

                            if m1Held then
                                local mouseX = mousePos.x - itemPosition.x
                                local percent = mouseX / sliderW
                                percent = clamp(percent, 0, 1)

                                local newValue = min + (max - min) * percent
                                newValue = math.floor((newValue / step) + 0.5) * step

                                newValue = math.max(min, math.min(max, newValue))
                                if newValue ~= sectionItem['value'] then
                                    sectionItem['value'] = newValue

                                    if itemCallback then
                                        itemCallback(newValue)
                                    end
                                end
                            end
                        else
                            sliderValue.Color = self._color_text
                        end

                        sectionY = sectionY + sliderH + 18 + labelH
                    elseif itemType == 'choice' then
                        local choiceOutline = itemDraws[1]
                        local choiceFill = itemDraws[2]
                        local choiceValues = itemDraws[3]
                        local choiceExpand = itemDraws[4]
                        local choiceLabel = itemDraws[5]

                        local choices = sectionItem['choices']
                        local multi = sectionItem['multi']

                        local _labelW, labelH = self._GetTextBounds('')
                        local choiceW = sectionW - self._padding * 3
                        local choiceH = 20
                        local choiceBoxSize = Vector2.new(choiceW, choiceH)
                        local choiceBoxPosition = itemPosition + Vector2.new(0, labelH + 10)

                        choiceLabel.Position = itemPosition
                        choiceLabel.Transparency = baseOpacity
                        choiceLabel.Visible = childrenVisible
                        choiceLabel.Color = self._color_text

                        local valuesText = table.concat(itemValue, ', ')
                        local valuesTextW, _valuesTextH = self._GetTextBounds(valuesText)
                        choiceValues.Position = itemPosition + Vector2.new(4, labelH / 2 + choiceH - 2)
                        choiceValues.Text = valuesTextW > choiceW - 32 and '...' or valuesText
                        choiceValues.Transparency = baseOpacity
                        choiceValues.Visible = childrenVisible
                        choiceValues.Color = self._color_text

                        choiceOutline.Position = choiceBoxPosition
                        choiceOutline.Size = choiceBoxSize
                        choiceOutline.Transparency = baseOpacity
                        choiceOutline.Visible = childrenVisible

                        choiceFill.Position = choiceBoxPosition + Vector2.new(2, 2)
                        choiceFill.Size = choiceBoxSize - Vector2.new(4, 4)
                        choiceFill.Transparency = baseOpacity
                        choiceFill.Visible = childrenVisible
                        choiceFill.Color = self._color_crust

                        local expandSymbol = '<'
                        local choiceExpandW, choiceExpandH = self._GetTextBounds(expandSymbol)
                        choiceExpand.Position = itemPosition + Vector2.new(choiceW - choiceExpandW - 4, choiceExpandH / 2 + choiceH - 2)
                        choiceExpand.Text = expandSymbol
                        choiceExpand.Transparency = baseOpacity
                        choiceExpand.Visible = childrenVisible
                        choiceExpand.Color = self._color_text

                        -- handle input
                        if self._IsMouseWithinBounds(choiceBoxPosition, choiceBoxSize) then
                            choiceOutline.Color = self._color_accent

                            if clickFrame then
                                local dropdownCallback = function(newValues)
                                    sectionItem['value'] = newValues

                                    if itemCallback then
                                        itemCallback(sectionItem['value'])
                                    end
                                end

                                self:_SpawnDropdown(itemValue, choices, multi, dropdownCallback, choiceBoxPosition + Vector2.new(0, choiceH), choiceW)
                            elseif ctxFrame then
                                local dropdownCallback = function(_newValues)
                                    sectionItem['value'] = {}
                                    itemCallback(sectionItem['value'])
                                end

                                self:_SpawnDropdown({}, {'Clear'}, false, dropdownCallback, mousePos, 60)

                            end
                        else
                            choiceOutline.Color = self._color_crust
                        end

                        sectionY = sectionY + choiceH + 18 + labelH
                    elseif itemType == 'button' then
                        local buttonOutline = itemDraws[1]
                        local buttonFill = itemDraws[2]
                        local buttonLabel = itemDraws[3]

                        local buttonText = sectionItem['label']

                        local buttonTextW, buttonTextH = self._GetTextBounds(buttonText)
                        local buttonBoxSize = Vector2.new(buttonTextW + self._padding * 2, 20)
                        buttonLabel.Position = itemPosition + Vector2.new(self._padding, 4)
                        buttonLabel.Transparency = baseOpacity
                        buttonLabel.Visible = childrenVisible
                        buttonLabel.Color = self._color_text

                        buttonOutline.Position = itemPosition
                        buttonOutline.Size = buttonBoxSize
                        buttonOutline.Transparency = baseOpacity
                        buttonOutline.Visible = childrenVisible

                        buttonFill.Position = itemPosition + Vector2.new(2, 2)
                        buttonFill.Size = buttonBoxSize - Vector2.new(4, 4)
                        buttonFill.Transparency = baseOpacity
                        buttonFill.Visible = childrenVisible
                        buttonFill.Color = self._color_crust

                        -- handle input
                        if self._IsMouseWithinBounds(itemPosition, buttonBoxSize) then
                            if clickFrame and itemCallback then
                                itemCallback(sectionItem['value'])
                            end

                            buttonOutline.Color = self._color_accent
                        else
                            buttonOutline.Color = self._color_crust
                        end

                        sectionY = sectionY + 22 + buttonTextH
                    elseif itemType == 'colorpicker' then
                        local colorpickerOutline = itemDraws[1]
                        local colorpickerFill = itemDraws[2]
                        local colorpickerShadow = itemDraws[3]
                        local colorpickerLabel = itemDraws[4]

                        local boxSize = Vector2.new(30, 14)
                        local boxPosition = itemPosition + Vector2.new(sectionW - boxSize.x - self._padding * 3, 0)
                        colorpickerOutline.Position = boxPosition
                        colorpickerOutline.Size = boxSize
                        colorpickerOutline.Transparency = baseOpacity
                        colorpickerOutline.Visible = childrenVisible
                        colorpickerOutline.Color = self._color_crust

                        colorpickerFill.Position = boxPosition + Vector2.new(1, 1)
                        colorpickerFill.Size = boxSize - Vector2.new(2, 2)
                        colorpickerFill.Transparency = baseOpacity
                        colorpickerFill.Color = Color3.fromRGB(unpack(sectionItem['value']))
                        colorpickerFill.Visible = childrenVisible

                        colorpickerShadow.Position = boxPosition + Vector2.new(4, 4)
                        colorpickerShadow.Size = boxSize - Vector2.new(8, 8)
                        colorpickerShadow.Transparency = baseOpacity * 0.25
                        colorpickerShadow.Visible = childrenVisible

                        colorpickerLabel.Position = itemPosition
                        colorpickerLabel.Transparency = baseOpacity
                        colorpickerLabel.Visible = childrenVisible
                        colorpickerLabel.Color = self._color_text

                        -- handle input
                        if self._IsMouseWithinBounds(boxPosition, boxSize) then
                            if clickFrame then
                                local colorpickerCallback = function(newColor)
                                    sectionItem['value'] = newColor

                                    if itemCallback then
                                        itemCallback( Color3.fromRGB(unpack(sectionItem['value'])) )
                                    end
                                end

                                self:_SpawnColorpicker(sectionItem['value'], sectionItem['label'], colorpickerCallback)
                            elseif ctxFrame then
                                self:_SpawnDropdown({}, {'Copy', 'Paste'}, false, function (values)
                                    local action = values[1]
                                    if action == 'Copy' then
                                        self._clipboard_color = itemValue
                                    elseif action == 'Paste' then
                                        sectionItem['value'] = self._clipboard_color or itemValue
                                        if itemCallback then
                                            itemCallback(Color3.fromRGB(unpack(sectionItem['value'])))
                                        end
                                    end
                                end, mousePos, 60)
                            end
                        end

                        sectionY = sectionY + boxSize.y + 10
                    elseif itemType == 'key' then
                        local keyLabel = itemDraws[1]
                        local keyOutline = itemDraws[2]
                        local keyFill = itemDraws[3]
                        local keyText = itemDraws[4]

                        local buttonText = sectionItem['_listening'] == true and '...' or itemValue:upper()
                        local buttonTextW, buttonTextH = self._GetTextBounds(buttonText)
                        local buttonBoxSize = Vector2.new(buttonTextW + self._padding * 2, 20)
                        local buttonPosition = itemPosition + Vector2.new(sectionW - buttonBoxSize.x - self._padding * 3, 0)
                        keyText.Position = buttonPosition + Vector2.new(self._padding, 4)
                        keyText.Transparency = baseOpacity
                        keyText.Text = buttonText
                        keyText.Visible = childrenVisible
                        keyText.Color = self._color_text

                        keyOutline.Position = buttonPosition
                        keyOutline.Size = buttonBoxSize
                        keyOutline.Transparency = baseOpacity
                        keyOutline.Visible = childrenVisible

                        keyFill.Position = buttonPosition + Vector2.new(2, 2)
                        keyFill.Size = buttonBoxSize - Vector2.new(4, 4)
                        keyFill.Transparency = baseOpacity
                        keyFill.Visible = childrenVisible
                        keyFill.Color = self._color_crust

                        keyLabel.Position = itemPosition + Vector2.new(0, buttonTextH / 2 + 1)
                        keyLabel.Transparency = baseOpacity
                        keyLabel.Visible = childrenVisible
                        keyLabel.Color = self._color_text

                        -- handle input
                        if self._IsMouseWithinBounds(buttonPosition, buttonBoxSize) then
                            if clickFrame then
                                sectionItem['_listening'] = true
                                self._inputs['m1']['click'] = false
                            end

                            keyOutline.Color = self._color_accent
                        else
                            keyOutline.Color = self._color_crust
                        end

                        if sectionItem['_listening'] then
                            for keycode, inputData in pairs(self._inputs) do
                                if inputData['click'] then
                                    sectionItem['value'] = keycode
                                    sectionItem['_listening'] = false
                                    
                                    break
                                end
                            end 
                        end

                        sectionY = sectionY + 22 + buttonTextH
                    end
                end

                -- section core
                local sectionBackdrop = sectionDraws[1]
                local sectionCrust = sectionDraws[2]
                local sectionBorder = sectionDraws[3]
                local sectionTitle = sectionDraws[4]

                sectionCrust.Position = sectionPos
                sectionCrust.Size = Vector2.new(sectionW, sectionY)
                sectionCrust.Transparency = baseOpacity
                sectionCrust.Visible = childrenVisible
                sectionCrust.Color = self._color_crust

                sectionBorder.Position = sectionPos + Vector2.new(1, 1)
                sectionBorder.Size = Vector2.new(sectionW - 2, sectionY - 2)
                sectionBorder.Transparency = baseOpacity
                sectionBorder.Visible = childrenVisible
                sectionBorder.Color = self._color_overlay

                local _sectionTitleW, sectionTitleH = self._GetTextBounds('')
                sectionTitle.Position = sectionPos + Vector2.new(10, - sectionTitleH / 2)
                sectionTitle.Transparency = baseOpacity
                sectionTitle.Visible = childrenVisible
                sectionTitle.Color = self._color_text

                sectionBackdrop.Visible = false

                sectionY = sectionY + self._padding
                if opposite == 1 then
                    totalSectionH_0 = totalSectionH_0 + sectionY
                else
                    totalSectionH_1 = totalSectionH_1 + sectionY
                end
            else
                -- tab is not active
                undrawAll(sectionDraws)

                -- and its items
                for _, sectionItem in ipairs(sectionItems) do
                    undrawAll(sectionItem['_drawings'])
                end
            end
        end
    end

    -- finalize all input
    self._tick = os.clock()
end

function UILib:Destroy()
    -- remove core
    for _, drawing in pairs(self._tree['_drawings']) do
        drawing:Remove()
    end

    -- remove dropdown
    self:_RemoveDropdown()
    self:_RemoveColorpicker()

    -- remove tree
    for _, tab in pairs(self._tree['_tabs']) do
        if tab['_drawings'] then
            for _, drawing in pairs(tab['_drawings']) do
                drawing:Remove()
            end
        end

        if tab._sections then
            for _, section in pairs(tab['_sections']) do
                for _, drawing in pairs(section['_drawings']) do
                    drawing:Remove()
                end
                
                if section._items then
                    for _, item in pairs(section._items) do
                        for _, drawing in pairs(item['_drawings']) do
                            drawing:Remove()
                        end
                    end
                end
            end
        end
    end

    self._tree = nil
    setrobloxinput(true)
end

return UILib
