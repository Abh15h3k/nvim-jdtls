local M = {}


function M.pick_one_async(items, prompt, label_fn, cb)
  if vim.ui then
    return vim.ui.select(items, {
      prompt = prompt,
      format_item = label_fn,
    }, cb)
  end
  local result = M.pick_one(items, prompt, label_fn)
  cb(result)
end


function M.pick_one(items, prompt, label_fn)
  local choices = {prompt}
  for i, item in ipairs(items) do
    table.insert(choices, string.format('%d: %s', i, label_fn(item)))
  end
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #items then
    return nil
  end
  return items[choice]
end


function M.pick_many(items, prompt, label_f)
  if not items or #items == 0 then
    return {}
  end
  local selected = {}
  for _, item in pairs(items) do
    local choice = vim.fn.inputlist({
      string.format('\n%s %s', prompt, label_f(item)),
      "1. Yes",
      "2. No"
    })
    if choice == 1 then
      table.insert(selected, item)
    end
  end
  return selected
end


return M
