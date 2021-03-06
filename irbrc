require 'irb/completion'

IRB.conf[:AUTO_INDENT] = true

IRB.conf[:IGNORE_SIGINT] = false

IRB.conf[:PROMPT][:MY_PROMPT] = {
  :AUTO_INDENT => true,
  :PROMPT_I =>  ">> ",
  :PROMPT_S => nil,
  :PROMPT_C => nil,
  :RETURN => "=>%s\n"
}

IRB.conf[:PROMPT_MODE] = :MY_PROMPT

def rir
  exec($0)
end
