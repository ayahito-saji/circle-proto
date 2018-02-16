#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

require 'pp'
require 'strscan'

class MyParser < Racc::Parser

module_eval(<<'...end sample2.ry/module_eval...', 'sample2.ry', 14)
attr_accessor :yydebug
attr_accessor :verbose

def parse(str)
  s = StringScanner.new(str)
  @q = []

  until s.eos?
    s.scan(/0x\h+/) ? @q << [:HEX,      s.matched] :
        s.scan(/\d+/)   ? @q << [:DEC,      s.matched] :
            s.scan(/./)     ? @q << [s.matched, s.matched] :
                (raise "scanner error")
  end

  pp @q if verbose

  do_parse
end

def next_token
  @q.shift
end

...end sample2.ry/module_eval...
##### State transition tables begin ###

racc_action_table = [
     3,     4,     6,     7,     5 ]

racc_action_check = [
     0,     0,     2,     5,     1 ]

racc_action_pointer = [
    -3,     4,     0,   nil,   nil,     3,   nil,   nil ]

racc_action_default = [
    -4,    -4,    -4,    -2,    -3,    -4,    -1,     8 ]

racc_goto_table = [
     2,     1 ]

racc_goto_check = [
     2,     1 ]

racc_goto_pointer = [
   nil,     1,     0 ]

racc_goto_default = [
   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  2, 6, :_reduce_none,
  1, 7, :_reduce_none,
  1, 7, :_reduce_none ]

racc_reduce_n = 4

racc_shift_n = 8

racc_token_table = {
  false => 0,
  :error => 1,
  "." => 2,
  :DEC => 3,
  :HEX => 4 }

racc_nt_base = 5

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "\".\"",
  "DEC",
  "HEX",
  "$start",
  "statement",
  "number" ]

Racc_debug_parser = true

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

# reduce 2 omitted

# reduce 3 omitted

def _reduce_none(val, _values, result)
  val[0]
end

end   # class MyParser

if __FILE__ == $0
  require 'optparse'
  require 'ostruct'

  opt = OpenStruct.new ARGV.getopts 'vd'
  str = ARGV.shift or (raise "no arguments")

  parser = MyParser.new
  parser.yydebug = opt.d
  parser.verbose = opt.v


  begin
    p parser.parse(str)
  rescue Racc::ParseError => e
    $stderr.puts e
  end
end
