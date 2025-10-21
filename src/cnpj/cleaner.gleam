import gleam/list
import gleam/regexp
import gleam/string

pub fn clean(cnpj: String) {
  let assert Ok(only_numbers_regex) =
    regexp.compile("[^0-9]", regexp.Options(False, False))

  regexp.replace(each: only_numbers_regex, in: cnpj, with: "")
}

pub fn has_letters(str: String) -> Bool {
  string.to_graphemes(str)
  |> list.any(fn(char) {
    case char {
      "0"
      | "1"
      | "2"
      | "3"
      | "4"
      | "5"
      | "6"
      | "7"
      | "8"
      | "9"
      | "."
      | "-"
      | "/" -> False
      _ -> True
    }
  })
}

/// Cleans a CNPJ string, automatically detecting and preserving the appropriate format.
///
/// For alphanumeric CNPJs, preserves letters and numbers (A-Z, 0-9) and converts to uppercase.
/// For numeric CNPJs, preserves only numbers (0-9).
///
/// # Examples
///
/// ```gleam
/// clean_auto("12.ABC.345/01DE-35")  // "12ABC34501DE35"
/// clean_auto("84.980.771/0001-82")  // "84980771000182"
/// ```
pub fn clean_auto(cnpj: String) -> String {
  case has_letters(cnpj) {
    True -> clean_alphanumeric(cnpj)
    False -> clean(cnpj)
  }
}

pub fn clean_alphanumeric(cnpj: String) -> String {
  let assert Ok(valid_chars_regex) =
    regexp.compile("[^A-Z0-9]", regexp.Options(False, False))

  cnpj
  |> string.uppercase
  |> regexp.replace(each: valid_chars_regex, with: "")
}

fn is_alphanumeric(cnpj: String) -> Bool {
  let first_twelve = string.slice(cnpj, 0, 12)
  let assert Ok(letter_regex) =
    regexp.compile("[A-Z]", regexp.Options(False, False))
  regexp.check(letter_regex, first_twelve)
}

/// Formats a CNPJ string, automatically detecting the format type.
///
/// Alphanumeric CNPJs are formatted as: "AA.AAA.AAA/AAAA-DD"
/// Numeric CNPJs are formatted as: "99.999.999/9999-99"
///
/// # Examples
///
/// ```gleam
/// format_auto("12ABC34501DE35")  // "12.ABC.345/01DE-35"
/// format_auto("84980771000182")  // "84.980.771/0001-82"
/// ```
pub fn format_auto(cnpj: String) -> String {
  case is_alphanumeric(cnpj) {
    True -> format_alphanumeric(cnpj)
    False -> format_numeric(cnpj)
  }
}

fn format_numeric(cnpj: String) -> String {
  let part1 = string.slice(cnpj, 0, 2)
  let part2 = string.slice(cnpj, 2, 3)
  let part3 = string.slice(cnpj, 5, 3)
  let part4 = string.slice(cnpj, 8, 4)
  let part5 = string.slice(cnpj, 12, 2)

  part1 <> "." <> part2 <> "." <> part3 <> "/" <> part4 <> "-" <> part5
}

fn format_alphanumeric(cnpj: String) -> String {
  let part1 = string.slice(cnpj, 0, 2)
  let part2 = string.slice(cnpj, 2, 3)
  let part3 = string.slice(cnpj, 5, 3)
  let part4 = string.slice(cnpj, 8, 4)
  let part5 = string.slice(cnpj, 12, 2)

  part1 <> "." <> part2 <> "." <> part3 <> "/" <> part4 <> "-" <> part5
}
