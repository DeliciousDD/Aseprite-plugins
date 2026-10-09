-- Pixel Alpha Opaque for Aseprite
-- Sets alpha to 255 only for pixels whose alpha is already greater than zero.

local function makeOpaqueCopy(source)
  local pc = app.pixelColor
  local copy = source:clone()
  local changed = 0

  if copy.colorMode == ColorMode.RGB then
    for it in copy:pixels() do
      local pixel = it()
      if pc.rgbaA(pixel) > 0 and pc.rgbaA(pixel) < 255 then
        it(pc.rgba(pc.rgbaR(pixel), pc.rgbaG(pixel), pc.rgbaB(pixel), 255))
        changed = changed + 1
      end
    end
  elseif copy.colorMode == ColorMode.GRAY then
    for it in copy:pixels() do
      local pixel = it()
      if pc.grayaA(pixel) > 0 and pc.grayaA(pixel) < 255 then
        it(pc.graya(pc.grayaV(pixel), 255))
        changed = changed + 1
      end
    end
  else
    return nil, 0, "此图层不是 RGB 或灰度图层。请先将精灵转换为 RGBA 或灰度模式。"
  end

  return copy, changed
end

local function makeActiveLayerOpaque()
  local sprite = app.sprite
  local layer = app.layer

  if not sprite or not layer then
    app.alert("请先打开精灵并选择一个图层。")
    return
  end

  if layer.isGroup then
    app.alert("请选择一个普通图层，而不是图层组。")
    return
  end

  if #layer.cels == 0 then
    app.alert("当前图层没有 Cel，因此没有可处理的像素。")
    return
  end

  -- Group cels by image ID so linked cels stay linked after the operation.
  local imageGroups = {}
  for _, cel in ipairs(layer.cels) do
    local id = cel.image.id
    if not imageGroups[id] then
      imageGroups[id] = { source = cel.image, cels = {} }
    end
    table.insert(imageGroups[id].cels, cel)
  end

  local replacements = {}
  local changedPixels = 0

  for _, group in pairs(imageGroups) do
    local copy, count, err = makeOpaqueCopy(group.source)
    if err then
      app.alert(err)
      return
    end

    if count > 0 then
      table.insert(replacements, { cels = group.cels, image = copy })
      changedPixels = changedPixels + count
    end
  end

  if changedPixels == 0 then
    app.alert("当前图层没有半透明像素。")
    return
  end

  app.transaction("将当前图层的像素 Alpha 设为不透明", function()
    for _, replacement in ipairs(replacements) do
      for _, cel in ipairs(replacement.cels) do
        cel.image = replacement.image
      end
    end
  end)

  app.refresh()
  app.alert(string.format("已将 %d 个半透明像素设为完全不透明。", changedPixels))
end

function init(plugin)
  plugin:newCommand{
    id = "PixelAlphaOpaque",
    title = "Alpha 不透明",
    group = "file_scripts",
    onenabled = function()
      return app.sprite ~= nil and app.layer ~= nil
    end,
    onclick = makeActiveLayerOpaque
  }
end
