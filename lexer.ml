(* Set true to display tokens parsed *)
let debug = false

(* Helpers *)
let n () = input_char stdin
let char_is_blank c = Char.equal c ' ' || Char.equal c '\t'
let char_is_digit c = Char.compare '0' c <= 0 && Char.compare c '9' <= 0
let float_of_digit c = (float_of_int (Char.code c)) -. (float_of_int (Char.code '0'))

(* State machine for recognising unsigned floating point numbers *)
let next_number peek =
  let rec after_dot value place =
    match n() with
    | c when char_is_digit c -> after_dot (value +. place *. (float_of_digit c)) (place /. 10.0)
    | c -> Symbol.Token.Number value, c in
  let rec before_dot value peek =
    match peek with
    | c when char_is_digit c -> before_dot (10.0 *. value +. (float_of_digit c)) (n())
    | '.' -> after_dot value 0.1
    | c -> Symbol.Token.Number value, c in
  before_dot 0.0 peek

(* State machine for recognising cosine operator *)
let next_cos () =
  if n() = 'o' && n() = 's'
  then Symbol.Token.Cos, n()
  else failwith "parse error, didn't get expected cos"


exception Newline

(* Entry point to state machine *)
let rec next_token peek =
  match peek with
  | c when c = '.' || char_is_digit c -> next_number peek
  | '(' -> Symbol.Token.Left, n()
  | ')' -> Symbol.Token.Right, n() 
  | '!' -> Symbol.Token.Fact, n()
  | '*' -> Symbol.Token.Mult, n()
  | '+' -> Symbol.Token.Plus, n()
  | '-' -> Symbol.Token.Minus, n()
  | 'c' -> next_cos ()
  | '\n' -> raise Newline
  | c when char_is_blank c -> next_token (n())
  | c -> failwith (Printf.sprintf "unrecognised character %c" c)

(* Run state machine until newline is detected *)
let get_token_stream () =
  let rec get_next_token tokens peek =
  try
    let (token, newpeek) = next_token peek in
    begin if debug then token |> Symbol.Token.to_string |> print_endline else () end;
    get_next_token (token::tokens) newpeek
  with Newline -> Ok (Symbol.Token.EOF::tokens |> List.rev)
     | e ->
         (* Discard rest of input until newline *)
         let rec discard_until_newline () = if n() = '\n' then () else discard_until_newline () in
         discard_until_newline ();
         Error (Printexc.to_string e)
  in get_next_token [] (n())

