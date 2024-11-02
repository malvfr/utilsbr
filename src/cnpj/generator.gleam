import cnpj/validation
import gleam/int
import gleam/list
import gleam/string
import utils/format

pub fn generate(formatted: Bool) -> String {
  let first_twelve_digits =
    list.fold(list.range(1, 12), "", fn(acc, _elm) {
      let cnpj_str_digit = int.random(9) |> int.to_string()
      string.append(acc, cnpj_str_digit)
    })
    |> string.split("")

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
