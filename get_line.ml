
(* main *)
let nb_args = Array.length Sys.argv in
if nb_args <> 3 then
  begin
    Printf.eprintf
      "get_line: error: usage: get_line line_num filename \
       (1 <= line_num <= `cat filename | wc -l`)\n";
    exit 1
  end;
let nums_str = Sys.argv.(1) in
let istr, jstr =
  if BatString.contains nums_str '-' then
    BatString.split nums_str ~by:"-"
  else
    (nums_str, nums_str)
in
let i = int_of_string istr in
let j = int_of_string jstr in
if i <= 0 then
  begin
    Printf.eprintf "get_line: error: %d <= 0\n" i;
    exit 1
  end;
let filename = Sys.argv.(2) in
let input = open_in filename in
let nb_lines = ref 0 in
try
  while true do
    let line = input_line input in
    incr nb_lines;
    if !nb_lines >= i && !nb_lines <= j then
      Printf.printf "%s\n" line
    ;
    if !nb_lines > j then
      begin
        close_in input;
        exit 0 (* normal *)
      end
  done
with _ ->
  begin
    close_in input;
    if i > !nb_lines then
      Printf.eprintf "get_line: error: i: %d > %d\n" i !nb_lines
    ;
    if j > !nb_lines && j <> i then
      Printf.eprintf "get_line: error: j: %d > %d\n" j !nb_lines
    ;
    exit 1 (* abnormal *)
  end
