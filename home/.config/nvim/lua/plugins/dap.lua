return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap = require("dap")
    require("nvim-dap-virtual-text")

    dap.adapters.ruby = {
      type = 'server';
      host = '127.0.0.1';
      port = 38698;
    }

    dap.configurations.ruby = {
      {
        type = "ruby",
        name = "debug remote",
        request = "attach",
        options = {
          source_filetype = 'ruby',
        },
        waiting = 1000,
      }
    }

    local dapui = require("dapui")

    dapui.setup({
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            -- "breakpoints",
            "stacks",
            -- "watches",
          },
          size = 40, -- 40 columns
          position = "left",
        },
        {
          elements = {
            "repl",
            -- "console",
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
    })
    -- these aren't necessary but make the dap ui just pop up automatically which is neat
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end
}
