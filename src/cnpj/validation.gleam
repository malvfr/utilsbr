import cnpj/cleaner
import gleam/int
import gleam/io
import gleam/iterator
import gleam/list
import gleam/regex
import gleam/string
import utils/format

pub fn handle_flexible_validation(cnpj: String) {
  let cleaned_cnpj = cleaner.clean(cnpj)

  case string.length(cleaned_cnpj) {
    14 -> {
      handle_cleaned_cnpj(cleaned_cnpj)
    }
    _ -> False
  }
}

pub fn handle_strict_validation(cnpj: String) {
  let cnpj_regex = format.unformatted_cnpj_regex()

  let is_regex_valid = regex.check(cnpj_regex, cnpj)

  case is_regex_valid {
    True -> handle_flexible_validation(cnpj)
    False -> False
  }
}

fn handle_cleaned_cnpj(cnpj: String) {
  case format.all_characteres_are_equal(cnpj) {
    True -> False
    False -> calculate_verification_digits_and_validate(cnpj)
  }
}

fn calculate_verification_digits_and_validate(cnpj: String) {
  let first_twelve_digits = string.slice(cnpj, 0, 12) |> string.split("")
  let last_two_digits = string.slice(cnpj, 12, 14) |> string.split("")

  let first_verification_digit =
    calculate_first_verification_digit(first_twelve_digits)

  let thirteen_digits =
    list.append(first_twelve_digits, [int.to_string(first_verification_digit)])

  let second_verification_digit =
    calculate_second_verification_digit(thirteen_digits)

  let is_valid =
    last_two_digits
    == [
      int.to_string(first_verification_digit),
      int.to_string(second_verification_digit),
    ]

  is_valid
}

fn calculate_first_verification_digit(first_twelve_digits: List(String)) {
  let verifying_digits = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

  let sum =
    list.index_fold(first_twelve_digits, 0, fn(acc, elm, index) {
      let assert Ok(digit) = int.parse(elm)
      let assert Ok(verifying_digit) =
        iterator.at(iterator.from_list(verifying_digits), index)

      acc + { digit * verifying_digit }
    })

  let last_sum_checker = sum % 11

  calculate_verification_digit(last_sum_checker)
}

fn calculate_second_verification_digit(thirteen_digits: List(String)) {
  let verifying_digits = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

  let sum =
    list.index_fold(thirteen_digits, 0, fn(acc, elm, index) {
      let assert Ok(digit) = int.parse(elm)
      let assert Ok(verifying_digit) =
        iterator.at(iterator.from_list(verifying_digits), index)

      acc + { digit * verifying_digit }
    })

  let last_sum_checker = sum % 11

  calculate_verification_digit(last_sum_checker)
}

fn calculate_verification_digit(last_sum_checker: Int) {
  let first_verification_digit = case last_sum_checker {
    0 -> 0
    1 -> 0
    _ -> 11 - last_sum_checker
  }

  first_verification_digit
}
