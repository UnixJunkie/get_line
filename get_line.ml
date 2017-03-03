open Printf

let randomize_list l =
  Core_kernel.Core_random.self_init ();
  Core.Std.List.permute l

type mode = Head of int
          | Tail of int
          | Just_one of int
          | Between of int * int

let is_substring super sub =
  try let _index = BatString.find super sub in true
  with Not_found -> false

let classify s =
  if BatString.starts_with s "+" then
    let n = int_of_string (BatString.lchop s) in
    Head n
  else if BatString.starts_with s "-" then
    let n = int_of_string (BatString.lchop s) in
    Tail n
  else if is_substring s ".." then
    let start_i, stop_i = BatString.split ~by:".." s in
    Between (int_of_string start_i, int_of_string stop_i)
  else
    Just_one (int_of_string s)

let main () =
  let nb_args = Array.length Sys.argv in
  if nb_args < 3 then
    (Printf.eprintf
       "get_line: error: usage:\nget_line {+n|-n|i|i..j} FILE [--rand] [-v] \
        (1 <= i [<= j] <= N; N = nb. lines in FILE)\n";
     exit 1);
  let options = Array.to_list Sys.argv in
  let randomize = List.mem "--rand" options in
  let invert = List.mem "-v" options in (* like 'grep -v' *)
  let nums_str = Sys.argv.(1) in
  let input_fn = Sys.argv.(2) in
  let all_lines = BatList.of_enum (BatFile.lines_of input_fn) in
  let nb_lines = List.length all_lines in
  let selected_lines =
    match classify nums_str with
    | Head n ->
      if n > nb_lines then
        (eprintf "get_line: %d > %d\n" n nb_lines;
         exit 1);
      (if invert then BatList.drop else BatList.take)
        n all_lines
    | Tail n ->
      if n > nb_lines then
        (eprintf "get_line: %d > %d\n" n nb_lines;
         exit 1);
      (if invert then BatList.take else BatList.drop)
        (nb_lines - n) all_lines
    | Just_one i ->
      if i < 1 || i > nb_lines then
        (eprintf "get_line: %d < 1 || %d > %d\n" i i nb_lines;
         exit 1);
      if invert then
        let xs, rest = BatList.takedrop (i - 1) all_lines in
        BatList.append xs (BatList.drop 1 rest)
      else
        BatList.take 1 (BatList.drop (i - 1) all_lines)
    | Between (i, j) ->
      if i < 1 || j < i || j > nb_lines then
        (eprintf "get_line: %d < 1 || %d < %d || %d > %d\n" i j i j nb_lines;
         exit 1);
      if invert then
        let xs, rest = BatList.takedrop (i - 1) all_lines in
        BatList.append xs (BatList.drop ((j - i) + 1) rest)
      else
        BatList.take ((j - i) + 1) (BatList.drop (i - 1) all_lines) in
  let to_output =
    if randomize then randomize_list selected_lines
    else selected_lines in
  List.iter (printf "%s\n") to_output

let () = main ()
