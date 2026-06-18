import gleam/list
import gleam/string
import utilsbr/utils/format

/// Removes every character that is not a digit (0-9).
pub fn clean(cnpj: String) -> String {
  cnpj
  |> string.to_graphemes
  |> list.filter(is_digit)
  |> string.join("")
}

fn is_digit(char: String) -> Bool {
  case char {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

fn is_uppercase_letter(char: String) -> Bool {
  case string.to_utf_codepoints(char) {
    [codepoint] -> {
      let code = string.utf_codepoint_to_int(codepoint)
      // ASCII 'A'..'Z'
      code >= 65 && code <= 90
    }
    _ -> False
  }
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

/// Uppercases the input and removes every character that is not A-Z or 0-9.
pub fn clean_alphanumeric(cnpj: String) -> String {
  cnpj
  |> string.uppercase
  |> string.to_graphemes
  |> list.filter(fn(char) { is_digit(char) || is_uppercase_letter(char) })
  |> string.join("")
}

/// Formats a cleaned 14-character CNPJ as "XX.XXX.XXX/XXXX-XX".
///
/// The grouping is identical for numeric and alphanumeric CNPJs, so a single
/// formatter handles both formats.
///
/// # Examples
///
/// ```gleam
/// format_auto("12ABC34501DE35")  // "12.ABC.345/01DE-35"
/// format_auto("84980771000182")  // "84.980.771/0001-82"
/// ```
pub fn format_auto(cnpj: String) -> String {
  format.format_cnpj(cnpj)
}
