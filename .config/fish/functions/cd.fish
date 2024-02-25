function cd
  builtin cd $argv

  if type -q eza
    lla
  else
    ls -al
  end
end