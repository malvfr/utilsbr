import cpf/validation
import gleam/int
import gleam/list
import gleam/string
import utils/format

/// Generates a Brazilian CPF (Cadastro de Pessoas Físicas) number.
/// 
/// A CPF is an 11-digit number used for tax purposes in Brazil. This function
/// generates a valid CPF number, optionally formatted with punctuation.
///
/// Args:
/// - `formatted` (Bool): If `True`, the generated CPF will be formatted with
///   punctuation (e.g., "123.456.789-09"). If `False`, the CPF will be a plain
///   string of digits (e.g., "12345678909").
///
/// Returns:
/// - `String`: The generated CPF number, optionally formatted.
pub fn generate(formatted: Bool) -> String {
  let first_nine_digits =
    list.range(1, 9)
    |> list.map(fn(_) { int.random(9) |> int.to_string() })

  let first_validation_digit =
    validation.calculate_first_verification_digit(first_nine_digits)

  let first_ten_digits =
    list.append(first_nine_digits, [int.to_string(first_validation_digit)])

  let second_validation_digit =
    validation.calculate_second_verification_digit(first_ten_digits)

  let cpf_string_candidate =
    first_ten_digits
    |> string.join("")
    |> string.append(int.to_string(second_validation_digit))

  let final_string = case
    format.all_characteres_are_equal(cpf_string_candidate)
  {
    True -> generate(formatted)
    False -> cpf_string_candidate
  }

  case formatted {
    True -> final_string |> format.format_cpf()
    False -> final_string
  }
}
