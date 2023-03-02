function find_config -a file
  # from: https://www.npmjs.com/package/find-config#algorithm
  # 1. If X/file.ext exists and is a regular file, return it. STOP
  # 2. If X has a parent directory, change X to parent. GO TO 1
  # 3. Return NULL.

  if test -e $file
    printf '%s\n' (string trim -r -c / (pwd))
  else if test (dirname (realpath $file)) = $HOME
    false
  else
    # a subshell so that we don't affect the caller's $PWD
    # fish -c "cd .. && find_config $file"
    find_config ../$file
  end
end
