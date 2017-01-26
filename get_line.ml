
(* main *)
let nb_args = Array.length Sys.argv in
if nb_args <> 3 then
  begin
    Printf.eprintf
      "get_line: error: usage: get_line line_num filename \
       (1 <= line_num <= `cat filename | wc -l`)\n";
    exit 1
  end;
let i = int_of_string Sys.argv.(1) in
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
    if !nb_lines = i then
      begin
        Printf.printf "%s\n" line;
        close_in input;
        exit 0 (* normal termination *)
      end
  done;
with _ ->
  begin
    close_in input;
    Printf.eprintf "get_line: error: %d > %d\n" i !nb_lines;
    exit 1
  end
