//// Strings in Gleam are UTF-8 binaries. They can be written in your code a
//// text surrounded by `"double quotes"`.
////

import gleam/iodata
import gleam/list
import gleam/order
import gleam/result.{Option}

pub type String =
  String

/// Determine if a string is empty.
///
/// ## Examples
///
///    > is_empty("")
///    True
///
///    > is_empty("the world")
///    False
///
pub fn is_empty(str: String) -> Bool {
  str == ""
}

/// Get the number of grapheme clusters in a given string.
///
/// This function has to iterate across the whole string to count the number of
/// graphemes, so it runs in linear time.
///
/// ## Examples
///
///    > length("Gleam")
///    5
///
///    > length("ß↑e̊")
///    3
///
///    > length("")
///    0
pub external fn length(String) -> Int =
  "string" "length"

///
/// Reverse a string.
///
/// This function has to iterate across the whole string so it runs in linear
/// time.
///
/// ## Examples
///
///    > reverse("stressed")
///    "desserts"
pub fn reverse(string: String) -> String {
  string
  |> iodata.new
  |> iodata.reverse
  |> iodata.to_string
}

///
/// Create a new string by replacing all occurrences of a given substring.
///
/// ## Examples
///
///    > replace("www.example.com", each: ".", with: "-")
///    "www-example-com"
///
///    > replace("a,b,c,d,e", each: ",", with: "/")
///    "a/b/c/d/e"
pub fn replace(
  in string: String,
  each pattern: String,
  with substitute: String,
) -> String {
  string
  |> iodata.new
  |> iodata.replace(each: pattern, with: substitute)
  |> iodata.to_string
}

///
/// Create a new string with all the graphemes in the input string converted to
/// lowercase.
///
/// Useful for case-insensitive comparisons.
///
/// ## Examples
///
///    > lowercase("X-FILES")
///    "x-files"
pub external fn lowercase(String) -> String =
  "string" "lowercase"

///
/// Create a new string with all the graphemes in the input string converted to
/// uppercase.
///
/// Useful for case-insensitive comparisons and VIRTUAL YELLING.
///
/// ## Examples
///
///    > uppercase("skinner")
///    "SKINNER"
pub external fn uppercase(String) -> String =
  "string" "uppercase"

///
/// Compares two strings to see which is "larger" by comparing their graphemes.
///
/// This does not compare the size or length of the given strings.
///
/// ## Examples
///
///    > compare("Anthony", "Anthony")
///    order.Eq
///
///    > compare("A", "B")
///    order.Gt
pub external fn compare(String, String) -> order.Order =
  "gleam_stdlib" "compare_strings"

// TODO
// Take a substring given a start and end Grapheme indexes. Negative indexes
// are taken starting from the *end* of the list.
//
// ## Examples
//    > slice("gleam", from: 1, to: 3)
//    "lea"
//
//    > slice("gleam", from: 1, to: 10)
//    "leam"
//
//    > slice("snakes on a plane!", from: -6, to: -1)
//    "plane"
//
//
// pub fn slice(out_of string: String, from start: Int, end: Int) -> String {}
// TODO
// Drop *n* Graphemes from the left side of a
//
// ## Examples
//    > drop_left(from: "The Lone Gunmen", up_to: 2)
//    "e Lone Gunmen"
//
//
// pub fn drop_left(from string: String, up_to num_graphemes: Int) -> String {}
// TODO
// Drop *n* Graphemes from the right side of a
//
// ## Examples
//    > drop_right(from: "Cigarette Smoking Man", up_to: 2)
//    "Cigarette Smoking M"
//
//
// pub fn drop_right(from string: String, up_to num_graphemes: Int) -> String {}
///
/// Check if the first string contains the second.
///
/// ## Examples
///
///    > contains(does: "theory", contain: "ory")
///    True
///
///    > contains(does: "theory", contain: "the")
///    True
///
///    > contains(does: "theory", contain: "THE")
///    False
external fn erl_contains(String, String) -> Bool =
  "gleam_stdlib" "string_contains"

///
pub fn contains(does haystack: String, contain needle: String) -> Bool {
  erl_contains(haystack, needle)
}

