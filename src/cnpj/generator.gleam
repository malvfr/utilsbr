import cnpj/validation
import gleam/int
import gleam/list
import gleam/string
import utils/format

/// Generates a CNPJ (Cadastro Nacional da Pessoa Jurídica) number.
/// 
/// This function generates a valid CNPJ number, optionally formatted with punctuation.
/// # Parameters
/// - `formatted` (Bool): If `True`, the generated CNPJ will be formatted with
///   punctuation (e.g., "12.345.678/0001-95"). If `False`, the CNPJ will be
///   returned as a plain string of digits.
///
/// # Returns
/// - (String): A valid CNPJ number, optionally formatted.
pub fn generate(formatted: Bool) -> String {
  let first_twelve_digits =
    list.range(1, 12)
    |> list.map(fn(_) { int.random(9) |> int.to_string() })

  let first_validation_digit =
    validation.calculate_first_verification_digit(first_twelve_digits)

  let first_thirteen_digits =
    list.append(first_twelve_digits, [int.to_string(first_validation_digit)])

  let second_validation_digit =
    validation.calculate_second_verification_digit(first_thirteen_digits)

  let cnpj_string_candidate =
    first_thirteen_digits
    |> string.join("")
    |> string.append(int.to_string(second_validation_digit))

  let final_string = case
    format.all_characteres_are_equal(cnpj_string_candidate)
  {
    True -> generate(formatted)
    False -> cnpj_string_candidate
  }

  case formatted {
    True -> final_string |> format.format_cnpj()
    False -> final_string
  }
}
