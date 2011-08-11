skip_vim_plugin "color-sampler"
skip_vim_plugin "scala"
skip_vim_plugin "cucumber"
skip_vim_plugin "molokai"
skip_vim_plugin "vwilight"
skip_vim_plugin "vividchalk"
vim_plugin_task "gnupg.vim" do
  sh "curl http://gitorious.org/vim-gnupg/vim-gnupg/blobs/raw/master/plugin/gnupg.vim > plugin/gnupg.vim"
end
