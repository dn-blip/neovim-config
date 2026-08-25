local function delete_qf_items()
    local start_idx, end_idx
  
    -- Check if the function was triggered via a visual selection
    -- (Vim sets visual marks '< and '> when leaving visual mode)
    local is_visual = vim.fn.visualmode() ~= ""

    if not is_visual then
        -- Normal mode: use the current line and optional count (e.g., 3d)
        start_idx = vim.fn.line('.')
        local count = vim.v.count > 0 and vim.v.count or 1
        end_idx = start_idx + count - 1
    else
        -- Visual mode: pull the visual selection bounds
        local v_start = vim.fn.line("'<")
        local v_end = vim.fn.line("'>")
        start_idx = math.min(v_start, v_end)
        end_idx = math.max(v_start, v_end)
        
        -- Clear visual mode state so the next run doesn't think it's still visual
        vim.fn.visualmode(true)
    end

    local qflist = vim.fn.getqflist()
  
    -- Calculate how many items to delete
    local count = (end_idx - start_idx) + 1

    -- Safely remove items from the table backwards to preserve index alignment
    for _ = 1, count do
        if qflist[start_idx] then
            table.remove(qflist, start_idx)
        end
    end

    -- Update the quickfix list ('r' replaces the current list)
    vim.fn.setqflist(qflist, 'r')
  
    -- Reposition the cursor nicely on the new item index
    local total_items = #qflist
    local target_line = math.min(start_idx, total_items > 0 and total_items or 1)
    vim.fn.cursor(target_line, 1)
end
