
(* Applies `f` to the arguments `x` and `y` in reveresed orded. *)
let flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c =
  fun f x y -> f y x

(* Mathematical composition of functions: `(f ∘ g)(x) = f(g(x))`. *)
let compose f g = fun x -> f (g x)

let invcompose g f = fun x -> f (g x)

(* Infix function composition operator. *)
let (<<) = compose

(* Infix inverse function composition operator. *)
let (>>) = invcompose

type void = Void

(* Identity function. *)
let identity : 'a -> 'a = fun x -> x

let const x = fun _ -> x

(* Ignores the passed argument and returns unit. *)
let ignore : 'a -> unit = fun _ -> ()

let exclusive_option_exn x y =
	match (x, y) with
	| Some v, None -> v
	| None, Some v -> v
	| None, None -> failwith "At least one of two options must be defined."
	| Some _, Some _ -> failwith "Both options are defined."


let defined_option = function
	| Some _ -> true
	| None -> false


let (=>) = (|>)
let ($) = (@@)


let rec repeat_until fn limit =
	let x = fn () in
	if (x = limit)
		then []
		else [x] @ repeat_until fn limit


let rec repeat_fn_to fn limit =
	let x = fn () in
	if (x = limit)
		then []
		else [x] @ repeat_fn_to fn limit

let (!?) x = print_endline "*"; x
let (!!) s =
    print_endline ("= " ^ s); s

let print = print_endline

let printf = Printf.printf

let format = Printf.sprintf

let (%) fmt x = Printf.sprintf fmt x
let (%%) fmt (x, y) = Printf.sprintf fmt x y
let (%%%) fmt (x, y, z) = Printf.sprintf fmt x y z

let first (x, _) = x
let second (_, y) = y

module type Type = sig
  type t
end

let join = String.concat
let map = List.map


let curry f (x, y) = f x y

type 'a result =
	| Ok of 'a
	| Error of string

let color_format color =
	format "\027[%dm%s\027[0m"
	   (match color with
		  | `Black   -> 30
	    | `Red     -> 31
	    | `Green   -> 32
	    | `Yellow  -> 33
	    | `Blue    -> 34
	    | `Magenta -> 35
	    | `Cyan    -> 36
	    | `White   -> 37)

let blue = color_format `Blue
let red = color_format `Red
let yellow = color_format `Yellow
let magenta = color_format `Magenta
let cyan = color_format `Cyan
let white = color_format `White
let green = color_format `Green
let bright_white x = format "\027[1;37m%s\027[0m" x
let bright_blue x = format "\027[1;34m%s\027[0m" x
let bright_magenta x = format "\027[1;35m%s\027[0m" x
let violet x = format "\027[0;34m%s\027[0m" x
(* let violet x = format "\027[0;49;34m%s\027[0m" x *)
let bright_red x = format "\027[1;31m%s\027[0m" x
let bright_green x = format "\027[1;32m%s\027[0m" x
let start_bright_white = format "\027[1;37m"
let start_white = format "\027[37m"
let end_color = "\027[0m"
let italic x  = "\027[3m" ^ x ^ "\027[0m"
let underline x  = "\027[4m" ^ x ^ "\027[0m"
let blink x  = "\027[5m" ^ x ^ "\027[0m"


let log x = print ("-- " ^ x)

let debug = false

let trace x =
  if debug then print ((cyan " > ") ^ x)
           else ()

let warn x =
  if debug then print ((yellow " ! ") ^ x)
           else ()

let error = failwith


let (|?) maybe default =
  match maybe with
  | Some v -> v
  | None -> Lazy.force default

let if_some fn = function
  | None -> ()
  | Some x -> fn x

let pipe_some fn = function
  | None -> None
  | Some x -> fn x

let map_some fn = function
  | None -> None
  | Some x -> Some (fn x)


module Lazy_stream = struct
  type 'a t = Cons of 'a * 'a t Lazy.t | Nil

  let of_stream stream =
    let rec next stream =
      try Cons(Stream.next stream, lazy (next stream))
      with Stream.Failure -> Nil
    in
    next stream

  let of_function f =
    let rec next f =
      match f () with
      | Some x -> Cons(x, lazy (next f))
      | None -> Nil
    in
    next f

  let of_string str = str |> Stream.of_string |> of_stream
  let of_channel ic = ic |> Stream.of_channel |> of_stream
end


let (<~>) x y = match compare x y with
  |  0 -> `EQ
  |  1 -> `GT
  | -1 -> `LT
  |  _ -> raise (Failure "Impossible comparison result.")