// TODO
// TODO: Not sure about the name and labels here
// See if the second string starts with the first one.
//
// ## Examples
//    > starts_with(does: "theory", start_with: "ory")
//    False
//
//
// pub fn starts_with(does string: String, start_with prefix: String) -> String {}
// TODO
// TODO: Not sure about the name and labels here
// See if the second string ends with the first one.
//
// ## Examples
//    > ends_with(does: "theory", end_with: "ory")
//    True
//
//
// pub fn ends_with(does string: String, end_with suffix: String) -> String {}
/// Create a list of strings by splitting a given string on a given substring.
///
/// ## Examples
///
///    > split("home/gleam/desktop/", on: "/")
///    ["home","gleam","desktop", ""]
pub fn split(x: String, on substring: String) -> List(String) {
  x
  |> iodata.new
  |> iodata.split(on: substring)
  |> list.map(with: iodata.to_string)
}

///
/// Create a new string by joining two strings together.
///
/// This function copies both strings and runs in linear time. If you find
/// yourself joining strings frequently consider using the [iodata](../iodata)
/// module as it can append strings much faster!
///
/// ## Examples
///
///    > append(to: "butter", suffix: "fly")
///    "butterfly"
pub fn append(to first: String, suffix second: String) -> String {
  first
  |> iodata.new
  |> iodata.append(second)
  |> iodata.to_string
}

///
/// Create a new string by joining many strings together.
///
/// This function copies both strings and runs in linear time. If you find
/// yourself joining strings frequently consider using the [iodata](../iodata)
/// module as it can append strings much faster!
///
/// ## Examples
///
///    > concat(["never", "the", "less"])
///    "nevertheless"
pub fn concat(strings: List(String)) -> String {
  strings
  |> iodata.from_strings
  |> iodata.to_string
}

///
fn repeat_help(chunk: String, result: List(String), repeats: Int) -> String {
  case repeats <= 0 {
    True -> concat(result)
    False -> repeat_help(chunk, [chunk, ..result], repeats - 1)
  }
}

/// Create a new string by repeating a string a given number of times.
///
/// This function runs in linear time.
///
/// ## Examples
///    > repeat("ha", times: 3)
///    "hahaha"
pub fn repeat(string: String, times times: Int) -> String {
  repeat_help(string, [], times)
}

///
/// Join many strings together with a given separator.
///
/// This function runs in linear time.
///
/// ## Examples
///
///    > join(["home","evan","Desktop"], with: "/")
///    "home/evan/Desktop"
pub fn join(strings: List(String), with separator: String) -> String {
  strings
  |> list.intersperse(with: separator)
  |> iodata.from_strings
  |> iodata.to_string
}
///
// TODO
// Pad a string on the left until it has at least given number of Graphemes.
//
// ## Examples
//    > pad_left("121", to: 5, with: ".")
//    "..121"
//
//    > pad_left("121", to: 3, with: ".")
//    "121"
//
//    > pad_left("121", to: 2, with: ".")
//    "121"
//
//
// pub fn pad_left(string: String, to size: Int, with: String) {}
// TODO
// Pad a string on the right until it has a given length.
//
// ## Examples
//    > pad_right("121", to: 5, with: ".")
//    "121.."
//
//    > pad_right("121", to: 3, with: ".")
//    "121"
//
//    > pad_right("121", to: 2, with: ".")
//    "121"
//
//
// pub fn pad_right(string: String, to size: Int, with: String) {}
// TODO
// Get rid of whitespace on both sides of a String.
//
// ## Examples
//    > trim("  hats  \n")
//    "hats"
//
//
// pub fn trim(string: String) -> String {}
// TODO
// Get rid of whitespace on the left of a String.
//
// ## Examples
//    > trim_left("  hats  \n")
//    "hats  \n"
//
//
// pub fn trim_left(string: String) -> String {}
// TODO
// Get rid of whitespace on the right of a String.
//
// ## Examples
//    > trim_right("  hats  \n")
//    "  hats"
//
//
// pub fn trim_right(string: String) -> String {}
// TODO
// /// Convert a string to a list of Graphemes.
// ///
// ///    > to_graphemes("abc")
//    ['a','b','c']
//
// ///
// pub fn to_graphemes(string: String) -> List(String) {}
// TODO
// Split a non-empty string into its head and tail. This lets you
// pattern match on strings exactly as you would with lists.
//
// ## Examples
//    > next_grapheme("")
//    Error(Nil)
//
//
// pub fn next_grapheme(string: String) -> Option(tuple(Grapheme, String)) {}
