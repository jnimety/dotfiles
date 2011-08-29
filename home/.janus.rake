skip_vim_plugin "color-sampler"
skip_vim_plugin "cucumber"
skip_vim_plugin "molokai"
skip_vim_plugin "scala"
skip_vim_plugin "vividchalk"
skip_vim_plugin "vwilight"

vim_plugin_task "gnupg.vim" do
  sh "curl http://gitorious.org/vim-gnupg/vim-gnupg/blobs/raw/master/plugin/gnupg.vim > plugin/gnupg.vim"
end

skip_vim_plugin "snipmate"
vim_plugin_task "ultisnips" do
  if File.exists?("ultisnips_rep")
    sh "(cd ultisnips_rep && bzr pull)"
  else
    sh "bzr branch lp:ultisnips ultisnips_rep"
  end
end
