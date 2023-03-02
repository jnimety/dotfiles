return {
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {
      virt_text_win_col = 80,
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    opts = {
      {
        floating = { border = "rounded" }
      },
      layouts = {
        {
          elements = { "repl" },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    keys = {
      {"<leader>ds", function() require("dap").continue() end, desc = "[D]ebugger [S]tart" },
      {"<leader>de", function ()
        local dap = require("dap")
        local virtual_text = require('nvim-dap-virtual-text/virtual_text')

        dap.disconnect()
        dap.close()
        dap.repl.close()
        virtual_text.clear_virtual_text()
      end, desc = "[D]ebugger [E]xit" },
    },
    config = function()
      local dap = require("dap")

      dap.defaults.focus_terminal = true

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

      dap.configurations.haml = {
        {
          type = "ruby",
          name = "debug remote",
          request = "attach",
          options = {
            source_filetype = 'haml',
          },
        }
      }

      local dapui = require("dapui")

      -- these aren't necessary but make the dap ui just pop up automatically which is neat
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end
  },
}
