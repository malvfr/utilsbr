import gleam/list
import gleam/string

/// Cleans a given CPF string by removing all non-numeric characters.
///
/// This function takes a CPF string as input and keeps only the digits (0-9),
/// returning the cleaned CPF string.
///
/// # Examples
///
/// ```gleam
/// let cleaned_cpf = clean("123.456.789-09")
/// assert cleaned_cpf == "12345678909"
/// ```
///
/// # Arguments
///
/// * `cpf` - A string representing the CPF to be cleaned.
///
/// # Returns
///
/// A new string containing only the numeric characters from the input CPF.
pub fn clean(cpf: String) -> String {
  cpf
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
