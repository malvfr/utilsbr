import cpf/validation
import gleam/int
import gleam/list
import gleam/string
import utils/format

pub fn generate(formatted: Bool) -> String {
  let first_nine_digits =
    list.fold(list.range(1, 9), "", fn(acc, _elm) {
      let cpf_str_digit = int.random(9) |> int.to_string()
      string.append(acc, cpf_str_digit)
    })
    |> string.split("")

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
